package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtEmployeeRoleDao;
import cn.qpwa.mgt.facade.system.entity.MgtEmployeeRole;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

/**
 * 用户角色关联数据访问层接口实现类，提供相关的CRUD操作
 */
@Repository("mgtEmployeeRoleDao")
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class MgtEmployeeRoleDaoImpl extends HibernateEntityDao<MgtEmployeeRole> implements MgtEmployeeRoleDao {

	@Override
	public List findEmployeeRoleByEmployeeId(Map<String, Object> paramMap) {
		// String sql =
		// "select * from t_employee_role t where t.employee_id=:employeeId";
		String sql = "select t.*,r.NAME from MGT_EMPLOYEE_ROLE t left join MGT_ROLE r ON r.id=t.ROLE_ID where t.employee_id=:employeeId";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("employeeId", paramMap.get("employeeId"));
		return query.list();
	}

	@Override
	public List findEmployeeRoleByRoleId(Map<String, Object> paramMap) {
		// String sql =
		// "select * from t_employee_role t where t.role_id=:roleId";
		String sql = "select * from MGT_EMPLOYEE_ROLE t where t.role_id=:roleId";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("roleId", paramMap.get("roleId"));
		return query.list();
	}

	@Override
	public Map<String, Object> findByEmployeeRole(Map<String, Object> paramMap) {
		// String sql =
		// "select * from t_employee_role t where t.employee_id=:employeeId and t.role_id=:roleId";
		String sql = "select * from MGT_EMPLOYEE_ROLE t where t.employee_id=:employeeId and t.role_id=:roleId";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("employeeId", paramMap.get("employeeId"));
		query.setParameter("roleId", paramMap.get("roleId"));
		return (Map<String, Object>) query.uniqueResult();
	}

	@Override
	public void deleteByUser(String employeeId) {
		Query query = super.getSession().createQuery("delete from MgtEmployeeRole s where s.employeeId =:employeeId");
		query.setParameter("employeeId", employeeId);
		query.executeUpdate();
	}

	@Override
	public void deleteByRoleId(String roleId) {
		Query query = super.getSession().createQuery("delete from MgtEmployeeRole s where roleId =:roleId");
		query.setParameter("roleId", roleId);
		query.executeUpdate();
	}
	
	/**
     * 删除用户和角色的配置关系
     * @author:lj
     * @date 2015-6-10 下午2:11:19
     * @param paramMap
     */
	@Override
    public void deleteEmployeeRoleRelation(Map<String, Object> paramMap){
		Query query = super.getSession().createQuery("delete from MgtEmployeeRole s where roleId = :roleId and employeeId = :employeeId");
		query.setParameter("roleId", paramMap.get("roleId"));
		query.setParameter("employeeId", paramMap.get("employeeId"));
		query.executeUpdate();
    }
}