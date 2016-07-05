package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtMenuDao;
import cn.qpwa.mgt.facade.system.entity.MgtMenu;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.*;

/**
 * 菜单数据访问层接口实现类，提供菜单相关的CRUD操作
 */
@Repository("mgtMenuDao")
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class MgtMenuDaoImpl extends HibernateEntityDao<MgtMenu> implements MgtMenuDao {

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		// StringBuilder sql = new
		// StringBuilder("select * from t_menu t where 1=1");
		StringBuilder sql = new StringBuilder("select id,pid,code,create_by,create_date,imgsrc,name,sortby,update_by,update_date,url,version,visible from MGT_MENU t where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and name like :name");
				param.put("name", "%" + paramMap.get("name") + "%");
			}
			if (paramMap.containsKey("visible") && StringUtils.isNotBlank(paramMap.get("visible").toString())) {
				sql.append(" and visible=:visible");
				param.put("visible", paramMap.get("visible"));
			}
			if (paramMap.containsKey("acId") && StringUtils.isNotBlank(paramMap.get("acId").toString()) && (paramMap.get("acId")!= paramMap.get("id"))) {
				System.out.println("acId="+paramMap.get("acId").toString());
				sql.append(" and pid=:acId");
				param.put("acId", paramMap.get("acId").toString());
			}
			if (paramMap.containsKey("id") && StringUtils.isNotBlank(paramMap.get("id").toString())) {
				System.out.println("id="+paramMap.get("id").toString());
				sql.append(" and id=:id");
				param.put("id", paramMap.get("id"));
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
		// String sql = "select * from t_menu t where visible=:visible";
		String sql = "select  id,pid,code,create_by,create_date,imgsrc,name,sortby,update_by,update_date,url,version,visible  from MGT_MENU t where visible=:visible";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("visible", paramMap.get("visible"));
		return query.list();
	}

	@Override
	public void delete(String[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createQuery("delete from MgtMenu s where s.id in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}

	@Override
	public List<Map<String, Object>> findByParentId(String pId, String visible) {
		// StringBuffer hql = new
		// StringBuffer("select * from t_menu s where s.pId=:pId");
		StringBuffer hql = new StringBuffer("select * from MGT_MENU s where s.pId=:pId");
		if (StringUtils.isNotBlank(visible)) {
			hql.append(" and s.visible=:visible");
		}
		hql.append(" order by s.sortby ");
		Query query = super.getSession().createSQLQuery(hql.toString())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("pId", pId);
		if (StringUtils.isNotBlank(visible)) {
			query.setParameter("visible", visible);
		}
		return query.list();
	}

	@Override
	public List<MgtMenu> findByMenuIds(Set<String> ids) {
		if (ids != null && ids.size() > 0) {
			Query query = super.getSession().createQuery("select s from MgtMenu s where s.id in (:ids)");
			query.setParameterList("ids", ids);
			return query.list();
		}
		return null;
	}

	@Override
	public int countMneuBySortby(Integer sortby) {
		Query query = super.getSession().createQuery("select count(s) from MgtMenu s where s.sortby=:sortby");
		query.setParameter("sortby", sortby);
		return Integer.parseInt(query.uniqueResult().toString());
	}
	/**
     * 根据角色id列表查询角色对应的菜单
     * @author:lj
     * @date 2015-6-9 下午1:50:54
     * @param paramMap
     * @return
     */
	@Override
    public List queryMenuListByRoleIds(Map<String, Object> paramMap){
		StringBuilder sql = new StringBuilder("select DISTINCT(t.id),t.name ,rr.role_id, rr.role_name from MGT_MENU t "); 
		sql.append("right join  (select t.*,r.ROLE_ID ,mr.name as role_name from MGT_RESOURCE t left join MGT_ROLE_RESOURCE r ");
		sql.append("on t.id = r.RESOURCE_ID left join MGT_ROLE mr on mr.id = r.role_id  where r.ROLE_ID in(:roleIds) and t.status=:status) rr on t.id = rr.MENU_ID where t.visible=:visible ORDER BY RR.ROLE_ID ");
		Query query = super.getSession().createSQLQuery(sql.toString()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameterList("roleIds", (List)paramMap.get("roleIds"));
		query.setParameter("status", paramMap.get("status"));
		query.setParameter("visible", "1");
		return query.list();
    }

	@Override
	public List<MgtMenu> fingMgtMenuByPid(String pid) {
		String hql = "from MgtMenu where pid = :pid";
		Query query = super.getSession().createQuery(hql);
		query.setParameter("pid", pid);
		return query.list();
	}
}












