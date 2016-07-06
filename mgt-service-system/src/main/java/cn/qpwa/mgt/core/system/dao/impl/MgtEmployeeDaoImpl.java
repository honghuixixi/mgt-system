package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtEmployeeDao;
import cn.qpwa.mgt.facade.system.entity.MgtEmployee;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户数据访问层接口实现类，提供用户相关的CRUD操作
 */
@Repository("mgtEmployeeDao")
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class MgtEmployeeDaoImpl extends HibernateEntityDao<MgtEmployee> implements MgtEmployeeDao {

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby, List relist) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
		// "select t.*,t2.name departname from t_employee t left join t_department_user t1 on t.id = t1.user_id left join t_department t2 on t1.depatement_id = t2.id where 1=1 and t.status != 2 ");
				"select t.*,t2.name departname from MGT_EMPLOYEE t left join MGT_DEPARTMENT_USER t1 on t.id = t1.user_id left join MGT_DEPARTMENT t2 on t1.depatement_id = t2.id where 1=1 and t.status != 2 ");
		if (null != paramMap) {
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString())) {
				sql.append(" and t.user_name like :userName");
				param.put("userName", "%" + paramMap.get("userName").toString() + "%");
			}
			if (paramMap.containsKey("userCode") && StringUtils.isNotBlank(paramMap.get("userCode").toString())) {
				sql.append(" and t.user_code like '%" + paramMap.get("userCode") + "%'");
			}
			if (paramMap.containsKey("sex") && StringUtils.isNotBlank(paramMap.get("sex").toString())) {
				sql.append(" and t.sex=:sex");
				param.put("sex", paramMap.get("sex"));
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				sql.append(" and t.status=:status");
				param.put("status", paramMap.get("status"));
			}
			if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString())) {
				sql.append(" and t.merchant_code=:merchantCode");
				param.put("merchantCode", paramMap.get("merchantCode"));
			}
			if (paramMap.containsKey("empTypes") && StringUtils.isNotBlank(paramMap.get("empTypes").toString())) {
				String empTypes = paramMap.get("empTypes").toString();
				switch (empTypes) {
				case "1":
					sql.append(" and t.SALESMEN_FLG = 'Y'");
					break;
				case "2":
					sql.append(" and t.LOGISTICS_PROVIDER_FLG = 'Y'");
					break;
				case "3":
					sql.append(" and t.PICK_FLG = 'Y'");
					break;
				default:
					break;
				}
			}
			if (paramMap.containsKey("notUserIds")) {
				sql.append(" and t.id not in ( ");
				List<String> EmployeeIds = (List<String>) paramMap.get("notUserIds");
				int length = EmployeeIds.size();
				for (int i = 0; i < length; i++) {
					String EmployeeId = EmployeeIds.get(i);
					sql.append(" '");
					sql.append(EmployeeId);
					sql.append("'");
					if (i < length - 1) {
						sql.append(" , ");
					}
				}
				sql.append(" ) ");
			}
			// if (paramMap.containsKey("departId")
			// && StringUtils.isNotBlank(paramMap.get("departId")
			// .toString())) {
			// sql.append(" and t2.id=:departId");
			// param.put("departId", paramMap.get("departId"));
			// }
			if (relist.size() > 0) {
				sql.append(" and t2.id in ( ");
				int length = relist.size();
				for (int i = 0; i < length; i++) {
					Map map = (Map) relist.get(i);
					sql.append(" '");
					sql.append(map.get("departId"));
					sql.append("'");
					if (i < length - 1) {
						sql.append(" , ");
					}
				}
				sql.append(" ) ");
			}
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}else{
			orderby.put("t.CREATE_DATE", "DESC");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public void delete(String[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createQuery("delete from MgtEmployee s where s.id in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}

	@Override
	public MgtEmployee getLoginEmployee(MgtEmployee param) {
		Query query = super.getSession().createQuery(
				"select s from MgtEmployee s where s.accountName=:accountName and s.password=:password");
		query.setParameter("accountName", param.getAccountName());
		query.setParameter("password", param.getPassword());

		Object obj = query.uniqueResult();

		if (null != obj) {
			return (MgtEmployee) obj;
		}
		return param;
	}
	
	@Override
	public MgtEmployee findLoginEmployee(MgtEmployee param) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		Query query = super.getSession().createQuery("select s from MgtEmployee s where s.accountName=:accountName");
		query.setParameter("accountName", param.getAccountName());
		query.setProperties(paramMap);
		Object obj = query.uniqueResult();
		if (null != obj) {
			return (MgtEmployee) obj;
		}
		return param;
	}

	@Override
	public String exist(String accountName) {
		String exist = "no";
		Query query = super.getSession().createQuery("select u from MgtEmployee u where accountName=:accountName");
		query.setParameter("accountName", accountName);
		List<MgtEmployee> list = query.list();
		// for (MgtEmployee employee : l) {
		// System.out.println(employee);
		// }
		if (list.isEmpty()) {
			return exist;
		} else {
			exist = "yes";
		}
		return exist;
	}

	@Override
	public MgtEmployee findByAccountName(String accountName) {
		Query query = super.getSession().createQuery("select u from MgtEmployee u where accountName=:accountName");
		query.setParameter("accountName", accountName);
		return (MgtEmployee) query.uniqueResult();
	}

	@Override
	public MgtEmployee findById(String employeeId) {
		Query query = super.getSession().createQuery(
				"select s from MgtEmployee s where s.status!=2 and s.id=:employeeId ");
		query.setParameter("employeeId", employeeId);
		Object obj = query.uniqueResult();
		if (null != obj) {
			return (MgtEmployee) obj;
		}
		return null;
	}

	@Override
	public List<Map<String, Object>> findByList(Map<String, Object> paramMap) {
		// String sql =
		// "select t.user_name name,t.id id from t_employee t where status!=2";
		String sql = "select t.user_name name,t.id id from MGT_EMPLOYEE t where status!=2";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}
	/**
     * 根据用户参数查询数据库中的数据
     * @author:lj
     * @date 2015-7-1 下午5:05:48
     * @param param
     * @return
     */
	@Override
    public MgtEmployee findEmployeeByParam(MgtEmployee param){
    	Map<String, Object> paramMap = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select s from MgtEmployee s where s.accountName=:accountName");
		paramMap.put("accountName", param.getAccountName());
		//liujing add merchantCode 用于人员权限分配中，根据用户名和当前登录用户的merchantCode查询用户名是否存在
		if (StringUtils.isNotBlank(param.getMerchantCode())) {
			sql.append(" and s.merchantCode=:merchantCode");
			paramMap.put("merchantCode", param.getMerchantCode());
		}
		Query query = super.getSession().createQuery(sql.toString());
		query.setProperties(paramMap);
		Object obj = query.uniqueResult();
		
		return (MgtEmployee) obj;
		
    }

	@Override
	public List<Map<String, Object>> getLogisticUser(Map<String,Object> params) {
		String sql = "select me.*,s.LOGISTICS_PROVIDER_FLG,s.USER_NO from MGT_EMPLOYEE me left join SCUSER s ON me.ACCOUNT_name=s.user_name where me.merchant_code=? and  s.LOGISTICS_PROVIDER_FLG='Y'";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, params.get("merchantCode").toString());
		return query.list();
	}

	@Override
	public List<MgtEmployee> findEmployeeByMerchantCode(
			List<BigDecimal> merchantCodes) {
		StringBuffer sql = new StringBuffer("select em.* from mgt_employee em where 1=1");
		if(null !=  merchantCodes && merchantCodes.size() > 0){
			sql.append(" and (" +SqlUtil.getSqlIn(merchantCodes, 1000, "em.MERCHANT_CODE")+")");
		}
		return super.createSQLQuery(sql.toString()).addEntity(MgtEmployee.class).list();
	}
	
	
}