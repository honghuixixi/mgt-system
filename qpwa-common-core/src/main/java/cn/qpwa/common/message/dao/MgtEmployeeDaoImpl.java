package cn.qpwa.common.message.dao;

import cn.qpwa.common.entity.Employee;
import cn.qpwa.common.utils.SqlUtil;
import cn.qpwa.common.core.dao.HibernateEntityDao;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 用户数据访问层接口实现类，提供用户相关的CRUD操作
 */
@Repository("employeeDao")
@SuppressWarnings({ "all"})
public class MgtEmployeeDaoImpl extends HibernateEntityDao<Employee> implements MgtEmployeeDao {

	@Override
	public List<Map<String, Object>> findByList(Map<String, Object> paramMap) {
		String sql = "select t.user_name name,t.id id from MGT_EMPLOYEE t where status!=2";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}
	
	@Override
	public List<Map<String, Object>> getLogisticUser(Map<String,Object> params) {
		String sql = "select me.*,s.LOGISTICS_PROVIDER_FLG,s.USER_NO from MGT_EMPLOYEE me left join SCUSER s ON me.ACCOUNT_name=s.user_name where me.merchant_code=? and  s.LOGISTICS_PROVIDER_FLG='Y'";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, params.get("merchantCode").toString());
		return query.list();
	}

	@Override
	public List<Employee> findEmployeeByMerchantCode(List<BigDecimal> merchantCodes) {
		StringBuffer sql = new StringBuffer("select em.* from mgt_employee em where 1=1");
		if(null !=  merchantCodes && merchantCodes.size() > 0){
			sql.append(" and (" +SqlUtil.getSqlIn(merchantCodes, 1000, "em.MERCHANT_CODE")+")");
		}
		return super.createSQLQuery(sql.toString()).addEntity(Employee.class).list();
	}
	
	
}