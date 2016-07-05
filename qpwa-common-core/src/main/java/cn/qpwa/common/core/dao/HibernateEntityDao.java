package cn.qpwa.common.core.dao;

import java.io.Serializable;
import java.util.Collection;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import javax.annotation.Resource;
import javax.management.RuntimeErrorException;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Projections;
import org.hibernate.impl.SessionFactoryImpl;
import org.hibernate.transform.Transformers;
import org.springframework.orm.hibernate3.HibernateCallback;

import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.GenericsUtils;
import cn.qpwa.common.utils.SystemContext;

/**
 * 负责为单个Entity对象提供CRUD操作的Hibernate DAO基类.
 * <p/>
 * 子类只要在类定义时指定所管理Entity的Class, 即拥有对单个Entity对象的CRUD操作.
 * 
 * <pre>
 * 
 * public class UserManager extends HibernateEntityDao&lt;User&gt; {
 * }
 * </pre>
 * 
 * @see HibernateGenericDao
 */
@SuppressWarnings({ "all" })
public class HibernateEntityDao<T> extends HibernateGenericDao implements
		EntityDao<T> {

	@Resource(name = "sessionFactory")
	// 为父类HibernateDaoSupport注入sessionFactory的值
	public void setSuperSessionFactory(SessionFactory sessionFactory) {

		super.setSessionFactory(sessionFactory);
	}

	protected Class<T> entityClass;// DAO所管理的Entity类型.

	/**
	 * 在构造函数中将泛型T.class赋给entityClass.
	 */
	@SuppressWarnings("unchecked")
	public HibernateEntityDao() {

		entityClass = GenericsUtils.getSuperClassGenricType(getClass());
	}

	/**
	 * 取得entityClass.JDK1.4不支持泛型的子类可以抛开Class<T> entityClass,重载此函数达到相同效果。
	 */
	protected Class<T> getEntityClass() {

		return entityClass;
	}

	/**
	 * 根据ID获取对象.
	 * 
	 * @see HibernateGenericDao#getId(Class,Object)
	 */
	public T get(Serializable id) {
		return get(getEntityClass(), id);
	}

	/**
	 * 获取全部对象
	 * 
	 * @see HibernateGenericDao#getAll(Class)
	 */
	public List<T> getAll() {

		return getAll(getEntityClass());
	}

	public void clear() {
		getSession().clear();
	}

	/**
	 * 获取全部对象,带排序参数.
	 * 
	 * @see HibernateGenericDao#getAll(Class,String,boolean)
	 */
	public List<T> getAll(String orderBy, boolean isAsc) {

		return getAll(getEntityClass(), orderBy, isAsc);
	}

	public long countAll() {

		return countAll(getEntityClass());
	}

	/**
	 * 根据ID移除对象.
	 * 
	 * @see HibernateGenericDao#removeById(Class,Serializable)
	 */
	public void removeById(Serializable id) {

		removeById(getEntityClass(), id);
	}

	/**
	 * 删去对象
	 * 
	 * @param hql
	 *            语句
	 * @param values
	 *            参数
	 */
	public int remove(String hql, Object[] values) {
		Query query = this.createQuery(hql, values);
		if (values != null) {
			for (int i = 0; i < values.length; i++)
				query.setParameter(i, values[i]);
		}
		return query.executeUpdate();
	}

	/**
	 * 取得Entity的Criteria.
	 * 
	 * @see HibernateGenericDao#createCriteria(Class,Criterion[])
	 */
	public Criteria createCriteria(Criterion... criterions) {

		return createCriteria(getEntityClass(), criterions);
	}

	/**
	 * 取得Entity的Criteria,带排序参数.
	 * 
	 * @see HibernateGenericDao#createCriteria(Class,String,boolean,Criterion[])
	 */
	public Criteria createCriteria(String orderBy, boolean isAsc,
			Criterion... criterions) {

		return createCriteria(getEntityClass(), orderBy, isAsc, criterions);
	}

	/**
	 * 根据属性名和属性值查询对象.
	 * 
	 * @return 符合条件的对象列表
	 * @see HibernateGenericDao#findBy(Class,String,Object)
	 */
	public List<T> findBy(String propertyName, Object value) {

		return findBy(getEntityClass(), propertyName, value);
	}

	/**
	 * 根据属性名和属性值查询对象,带排序参数.
	 * 
	 * @return 符合条件的对象列表
	 * @see HibernateGenericDao#findBy(Class,String,Object,String,boolean)
	 */
	public List<T> findBy(String propertyName, Object value, String orderBy,
			boolean isAsc) {

		return findBy(getEntityClass(), propertyName, value, orderBy, isAsc);
	}

	/**
	 * 根据属性名和属性值查询单个对象.
	 * 
	 * @return 符合条件的唯一对象 or null
	 * @see HibernateGenericDao#findUniqueBy(Class,String,Object)
	 */
	public T findUniqueBy(String propertyName, Object value) {

		return findUniqueBy(getEntityClass(), propertyName, value);
	}

	/**
	 * 判断对象某些属性的值在数据库中唯一.
	 * 
	 * @param uniquePropertyNames
	 *            在POJO里不能重复的属性列表,以逗号分割 如"name,loginid,password"
	 * @see HibernateGenericDao#isUnique(Class,Object,String)
	 */
	public boolean isUnique(Object entity, String uniquePropertyNames) {

		return isUnique(getEntityClass(), entity, uniquePropertyNames);
	}

	// TODO:CHECK
	public Page sqlqueryForpage(String sql, Map args, LinkedHashMap<String, String> orderby) {
		String sqlString = sql + buildOrderby(orderby);
		SQLQuery query = getSession().createSQLQuery(sqlString);
		this.setParames(args, query);
		Page page = new Page();
		List list = query
				.setFirstResult(
						SystemContext.getOffset().intValue() > 0 ? (SystemContext.getOffset().intValue() - 1)
								* SystemContext.getPagesize().intValue() : SystemContext.getOffset().intValue())
				.setMaxResults(SystemContext.getPagesize().intValue())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();

		// 查询总数
		SQLQuery countQuery = getSession().createSQLQuery(this.getHibernateCountQuery(query.getQueryString()));
		this.setParames(args, countQuery);
		//TODO:
		Integer totalCount = Integer.parseInt(countQuery.uniqueResult().toString());
		page.setTotal(totalCount);
		page.setItems(list);
		return page;
	}
	// TODO:CHECK by sunyang 2016-5-26
	public Page sqlqueryForpage1(String sql, Map args, LinkedHashMap<String, String> orderby) {
		String sqlString = sql + buildOrderby(orderby);
		SQLQuery query = getSession().createSQLQuery(sqlString);
		this.setParames(args, query);
		Page page = new Page();
		List list = query
				.setFirstResult(
						SystemContext.getOffset().intValue() > 0 ? (SystemContext.getOffset().intValue() - 1)
								* SystemContext.getPagesize().intValue() : SystemContext.getOffset().intValue())
								.setMaxResults(SystemContext.getPagesize().intValue())
								.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		
		// 查询总数
		SQLQuery countQuery = getSession().createSQLQuery(this.getHibernateCountQuery1(query.getQueryString()));
		this.setParames(args, countQuery);
		//TODO:
		Integer totalCount = Integer.parseInt(countQuery.uniqueResult().toString());
		page.setTotal(totalCount);
		page.setItems(list);
		return page;
	}
	// TODO:CHECK
	public Map<String,Object> sqlqueryForMap(String sql, Map args) {
		String sqlString = sql;
		SQLQuery query = getSession().createSQLQuery(sqlString);
		this.setParames(args, query);
		Map<String,Object> map = (Map<String, Object>) query
				.setFirstResult(
						SystemContext.getOffset().intValue() > 0 ? (SystemContext.getOffset().intValue() - 1)
								* SystemContext.getPagesize().intValue() : SystemContext.getOffset().intValue())
				.setMaxResults(SystemContext.getPagesize().intValue())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();

		return map;
	}

	public Page queryForpage(String hql) {
		return queryForpage(hql, null, null);
	}

	public Page queryForpage(String hql, LinkedHashMap<String, String> orderby) {
		return queryForpage(hql, null, orderby);
	}

	public Page queryForpage(String hql, Object[] params,
			LinkedHashMap<String, String> orderby) {
		return queryForpage(hql, params, SystemContext.getOffset(),
				SystemContext.getPagesize(), orderby);
	}

	public Page queryForpage(String hql, int offset, int pagesize,
			LinkedHashMap<String, String> orderby) {
		return queryForpage(hql, null, offset, pagesize, orderby);
	}

	public Page queryForpage(String hql, Object values, int offset,
			int pagesize, LinkedHashMap<String, String> orderby) {
		return queryForpage(hql, new Object[] { values }, offset, pagesize,
				orderby);
	}

	public Page queryForpage(String select, Object[] values, int pagestart,
			int pagesize, LinkedHashMap<String, String> orderby) {
		Page page = new Page(
				(SystemContext.getOffset() - SystemContext.getOffset()
						% SystemContext.getPagesize())
						/ SystemContext.getPagesize(),
				SystemContext.getPagesize());
		String countHql = getHibernateCountQuery(select);
		Long totalCount = (Long) queryForObject(countHql, values);
		page.setTotalCount(totalCount.intValue());
		page.setItems(queryForList(select, values, pagestart, pagesize, orderby));
		return page;
	}

	public Page queryForPage(final String selectCount, final String select,
			final Object[] values, int pagestart, final int pagesize,
			final LinkedHashMap<String, String> orderby) {
		Page page = new Page();
		Long totalCount = (Long) queryForObject(selectCount, values);
		page.setTotal(totalCount.intValue());
		page.setItems(queryForList(select, values, pagestart, pagesize, orderby));
		return page;
	}
	
	protected List queryForList(final String select, final Object[] values,
			final int pagestart, final int pagesize,
			final LinkedHashMap<String, String> orderby) {
		HibernateCallback selectCallback = new HibernateCallback() {
			public Object doInHibernate(Session session) {
				Query query = session.createQuery(select
						+ buildOrderby(orderby));
				if (values != null) {
					for (int i = 0; i < values.length; i++)
						query.setParameter(i, values[i]);
				}
				int _pagestart = ((pagestart <= 0 ? 1 : pagestart) - 1) * pagesize;
				return query.setFirstResult(_pagestart).setMaxResults(pagesize)
						.list();
			}
		};
		return (List) getHibernateTemplate().executeFind(selectCallback);
	}

	/**
	 * 通过sql查询分页列表
	 * 注意联合查询的sql语句，由于表中会存在相同的字段名称，此时一定要使用别名区分相同字段的名称
	 * 
	 * @param listSql
	 * @param countSql
	 * @param rowMapper
	 * @param orderby
	 * @return
	 */
	public Page sqlQueryForPage(String sql, Object[] params,
			LinkedHashMap<String, String> orderby) {
		return sqlQueryForPage(sql, params, SystemContext.getOffset(),
				SystemContext.getPagesize(), orderby);
	}

	/**
	 * 通过sql查询分页列表
	 * 注意联合查询的sql语句，由于表中会存在相同的字段名称，此时一定要使用别名区分相同字段的名称
	 * 
	 * @param listSql
	 *            获取列表的SQL
	 * @param countSql
	 *            查询总数的SQL
	 * @param rowMapper
	 *            结果数组转化成对象
	 * @param pagestart
	 * @param pagesize
	 * @param orderby
	 * @return
	 */
	public Page sqlQueryForPage(String sql, Object[] params, int offSet,
			int pagesize, LinkedHashMap<String, String> orderby) {
		// 查询总数
		SQLQuery countQuery = getSession().createSQLQuery(
				getHibernateCountQuery(sql));
		if (null != params && params.length > 0) {
			for (int i = 0; i < params.length; i++) {
				countQuery.setParameter(i, params[i]);
			}
		}
		Integer totalCount = Integer.parseInt(countQuery.uniqueResult()
				.toString());

		Page page = new Page((offSet - offSet % pagesize) / pagesize + 1,
				pagesize);
		page.setTotalCount(totalCount);
		page.setItems(sqlQueryForList(sql, params, offSet, pagesize, orderby));
		return page;
	}

	public Object queryForObject(final String select, final Object[] values) {

		HibernateCallback selectCallback = new HibernateCallback() {
			public Object doInHibernate(Session session) {
				Query query = session.createQuery(select);
				if (values != null) {
					for (int i = 0; i < values.length; i++)
						query.setParameter(i, values[i]);
				}
				return query.uniqueResult();
			}
		};
		return getHibernateTemplate().execute(selectCallback);
	}

	public Object querySQLForObject(final String select, final Object[] values) {

		HibernateCallback selectCallback = new HibernateCallback() {
			public Object doInHibernate(Session session) {
				Query query = session.createSQLQuery(select);
				if (values != null) {
					for (int i = 0; i < values.length; i++)
						query.setParameter(i, values[i]);
				}
				return query.uniqueResult();
			}
		};
		return getHibernateTemplate().execute(selectCallback);
	}

	/**
	 * 返回单实体类
	 * 
	 * @param select
	 * @param values
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public Object findForObject(final String select, final Object[] values) {

		HibernateCallback selectCallback = new HibernateCallback() {
			public Object doInHibernate(Session session) {
				Query query = session.createQuery(select);
				if (values != null) {
					for (int i = 0; i < values.length; i++)
						query.setParameter(i, values[i]);
				}
				return query.uniqueResult();
			}
		};
		return getHibernateTemplate().execute(selectCallback);
	}

	/**
	 * 注意联合查询的sql语句，由于表中会存在相同的字段名称，此时一定要使用别名区分相同字段的名称
	 * 
	 * @param sql
	 * @param params
	 * @param orderby
	 * @return
	 */
	public List<Map<String, Object>> sqlQueryForList(String sql,
			Object[] params, LinkedHashMap<String, String> orderby) {

		return sqlQueryForList(sql, params, SystemContext.getOffset(),
				SystemContext.getPagesize(), orderby);

	}

	public List<Map<String, Object>> sqlQueryForList(String sql,
			Object[] params, Integer offSet, Integer pagesize,
			LinkedHashMap<String, String> orderby) {
		// sql的拼装
		String querySql = null;
		sql += buildOrderby(orderby);
		if (offSet != null && pagesize != null) {
			querySql = getSqlPagingQuery(sql, offSet, pagesize);
		} else {
			querySql = sql;
		}
//		System.out.println(this.getClass().getName() + " | sqlQueryForList | " + querySql);
		SQLQuery listQuery = getSession().createSQLQuery(querySql);
		listQuery.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		int i = 0;
		if (null != params && params.length > 0) {
			for (; i < params.length; i++) {
				listQuery.setParameter(i, params[i]);
			}
		}
		return listQuery.list();
	}

	protected String getSqlPagingQuery(String oldSqlStr, int firstResult,
			int pagesize) {
		StringBuffer buffer = null;
		if (StringUtils.containsIgnoreCase(this.getDialect(), "oracle")) {
			firstResult = ((firstResult <= 0 ? 1 : firstResult) - 1) * pagesize;
			buffer = new StringBuffer(
					"select * from (select t1.*,rownum rownum_ from (")
					.append(oldSqlStr).append(")t1 where rownum <= ")
					.append(firstResult + pagesize)
					.append(")t2 where t2.rownum_ >")
					.append(firstResult);
		} else {
			buffer = new StringBuffer(oldSqlStr);
			if (pagesize > 0) {
				buffer.append(" limit ").append(pagesize);
			}
			if (firstResult > 0) {
				buffer.append(" offset ").append((firstResult - 1) * pagesize);
			}
		}
		return buffer.toString();
	}

	/**
	 * 组装order by语句
	 * 
	 * @param orderby
	 * @return
	 */
	protected static String buildOrderby(LinkedHashMap<String, String> orderby) {

		StringBuffer orderbyql = new StringBuffer(" ");
		if (orderby != null && orderby.size() > 0) {
			orderbyql.append(" order by ");
			for (String key : orderby.keySet()) {
				orderbyql.append(key).append(" ").append(orderby.get(key))
						.append(",");
			}
			orderbyql.deleteCharAt(orderbyql.length() - 1);
		}

		return orderbyql.toString();
	}

	protected String getHibernateCountQuery(String hql) {
		hql = StringUtils.defaultIfEmpty(hql, "");
		String hqltmp = hql.toLowerCase();
		int index = hqltmp.indexOf("from");
		if (StringUtils.countMatches(hqltmp, "from") == 1) {
			return "select count(*) " + hql.substring(index);
		}else if(index != -1 && StringUtils.countMatches(hqltmp, "from") > 1){
			return "select count(*) FROM (" + hql + ")";
		}
		throw new RuntimeErrorException(null, "无效的sql语句");
	}
	
	protected String getHibernateCountQuery1(String hql) {
		hql = StringUtils.defaultIfEmpty(hql, "");
		String hqltmp = hql.toLowerCase();
		int index = hqltmp.indexOf("from");
		if (StringUtils.countMatches(hqltmp, "from") == 1) {
			return "select count(*) FROM (" + hql + ")";
		}else if(index != -1 && StringUtils.countMatches(hqltmp, "from") > 1){
			return "select count(*) FROM (" + hql + ")";
		}
		throw new RuntimeErrorException(null, "无效的sql语句");
	}

	public <V> List<V> queryList(CriteriaModel criteriaModel, Class<V> classes)
			throws Exception {
		List<V> result = null;
		if (criteriaModel != null && classes != null) {
			Criteria criteria = getSession().createCriteria(entityClass);
			criteria = HibernateCriteriaEnum.createCriteriaQuery(criteria,
					criteriaModel);
			result = criteria.list();
		}
		return result;
	}

	public List<T> queryList(CriteriaModel criteriaModel) throws Exception {
		return this.queryList(criteriaModel, getEntityClass());
	}

	public <V> long queryCount(CriteriaModel criteriaModel, Class<V> classes)
			throws Exception {
		long result = 0;
		if (criteriaModel != null && classes != null) {
			Criteria criteria = getSession().createCriteria(entityClass);
			criteria = HibernateCriteriaEnum.createCriteriaQuery(criteria,
					criteriaModel);

			Object count = criteria.setProjection(Projections.rowCount())
					.uniqueResult();
			result = Long.parseLong(count.toString());
		}
		return result;
	}

	public long queryCount(CriteriaModel criteriaModel) throws Exception {
		return this.queryCount(criteriaModel, getEntityClass());
	}

	public <V> PageView<V> queryPage(CriteriaModel criteriaModel,
			Class<V> classes) throws Exception {
		PageView<V> result = null;
		if (classes != null && criteriaModel != null) {
			result = new PageView<V>(criteriaModel.getRows(),
					criteriaModel.getPage());

			Criteria criteria = getSession().createCriteria(classes);
			criteria = HibernateCriteriaEnum.createCriteriaQuery(criteria,
					criteriaModel);

			List<V> items = criteria.list();
			Object count = criteria.setProjection(Projections.rowCount())
					.uniqueResult();
			long total = Long.parseLong(count.toString());

			result.setTotalrecord(total);
			result.setRecords(items);
		}
		return result;
	}

	public PageView<T> queryPage(CriteriaModel criteriaModel) throws Exception {
		return this.queryPage(criteriaModel, getEntityClass());
	}
	
	private String getDialect() {
		SessionFactoryImpl sessionFactory = (SessionFactoryImpl) getSessionFactory();
		return sessionFactory.getDialect().toString();
	}

	/**
	 * 通过参数集合设置sql参数(以参数名匹配)
	 * @param args
	 * @param query
	 */
	private void setParames(Map args, Query query) {
		if ((args != null) && (args.size() > 0)) {
			Iterator<Entry<String, Object>> iterator = args.entrySet().iterator();
			while (iterator.hasNext()) {
				Entry<String, Object> entry = iterator.next();
				if(entry.getValue() instanceof Object[]){
					query.setParameterList(entry.getKey(), (Object[])entry.getValue());
				}else if(entry.getValue() instanceof Collection){
					query.setParameterList(entry.getKey(), (Collection)entry.getValue());
				}else{
					query.setParameter(entry.getKey(), entry.getValue());
				}
			}
		}
	}
}
