package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.SubaccountDAO;
import cn.qpwa.mgt.facade.system.entity.Subaccount;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;
import org.springframework.util.CollectionUtils;

import java.math.BigDecimal;
import java.util.*;

@Repository("subaccountDAO")
public class SubaccountDAOImpl extends HibernateEntityDao<Subaccount> implements SubaccountDAO{
	/**
	 * 通过用户名、更新余额积分
	 * @param orderID
	 * 			订单id
	 * @return 
	 * @return CouponMas
	 */
	public boolean upSubaccountAmount(String custId, BigDecimal amount, BigDecimal points)
	{
		String sql = "UPDATE SUBACCOUNT SET AMOUNT = nvl(AMOUNT, 0) + ?, POINTS = nvl(POINTS, 0) + ? " +
				" WHERE CUST_ID" +
				" = ?";
		int check = this.getSession().createSQLQuery(sql).setBigDecimal(0, amount).setBigDecimal(1, points).setString(2, custId).executeUpdate();
		if (check > 0){
			return true;
		}
		return false;
	
	}
	

	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select t.*,(SELECT count(*) FROM SUBACCOUNT t1 where t1.CUST_ID=t.CUST_ID and t1.SUBACCOUNT_TYPE='8001') ECITICACCOUNTNUM from SUBACCOUNT t  where 1=1 ");
		if (null != paramMap) {
 
			if (paramMap.containsKey("subaccountType") && StringUtils.isNotBlank(paramMap.get("subaccountType").toString())) {
				sql.append(" and t.SUBACCOUNT_TYPE=:subaccountType");
				param.put("subaccountType", paramMap.get("subaccountType"));
			}
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and t.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
			if (paramMap.containsKey("custName") && StringUtils.isNotBlank(paramMap.get("custName").toString())) {
				sql.append(" and t.CUST_NAME=:custName");
				param.put("custName", paramMap.get("custName"));
			}
			if (paramMap.containsKey("custIds") && StringUtils.isNotBlank(paramMap.get("custIds").toString())) {
				sql.append(" and t.CUST_ID in (:custIds)");
				param.put("custIds", StringUtils.split(paramMap.get("custIds").toString(), ","));
			}
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
	
	@Override
	public Page queryAAMList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select t.id,t.cust_id,t.subaccount_type,t.attached_account,t.cust_name,t.property,t.state from subaccount t where  t.subaccount_type='8001' ");
		if (null != paramMap) {
 
			if (paramMap.containsKey("merchantUserName") && StringUtils.isNotBlank(paramMap.get("merchantUserName").toString())) {
				sql.append(" and t.cust_id in(select user_name from scuser where ref_user_name =:merchantUserName)");
				param.put("merchantUserName", paramMap.get("merchantUserName"));
			}
			
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public void delete(Long[] ids) {
		if (ids != null && ids.length > 0) {
			Query query = super.getSession().createQuery("delete from Subaccount s where s.id in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}


	@Override
	public Page queryBalanceSubaccounts(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select t.id,t.cust_id,t.subaccount_type,t.attached_account,t.cust_name,"
				+ "t.amount,t.cash_amount,t.uncash_amount,freeze_cash_amount,freeze_uncash_amount,t.property,t.state from subaccount t where  t.subaccount_type='9001' ");
		if (null != paramMap) {
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and t.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
			if (paramMap.containsKey("custName") && StringUtils.isNotBlank(paramMap.get("custName").toString())) {
				sql.append(" and t.CUST_NAME like '%" + paramMap.get("custName") + "%'");
			}
			if (paramMap.containsKey("changeTypes") && StringUtils.isNotBlank(paramMap.get("changeTypes").toString())) {
				if("01".equals(paramMap.get("changeTypes"))){
					sql.append(" and t.AMOUNT>0");
				}
			}
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public Page queryBalanceSubaccountDetails(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select se.WORKDATE,se.CHANGE_TYPE,se.REFSN,se.SEQFLAG,t.id,t.cust_id,t.subaccount_type,t.attached_account,t.cust_name,"
				+ "se.amount-se.preamount trans_amt,t.amount,t.cash_amount,t.uncash_amount,freeze_cash_amount,freeze_uncash_amount,t.property,t.state from subaccount t,subaccountseq se"
				+ " where t.id=se.subaccount_id ");
		if (null != paramMap) {
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and t.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
			if (paramMap.containsKey("seqFlag") && StringUtils.isNotBlank(paramMap.get("seqFlag").toString())) {
				sql.append(" and se.SEQFLAG=:seqFlag");
				param.put("seqFlag", paramMap.get("seqFlag"));
			}
			if (paramMap.containsKey("changeTypes") && StringUtils.isNotBlank(paramMap.get("changeTypes").toString())) {
				String[] changeTypes = StringUtils.split(paramMap.get("changeTypes").toString(), ",");
				sql.append(" AND CHANGE_TYPE in(:changeTypes)");
				param.put("changeTypes", changeTypes);
			}
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
				orderby.put("t." + paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
	
	public Map<String,Object> reportAccountInOut(Map<String, Object> paramMap){
		List<String> param = new ArrayList<String>();
		StringBuffer sbuSql = new StringBuffer("select sum (case when ss.seqflag='0' then amount-preamount else 0 end) inval, "//收入
			+"sum (case when ss.seqflag='0' then 0 else preamount-amount end) outval "//支出
			+"from subaccountseq ss where ss.subaccount_type='8001' ");
		if(paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
			sbuSql.append(" AND TO_DATE(ss.WORKDATE, 'yyyyMMdd')>=TO_DATE(?,'yyyy-MM-dd') ");
				param.add(paramMap.get("startDate").toString());
		}
		if(paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
			sbuSql.append(" AND  TO_DATE(ss.WORKDATE, 'yyyyMMdd')<=TO_DATE(?,'yyyy-MM-dd')");
				param.add(paramMap.get("endDate").toString());
		}
		sbuSql.append(" AND nvl(ss.ref_account_code,'N') not in(select sb.attached_account from subaccount sb where sb.subaccount_type='8001')");
		List<Map<String,Object>> results = super.sqlQueryForList(sbuSql.toString(), param.toArray(), null);
		if(CollectionUtils.isEmpty(results)) return null;
		return results.get(0);
	}
	
	public Map<String,Object> reportAmtSpread(Map<String, Object> paramMap){
		List<String> param = new ArrayList<String>();
		StringBuffer sbuSql = new StringBuffer("select sum (case when ss.id='11' then amount else 0 end) qs_val, "//清算户
			+"sum (case when ss.id='12' then amount else 0 end) jx_val, "//公共计息户
			+"sum (case when ss.id='13' then amount else 0 end) tz_val, "//公共调账户
			+"sum (case when ss.id='14' then amount else 0 end) zj_val, "//资金初始化
			+"sum (case when ss.id not in('11','12','13','14') then amount else 0 end) qt_val "//其它
			+"from subaccount ss where ss.subaccount_type='8001' ");
		if(paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
			sbuSql.append(" AND ss.CREATE_TIME>=TO_DATE(?,'yyyy-MM-dd') ");
				param.add(paramMap.get("startDate").toString());
		}
		if(paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
			sbuSql.append(" AND ss.CREATE_TIME<=TO_DATE(?,'yyyy-MM-dd')");
				param.add(paramMap.get("endDate").toString());
		}
		List<Map<String,Object>> results = super.sqlQueryForList(sbuSql.toString(), param.toArray(), null);
		if(CollectionUtils.isEmpty(results)) return null;
		return results.get(0);
	}
}
