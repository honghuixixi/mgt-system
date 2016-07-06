package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtDepartmentUserDao;
import cn.qpwa.mgt.facade.system.entity.MgtDepartmentUser;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门用户关联数据访问层接口实现类，提供相关的CRUD操作
 */
@Repository("mgtDepartmentUserDao")
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class MgtDepartmentUserDaoImpl extends HibernateEntityDao<MgtDepartmentUser> implements MgtDepartmentUserDao {

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		// StringBuilder sql = new
		// StringBuilder("select * from t_department_user t where 1=1");
		StringBuilder sql = new StringBuilder("select * from MGT_DEPARTMENT_USER t where 1=1");
		if (null != paramMap) {
			if (paramMap.containsKey("departCode") && StringUtils.isNotBlank(paramMap.get("departCode").toString())) {
				sql.append(" and departCode=:departCode");
				param.put("departCode", paramMap.get("departCode"));
			}
			if (paramMap.containsKey("deptName") && StringUtils.isNotBlank(paramMap.get("deptName").toString())) {
				sql.append(" and deptName like :deptName");
				param.put("deptName", "%" + paramMap.get("deptName") + "%");
			}
			if (paramMap.containsKey("simpName") && StringUtils.isNotBlank(paramMap.get("simpName").toString())) {
				sql.append(" and deptName like :simpName");
				param.put("simpName", "%" + paramMap.get("simpName") + "%");
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				sql.append(" and status=:status");
				param.put("status", paramMap.get("status"));
			}
			if (orderby.containsKey("departCode") && StringUtils.isNotBlank(orderby.get("departCode").toString())) {
				sql.append(" order by departCode asc");
			}
		}
		return this.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public void deleteByUserId(String userId) {
		Query query = super.getSession().createQuery("delete from MgtDepartmentUser s where s.userId=:userId");
		query.setParameter("userId", userId);
		query.executeUpdate();
	}

	@Override
	public List<MgtDepartmentUser> findByUserId(String userId) {
		Query query = super.getSession().createQuery("select s from MgtDepartmentUser s where s.userId=:userId");
		query.setParameter("userId", userId);
		return query.list();
	}
	/**
	 * 根据用户id查询用户所在公司id
	 * @author:lj
	 * @date 2015-6-12 上午11:45:58
	 * @param userId
	 * @return
	 */
	@Override
	public String findDepartmentIdByUserId(String userId){
		StringBuilder sql = new StringBuilder("select (case when t.pId ='-1' then t.id  else t.pId end) as depatementId from MgtDepartmentUser s,MgtDepartment t ");
		sql.append("where s.depatementId = t.id and s.userId = :userId");
		Query query = super.getSession().createQuery(sql.toString());
		query.setParameter("userId", userId);
		return (String)query.uniqueResult();
	}
}