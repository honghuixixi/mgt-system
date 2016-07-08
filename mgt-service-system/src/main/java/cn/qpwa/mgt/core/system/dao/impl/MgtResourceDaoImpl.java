package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtResourceDao;
import cn.qpwa.mgt.facade.system.entity.MgtResource;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.*;

/**
 * 资源信息数据访问层接口实现类，提供资源信息相关的CRUD操作
 */
@Repository("mgtResourceDao")
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class MgtResourceDaoImpl extends HibernateEntityDao<MgtResource> implements MgtResourceDao {

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
//		 "select t.*,s.name as menuname from t_resource t left join t_menu s on t.menu_id=s.id where 1=1");
				"select t.*,s.name as menuname from MGT_RESOURCE t left join MGT_MENU s on t.menu_id=s.id where 1=1");
		if (null != paramMap) {

			if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and t.name like :name");
				param.put("name", "%" + paramMap.get("name") + "%");
			}
			if (paramMap.containsKey("menuname") && StringUtils.isNotBlank(paramMap.get("menuname").toString())) {
				sql.append(" and s.name like :menuname");
				param.put("menuname", "%" + paramMap.get("menuname") + "%");
			}
			if (paramMap.containsKey("code") && StringUtils.isNotBlank(paramMap.get("code").toString())) {
				sql.append(" and t.code=:code");
				param.put("code", paramMap.get("code"));
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				sql.append(" and t.status=:status");
				param.put("status", paramMap.get("status"));
			}
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
			if (paramMap.get("orderby").toString().equals("menuname")) {
				orderby.put("s.name", paramMap.get("sord").toString());
			} else {
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public void delete(String[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createQuery("delete from MgtResource s where s.id in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}

	@Override
	public void deleteByMenuIds(String[] menuIds) {
		Query query = super.getSession().createQuery("delete from MgtResource s where s.menuid in (:menuIds)");
		query.setParameterList("menuIds", menuIds);
		query.executeUpdate();
	}

	@Override
	public List findByList(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		List<Object> parms = new ArrayList<Object>();
		StringBuilder sql = new StringBuilder(
//		 "select t.*,s.name menuname from t_resource t left join t_menu s on t.menu_id=s.id where 1=1");
		// "select t.ID,t.CODE,t.CREATE_BY,t.CREATE_DATE,t.MENU_ID,t.MERCHANT_ID,t.NAME,t.ORDERBY,t.RESOURCETYPE_ID,t.STATUS,t.UPDATE_BY,t.UPDATE_DATE,t.URL,t.VALUE,t.VERSION,s.NAME menuname from MGT_RESOURCE t left join MGT_MENU s on t.menu_id=s.id where 1=1");
				"select t,s.name as menuname from MgtResource t, MgtMenu s where t.menuid=s.id and 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("menuid") && StringUtils.isNotBlank(paramMap.get("menuid").toString())) {
				sql.append(" and t.menuid=?");
				param.put("menuid", paramMap.get("menuid"));
				parms.add(paramMap.get("menuid"));
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				sql.append(" and t.status=:status");
				param.put("status", paramMap.get("status"));
				parms.add(paramMap.get("status"));
			}
		}
		return super.find(sql.toString(), parms.toArray());
	}

	@Override
	public List<Map<String, Object>> findResourceByMenuId(String menuId) {
//		 String sql = "select * from t_resource t where t.menu_id=:menuId";
		String sql = "select * from MGT_RESOURCE t where t.menu_id=:menuId";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("menuId", menuId);
		return query.list();
	}

	@Override
	public List<Map<String, Object>> findResourceByIds(String[] ids, String status) {
//		 String sql =
//		 "select * from t_resource t where t.id in(:ids) and t.status=:status";
		String sql = "select * from MGT_RESOURCE t where t.id in(:ids) and t.status=:status";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameterList("ids", ids);
		query.setParameter("status", status);
		return query.list();
	}

	@Override
	public int findResourceByUrl(String url) {
		Query query = super.getSession().createQuery("select count(r) from MgtResource r where r.url=:url");
		query.setParameter("url", url);
		return Integer.parseInt(query.uniqueResult().toString());
	}
	/**
     * 根据角色id数组查询资源列表
     * @author:lj
     * @date 2015-6-9 上午11:39:00
     * @param paramMap
     * @return
     */
    public List queryResourceListByRoleIds(Map<String, Object> paramMap){
    	String sql = "select t.*,r.ROLE_ID from MGT_RESOURCE t left join MGT_ROLE_RESOURCE r on t.id = r.RESOURCE_ID where r.ROLE_ID in(:roleIds) and t.status=:status";
    	Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameterList("roleIds", (List)paramMap.get("roleIds"));
		query.setParameter("status", paramMap.get("status"));
		return query.list();
    }
    
    @Override
	public List findAll() {
    	String sql = "select * from MGT_RESOURCE t where t.status=:status";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("status", "1");
		return query.list();
	}
}