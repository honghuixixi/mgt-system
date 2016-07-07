package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.mgt.core.system.dao.MgtRoleResourceDao;
import cn.qpwa.mgt.facade.system.entity.MgtRoleResource;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 资源角色关联数据访问层接口实现类，提供相关的CRUD操作
 */
@Repository("mgtRoleResourceDao")
@SuppressWarnings({ "rawtypes", "deprecation" })
public class MgtRoleResourceDaoImpl extends HibernateEntityDao<MgtRoleResource> implements MgtRoleResourceDao {
	
	@Override
	public List findByList(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select * from t_role_resource t where 1=1");
		// StringBuilder sql = new
		// StringBuilder("select * from MGT_ROLE_RESOURCE t where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("roleId") && StringUtils.isNotBlank(paramMap.get("roleId").toString())) {
				sql.append(" and role_id=:roleId");
				param.put("roleId", paramMap.get("roleId"));
			}
			if (paramMap.containsKey("resourceId") && StringUtils.isNotBlank(paramMap.get("resourceId").toString())) {
				sql.append(" and resource_id=:resourceId");
				param.put("resourceId", paramMap.get("resourceId"));
			}
		}
		return super.find(sql.toString(), param);
	}

	@Override
	public List findByResourceId(String resourceId) {
		Query query = super.getSession().createQuery("select t from MgtRoleResource t where t.resourceId=:resourceId");
		query.setParameter("resourceId", resourceId);
		return query.list();
	}

	@Override
	public void deleteByRoleId(String roleId) {
		Query query = super.getSession().createQuery("delete from MgtRoleResource s where s.roleId=:roleId");
		query.setParameter("roleId", roleId);
		query.executeUpdate();
	}

	@Override
	public void deleteByResourceId(String resourceId) {
		Query query = super.getSession().createQuery("delete from MgtRoleResource s where s.resourceId=:resourceId");
		query.setParameter("resourceId", resourceId);
		query.executeUpdate();
	}

	@Override
	public List findRoleResourceByRoleId(List objects) {
		// String sql =
		// "select * from t_role_resource s where s.role_id in (:roleIds)";
		String sql = "select * from MGT_ROLE_RESOURCE s where s.role_id in (:roleIds)";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameterList("roleIds", objects);
		return query.list();
	}

	@Override
	public List findResourceByRoleId(String roleId) {
		// String sql =
		// "select * from t_resource t where t.id in(select s.resource_id from t_role_resource s where s.role_id=:roleId)";
		String sql = "select * from MGT_RESOURCE t where t.id in(select s.resource_id from MGT_ROLE_RESOURCE s where s.role_id=:roleId)";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("roleId", roleId);
		return query.list();
	}
}