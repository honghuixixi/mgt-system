package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.mgt.core.system.dao.PaybillDAO;
import cn.qpwa.mgt.facade.system.entity.Paybill;
import org.hibernate.HibernateException;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.dao.DataAccessResourceFailureException;
import org.springframework.stereotype.Repository;
import org.apache.commons.lang.StringUtils;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.*;

@Repository("paybillDAO")
@SuppressWarnings({"unchecked","rawtypes"})
public class PaybillDAOImpl extends HibernateEntityDao<Paybill> implements  PaybillDAO{

	@Override
	public List findPayBillPrams(Map<String, Object> obj) {
			Query query  = getSession().createSQLQuery(""
					+ "select "
					+ "cb.fee_templetno,"
					+ "cb.channel_payflag,"
					+ "Fee_Cust_Id,"
					+ "cb.channel_account,"
					+ "cb.rechargedtl_status "
					+ "from CHANNEL_BANK_ACCOUNT cb "
					+ "where"
					+ " channel_id=:channelId  "
					+ "and tran_type=:tranType").setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
			query.setParameter("channelId", obj.get("channelId"));
			query.setParameter("tranType", obj.get("tranType"));
		
		return query.list();
	}
	@Override
	public Page<Map<String, Object>> findPaybill(Map<String, Object> jobj){
		
		StringBuffer sql = new StringBuffer("SELECT p.* FROM SCUSER s RIGHT JOIN PAYBILL p ON (p.PAYERCUST_ID=s.USER_NAME OR p.PAYEECUST_ID=s.USER_NAME) WHERE 1=1 ");
		Map<String, Object> para = new HashMap<String, Object>();
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		
		if(jobj.containsKey("userName")) {
			sql.append(" AND s.USER_NAME =:userName ");
			para.put("userName", jobj.get("userName"));
		}
		if (jobj.containsKey("startDate") && StringUtils.isNotBlank(jobj.get("startDate").toString())&&
				jobj.containsKey("endDate") && StringUtils.isNotBlank(jobj.get("endDate").toString())) {
			sql.append(" AND to_char(p.CREATE_TIME,'yyyy-mm-dd') >=:startDate AND to_char(p.CREATE_TIME,'yyyy-mm-dd') <=:endDate");
			para.put("startDate", jobj.get("startDate"));
			para.put("endDate", jobj.get("endDate"));
		}
		if (jobj.containsKey("state") && StringUtils.isNotBlank(jobj.get("state").toString())) {
			sql.append(" AND p.STATE=:state ");
			para.put("state", jobj.get("state"));
		}
		if (jobj.containsKey("minMoney") && StringUtils.isNotBlank(jobj.get("minMoney").toString())&&
				jobj.containsKey("maxMoney") && StringUtils.isNotBlank(jobj.get("maxMoney").toString())) {
			sql.append(" AND p.TRANAMOUNT >=:minMoney AND p.TRANAMOUNT <=:maxMoney");
			para.put("minMoney", jobj.get("minMoney"));
			para.put("maxMoney", jobj.get("maxMoney"));
		}
		if (jobj.containsKey("tradeType") && StringUtils.isNotBlank(jobj.get("tradeType").toString())) {
			if(jobj.get("tradeType").equals("1")){
				sql.append(" AND p.PAYEECUST_ID=:userName ");
			}else{
				sql.append(" AND p.PAYERCUST_ID=:userName ");
			}
			para.put("userName", jobj.get("userName"));
		}
		if (jobj.containsKey("tranType") && StringUtils.isNotBlank(jobj.get("tranType").toString())) {
			sql.append(" AND p.TRAN_TYPE=:tranType ");
			para.put("tranType", jobj.get("tranType"));
		}
		if (jobj.containsKey("payState") && StringUtils.isNotBlank(jobj.get("payState").toString())) {
			sql.append(" AND p.PAY_STATE=:payState ");
			para.put("payState", jobj.get("payState"));
		}
		if (jobj.containsKey("batchidIsNotNull")) {
			sql.append(" AND p.BATCHID IS NOT NULL ");
		}
		if (StringUtils.isNotBlank(jobj.get("orderby").toString())) {
			orderby.put(jobj.get("orderby").toString(), jobj.get("sord").toString());
		}else{
			orderby.put("p.CREATE_TIME", "desc");

		}
		
		return super.sqlqueryForpage(sql.toString(),para,orderby);
	}
	@Override
	public List<Map<String, Object>> findBatchId(String batchid){
		String sql = "SELECT * FROM PAYBILL " +
				"WHERE BATCHID=?";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setParameter(0, batchid).list();
	}
	
	@Override
	public Page<Map<String, Object>> queryPaybillPage(Map<String, Object> params, LinkedHashMap<String, String> orderby) {
		StringBuffer sql = new StringBuffer("SELECT t.*,t1.name logisticusername FROM ORDER_MAS t left join SCUSER t1 on t.LOGISTIC_USER_CODE = t1.USER_NO  WHERE 1=1");
		Map<String, Object> parms = new HashMap<String, Object>();
		
		if(null!=params){
			if(params.containsKey("payStatus") && StringUtils.isNotBlank(params.get("payStatus").toString())) {
				sql.append(" AND t.PAY_STATUS=:payStatus");
				parms.put("payStatus", params.get("payStatus"));
			}
			if(params.containsKey("statusFlg") && StringUtils.isNotBlank(params.get("statusFlg").toString())) {
				sql.append(" AND t.STATUS_FLG=:statusFlg");
				parms.put("statusFlg", params.get("statusFlg"));
			}
			if(params.containsKey("logisticCode") && StringUtils.isNotBlank(params.get("logisticCode").toString())) {
				sql.append(" AND t.LOGISTIC_CODE=:logisticCode");
				parms.put("logisticCode", params.get("logisticCode"));
			}
			if(params.containsKey("batchId") && StringUtils.isNotBlank(params.get("batchId").toString())) {
				sql.append(" AND t.BATCH_ID=:batchId");
				parms.put("batchId", params.get("batchId"));
			}
		}
		orderby = new LinkedHashMap<String, String>();
		if (StringUtils.isNotBlank((String)params.get("orderby"))) {
			orderby.put(params.get("orderby").toString(), params.get("sord").toString());
		}else{
			orderby.put("MAS_DATE", "desc");
		}
		
		return super.sqlqueryForpage(sql.toString(), parms, orderby);
	}
	
	/**
	  * 根据开始时间和结束时间查询账单列表
	  * @author:lj
	  * @param startDate
	  * @param endDate
	  * @return
	  * @date 2015-8-3 下午2:10:42
	  */
	 @Override
	 public List<Paybill> findPaybillByParam(Map<String, Object> params){
	  Map<String,Object> param = new HashMap<String,Object>();
	  StringBuffer sql = new StringBuffer("SELECT * FROM PAYBILL t WHERE 1=1");
	  if(params.containsKey("startDate") && StringUtils.isNotBlank(params.get("startDate").toString())
	    &&params.containsKey("endDate") && StringUtils.isNotBlank(params.get("endDate").toString())){
		   sql.append(" AND t.CREATE_TIME BETWEEN TO_DATE(:startDate,'yyyy-mm-dd hh24:mi:ss') AND TO_DATE(:endDate,'yyyy-mm-dd hh24:mi:ss')");
		   param.put("startDate", params.get("startDate"));
		   param.put("endDate", params.get("endDate"));
	  }
	  if(params.containsKey("rechargeState") && StringUtils.isNotBlank(params.get("rechargeState").toString())) {
		   sql.append(" AND t.RECHARGE_STATE=:rechargeState");
		   param.put("rechargeState", params.get("rechargeState"));
	  }
	  if(params.containsKey("rechargedtlStatus") && StringUtils.isNotBlank(params.get("rechargedtlStatus").toString())) {
		   sql.append(" AND t.RECHARGEDTL_STATUS=:rechargedtlStatus");
		   param.put("rechargedtlStatus", params.get("rechargedtlStatus"));
	  }
	  if(params.containsKey("channelCheckType") && StringUtils.isNotBlank(params.get("channelCheckType").toString())) {
		   sql.append(" AND t.CHANNEL_CHECK_TYPE=:channelCheckType");
		   param.put("channelCheckType", params.get("channelCheckType"));
	  }
	  return super.createSQLQuery(sql.toString(),param).addEntity(Paybill.class).list();
	  
	 }
	 
		@Override
		public Page<Map<String, Object>> PayMethodCheck(Map<String, Object> params, LinkedHashMap<String, String> orderby) {
			StringBuffer sql = new StringBuffer("select to_char(to_date(pd.tran_date,'YYYY-MM-DD HH24:MI:SS'),'yyyy-mm-dd') tran_date,(select name from TRAN_TYPE where code=pd.tran_type) tran_type,"+
											"(select sum(case when pd.payeecust_id=:payWayId then pd.tranamount else 0 end)"+
										"-sum(case when pd.payercust_id=:payWayId then pd.tranamount else 0 end) from paybill pd"+
										" where (pd.payercust_id=:payWayId or pd.payeecust_id=:payWayId) and to_date(pd.tran_date,'YYYY-MM-DD HH24:MI:SS')<:startDate and pd.pay_state='03') begin_money,pd.tran_note,");
			Map<String, Object> parms = new HashMap<String, Object>();
			if(null!=params){
				if (params.containsKey("channelId") && StringUtils.isNotBlank(params.get("channelId").toString())) {
					sql.append(" case when pd.payeecust_id=:payWayId then pd.tranamount else null end - nvl(pd.channel_fee,0) cr,"+
							   " case when pd.payercust_id=:payWayId then pd.tranamount else null end - nvl(pd.channel_fee,0) dr,pd.sn from paybill pd"+
							   " where (pd.payercust_id=:payWayId or pd.payeecust_id=:payWayId)");
					parms.put("payWayId", params.get("channelId").toString());
				}
				if (params.containsKey("startDate") && StringUtils.isNotBlank(params.get("startDate").toString())) {
					sql.append(" AND to_date(pd.tran_date,'YYYY-MM-DD HH24:MI:SS')>=:startDate");
					parms.put("startDate",DateUtil.toDate((String)params.get("startDate")));
				}else{
					parms.put("startDate","");
				}
				if (params.containsKey("tranType") && StringUtils.isNotBlank(params.get("tranType").toString())&& !"0".equals(params.get("tranType").toString())) {
					sql.append(" AND pd.tran_type =:tranType");
					parms.put("tranType",(String)params.get("tranType"));
				}
				if (params.containsKey("tranNote") && StringUtils.isNotBlank(params.get("tranNote").toString())) {
					sql.append(" AND pd.tran_note like :tranNote");
					parms.put("tranNote","%"+params.get("tranNote")+"%");
				}
				if (params.containsKey("endDate") && StringUtils.isNotBlank(params.get("endDate").toString())) {
					sql.append(" AND to_date(pd.tran_date,'YYYY-MM-DD HH24:MI:SS')<=:endDate");
					parms.put("endDate", DateUtil.toDate((String)params.get("endDate")));
				}else{
					sql.append(" AND to_date(pd.tran_date,'YYYY-MM-DD HH24:MI:SS')<=sysdate ");
				}				
			}
			orderby = new LinkedHashMap<String, String>();
			if (StringUtils.isNotBlank((String)params.get("orderby"))) {
				orderby.put(params.get("orderby").toString(), params.get("sord").toString());
			}else{
				orderby.put("TRAN_DATE", "desc");
			}
			
			return super.sqlqueryForpage(sql.toString(), parms, orderby);
		}
		
		@Override
		public Map<String, Object> getAjaxTransDetail(Map<String, Object> params) {
			StringBuffer sql = new StringBuffer("select sum(T.begin_money) sum_begin,sum(T.cr) sum_cr,sum(T.dr) sum_dr from (select case when "+
			" pd.payeecust_id=:channelId then pd.tranamount else null end - nvl(pd.channel_fee,0) cr, case when pd.payercust_id=:channelId then" +
			" pd.tranamount else null end - nvl(pd.channel_fee,0) dr,case when pd.payeecust_id=:channelId then pd.tranamount else 0 end - case when"+
			" pd.payercust_id=:channelId then pd.tranamount else 0 end begin_money from paybill pd where 1=1 ");
			Map<String, Object> parms = new HashMap<String, Object>();
			if(null!=params){
				if (params.containsKey("channelId") && StringUtils.isNotBlank(params.get("channelId").toString())) {
					sql.append(" and (pd.payercust_id=:channelId or pd.payeecust_id=:channelId)");
					parms.put("channelId", params.get("channelId").toString());
				}
				if (params.containsKey("startDate") && StringUtils.isNotBlank(params.get("startDate").toString())) {
					sql.append(" AND to_date(pd.tran_date,'YYYY-MM-DD HH24:MI:SS')<:startDate");
					parms.put("startDate",DateUtil.toDate((String)params.get("startDate")));
				}
				sql.append(" and pd.pay_state='03' ) t");
			}
			
			Query query = super.createSQLQuery(sql.toString(), parms);
			return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
		}
	 
	 /**
	  * 查询每天的汇总记录集合（根据定时任务生成的记录）
	  * @author: lj
	  * @param jobj
	  * @return
	  * @date : 2015-8-5下午4:07:30
	  */
	 @Override
	 public Page<Map<String, Object>> querySummaryPaybillByPage(Map<String, Object> jobj){

		   //查询手动对账，对账状态为未对账的数据
			StringBuffer sql = new StringBuffer("SELECT p.* FROM PAYBILL p  WHERE 1=1 AND p.CHANNEL_CHECK_TYPE= 'N' AND p.CHANNEL_CHECK_STATE='00' ");
			Map<String, Object> para = new HashMap<String, Object>();
			LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
			
			if (jobj.containsKey("startDate") && StringUtils.isNotBlank(jobj.get("startDate").toString())&&
					jobj.containsKey("endDate") && StringUtils.isNotBlank(jobj.get("endDate").toString())) {
				sql.append(" AND to_char(p.CREATE_TIME,'yyyy-mm-dd') >=:startDate AND to_char(p.CREATE_TIME,'yyyy-mm-dd') <=:endDate");
				para.put("startDate", jobj.get("startDate"));
				para.put("endDate", jobj.get("endDate"));
			}
			if (jobj.containsKey("minMoney") && StringUtils.isNotBlank(jobj.get("minMoney").toString())&&
					jobj.containsKey("maxMoney") && StringUtils.isNotBlank(jobj.get("maxMoney").toString())) {
				sql.append(" AND p.TRANAMOUNT >=:minMoney AND p.TRANAMOUNT <=:maxMoney");
				para.put("minMoney", jobj.get("minMoney"));
				para.put("maxMoney", jobj.get("maxMoney"));
			}
			/*//对账类型：Y-自动对帐   N-手动对帐
			if (jobj.containsKey("channelCheckType") && StringUtils.isNotBlank(jobj.get("channelCheckType").toString())) {
				sql.append(" AND p.CHANNEL_CHECK_TYPE=:channelCheckType ");
				para.put("channelCheckType", jobj.get("channelCheckType"));
			}
			//对账状态
			if (jobj.containsKey("channelCheckState") && StringUtils.isNotBlank(jobj.get("channelCheckState").toString())) {
				sql.append(" AND p.CHANNEL_CHECK_STATE=:channelCheckState ");
				para.put("channelCheckState", jobj.get("channelCheckState"));
			}*/
			if (StringUtils.isNotBlank(jobj.get("orderby").toString())) {
				orderby.put(jobj.get("orderby").toString(), jobj.get("sord").toString());
			}
			
			return super.sqlqueryForpage(sql.toString(),para,orderby);
	 }
	 /**
	  * 对账完成
	  * @author: lj
	  * @date : 2015-8-5下午5:02:13
	  */
	@Override
	public String checkPaybill(String sn,String bankSn) throws SQLException {
		Connection conn = super.getSession().connection();
		CallableStatement call = conn.prepareCall("{Call B2B_FIN_UTIL.disasm_trans(?,?,?)}");
		call.setString(1, sn);
		call.setString(2, bankSn);
		//输出参数，如果为空，证明成功
		call.registerOutParameter(3, oracle.jdbc.OracleTypes.VARCHAR);
		call.execute();
	    return call.getString(3);
	}
	@Override
	public void sumPaybillData() {
		try {
			Connection conn = super.getSession().connection();
			CallableStatement call = conn.prepareCall("{Call B2B_FIN_UTIL.collect_fund(?,?)}");
			call.setDate(1, new Date(System.currentTimeMillis()));
			//输出参数，如果为空，证明成功
			call.registerOutParameter(2, oracle.jdbc.OracleTypes.VARCHAR);
			call.execute();
			System.out.println(call.getString(2));
		} catch (DataAccessResourceFailureException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	}
	@Override
	public void paybillB2bData() {
		try {
			Connection conn = super.getSession().connection();
			CallableStatement call = conn.prepareCall("{Call B2B_FIN_UTIL.issue_payment(?,?)}");
			call.setDate(1, new Date(System.currentTimeMillis()));
			//输出参数，如果为空，证明成功
			call.registerOutParameter(2, oracle.jdbc.OracleTypes.VARCHAR);
			call.execute();
			System.out.println(call.getString(2));
		} catch (DataAccessResourceFailureException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalStateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	    
	}
 
@Override
public String calcFee(Map<String, Object> obj) {
	try {
		Connection conn = super.getSession().connection();
		CallableStatement call = conn.prepareCall("{Call B2B_FIN_UTIL.calc_fee(?,?,?,?)}");
		call.setString(1, obj.get("feeTempletNo").toString());
		call.setString(2, obj.get("tranType").toString());
		call.setDouble(3, Double.parseDouble(obj.get("tranAmount").toString()));
		//输出参数，如果为空，证明成功
		call.registerOutParameter(4, oracle.jdbc.OracleTypes.NUMBER);
		call.execute();
		System.out.println(call.getDouble(4));
		return call.getDouble(4)+"";
	} catch (DataAccessResourceFailureException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (HibernateException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IllegalStateException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (SQLException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}
    return null;
}
	@Override
	public void updatePaybill(String key) {
		
		StringBuffer sql = new StringBuffer("update PAYBILL SET  CHECK_STATE='02' where BATCHID="+key);
		
		SQLQuery query = super.createSQLQuery(sql.toString());
		 query.executeUpdate();
	 }
	
	@Override
	public List<Map<String, Object>> ChannelSummary(Map<String, Object> jobj){
		
		StringBuffer sql = new StringBuffer("SELECT  (a.cb+b.wcr-c.wdr-d.nd-f.account) balance,cb,wcr,wdr,nd,account,cr,dr  FROM ");
		List<Object> para = new ArrayList<Object>();
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		if(jobj.containsKey("channelId")) {
			sql.append("(select sum(case when pd.payeecust_id=? then pd.tranamount else 0 end)-sum(case when pd.payercust_id=? then pd.tranamount else 0 end) cb from paybill pd where (pd.payercust_id=? or pd.payeecust_id=?) and pd.pay_state='03') a,(select NVL(sum(case when pd.payeecust_id=? then pd.tranamount else 0 end),0) cr,NVL(sum(case when pd.payercust_id=? then pd.tranamount else 0 end),0) dr from paybill pd where (pd.payercust_id=? or pd.payeecust_id=?) and pd.pay_state='03' ");
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
		}
		if (jobj.containsKey("startDate") && StringUtils.isNotBlank(jobj.get("startDate").toString())) {
			sql.append("  AND pd.tran_date>=? ");
			para.add(jobj.get("startDate").toString().replaceAll("-", ""));
		}
		if (jobj.containsKey("endDate") && StringUtils.isNotBlank(jobj.get("endDate").toString())) {
			sql.append(" and pd.tran_date<=? ");
			para.add(jobj.get("endDate").toString().replaceAll("-", ""));
		}
		if(jobj.containsKey("channelId")) {
			sql.append(" ) ,(select sum(case when pd.channel_id=? and pd.line_type='Z' then pd.tranamount else 0 end) wcr from paybill_dtl pd  where pd.pay_state<>'02') b,(select sum(case when pd.channel_id=? and pd.line_type='A' then pd.tranamount else 0 end) wdr from paybill_dtl pd  where pd.pay_state<>'02') c,(select nvl(sum(pb.tranamount-pb.channel_fee),0)  nd from paybill pb where nvl(pb.disasm_state,'N')='N' and pb.tran_type in('9000','9001') and pb.pay_state='03' and  pb.recharge_sn in(select pb.sn from paybill pb where pb.tran_type='9002' and pb.payeecust_id=?)) d,(select nvl(sum(sa.amount),0) account from subaccount sa where sa.channel_id=?) f");
			System.out.println(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
		}
		
		return super.sqlQueryForList(sql.toString(),para.toArray(),orderby);
	}
	
	@Override
	public List<Map<String, Object>> CrDrdetail(Map<String, Object> jobj){
		StringBuffer sql = new StringBuffer("select pd.tran_subtype, ");
		List<Object> para = new ArrayList<Object>();
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		if(jobj.containsKey("channelId")) {
			System.out.println(jobj.get("channelId"));
			sql.append("  sum(case when pd.payeecust_id=? then pd.tranamount else 0 end) cr, sum(case when pd.payercust_id=? then pd.tranamount else 0 end) dr from paybill pd where (pd.payercust_id=? or pd.payeecust_id=?) and pd.pay_state='03'  ");
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
			para.add(jobj.get("channelId"));
		}
		if (jobj.containsKey("startDate") && StringUtils.isNotBlank(jobj.get("startDate").toString())) {
			sql.append("  AND pd.tran_date>=? ");
			para.add(jobj.get("startDate").toString().replaceAll("-", ""));
		}
		if (jobj.containsKey("endDate") && StringUtils.isNotBlank(jobj.get("endDate").toString())) {
			sql.append(" and pd.tran_date<=? ");
			para.add(jobj.get("endDate").toString().replaceAll("-", ""));
		}
			sql.append(" group by pd.tran_subtype ");
			orderby.put("pd.TRAN_SUBTYPE", "ASC");
		return super.sqlQueryForList(sql.toString(),para.toArray(),orderby);
	}
	@Override
	public Map<String, Object> findWaitPayData() {
		Query query = getSession().createSQLQuery(
				"select su.cust_id,pc.channel_id,pc.channel_account,pc.channel_bank_type bank_type,pc.merchant_no bank_name,su.attached_account bankcardno,su.cust_name bankcardname "
				+ "from SUBACCOUNT su,PAY_CHANNEL pc  "
				+ " where su.cust_id=pc.user_name and su.subaccount_type='8001' "
				+ "and su.cust_id='WLW'  "
				+ "and su.attached_accounttype='A' "
				+ "and pc.platform_flg='Y' ").setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return (Map<String, Object>) query.uniqueResult();
	}
	@Override
	public Map<String, Object> findTranTypeData(Map<String,Object> params) {
		Query query = getSession().createSQLQuery(
				" SELECT cb.fee_templetno,cb.channel_payflag,Fee_Cust_Id,cb.rechargedtl_status,Recharge_account,cb.TRAN_TYPE "
				+ "FROM  CHANNEL_BANK_ACCOUNT cb "
				+ "WHERE cb.channel_id=:channelId "
				+ "and cb.TRAN_TYPE='9102'").setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("channelId", params.get("CHANNEL_ID"));
		return (Map<String, Object>) query.uniqueResult();
	}
}
