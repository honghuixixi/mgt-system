package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtRoleDao;
import cn.qpwa.mgt.facade.system.entity.MgtRole;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 角色信息数据访问层接口实现类，提供角色信息相关的CRUD操作
 */
@Repository("mgtRoleDao")
@SuppressWarnings({ "rawtypes", "deprecation" })
public class MgtRoleDaoImpl extends HibernateEntityDao<MgtRole> implements MgtRoleDao {

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		// StringBuilder sql = new
		// StringBuilder("select * from t_role t where 1=1");
		StringBuilder sql = new StringBuilder("select t.*,s.NAME as MERCHANT_NAME from MGT_ROLE t left join SCUSER s on s.USER_NO = t.MERCHANT_CODE where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and t.name like :name");
				param.put("name", "%" + paramMap.get("name") + "%");
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				sql.append(" and status=:status");
				param.put("status", paramMap.get("status"));
			}
			if (paramMap.containsKey("visible") && StringUtils.isNotBlank(paramMap.get("visible").toString())) {
				sql.append(" and visible=:visible");
				param.put("visible", paramMap.get("visible"));
			}
			if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString())) {
				sql.append(" and MERCHANT_CODE=:merchantCode");
				param.put("merchantCode", paramMap.get("merchantCode"));
			}
			if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public List findByList(Map<String, Object> paramMap) {
		// String sql = "select * from t_role t where status=:status";
		StringBuilder sql = new StringBuilder("select * from MGT_ROLE t where status=:status ");
		if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString())) {
			sql.append(" and MERCHANT_CODE=:merchantCode");
		}
		Query query = super.createSQLQuery(sql.toString(),paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}

	@Override
	public void delete(String[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createQuery("delete from MgtRole s where s.id in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}

	@Override
	public List findByName(String name) {
		// String sql = "select * from t_role t where name=:name";
		String sql = "select * from MGT_ROLE t where name=:name";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("name", name);
		return query.list();
	}
	
	/**
     * 根据用户id和商户code查询用户该商户下的角色
     * @author:lj
     * @date 2015-6-8 下午6:06:49
     * @param paramMap
     * @return
     */
	@SuppressWarnings("unchecked")
	@Override
    public List<MgtRole> findRoleListByMap(Map<String, Object> paramMap){
		StringBuilder sql = new StringBuilder("select  DISTINCT(r.id), r.* from MGT_ROLE r left join  MGT_EMPLOYEE_ROLE  e on r.id = e.ROLE_ID ");
		sql.append("where r.status = :status and e.EMPLOYEE_ID = :employeeId ");
		if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString())) {
			sql.append(" or r.MERCHANT_CODE = :merchantCode");
		}
		return super.createSQLQuery(sql.toString(), paramMap).addEntity(MgtRole.class).list();
		
    }
	
	/**
     * 修改角色的工作域属性
     * @author:lj
     * @date 2015-6-9 上午9:19:10
     * @param paramMap（RoleIds,scope）
     */
	@Override
    public void modifyRoleScope(Map<String, Object> paramMap){
		String[] ids = paramMap.get("ids").toString().split(",");
		String scope = paramMap.get("scope").toString();
		Query query = super.getSession().createQuery("update  MgtRole s set s.scope = :scope where s.id in (:ids)");
		query.setParameter("scope", scope);
		query.setParameterList("ids", ids);
		query.executeUpdate();
    }



	@Override
	public List findByAll(Map<String, Object> paramMap) {
		// String sql = "select * from t_role t where status=:status";
		StringBuilder sql = new StringBuilder("select t from MgtRole t where visible=:visible ");
		if (paramMap.containsKey("merchantCode") && null!=paramMap.get("merchantCode")) {
			sql.append(" and merchantCode=:merchantCode");
		}
		Query query = getSession().createQuery(sql.toString());
		query.setParameter("visible", paramMap.get("visible"));
		if (paramMap.containsKey("merchantCode") && null!=paramMap.get("merchantCode")) {
		query.setParameter("merchantCode", paramMap.get("merchantCode"));
		}
		return query.list();
	}

	@Override
	public List<Map<String, Object>> findByPublc(Map<String, Object> params) {
		StringBuffer sql = new StringBuffer("SELECT * from MGT_ROLE where 1=1");
		if (params.containsKey("publicFlg") && null!=params.get("publicFlg")) {
			sql.append(" and PUBLIC_FLG=:publicFlg");
		}
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), params).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	
}