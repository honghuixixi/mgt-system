package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtDepartmentDao;
import cn.qpwa.mgt.facade.system.entity.MgtDepartment;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门数据访问层接口实现类，提供部门相关的CRUD操作
 */
@Repository("mgtDepartmentDao")
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class MgtDepartmentDaoImpl extends HibernateEntityDao<MgtDepartment> implements MgtDepartmentDao {

	@Override
	public List<MgtDepartment> findByParentId(String parentId) {
		Query query = super.getSession().createQuery("select s from MgtDepartment s where s.pId=:parentId");
		query.setParameter("parentId", parentId);
		return query.list();
	}

	@Override
	public List<MgtDepartment> findByCode(String code) {
		Query query = super.getSession().createQuery(
				"select s from MgtDepartment s where s.status!=2 and s.seq like '" + code + "%'");
		List<MgtDepartment> departmentList = query.list();
		return departmentList;
	}

	@Override
	public MgtDepartment findbyId(String depId) {
		Query query = super.getSession()
				.createQuery("select s from MgtDepartment s where s.status!=2 and s.id=:depId ");
		query.setParameter("depId", depId);
		Object obj = query.uniqueResult();
		if (null != obj) {
			return (MgtDepartment) obj;
		}
		return null;
	}

	@Override
	public void delete(String[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createQuery("delete from MgtDepartment s where s.id in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		// StringBuilder sql = new
		// StringBuilder("select * from t_department t where 1=1");
		StringBuilder sql = new StringBuilder("select * from MGT_DEPARTMENT t where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("departCode") && StringUtils.isNotBlank(paramMap.get("departCode").toString())) {
				sql.append(" and DEPART_CODE=:departCode");
				param.put("departCode", paramMap.get("departCode"));
			}
			if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and name like :name");
				param.put("name", "%" + paramMap.get("name") + "%");
			}
			if (paramMap.containsKey("simpName") && StringUtils.isNotBlank(paramMap.get("simpName").toString())) {
				sql.append(" and simp_name like :simpName");
				param.put("simpName", "%" + paramMap.get("simpName") + "%");
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				sql.append(" and status=:status");
				param.put("status", paramMap.get("status"));
			}
			
		}
		return this.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public List queryForList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder(
		// "select t.id, t.pId, t.name from t_department t left join t_department_user t1 on t.id = t1.depatement_id where status=:status");
				"select t.id, t.pId, t.name from MGT_DEPARTMENT t left join MGT_DEPARTMENT_USER t1 on t.id = t1.depatement_id where status=:status");
		if (paramMap.containsKey("pId") && StringUtils.isNotBlank(paramMap.get("pId").toString())) {
			sql.append(" and t.pId =:pId");
		}
		if (paramMap.containsKey("userId") && StringUtils.isNotBlank(paramMap.get("userId").toString())) {
			sql.append(" and t1.user_id =:userId");
		}
		Query query = super.getSession().createSQLQuery(sql.toString())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("status", paramMap.get("status"));
		if (paramMap.containsKey("pId") && StringUtils.isNotBlank(paramMap.get("pId").toString())) {
			query.setParameter("pId", paramMap.get("pId"));
		}
		if (paramMap.containsKey("userId") && StringUtils.isNotBlank(paramMap.get("userId").toString())) {
			query.setParameter("userId", paramMap.get("userId"));
		}
		return query.list();
	}

	@Override
	public void deleteDept(String code) {
		String Hql = "delete from MgtDepartment s where s.seq like '" + code.toString() + "%' ";
		Query query = super.getSession().createQuery(Hql.toString());
		query.executeUpdate();
	}

	@Override
	public String findExist(String departCode) {
		String exist = "no";
		Query query = super.getSession().createQuery("select s from MgtDepartment s where s.departCode=:departCode");
		query.setParameter("departCode", departCode);
		if (query.list().isEmpty()) {
			return exist;
		} else {
			exist = "yes";
		}
		return exist;
	}

	@Override
	public String findExistBySeq(JSONArray jsonArray) {
		String exist = "no";
		StringBuffer sb = new StringBuffer(
		// "select * from t_employee s left join t_department_user s1 on s.id = s1.user_id where s.status !=2");
				"select * from MGT_EMPLOYEE s left join MGT_DEPARTMENT_USER s1 on s.id = s1.user_id where s.status !=2");
		int length = jsonArray.size();
		if (length > 0) {
			sb.append(" and s1.depatement_id in (");
			for (int i = 0; i < length; i++) {
				JSONObject jsonObject = (JSONObject) jsonArray.get(i);
				sb.append("'").append(jsonObject.get("ID")).append("'");
				sb.append(", ");
			}
			sb.deleteCharAt(sb.length() - 2);
			sb.append(") ");
		}
		Query query = super.getSession().createSQLQuery(sb.toString());

		if (query.list().isEmpty()) {
			return exist;
		} else {
			exist = "yes";
		}
		return exist;
	}

	@Override
	public JSONArray findByParentMap(List list) {
		// StringBuilder sql = new
		// StringBuilder("select t.id, t.pId, t.name from t_department t where t.status!=2");
		StringBuilder sql = new StringBuilder("select t.id, t.pId, t.name from MGT_DEPARTMENT t where t.status!=2");
		int length = list.size();
		sql.append(" and t.pId in ( ");
		for (int i = 0; i < length; i++) {
			sql.append("'");
			sql.append(list.get(i));
			sql.append("'");
			sql.append(", ");
		}
		sql.deleteCharAt(sql.length() - 2);
		sql.append(" )");
		Query query = super.getSession().createSQLQuery(sql.toString())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		JSONArray data = new JSONArray();
		List reList = query.list();
		if (null != reList && reList.size() > 0) {
			data = JSONArray.fromObject(reList);
		}
		return data;
	}

	@Override
	public List findDeptByPids(List list) {
		// StringBuilder sql = new
		// StringBuilder("select t.id, t.pId, t.name from t_department t where t.status!=2");
		StringBuilder sql = new StringBuilder("select t.id, t.pId, t.name from MGT_DEPARTMENT t where t.status!=2");
		int length = list.size();
		sql.append(" and t.pId in ( ");
		for (int i = 0; i < length; i++) {
			sql.append("'");
			sql.append(list.get(i));
			sql.append("'");
			sql.append(", ");
		}
		sql.deleteCharAt(sql.length() - 2);
		sql.append(" )");
		Query query = super.getSession().createSQLQuery(sql.toString())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}
	/**
     * 根据分页和查询条件查询部门列表
     * @author:lj
     * @date 2015-6-5 下午1:44:30
     * @param paramMap
     * @param orderby
     * @return
     */
	@Override
    public Page queryDepartmentListByPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderBy){
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select t.ID,t.NAME ,t.DEPART_CODE, t.PID,");
		sql.append("( case when t.pid ='-1' then t.NAME when t.pid!='-1' then (select NAME from MGT_DEPARTMENT d where d.id = t.pid) end) as COMPANY_NAME,t.MEMO ");
		sql.append("from MGT_DEPARTMENT t where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString())) {
				sql.append(" and PID=(select id from MGT_DEPARTMENT m where m.pid = '-1' and m.MERCHANT_CODE = :merchantCode)");
				param.put("merchantCode", paramMap.get("merchantCode"));
			}
			if (paramMap.containsKey("departCode") && StringUtils.isNotBlank(paramMap.get("departCode").toString())) {
				sql.append(" and DEPART_CODE=:departCode");
				param.put("departCode", paramMap.get("departCode"));
			}
			if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and name like :name");
				param.put("name", "%" + paramMap.get("name") + "%");
			}
			if (paramMap.containsKey("simpName") && StringUtils.isNotBlank(paramMap.get("simpName").toString())) {
				sql.append(" and simp_name like :simpName");
				param.put("simpName", "%" + paramMap.get("simpName") + "%");
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				sql.append(" and status=:status");
				param.put("status", paramMap.get("status"));
			}
			
		}
		return super.sqlqueryForpage(sql.toString(), param, orderBy);
	}
	
	/**
     * 根据商家编号上级部门
     * @author:lj
     * @date 2015-6-8 上午10:31:33
     * @param merchantCode
     * @return
     */
	@Override
    public String findParentIdByMerchantCode(String merchantCode){
		String parentId = "";
		Query query = super.getSession().createQuery("select t from MgtDepartment t where t.pId='-1' and  t.merchantCode=:merchantCode");
		query.setParameter("merchantCode", merchantCode);
		List<MgtDepartment> list = query.list();
		if (null != list && list.size()>0) {
			//只取第一条数据就可以
			MgtDepartment mDepartment = list.get(0);
			parentId = mDepartment.getId();
		}
		return parentId;
    }
	/**
     * 根据主键id删除部门
     * @author:lj
     * @date 2015-6-8 下午2:06:34
     * @param id
     */
    public void deleteDepartmentById(String id){
    	String sql = "delete from MgtDepartment s where s.id = :id";
		Query query = super.getSession().createQuery(sql.toString());
		query.setParameter("id", id);
		query.executeUpdate();
    }

}
