package cn.qpwa.mgt.common.core.dao;

import java.io.Serializable;
import java.util.List;

import org.hibernate.LockMode;

import cn.qpwa.mgt.common.page.PageView;

@SuppressWarnings({"rawtypes","hiding"})
public interface EntityDao<T> {
	T get(Serializable id);

	List<T> getAll();

	void save(Object o);
	
	void merge(Object o);

	void remove(Object o);

	void removeById(Serializable id);

	/**
	 * 获取Entity对象的主键名.
	 */
	String getIdName(Class clazz);

	long countAll();

	public void clear();

	public <V> V findUniqueBy(Class<V> entityClass, String propertyName,
			Object value);

	public <V> V findUniqueBy(Class<V> entityClass, String[] propertyName,
			Object[] value);
	public <V> V findUniqueBy(Class<V> entityClass, String propertyName,
			Object value,LockMode lockMode);

	public <V> V findUniqueBy(Class<V> entityClass, String[] propertyName,
			Object[] value,LockMode lockMode);

	public <V> List<V> findBy(Class<V> entityClass, String propertyName,
			Object value);
	public <T> List<T> findBy(Class<T> entityClass, String[] propertyName, Object[] value);
	public <T> List<T> findBy(Class<T> entityClass, String[] propertyName, Object[] value,int firstResult,int maxResultss);

	/**
	 * 查找list
	 * 
	 * @Title: queryList
	 * 
	 * @param criteriaModel
	 * @return
	 * @throws Exception
	 */
	public <T> List<T> queryList(CriteriaModel criteriaModel) throws Exception;

	public <V> List<V> queryList(CriteriaModel criteriaModel, Class<V> classes)
			throws Exception;

	/**
	 * 查询数量
	 * 
	 * @Title: queryCount
	 * 
	 * @param criteriaModel
	 * @return
	 * @throws Exception
	 */
	public long queryCount(CriteriaModel criteriaModel) throws Exception;

	public <V> long queryCount(CriteriaModel criteriaModel, Class<V> classes)
			throws Exception;

	public PageView<T> queryPage(CriteriaModel criteriaModel) throws Exception;

	public <V> PageView<V> queryPage(CriteriaModel criteriaModel,
			Class<V> classes) throws Exception;
	public <V> List<V> findBy(Class<V> entityClass, String propertyName,
			Object value,LockMode lockMode);
	public <T> List<T> findBy(Class<T> entityClass, String[] propertyName, Object[] value,LockMode lockMode);
}
