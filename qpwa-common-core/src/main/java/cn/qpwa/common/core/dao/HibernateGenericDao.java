package cn.qpwa.common.core.dao;

import java.io.Serializable;
import java.lang.reflect.InvocationTargetException;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.beanutils.PropertyUtils;
import org.hibernate.Criteria;
import org.hibernate.LockMode;
import org.hibernate.LockOptions;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;
import org.hibernate.criterion.SimpleExpression;
import org.hibernate.metadata.ClassMetadata;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;
import org.springframework.util.Assert;
import org.springframework.util.ReflectionUtils;

/**
 * Hibernate Dao的泛型基类.
 * <p/>
 * 继承于Spring的<code>HibernateDaoSupport</code>,提供分页函数和若干便捷查询方法，并对返回值作了泛型类型转换.
 * 
 * @see HibernateDaoSupport
 * @see HibernateEntityDao
 */
@SuppressWarnings("all")
public class HibernateGenericDao extends HibernateDaoSupport {

	/**
	 * 根据ID获取对象. 实际调用Hibernate的session.load()方法返回实体或其proxy对象. 如果对象不存在，抛出异常.
	 */
	public <T> T get(Class<T> entityClass, Serializable id) {
		return (T) getHibernateTemplate().get(entityClass, id);
	}

	/**
	 * 获取全部对象.
	 */
	public <T> List<T> getAll(Class<T> entityClass) {
		return getHibernateTemplate().loadAll(entityClass);
	}

	/**
	 * 获取全部对象,带排序字段与升降序参数.
	 */
	public <T> List<T> getAll(Class<T> entityClass, String orderBy,
			boolean isAsc) {
		Assert.hasText(orderBy);
		DetachedCriteria deta = DetachedCriteria.forClass(entityClass).addOrder(
				Order.asc(orderBy));
		if (isAsc)
			return (List<T>)getHibernateTemplate().findByCriteria(deta);
		else
			return (List<T>)getHibernateTemplate().findByCriteria(deta);
	}

	/**
	 * 保存对象.
	 */
	public void save(Object o) {
		getHibernateTemplate().saveOrUpdate(o);
	}
	
	/**
	 * 保存对象.
	 */
	public void merge(Object o) {
		getHibernateTemplate().merge(o);
	}

	/**
	 * 删除对象.
	 */
	public void remove(Object o) {
		getHibernateTemplate().delete(o);
	}

	/**
	 * 根据ID删除对象.
	 */
	public <T> void removeById(Class<T> entityClass, Serializable id) {
		remove(get(entityClass, id));
	}

	public void flush() {
		getHibernateTemplate().flush();
	}

	public void clear() {
		getHibernateTemplate().clear();
	}

	/**
	 * 创建Query对象.
	 * 对于需要first,max,fetchsize,cache,cacheRegion等诸多设置的函数,可以在返回Query后自行设置.
	 * 留意可以连续设置,如下：
	 * 
	 * <pre>
	 * dao.getQuery(hql).setMaxResult(100).setCacheable(true).list();
	 * </pre>
	 * 
	 * 调用方式如下：
	 * 
	 * <pre>
	 *        dao.createQuery(hql)
	 *        dao.createQuery(hql,arg0);
	 *        dao.createQuery(hql,arg0,arg1);
	 *        dao.createQuery(hql,new Object[arg0,arg1,arg2])
	 * </pre>
	 * 
	 * @param values
	 *            可变参数.
	 */
	public Query createQuery(String hql, Object... values) {
		Assert.hasText(hql);
		Query query = getSession().createQuery(hql);
		for (int i = 0; i < values.length; i++) {
			query.setParameter(i, values[i]);
		}
		return query;
	}

	/**
	 * 创建Query对象<br/>
	 * 通过hibernate的":"占位符形式为变量赋值<br/>
	 * 适合不确定多参数赋值，如：FROM Entity e WHERE e.column in (:column),其中:column可以有多个值
	 * 
	 * @param hql
	 *            预执行的hql语句
	 * @param map
	 *            参数集合，key为字符串占位符，如“ids”,value为对应的值
	 * 
	 */
	public Query createQuery(String hql, Map<String, Object> map) {
		Assert.hasText(hql);
		Query query = getSession().createQuery(hql);
		if (map != null) {
			Iterator<Entry<String, Object>> iterator = map.entrySet().iterator();
			while (iterator.hasNext()) {
				Entry<String, Object> entry = iterator.next();
				Object value = entry.getValue();
				String key = entry.getKey();
				// 目前仅支持以下类型的赋值
				if (value instanceof Collection<?>) {
					query.setParameterList(key, (Collection<?>) value);
				} else if (value instanceof Object[]) {
					query.setParameterList(key, (Object[]) value);
				} else {
					query.setParameter(key, value);
				}
			}
		}
		return query;
	}

	/**
	 * 创建SQLQuery对象.
	 * 
	 * @see createQuery
	 */
	public SQLQuery createSQLQuery(String sql, Object... values) {
		SQLQuery query = getSession().createSQLQuery(sql);
		for (int i = 0; i < values.length; i++) {
			query.setParameter(i, values[i]);
		}
		return query;
	}

	/**
	 * 创建SQLQuery对象<br/>
	 * 通过hibernate的：占位符形式为变量赋值<br/>
	 * 适合不确定多参数赋值，如：SELECT * FROM TAB WHERE column in (:column),其中:column可以有多个值
	 * 
	 * @param sql
	 *            预执行的sql语句
	 * @param map
	 *            参数集合，key为字符串占位符，如“:ids”,value为对应的值
	 * 
	 */
	public SQLQuery createSQLQuery(String sql, Map<String, Object> map) {
		SQLQuery query = getSession().createSQLQuery(sql);
		if (map != null) {
			Iterator<Entry<String, Object>> iterator = map.entrySet().iterator();
			while (iterator.hasNext()) {
				Entry<String, Object> entry = iterator.next();
				Object value = entry.getValue();
				String key = entry.getKey();
				// 目前仅支持以下类型的赋值
				if (value instanceof Collection<?>) {
					query.setParameterList(key, (Collection<?>) value);
				} else if (value instanceof Object[]) {
					query.setParameterList(key, (Object[]) value);
				} else {
					query.setParameter(key, value);
				}
			}
		}
		return query;
	}

	/**
	 * 创建Criteria对象.
	 * 
	 * @param criterions
	 *            可变的Restrictions条件列表,见{@link #createQuery(String,Object...)}
	 */
	public <T> Criteria createCriteria(Class<T> entityClass,
			Criterion... criterions) {
		Criteria criteria = getSession().createCriteria(entityClass);
		for (Criterion c : criterions) {
			criteria.add(c);
		}
		return criteria;
	}

	/**
	 * 创建Criteria对象，带排序字段与升降序字段.
	 * 
	 * @see #createCriteria(Class,Criterion[])
	 */
	public <T> Criteria createCriteria(Class<T> entityClass, String orderBy,
			boolean isAsc, Criterion... criterions) {
		Assert.hasText(orderBy);

		Criteria criteria = createCriteria(entityClass, criterions);

		if (isAsc)
			criteria.addOrder(Order.asc(orderBy));
		else
			criteria.addOrder(Order.desc(orderBy));

		return criteria;
	}

	/**
	 * 根据hql查询,直接使用HibernateTemplate的find函数.
	 * 
	 * @param values
	 *            可变参数,见{@link #createQuery(String,Object...)}
	 */
	@SuppressWarnings("rawtypes")
	public List find(String hql, Object... values) {
		Assert.hasText(hql);
		return getHibernateTemplate().find(hql, values);
	}

	/**
	 * 根据属性名和属性值查询对象.
	 * 
	 * @return 符合条件的对象列表
	 */
	public <T> List<T> findBy(Class<T> entityClass, String propertyName,
			Object value) {
		Assert.hasText(propertyName);
		return createCriteria(entityClass, Restrictions.eq(propertyName, value))
				.list();
	}

	/**
	 * 根据属性名和属性值查询对象,带排序参数.
	 */
	public <T> List<T> findBy(Class<T> entityClass, String propertyName,
			Object value, String orderBy, boolean isAsc) {
		Assert.hasText(propertyName);
		Assert.hasText(orderBy);
		return createCriteria(entityClass, orderBy, isAsc,
				Restrictions.eq(propertyName, value)).list();
	}

	/**
	 * 根据属性名和属性值查询唯一对象.
	 * 
	 * @return 符合条件的唯一对象 or null if not found.
	 */
	public <T> T findUniqueBy(Class<T> entityClass, String propertyName,
			Object value) {
		Assert.hasText(propertyName);
		return (T) createCriteria(entityClass,
				Restrictions.eq(propertyName, value)).uniqueResult();
	}
	
	/**
	 * 根据两个属性取一个对象
	 * @Title: findUniqueBy
	 *
	 * @param entityClass
	 * @param propertyName
	 * @param value
	 * @return
	 */
	public <V> V findUniqueBy(Class<V> entityClass, String[] propertyName, Object[] value){
		if(propertyName!=null && value!=null && propertyName.length==value.length){
			Criteria criteria = getSession().createCriteria(entityClass);
			for (int i = 0; i < propertyName.length; i++) {
				Criterion c = Restrictions.eq(propertyName[i], value[i]);
				criteria.add(c);
			}
			List list = criteria.list();
			if(list!=null && list.size()>0){
				return (V) list.get(0);
			}
		}
		return null;
	}
	
	/**
	 * 根据两个属性取一个对象
	 * @Title: findUniqueBy
	 *
	 * @param entityClass
	 * @param propertyName
	 * @param value
	 * @return
	 */
	public <T> List<T> findBy(Class<T> entityClass, String[] propertyNames, Object[] values){
//		SimpleExpression[3] s = new SimpleExpression()[];
		SimpleExpression criterions[]=new SimpleExpression[propertyNames.length];
		for(int i=0;i<propertyNames.length;i++){
			criterions[i]=Restrictions.eq(propertyNames[i], values[i]);
		}
		return createCriteria(entityClass,criterions).list();
		}
	/**
	 * 根据两个属性取一个对象
	 * @Title: findUniqueBy
	 *
	 * @param entityClass
	 * @param propertyName
	 * @param value
	 * @return
	 */
	public <T> List<T> findBy(Class<T> entityClass, String[] propertyNames, Object[] values,int firstResult,int maxResults){
//		SimpleExpression[3] s = new SimpleExpression()[];
		SimpleExpression criterions[]=new SimpleExpression[propertyNames.length];
		for(int i=0;i<propertyNames.length;i++){
			criterions[i]=Restrictions.eq(propertyNames[i], values[i]);
		}
		return createCriteria(entityClass,criterions).setFirstResult(firstResult).setMaxResults(maxResults).list();
		}

	/**
	 * 判断对象某些属性的值在数据库中是否唯一.
	 * 
	 * @param uniquePropertyNames
	 *            在POJO里不能重复的属性列表,以逗号分割 如"name,loginid,password"
	 */
	public <T> boolean isUnique(Class<T> entityClass, Object entity,
			String uniquePropertyNames) {
		Assert.hasText(uniquePropertyNames);
		Criteria criteria = createCriteria(entityClass).setProjection(
				Projections.rowCount());
		String[] nameList = uniquePropertyNames.split(",");
		try {
			// 循环加入唯一列
			for (String name : nameList) {
				criteria.add(Restrictions.eq(name,
						PropertyUtils.getProperty(entity, name)));
			}

			// 以下代码为了如果是update的情况,排除entity自身.

			String idName = getIdName(entityClass);

			// 取得entity的主键值
			Serializable id = getId(entityClass, entity);

			// 如果id!=null,说明对象已存在,该操作为update,加入排除自身的判断
			if (id != null)
				criteria.add(Restrictions.not(Restrictions.eq(idName, id)));
		} catch (Exception e) {
			ReflectionUtils.handleReflectionException(e);
		}
		return (Integer) criteria.uniqueResult() == 0;
	}

	/**
	 * 取得对象的主键值,辅助函数.
	 */
	@SuppressWarnings("rawtypes")
	public Serializable getId(Class entityClass, Object entity)
			throws NoSuchMethodException, IllegalAccessException,
			InvocationTargetException {
		Assert.notNull(entity);
		Assert.notNull(entityClass);
		return (Serializable) PropertyUtils.getProperty(entity,
				getIdName(entityClass));
	}

	/**
	 * 取得对象的主键名,辅助函数.
	 */
	@SuppressWarnings("rawtypes")
	public String getIdName(Class clazz) {
		Assert.notNull(clazz);
		ClassMetadata meta = getSessionFactory().getClassMetadata(clazz);
		Assert.notNull(meta, "Class " + clazz
				+ " not define in hibernate session factory.");
		String idName = meta.getIdentifierPropertyName();
		Assert.hasText(idName, clazz.getSimpleName()
				+ " has no identifier property define.");
		return idName;
	}

	/**
	 * 去除hql的select 子句，未考虑union的情况,用于pagedQuery.
	 * 
	 * @see #pagedQuery(String,int,int,Object[])
	 */
	@SuppressWarnings("unused")
	private static String removeSelect(String hql) {
		Assert.hasText(hql);
		int beginPos = hql.toLowerCase().indexOf("from");
		Assert.isTrue(beginPos != -1, " hql : " + hql
				+ " must has a keyword 'from'");
		return hql.substring(beginPos);
	}

	/**
	 * 去除hql的orderby 子句，用于pagedQuery.
	 * 
	 * @see #pagedQuery(String,int,int,Object[])
	 */
	@SuppressWarnings("unused")
	private static String removeOrders(String hql) {
		Assert.hasText(hql);
		Pattern p = Pattern.compile("order\\s*by[\\w|\\W|\\s|\\S]*",
				Pattern.CASE_INSENSITIVE);
		Matcher m = p.matcher(hql);
		StringBuffer sb = new StringBuffer();
		while (m.find()) {
			m.appendReplacement(sb, "");
		}
		m.appendTail(sb);
		return sb.toString();
	}

	public <T> long countAll(Class<T> entityClass) {
		Criteria criteria = getSession().createCriteria(entityClass);
		Object count = criteria.setProjection(Projections.rowCount())
				.uniqueResult();
		long result = Long.parseLong(count.toString());
		return result;
	}
	
	
	/**
	 * 根据两个属性取一个对象
	 * @Title: findUniqueBy
	 *
	 * @param entityClass
	 * @param propertyName
	 * @param value
	 * @return
	 */
	public <V> V findUniqueBy(Class<V> entityClass, String[] propertyName, Object[] value,LockMode lockMode){
		if(propertyName!=null && value!=null && propertyName.length==value.length){
			Criteria criteria = getSession().createCriteria(entityClass);
			criteria.setLockMode(lockMode);
			for (int i = 0; i < propertyName.length; i++) {
				Criterion c = Restrictions.eq(propertyName[i], value[i]);
				criteria.add(c);
			}
			List list = criteria.list();
			if(list!=null && list.size()>0){
				return (V) list.get(0);
			}
		}
		return null;
	}
	/**
	 * 根据属性名和属性值查询唯一对象.
	 * 
	 * @return 符合条件的唯一对象 or null if not found.
	 */
	public <T> T findUniqueBy(Class<T> entityClass, String propertyName,
			Object value,LockMode lockMode) {
		Assert.hasText(propertyName);
		return (T) createCriteria(entityClass,
				Restrictions.eq(propertyName, value)).setLockMode(lockMode).uniqueResult();
	}
	
	/**
	 * 根据属性名和属性值查询对象.
	 * 
	 * @return 符合条件的对象列表
	 */
	public <T> List<T> findBy(Class<T> entityClass, String propertyName,
			Object value,LockMode lockMode) {
		Assert.hasText(propertyName);
		return createCriteria(entityClass, Restrictions.eq(propertyName, value)).setLockMode(lockMode)
				.list();
	}

	/**
	 * 根据两个属性取一个对象
	 * @Title: findUniqueBy
	 *
	 * @param entityClass
	 * @param propertyName
	 * @param value
	 * @return
	 */
	public <T> List<T> findBy(Class<T> entityClass, String[] propertyNames, Object[] values,LockMode lockMode){
//		SimpleExpression[3] s = new SimpleExpression()[];
		SimpleExpression criterions[]=new SimpleExpression[propertyNames.length];
		for(int i=0;i<propertyNames.length;i++){
			criterions[i]=Restrictions.eq(propertyNames[i], values[i]);
		}
		return createCriteria(entityClass,criterions).setLockMode(lockMode).list();
		}
}