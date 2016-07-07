package cn.qpwa.mgt.core.system.dao.impl;


import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;

import cn.qpwa.common.utils.AreaSetSqlUtil;
import cn.qpwa.common.utils.ValidateUtil;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.mgt.core.system.dao.OrderMasDAO;
import cn.qpwa.mgt.facade.system.entity.OrderMas;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.Map.Entry;

@Repository("orderMasDAO")
@SuppressWarnings({ "unchecked", "deprecation", "rawtypes" })
public class OrderMasDAOImpl extends HibernateEntityDao<OrderMas> implements OrderMasDAO {
	public static final Logger log = Logger.getLogger(OrderMasDAOImpl.class);

	@Override
	public Page<Map<String, Object>> findOrderMas(Map<String, Object> obj) {
		List<Object> parms = new ArrayList<Object>();
		StringBuffer sql = new StringBuffer(
				"SELECT nvl((om.CREATE_DATE- to_date('1970-01-01 08:00:00','yyyy-mm-dd hh24:mi:ss'))* 24*60*60*1000, 0) as OM_CREATE_DAT,om.*,sm.STM_NAME,trunc(sysdate-MAS_DATE) as DIF_DAY,s.NAME as LOGISTIC_USER_NAME  FROM ORDER_MAS om LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE LEFT JOIN SCUSER s ON  om.LOGISTIC_USER_CODE=s.USER_NO WHERE INTERNAL_FLG = 'N' AND om.MAS_CODE='SALES' AND om.USER_NO=?");
		parms.add(obj.get("userNo"));
		
		if (obj.containsKey("statusFlg")) {
			Object statusObj = obj.get("statusFlg");
			if (statusObj != null && "WAITPAYMENT".equals(statusObj.toString())) {//判断statusFlg是否为待付款状态，如果是则加入判断：支付方式为在线支付，若不是则查询其他状态
				sql.append(" AND (om.STATUS_FLG='WAITPAYMENT' AND sm.STM_CODE='4028b88146176a290146176a8ebc0000')");
			} else if (statusObj != null && "DOING".equals(statusObj.toString())) {
				sql.append(" AND (om.STATUS_FLG!='SUCCESS' AND om.STATUS_FLG!='CLOSE')");
		    }else if (statusObj != null && StringUtils.isNotBlank(statusObj.toString())) {
				sql.append(" AND om.STATUS_FLG=?");
				parms.add(statusObj.toString());
			}
		}
		if (obj.containsKey("payStatus") && StringUtils.isNotBlank((String)obj.get("payStatus"))) {
			sql.append(" AND om.PAY_STATUS=?");
			//如果是已支付订单状态应为已完成（针对app项目）
			if(((String)obj.get("payStatus")).equals("PAID"))
			{
				sql.append(" AND STATUS_FLG = 'SUCCESS'");
			}
			parms.add(obj.get("payStatus").toString());
		}
		LinkedHashMap<String, String> order = new LinkedHashMap<String, String>();
		order.put("om.CREATE_DATE", "DESC");
		return super.sqlQueryForPage(sql.toString(), parms.toArray(), order);
	}

	/**
	 * 通过参数集合条件，获取订单列表
	 * 
	 * @param paramMap
	 *            参数集合，可入参：用户ID(userNo)、订单编号(masNo)、订单状态(statusFlg)、商户ID(
	 *            vendorUserNo)
	 * @param orderby
	 *            排序条件集合
	 * 
	 * @return 订单分页集合
	 */
	public Page findOrderMas(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"  SELECT to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,om.*,sm.STM_NAME,TO_CHAR(om.MAS_NO) CHAR_MAS_NO,op.PAY_AMOUNT,sc.NAME," +
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'Y' and MAS_PK_NO = om.PK_NO), 0)AS COUPON_AMOUNT," + //优惠劵
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'P' and MAS_PK_NO = om.PK_NO), 0)AS POINTS_AMOUNT," + //积分
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'B' and MAS_PK_NO = om.PK_NO), 0)AS B_AMOUNT," + //余额
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'T' and MAS_PK_NO = om.PK_NO), 0)AS T_AMOUNT," + //代缴货款
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'O' and MAS_PK_NO = om.PK_NO), 0)AS O_AMOUNT" + //银行卡
				"  FROM ORDER_MAS om " +
				"  LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE " +
				"  LEFT JOIN ORDER_PAYMENT op ON op.MAS_PK_NO=om.MAS_NO " +
				"  LEFT JOIN SCUSER sc ON om.LOGISTIC_USER_CODE = sc.USER_NO  WHERE 1=1 ");
		
		if (null != paramMap) {
			//-by L.Dragon
			//-by L.Dragon
			if (!paramMap.containsKey("refPkNo")){
				sql.append(" AND INTERNAL_FLG = 'N'");
				if (paramMap.containsKey("statusFlg") && paramMap.get("statusFlg")!= null) {
					if (StringUtils.isNotBlank(paramMap.get("statusFlg").toString())) {
						sql.append(" AND om.STATUS_FLG=:statusFlg");
						param.put("statusFlg", paramMap.get("statusFlg"));
					}
				}
			}else{
				//b2b主站查询大订单列表需要-by liujing
				if(paramMap.get("refPkNo") == null){
					sql.append(" AND om.REF_PK_NO is null");
				}else {
					sql.append(" AND om.REF_PK_NO =:refPkNo");
					param.put("refPkNo", paramMap.get("refPkNo"));
			   }
				if (paramMap.containsKey("statusFlg")) {
					Object statusFlg = paramMap.get("statusFlg");
					if (statusFlg != null && "DOING".equals(statusFlg.toString())) {
						sql.append("  AND (om.STATUS_FLG in('WAITPAYMENT','INPROCESS', 'WAITDELIVER', 'DELIVERED', 'RETURNSING') " +
								   "  OR  om.STATUS_FLG in('SUCCESS') AND om.PAY_STATUS NOT IN('PAID'))");
					}
					if (statusFlg != null && "SUCCESS".equals(statusFlg.toString())) {
						sql.append("  AND (om.STATUS_FLG in('SUCCESS') AND om.PAY_STATUS in('PAID'))" );
					}
					if (statusFlg != null && "CLOSE".equals(statusFlg.toString())) {
						sql.append("  AND (om.STATUS_FLG in('CLOSE'))");
					}
				}
			}
			if (paramMap.containsKey("userNo") && StringUtils.isNotBlank(paramMap.get("userNo").toString())) {
				sql.append(" AND om.USER_NO=:userNo");
				param.put("userNo", paramMap.get("userNo"));
			}
			if (paramMap.containsKey("vendorUserNo") && StringUtils.isNotBlank(paramMap.get("vendorUserNo").toString())) {
				sql.append(" AND om.VENDOR_USER_NO=:vendorUserNo");
				param.put("vendorUserNo", paramMap.get("vendorUserNo"));
			}
			if (paramMap.containsKey("masNo") && StringUtils.isNotBlank(paramMap.get("masNo").toString())) {
				sql.append(" AND om.MAS_NO like :masNo");
				param.put("masNo", "%" + paramMap.get("masNo") + "%");
			}
			if (paramMap.containsKey("subStatus") && StringUtils.isNotBlank(paramMap.get("subStatus").toString())) {
				sql.append(" AND om.SUB_STATUS=:subStatus");
				param.put("subStatus", paramMap.get("subStatus"));
			}
			if (StringUtils.isNotBlank((String)paramMap.get("orderby"))) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
			if(!paramMap.containsKey("Flg")){
				sql.append(" AND om.MAS_CODE = 'SALES'");
			}
			//退货单 -by TheDragonLord
			if (paramMap.containsKey("Flg") && StringUtils.isNotBlank(paramMap.get("Flg").toString()) && paramMap.get("Flg").equals("INPROCESS")) {
				sql.append(" AND ( om.MAS_CODE = 'RETURN' AND om.WH_C=:whC AND om.STATUS_FLG = 'INPROCESS' AND om.ORDER_TYPE IN ('LBP','FBP'))");
				param.put("whC", paramMap.get("whC"));
			} 
			if (paramMap.containsKey("Flg") && StringUtils.isNotBlank(paramMap.get("Flg").toString()) && paramMap.get("Flg").equals("DELIVERED")) {
				sql.append(" AND ( om.MAS_CODE='RETURN' AND om.ORDER_TYPE ='LBP' AND om.STATUS_FLG='DELIVERED' AND om.WH_C = :whC)");
				param.put("whC", paramMap.get("whC"));
			}
			if (paramMap.containsKey("Flg") && StringUtils.isNotBlank(paramMap.get("Flg").toString()) && paramMap.get("Flg").equals("SUCCESS")) {
				sql.append(" AND (  om.MAS_CODE = 'RETURN' AND om.ORDER_TYPE IN ('LBP','FBP') AND om.STATUS_FLG = 'SUCCESS' AND om.WH_C=:whC)");
				param.put("whC", paramMap.get("whC"));
			}
		}
   		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
	
	@Override
	public Page findOrderMasGather(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(mom.MAS_DATE,'yyyy-mm-dd hh24:mi:ss'),to_char(mom.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss'),mom.*,TO_CHAR(mom.MAS_NO) CHAR_MAS_NO FROM MERGE_ORDER_MAS mom ");
		if (null != paramMap) {
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString())) {
				sql.append(" WHERE MAS_CODE='VNMERGE' AND mom.SP_USER_NAME=:userName");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("masCode") && StringUtils.isNotBlank(paramMap.get("masCode").toString())) {
				sql.append(" WHERE MAS_CODE='VNMERGE' AND mom.MAS_CODE =:masCode");
				param.put("masCode", paramMap.get("masCode"));
			}
			if (paramMap.containsKey("destWhC") && StringUtils.isNotBlank(paramMap.get("destWhC").toString())) {
				sql.append(" WHERE MAS_CODE IN ('VNMERGE','WHMERGE') AND mom.DEST_WH_C =:destWhC");
				param.put("destWhC", paramMap.get("destWhC"));
			}
			if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())) {
				sql.append("  AND mom.STATUS_FLG=:statusFlg");
				param.put("statusFlg", paramMap.get("statusFlg"));
			}
			if (StringUtils.isNotBlank((String)paramMap.get("orderby"))) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
	
	@Override
	public Page getMergeOrderMas(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(mom.MAS_DATE,'yyyy-mm-dd hh24:mi:ss'),to_char(mom.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss'),mom.*,TO_CHAR(mom.MAS_NO) CHAR_MAS_NO FROM MERGE_ORDER_MAS mom where 1 = 1");
		if (null != paramMap) {
			if (paramMap.containsKey("masCode") && StringUtils.isNotBlank(paramMap.get("masCode").toString())) {
				
				sql.append(" AND mom.MAS_CODE IN (:masCode)");
				param.put("masCode", paramMap.get("masCode").toString().split(","));
			}
			if (paramMap.containsKey("destWhC") && StringUtils.isNotBlank(paramMap.get("destWhC").toString())) {
				//汇总单状态为已完成时，发出方和接收方都是本仓库的所有汇总单都要查询出来
				String masCode = (String)paramMap.get("masCode");
				String statusFlg = (String)paramMap.get("statusFlg");
				if("VNMERGE,WHMERGE".equals(masCode) && "P".equals(statusFlg)){
					sql.append(" AND (mom.DEST_WH_C =:destWhC or mom.ACC_CODE=:accCode)");
					param.put("destWhC", paramMap.get("destWhC"));
					param.put("accCode", paramMap.get("destWhC"));
				}else{
					sql.append(" AND mom.DEST_WH_C =:destWhC");
					param.put("destWhC", paramMap.get("destWhC"));
				}
			}
			if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())) {
				sql.append(" AND mom.STATUS_FLG=:statusFlg");
				param.put("statusFlg", paramMap.get("statusFlg"));
			}
			
			if (paramMap.containsKey("accCode") && StringUtils.isNotBlank(paramMap.get("accCode").toString())) {
				sql.append(" AND mom.ACC_CODE=:accCode");
				param.put("accCode", paramMap.get("accCode"));
			}
			if (paramMap.containsKey("accName") && StringUtils.isNotBlank(paramMap.get("accName").toString())) {
				sql.append(" AND mom.ACC_NAME like :accName");
				param.put("accName", "%" + paramMap.get("accName") + "%");
			}
			if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public List<Map<String, Object>> getOrigOrderMas(BigDecimal PK_NO){
		String sql= "select oi.* ,pm.PLU_C plu_c from ORDER_ITEM oi left join PLU_MAS pm ON pm.STK_C = oi.STK_C where oi.MAS_PK_NO= ? order by oi.ITEM_NO";		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, PK_NO).list();
	}
	
	@Override
	public Map<String, String> findOrderMasStatusCount(BigDecimal userID) {
		//2015-12-10 lj,将查询大订单的统计数量，修改为查询子订单和正常订单，将REF_PK_NO is null 修改INTERNAL_FLG ='N'
		String sql = "SELECT (SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND REF_PK_NO is null AND USER_NO=?) TOTAL,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND (STATUS_FLG IN ('WAITPAYMENT','INPROCESS', 'WAITDELIVER', 'DELIVERED', 'RETURNSING') OR  (STATUS_FLG ='SUCCESS' AND PAY_STATUS != 'PAID'))) DOING,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND STATUS_FLG='WAITDELIVER') WAITDELIVER,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND STATUS_FLG='DELIVERED') DELIVERED,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND STATUS_FLG ='SUCCESS' AND PAY_STATUS ='PAID') SUCCESS,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND STATUS_FLG='RETURNSING') RETURNSING,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND STATUS_FLG='CLOSE') CLOSE,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND PAY_STATUS='WAITPAYMENT') WAITPAYMENT,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND PAY_STATUS='PAID') PAID,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND PAY_STATUS='PAYMENTPROCESS') PAYMENTPROCESS,"
				+ "(SELECT COUNT(*) FROM ORDER_MAS WHERE MAS_CODE = 'SALES' AND INTERNAL_FLG ='N' AND USER_NO=? AND PAY_STATUS='REFUNDMENT') REFUNDMENT FROM DUAL";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, String>) query.setBigDecimal(0, userID).setBigDecimal(1, userID).setBigDecimal(2, userID)
				.setBigDecimal(3, userID).setBigDecimal(4, userID).setBigDecimal(5, userID).setBigDecimal(6, userID)
				.setBigDecimal(7, userID).setBigDecimal(8, userID).setBigDecimal(9, userID).setBigDecimal(10, userID)
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}


	@Override
	public Map<String, String> findOrderMasStatusCountByMerchantCode(BigDecimal merchantCode) {
		String sql = "";
		SQLQuery query = null;
		if (merchantCode == null) {
			sql = "SELECT"
					+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND STATUS_FLG='INPROCESS') INPROCESS,"
					+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND STATUS_FLG='WAITDELIVER') WAITDELIVER,"
					+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND STATUS_FLG='DELIVERED') DELIVERED,"
					+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND STATUS_FLG='RETURNSING') RETURNSING,"
					+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND STATUS_FLG='SUCCESS') SUCCESS,"
					+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND STATUS_FLG='CLOSE') CLOSE"
					+ " FROM DUAL";
			query = super.getSession().createSQLQuery(sql);
			return (Map<String, String>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
		}
		sql = "SELECT"
				+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND VENDOR_USER_NO=? AND STATUS_FLG='INPROCESS') INPROCESS,"
				+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND VENDOR_USER_NO=? AND STATUS_FLG='WAITDELIVER') WAITDELIVER,"
				+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND VENDOR_USER_NO=? AND STATUS_FLG='DELIVERED') DELIVERED,"
				+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND VENDOR_USER_NO=? AND STATUS_FLG='RETURNSING') RETURNSING,"
				+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND VENDOR_USER_NO=? AND STATUS_FLG='SUCCESS') SUCCESS,"
				+ " (SELECT COUNT(*) FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND VENDOR_USER_NO=? AND STATUS_FLG='CLOSE') CLOSE"
				+ " FROM DUAL";
		query = super.getSession().createSQLQuery(sql);

		return (Map<String, String>) query.setBigDecimal(0, merchantCode).setBigDecimal(1, merchantCode)
				.setBigDecimal(2, merchantCode).setBigDecimal(3, merchantCode).setBigDecimal(4, merchantCode)
				.setBigDecimal(5, merchantCode).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public Map<String, Object> findUniqueOrderMas(BigDecimal userID, BigDecimal orderID) {
		StringBuffer sql = new StringBuffer(
				"SELECT sc3.REMARK5,sc2.NAME as LNAME,sc1.NAME as empname,sc1.CRM_MOBILE as empMobile,to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DAT,to_char(om.MODIFY_DATE,'yyyy-mm-dd hh24:mi:ss') OM_MODIFY_DATE,om.*,sm.STM_NAME STM_NAME,scm.SC_ADDRESS SC_ADDRESS," +
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'Y' and MAS_PK_NO = om.PK_NO), 0)AS COUPON_AMOUNT," + //优惠券
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'P' and MAS_PK_NO = om.PK_NO), 0)AS POINTS_AMOUNT," + //积分
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'T' and MAS_PK_NO = om.PK_NO), 0)AS T_AMOUNT," + //代缴货款
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'B' and MAS_PK_NO = om.PK_NO), 0)AS B_AMOUNT," + //余额
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'O' and MAS_PK_NO = om.PK_NO), 0)AS O_AMOUNT" + //银行卡
				" FROM ORDER_MAS om LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE LEFT JOIN SELF_COLLECT_MAS scm ON scm.PK_NO=om.SC_PK_NO"
						+" LEFT JOIN SCUSER sc ON sc.USER_NO=om.USER_NO LEFT JOIN SCUSER sc1 ON sc1.USER_NO=sc.PIC_NO LEFT JOIN SCUSER sc2 ON sc2.USER_NO=om.LOGISTIC_CODE LEFT JOIN SCUSER sc3 ON sc3.USER_NAME=om.VENDOR_CODE WHERE 1=1 AND om.PK_NO=?");
		if (userID != null)
			sql.append(" and om.USER_NO=? ");
		Query query = super.getSession().createSQLQuery(sql.toString())
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setBigDecimal(0, orderID);
		if (userID != null)
			query.setBigDecimal(1, userID);
		return (Map<String, Object>) query.uniqueResult();
	}

	@Override
	public void executeSplitOrder(BigDecimal orderId) throws SQLException {
		Connection conn = super.getSession().connection();
		CallableStatement call = conn.prepareCall("{Call B2B_SITE_UTIL.split_order(?,?,?,?)}");
		call.setBigDecimal(1, orderId);
		call.registerOutParameter(2, oracle.jdbc.OracleTypes.NUMBER);
		call.registerOutParameter(3, oracle.jdbc.OracleTypes.VARCHAR);
		call.registerOutParameter(4, oracle.jdbc.OracleTypes.VARCHAR);
		call.execute();
		Object p_count = call.getObject(2);
		// 第一个返回值小于1时，说明分单失败
		if (p_count == null || ((BigDecimal) p_count).signum() < 1) {
//			call.getObject(2);
			StringBuffer info = new StringBuffer("Call B2B_SITE_UTIL.split_order error, ");
			info.append("orderId:").append(orderId);
			info.append("; OutParameter2:").append(p_count == null ? "" : p_count.toString());
			info.append("; OutParameter4:").append(call.getObject(4).toString()).toString();
			log.info(info);
			throw new SQLException();
		}
	}

	@Override
	public void executeUpdateStatus(String orderIds, String actionCode, String accountName) throws SQLException {
		Connection conn = super.getSession().connection();
		CallableStatement call =null;
		// 订单IDs(以逗号分割)、状态操作编码（VENDORCONFIRM接收订单；VENDORPRINT打印订单；VENDORDELIVER发货）、商户操作人（accountName）、返回值
		if(!orderIds.contains(",")){
			call = conn.prepareCall("{Call B2B_SITE_UTIL.vendor_update_status(?,?,?,?)}");
		}else{
			call = conn.prepareCall("{Call B2B_SITE_UTIL.vendor_update_status_batch(?,?,?,?)}");
		}
		call.setString(1, orderIds);
		call.setString(2, actionCode);
		call.setString(3, accountName);
		call.registerOutParameter(4, oracle.jdbc.OracleTypes.NUMBER);
		call.execute();
	}

	@Override
	public void whUpdateStatus(String orderId, String actionCode){
		super.getSession().createSQLQuery("update ORDER_MAS　t set t.SUB_STATUS=? where t.PK_NO=?").setString(0, actionCode).setString(1, orderId).executeUpdate();	
	}
	
	@Override
	public Page<Map<String, Object>> findOrderMasByTime(Map<String, Object> params) {
		StringBuffer sql = new StringBuffer(
				"SELECT to_char(om.CREATE_DATE, 'yyyy-mm-dd hh24:mi:ss') CREATE_DATE, om.MAS_NO, om.AMOUNT FROM ORDER_MAS om WHERE 1=1 ");
		List<Object> param = new ArrayList<Object>();
		if (params.containsKey("userNo")) {
			sql.append(" AND om.USER_NO = ?");
			param.add(params.get("userNo"));
			//查询已完成订单的记录，而非各种状态的订单记录
			sql.append(" AND om.STATUS_FLG = ?");
			param.add(params.get("statusFlg"));

			// 如果timeFlg不为'all'查询最近仨个月的订单信息
			if (!"all".equals(params.get("timeFlg"))) {
				sql.append(" AND om.CREATE_DATE >= add_months(sysdate,-3) AND om.CREATE_DATE <= sysdate");
			}
		}

		LinkedHashMap<String, String> order = new LinkedHashMap<String, String>();
		order.put("om.CREATE_DATE", "DESC");

		return super.sqlQueryForPage(sql.toString(), param.toArray(), order);
	}

	@Override
	public Map<String, String> getAmountSum(Map<String, Object> params) {
		StringBuffer sql = new StringBuffer("SELECT SUM(om.AMOUNT) SUM FROM ORDER_MAS om WHERE 1=1 ");
		if (params.containsKey("userNo")) {
			sql.append(" AND om.USER_NO = ?");
			
			//查询已完成订单的记录，而非各种状态的订单记录
			sql.append(" AND om.STATUS_FLG = ?");

			// 如果timeFlg不为'all'查询最近仨个月的订单信息
			if (!"all".equals(params.get("timeFlg"))) {
				sql.append(" AND om.CREATE_DATE >= add_months(sysdate,-3) AND om.CREATE_DATE <= sysdate");
			}
		}

		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
		return (Map<String, String>) query.setBigDecimal(0, (BigDecimal) params.get("userNo")).setString(1, (String) params.get("statusFlg"))
				.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public List<OrderMas> completeOrder(Date date) {
		String hql = "Select o from OrderMas o where o.paymentType= '4028b88146176a290146176a8ebc0000' and o.statusFlg = 'WAITDELIVER' and o.masDate=?";
		List<OrderMas> list =  super.getSession().createQuery(hql).setTimestamp(0, date).list();
		Collections.shuffle(list);
		return list;
	}

	@Override
	public Page getReconciliationList(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select OM.RECEIVER_MOBILE,RD.FEE,OM.PK_NO,RD.DEAL_ID,(case when OM.MAS_NO is null then RD.ORDER_ID else OM.MAS_NO end) as CHAR_MAS_NO,OM.AMOUNT,RD.ORDER_AMOUNT," +
				"to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE" +
				" from (select * from ORDER_MAS om where OM.PAYMENT_TYPE = '4028b88146176a290146176a8ebc0000' and OM.PAY_STATUS = 'PAID' ) om " +
				"left join RECONCILIATION_DETAIL rd on OM.MAS_NO = RD.ORDER_ID" +
				" where OM.AMOUNT <> RD.ORDER_AMOUNT AND om.MAS_CODE = 'SALES'");
		if (null != paramMap) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" AND OM.CREATE_DATE>:startDate");
				param.put("startDate", DateUtil.toDate((String)paramMap.get("startDate")));
			}
			
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" AND OM.CREATE_DATE<:endDate");
				param.put("endDate", DateUtil.toDate((String)paramMap.get("endDate")));
			}
			if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		sql.append(" UNION select OM.RECEIVER_MOBILE,RD.FEE,OM.PK_NO,RD.DEAL_ID,(case when OM.MAS_NO is null then RD.ORDER_ID else OM.MAS_NO end) as CHAR_MAS_NO,OM.AMOUNT,RD.ORDER_AMOUNT," +
				"to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE" +
				" from RECONCILIATION_DETAIL rd left join ORDER_MAS om on RD.ORDER_ID = om.MAS_NO WHERE NOT EXISTS (select * from ORDER_MAS om where OM.MAS_NO = RD.ORDER_ID)");
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public Map<String, Object> findAll(Map<String, Object> params) {
		StringBuffer sql = new StringBuffer("SELECT COUNT(oi.PK_NO) num FROM ORDER_ITEM oi WHERE oi.MAS_PK_NO IN(SELECT om.pk_no FROM ORDER_MAS om WHERE 1=1 ");
		
		if(params.containsKey("statusFlg")) {
			if(null != params.get("statusFlg") && !"".equals(params.get("statusFlg"))) {
				sql.append(" AND om.STATUS_FLG = :statusFlg");
			}
		}
		if(params.containsKey("userNo")) {
			sql.append(" AND om.USER_NO = :userNo)");
		}
		
		Query query = super.createSQLQuery(sql.toString(), params);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public List<Map<String, Object>> getOrderActionLog(String typeCode
			,BigDecimal interval) {
		StringBuffer sql = new StringBuffer(
				"SELECT to_char(OAL.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') CREATE_DATE_F,OAL.CREATE_DATE,OAL.SHOP_ID,OAL.OM_MAS_NO,BSM.SHOP_CODE,BSM.SHOP_NAME,BSM.ADDRESS,BSM.TEL,BSM.LATITUDE,BSM.LONGITUDE FROM ORDER_ACTION_LOG OAL LEFT JOIN B2B_SHOP_MAS BSM ON OAL.SHOP_ID = BSM.SHOP_ID WHERE OAL.ACTION_CODE = ? AND OAL.CREATE_DATE BETWEEN sysdate-?/24/60/60 AND sysdate");
		Query query = super.getSession().createSQLQuery(sql.toString())
				.setString(0, typeCode).setBigDecimal(1,interval);
		return (List<Map<String, Object>>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public Page queryOrderMasList(Map<String, Object> params, LinkedHashMap<String, String> orderby) {
		StringBuffer sql = new StringBuffer("SELECT * FROM ORDER_MAS om LEFT JOIN SCUSER s ON om.LOGISTIC_USER_CODE=s.USER_NO WHERE 1=1");
		Map<String, Object> parms = new HashMap<String, Object>();
		orderby = new LinkedHashMap<String, String>();
		if(params.containsKey("fromdate") && params.containsKey("todate")) {
			sql.append(" AND om.MAS_DATE BETWEEN TO_DATE(:fromdate,'YYYYMMDD') AND TO_DATE(:todate,'YYYYMMDD')");
			parms.put("fromdate", params.get("fromdate"));
			parms.put("todate", params.get("todate"));
		}
		if(params.containsKey("statusFlg")) {
			sql.append(" AND om.STATUS_FLG in(:statusFlg) ");
			parms.put("statusFlg", params.get("statusFlg"));
		}
		if(params.containsKey("masCode")) {
			sql.append(" AND om.MAS_CODE=:masCode ");
			parms.put("masCode", params.get("masCode"));
		}
		if(params.containsKey("orderType")) {
			//2016-3-7 lj解决退货单查询不到sop接口，如果是退货单，订单类型可以是数组
			if(params.containsKey("masCode") && params.get("masCode").toString().equals("RETURN")){
				sql.append(" AND om.ORDER_TYPE in (:orderType) ");
			}else{
				sql.append(" AND om.ORDER_TYPE=:orderType ");
			}
			parms.put("orderType", params.get("orderType"));
		}
		if(params.containsKey("vendorCode")) {
			sql.append(" AND om.VENDOR_CODE=:vendorCode ");
			parms.put("vendorCode", params.get("vendorCode"));
		}
		if(params.containsKey("spUserNo")) {
			sql.append(" AND EXISTS(SELECT 1 FROM SCUSER s WHERE s.USER_NO = OM.USER_NO AND s.PIC_NO = :spUserNo )");
			parms.put("spUserNo", params.get("spUserNo"));
			if(params.containsKey("shopname")) {
				sql.append("AND s.NAME LIKE :shopname ");
				parms.put("shopname", params.get("shopname"));
			}
		}
		if (StringUtils.isNotBlank((String)params.get("orderby"))) {
			orderby.put(params.get("orderby").toString(), params.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), parms, orderby);
		
	}

	@Override
	public List<Map<String, Object>> getSupplierOrderList(
			Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,AM.ADDRESS1,om.*,sm.STM_NAME,TO_CHAR(om.MAS_NO) CHAR_MAS_NO,WM.NAME AS WMNAME,(case DELIVERY_TYPE when 'L' then '货到付款' when 'S' then '在线支付' ELSE '其他' END) as DM_NAME FROM ORDER_MAS om LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE LEFT JOIN WH_MAS WM ON WM.WH_C=om.FBP_LBP_WH_C " +
				"LEFT JOIN ADDRESS_MAS AM ON AM.PK_NO=om.ADDRESS_NO" +
				" WHERE ORDER_TYPE = 'LBP' AND INTERNAL_FLG = 'N' AND om.MAS_CODE = 'SALES'");
		if (null != paramMap) {
			if (paramMap.containsKey("userNo") && StringUtils.isNotBlank(paramMap.get("userNo").toString())) {
				sql.append(" AND om.USER_NO=:userNo");
				param.put("userNo", paramMap.get("userNo"));
			}
			if (paramMap.containsKey("vendorUserNo") && StringUtils.isNotBlank(paramMap.get("vendorUserNo").toString())) {
				sql.append(" AND om.VENDOR_USER_NO=:vendorUserNo");
				param.put("vendorUserNo", paramMap.get("vendorUserNo"));
			}
			if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString()) && !"ORDER".equals(paramMap.get("statusFlg").toString())) {
				sql.append("  AND om.STATUS_FLG IN (:statusFlg)");
				param.put("statusFlg", ((String)paramMap.get("statusFlg")).split(","));
				if("INPROCESS".equals(paramMap.get("statusFlg").toString())){
					sql.append(" AND  VENDOR_MERGE_FLG = 'N' ");
				}
			}
		}
		if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		sql.append(super.buildOrderby(orderby));
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> getWhcOrderList(
			Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,om.*,TO_CHAR(om.MAS_NO) CHAR_MAS_NO,WM.NAME AS WMNAME FROM ORDER_MAS om LEFT JOIN WH_MAS WM ON WM.WH_C=om.WH_C where om.MAS_CODE = 'SALES' ");
		if (null != paramMap) {
			if (paramMap.containsKey("whC") && StringUtils.isNotBlank(paramMap.get("whC").toString())) {
				sql.append(" and ((om.ORDER_TYPE = 'LBP' AND om.VENDOR_MERGE_FLG = 'P' AND om.FBP_LBP_WH_C = :whC AND om.FBP_LBP_WH_C <> om.WH_C) OR (om.ORDER_TYPE = 'FBP' AND om.FBP_LBP_WH_C = :whC  AND om.FBP_LBP_WH_C <> om.WH_C)) " +
						" AND OM.WH_MERGE_FLG = 'N'");
				param.put("whC", paramMap.get("whC"));
				System.out.println("待合并订单当前仓库为"+paramMap.get("whC"));
				log.info("待合并订单当前仓库为"+paramMap.get("whC"));
			}
		}
		if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		sql.append(super.buildOrderby(orderby));
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	private void setParames(Map args, Query query) {
		if ((args != null) && (args.size() > 0)) {
			Iterator<Entry<String, Object>> iterator = args.entrySet().iterator();
			while (iterator.hasNext()) {
				Entry<String, Object> entry = iterator.next();
				if(entry.getValue() instanceof Object[]){
					query.setParameterList(entry.getKey(), (Object[])entry.getValue());
				}else if(entry.getValue() instanceof Collection){
					query.setParameterList(entry.getKey(), (Collection)entry.getValue());
				}else{
					query.setParameter(entry.getKey(), entry.getValue());
				}
			}
		}
	}

	@Override
	public List<Map<String, Object>> findOrderListByIds(String ids) {
		if(StringUtils.isBlank(ids)){
			return null;
		}
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,om.*,WM.NAME AS WMNAME,WM1.NAME AS WMNAME1,TO_CHAR(om.MAS_NO) CHAR_MAS_NO FROM ORDER_MAS om LEFT JOIN WH_MAS WM ON WM.WH_C=om.FBP_LBP_WH_C LEFT JOIN WH_MAS WM1 ON WM1.WH_C=om.WH_C WHERE OM.PK_NO IN (:ids)");
		param.put("ids", ids.split(","));
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public Page<Map<String, Object>> getWarehouseOrderList(
			Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"SELECT B2B_MISC_UTIL.GET_ORDER_CAN_DELIVER(om.PK_NO) AS REMARKS1,B2B_MISC_UTIL.get_order_remark(om.PK_NO) AS REMARKS,rm.ROUTE_NAME,to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,( SELECT (SELECT area_name FROM AREA_MAS_WEB z WHERE z.area_id = (SELECT parent_id FROM AREA_MAS_WEB y WHERE y.AREA_ID = x.parent_id)) || '->' || (SELECT area_name FROM AREA_MAS_WEB y WHERE y.AREA_ID = x.parent_id)  || '->' || area_name FROM AREA_MAS_WEB x WHERE area_id = OM.AREA_ID) AS OM_AREA, " +
				"AM.ADDRESS1,om.*,sm.STM_NAME,(case DELIVERY_TYPE when 'L' then '货到付款' when 'S' then '在线支付' ELSE '其他' END) as DM_NAME,TO_CHAR(om.MAS_NO) CHAR_MAS_NO,WM.NAME AS WMNAME,SC.NAME AS LOGISTIC_NAME FROM ORDER_MAS om LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE LEFT JOIN WH_MAS WM ON WM.WH_C=om.FBP_LBP_WH_C " +
				" LEFT JOIN ADDRESS_MAS AM ON AM.PK_NO=om.ADDRESS_NO " +
				" LEFT JOIN SCUSER SC ON SC.USER_NO=om.LOGISTIC_CODE " +
				" left join vendor_cust vc on (vc.CUST_CODE = om.cust_code and vc.VENDOR_CODE = om.vendor_code )" +
				" left join B2B_ROUTE_MAS rm on (rm.ROUTE_CODE = vc.ROUTE_CODE and rm.logistic_code = sc.user_name)" +
				" WHERE om.MAS_CODE = 'SALES' and om.INTERNAL_FLG = 'N'");
		if (null != paramMap) {
			if (paramMap.containsKey("destWhC") && StringUtils.isNotBlank(paramMap.get("destWhC").toString())) {
				sql.append(" AND om.WH_C=:destWhC ");
				param.put("destWhC", paramMap.get("destWhC"));
			}
			if (paramMap.containsKey("whC") && StringUtils.isNotBlank(paramMap.get("whC").toString())) {
				sql.append(" AND om.WH_C=:whC ");
				param.put("whC", paramMap.get("whC"));
			}
			if (paramMap.containsKey("masNo") && StringUtils.isNotBlank(paramMap.get("masNo").toString())) {
				sql.append(" AND om.MAS_NO=:masNo ");
				param.put("masNo", paramMap.get("masNo"));
			}
			if (paramMap.containsKey("shopName") && StringUtils.isNotBlank(paramMap.get("shopName").toString())) {
				sql.append(" AND om.CUST_NAME like :shopName ");
				param.put("shopName", paramMap.get("shopName"));
			}
			if (paramMap.containsKey("routeName") && StringUtils.isNotBlank(paramMap.get("routeName").toString())) {
				sql.append(" AND rm.ROUTE_NAME like :routeName ");
				param.put("routeName", paramMap.get("routeName"));
			}
			if (paramMap.containsKey("areaId") && StringUtils.isNotBlank(paramMap.get("areaId").toString())) {
				sql.append(" AND om.AREA_ID =:areaId ");
				param.put("areaId", paramMap.get("areaId"));
			}
			if(paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())){
				if("WAITDELIVER".equals(paramMap.get("statusFlg"))){
					//sql.append(" AND ((ORDER_TYPE = 'LBP' AND WH_MERGE_FLG = 'P') OR (ORDER_TYPE = 'FBP' AND om.FBP_LBP_WH_C = om.WH_C) OR (ORDER_TYPE = 'FBP' AND om.FBP_LBP_WH_C <> om.WH_C AND WH_MERGE_FLG = 'P' )) AND om.STATUS_FLG='INPROCESS'");
					sql.append(" AND om.ORDER_TYPE IN ('LBP','FBP') AND OM.STATUS_FLG ='INPROCESS' ");
					if("WAITPRINT".equals(paramMap.get("sub_status_radio"))){
						sql.append(" AND om.SUB_STATUS='WAITPRINT'");
					}else{
						sql.append(" AND om.SUB_STATUS='WAITDELIVER'");
					}
					if (paramMap.containsKey("pickCheckValue") && StringUtils.isNotBlank(paramMap.get("pickCheckValue").toString())) {
						sql.append(" AND om.PICK_FLG=:pickCheckValue");
						param.put("pickCheckValue", paramMap.get("pickCheckValue"));
					}
				}else if("DELIVERED".equals(paramMap.get("statusFlg")) || "SUCCESS".equals(paramMap.get("statusFlg"))){
					sql.append(" AND om.STATUS_FLG=:statusFlg ");
					param.put("statusFlg", paramMap.get("statusFlg"));
					sql.append("AND ORDER_TYPE IN ('LBP','FBP')");
				}
			}
		}
		if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public Map<String, Object> getBoughtQty(BigDecimal promPkNo, BigDecimal userNo) {
		if(null == userNo)
		{
			String sql = "select sum(T.UOM_QTY) AS QTY from ORDER_ITEM t left join ORDER_MAS tt on t.MAS_PK_NO = TT.PK_NO where t.PROM_ITEM_PK_NO  = ? and tt.STATUS_FLG <> 'CLOSE'  and t.NET_PRICE >0";
			return (Map<String, Object>)super.getSession().createSQLQuery(sql)
					.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, promPkNo).uniqueResult();
		}else{
			String sql = "select sum(T.UOM_QTY) AS QTY from ORDER_ITEM t left join ORDER_MAS tt on t.MAS_PK_NO = TT.PK_NO where t.PROM_ITEM_PK_NO  = ? and TT.USER_NO = ? and tt.STATUS_FLG <> 'CLOSE' and t.NET_PRICE >0";
			return (Map<String, Object>)super.getSession().createSQLQuery(sql)
					.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, promPkNo).setBigDecimal(1, userNo).uniqueResult();
		}
	}

	@Override
	public Page<Map<String, Object>> queryPayOrderPage(Map<String, Object> params, LinkedHashMap<String, String> orderby) {
		StringBuffer sql = new StringBuffer("SELECT t.*,t1.name logisticusername FROM ORDER_MAS t left join SCUSER t1 on t.LOGISTIC_USER_CODE = t1.USER_NO WHERE t.BATCH_ID is null and t.LOGISTIC_CODE  is not null AND t.MAS_CODE = 'SALES' ");
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
			if(params.containsKey("logisticUserCode") && StringUtils.isNotBlank(params.get("logisticUserCode").toString())) {
				sql.append(" AND t.LOGISTIC_USER_CODE=:logisticUserCode");
				parms.put("logisticUserCode", params.get("logisticUserCode"));
			}
			if(params.containsKey("logisticCode") && StringUtils.isNotBlank(params.get("logisticCode").toString())) {
				sql.append(" AND t.LOGISTIC_CODE=:logisticCode");
				parms.put("logisticCode", params.get("logisticCode"));
			}
			if(params.containsKey("logisticusername") && StringUtils.isNotBlank(params.get("logisticusername").toString())) {
				sql.append(" AND t1.NAME=:logisticusername");
				parms.put("logisticusername", params.get("logisticusername"));
			}
			//SP_NAME
			if(params.containsKey("custName") && StringUtils.isNotBlank(params.get("custName").toString())) {
				sql.append(" AND t.CUST_NAME=:custName");
				parms.put("custName", params.get("custName"));
			}
			
			if(params.containsKey("spName") && StringUtils.isNotBlank(params.get("spName").toString())) {
				sql.append(" AND t.SP_NAME=:spName");
				parms.put("spName", params.get("spName"));
			}
			
			if(params.containsKey("masDate") && StringUtils.isNotBlank(params.get("masDate").toString())) {
				sql.append(" AND to_char(t.MAS_DATE,'yyyy-MM-dd')=:masDate");
				parms.put("masDate", params.get("masDate"));
			}
			if(params.containsKey("startDate") && StringUtils.isNotBlank(params.get("startDate").toString())) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				sql.append(" AND  t.MAS_DATE >=:startDate");
				try {
					parms.put("startDate", sdf.parse(params.get("startDate").toString()+" 00:00:00"));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if(params.containsKey("endDate") && StringUtils.isNotBlank(params.get("endDate").toString())) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				sql.append(" AND  t.MAS_DATE <=:endDate");
				try {
					parms.put("endDate", sdf.parse(params.get("endDate").toString()+" 23:59:59"));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			
			if (params.containsKey("masNo") && StringUtils.isNotBlank(params.get("masNo").toString())) {
				sql.append(" and t.MAS_NO like :masNo");
				parms.put("masNo", "%" + params.get("masNo") + "%");
			}
			if (params.containsKey("pkNo") && StringUtils.isNotBlank(params.get("pkNo").toString())) {
				sql.append(" and t.PK_NO = :pkNo");
				parms.put("pkNo", params.get("pkNo"));
			}
		}
		orderby = new LinkedHashMap<String, String>();
		if (StringUtils.isNotBlank((String)params.get("orderby"))) {
			orderby.put("t."+params.get("orderby").toString(), params.get("sord").toString());
		}else{
			orderby.put("t.MAS_NO", "desc");
		}
		
		return super.sqlqueryForpage(sql.toString(), parms, orderby);
		
	}

	@Override
	public void executeReleaseInventory(BigDecimal p_pk_no, String p_mas_code, char p_action_type)
			throws SQLException {
		Connection conn = super.getSession().connection();
		CallableStatement call = null;
		call = conn.prepareCall("{Call B2B_SITE_UTIL.reserve_order(?,?,?)}");
		call.setBigDecimal(1, p_pk_no);
		call.setString(2, p_mas_code);
		call.setString(3, String.valueOf(p_action_type));
		StringBuffer info = new StringBuffer("Call B2B_SITE_UTIL.reserve_order info, ");
		info.append("PK_NO:").append(p_pk_no);
		info.append("; MAS_CODE:").append(p_mas_code);
		info.append("; ACTION_TYPE:").append(p_action_type).toString();
		log.info(info);
		call.execute();
	}
	
	
	@Override
	public List<OrderMas> findByBatchId(String batchId) {
			Query query = getSession().createQuery("select t from OrderMas t where t.batchId=:batchId");
			query.setParameter("batchId", batchId);
			return query.list();
	}

	@Override
	public Integer countOrderMasByPayStatus(BigDecimal[] pkNos) {
		Query query = getSession().createQuery("select count(t) from OrderMas t where ( payStatus!=:payStatus or batchId is not null ) and pkNo in (:pkNos)");
		query.setParameter("payStatus", "WAITPAYMENT");
		query.setParameterList("pkNos", pkNos);
		return Integer.parseInt(query.uniqueResult().toString());
	}
	
	@Override
	public Page findOrderitem(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("SELECT oi.* ,NVL((CASE WHEN qty2 is  NULL THEN qty1 else qty2 END),0) as SJQTY, ODR_DESC FROM ORDER_ITEM oi " +
				"left join ORDER_DIFF_REASON T2 on oi.ODR_CODE = T2.ODR_CODE " +
				"WHERE 1=1");
		if (paramMap.containsKey("pkNo") && StringUtils.isNotBlank(paramMap.get("pkNo").toString())) {
			sql.append(" and oi.MAS_PK_NO=:pkNo");
			param.put("pkNo", paramMap.get("pkNo"));
		}
		orderby = new LinkedHashMap<String, String>();
		orderby.put("oi.ITEM_NO", "desc");
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
	
	@Override
	public List findOrderitem(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("SELECT oi.* ,NVL((CASE WHEN qty2 is  NULL THEN qty1 else qty2 END),0) as SJQTY, ODR_DESC, NET_PRICE FROM ORDER_ITEM oi " +
				"left join ORDER_DIFF_REASON T2 on oi.ODR_CODE = T2.ODR_CODE " +
				"WHERE 1=1");
		if (paramMap.containsKey("pkNo") && StringUtils.isNotBlank(paramMap.get("pkNo").toString())) {
			sql.append(" and oi.MAS_PK_NO=:pkNo");
			param.put("pkNo", paramMap.get("pkNo"));
		}
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public void orderUpdate(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuffer sql = new StringBuffer();
		if(paramMap.containsKey("picFlg"))
		{
			sql.delete(0,sql.length());
			sql = new StringBuffer("update ORDER_MAS set PICK_FLG= :picFlg");
			sql.append(" where PK_NO in (:pkNos)");
			param.put("pkNos", paramMap.get("pkNos"));
			param.put("picFlg", paramMap.get("picFlg"));
		}else{
			sql = new StringBuffer("update ORDER_MAS set LOGISTIC_USER_CODE=:logisticUserCode");
			param.put("logisticUserCode", paramMap.get("logisticUserCode"));
			if(paramMap.containsKey("statusFlg") && paramMap.get("statusFlg") != null)
			{
				sql.append(", STATUS_FLG=:statusFlg");
				param.put("picFlg", paramMap.get("picFlg"));
			}
			sql.append(" where PK_NO in (:id)");
			param.put("id", paramMap.get("id").toString().split(","));
		}
		super.createSQLQuery(sql.toString(), param).executeUpdate();
	}

	@Override
	public void orderDetailsUpdate(Map<String, Object> paramMap) {
		StringBuffer sql = new StringBuffer("update ORDER_ITEM set qty2 = :qty2");
		if(paramMap.containsKey("diffMiscAmt") && paramMap.get("diffMiscAmt") != null)
		{
			sql.append(", DIFF_MISC_AMT = :diffMiscAmt");
		}
		if(paramMap.containsKey("diffRemark") && paramMap.get("diffRemark") != null)
		{
			sql.append(", DIFF_REMARK = :diffRemark");
		}
		if(paramMap.containsKey("odrCode") && paramMap.get("odrCode") != null)
		{
			sql.append(", ODR_CODE = :odrCode");
		}
		sql.append(" where PK_No = :pkNo");
		super.createSQLQuery(sql.toString(), paramMap).executeUpdate();
		//super.flush();
		//super.clear();
	}
	
	@Override
	public void orderDetailsUpdate(String orderitemStr) {
		orderitemStr =orderitemStr.replaceAll("\\[", "");
		orderitemStr =orderitemStr.replaceAll("\\]", "");
		String [] strs = orderitemStr.split("\\},");
		for(int i = 0;i<strs.length ;i++){
			String s="";
			if(strs.length==1){
				s=strs[i];
			}else{
				s=strs[i]+"}";
			}
			JSONObject paramMap = JSONObject.fromObject(s); //将字符串{“id”：1}
			StringBuffer sql = new StringBuffer("update ORDER_ITEM set qty2 = :qty2");
			if(paramMap.containsKey("diffMiscAmt") && paramMap.get("diffMiscAmt") != null)
			{
				sql.append(", DIFF_MISC_AMT = :diffMiscAmt");
			}
			if(paramMap.containsKey("diffRemark") && paramMap.get("diffRemark") != null)
			{
				sql.append(", DIFF_REMARK = :diffRemark");
			}
			if(paramMap.containsKey("odrCode") && paramMap.get("odrCode") != null)
			{
				sql.append(", ODR_CODE = :odrCode");
			}
			sql.append(" where PK_No = :pkNo");
			super.createSQLQuery(sql.toString(), paramMap).executeUpdate();
			super.flush();
			//super.clear();
		}
	}


	@Override
	public Page findLogisticsOrderMas(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		System.out.println("paramMap =========="+paramMap.toString());
		StringBuilder sql = new StringBuilder(
				"SELECT (select route_name from B2B_ROUTE_MAS where route_code = om.route_code and LOGISTIC_CODE = '"+paramMap.get("logisticUserName").toString()+"') route_name, om.*," +
				"(SELECT count(CASE WHEN qty2 is NOT NULL THEN 1 END)+" //qty2不为空则为1
				+"count(CASE WHEN qty1 is NULL THEN 1 END)+" //qty1为空则为1
				+"count((CASE WHEN ((SELECT SUM(UOM_QTY) - SUM(NVL(QTY1, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = om.PK_NO)) <> 0 THEN 1 END))+"//判断uom_qty-qty1是否为0，为0则可批量操作，否则不可批量操作   2015-12-16 zld 修改
				+"count(CASE WHEN (AMOUNT-(SELECT SUM(QTY1*net_price) FROM ORDER_ITEM WHERE MAS_PK_NO = om.PK_NO))<0 THEN 1 END) FROM ORDER_ITEM WHERE MAS_PK_NO = om.PK_NO) "//计算AMOUNT-订单详情总金额，如果<0则为1,若以上条件相加>0则此数据异常
				+"as CN,nvl((AMOUNT-(SELECT SUM(QTY1*net_price) FROM ORDER_ITEM WHERE MAS_PK_NO = om.PK_NO)),0) "//计算AMOUNT-订单详情总金额,若为空则为0
				+"as CN2,(SELECT count(CASE WHEN qty1 is NULL THEN 1 END)FROM ORDER_ITEM WHERE MAS_PK_NO = om.PK_NO) "//判断qty1是否存在,若不存在则为1
				+"as CN3,(SELECT SUM(UOM_QTY) - SUM(NVL(QTY1, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = om.PK_NO)"
				+"as CN4,(om.AMOUNT - abs(NVL(om.DIFF_MISC_AMT,0)) - NVL(om.MISC_PAY_AMT,0) + NVL(om.FREIGHT,0)) " //应收金额
				+"AS AMOUNT_CN  ");
		if (null != paramMap) {
			
			if (paramMap.containsKey("logisticUserCode") && StringUtils.isNotBlank(paramMap.get("logisticUserCode").toString())) {
				if(paramMap.get("logisticUserCode").equals("NULL")){
					//添加重新分配功能  By:zhaowei
					if(paramMap.containsKey("allotre") &&"Y".equals(paramMap.get("allotre"))){
						sql.append(" FROM ORDER_MAS om WHERE om.MAS_CODE = 'SALES' AND om.LOGISTIC_USER_CODE IS NOT NULL");
					}else{
						sql.append(" FROM ORDER_MAS om WHERE om.MAS_CODE = 'SALES' AND om.LOGISTIC_USER_CODE IS NULL");
					}
				}else if(paramMap.get("logisticUserCode").equals("NOT NULL")){
					sql.append(", s.NAME FROM ORDER_MAS om left join SCUSER s ON s.user_no=om.LOGISTIC_USER_CODE WHERE om.MAS_CODE = 'SALES'");
					sql.append(" AND om.LOGISTIC_USER_CODE IS NOT NULL");
					if (paramMap.containsKey("logisticsName") && StringUtils.isNotBlank(paramMap.get("logisticsName").toString())) {
						sql.append(" AND s.name like :logisticsName");
						param.put("logisticsName", "%" + paramMap.get("logisticsName") + "%");
					}
				}else{
					sql.append(" , s.NAME FROM ORDER_MAS om left join SCUSER s ON s.user_no=om.LOGISTIC_USER_CODE Where LOGISTIC_USER_CODE=:logisticUserCode AND om.MAS_CODE = 'SALES'");
					param.put("logisticUserCode", paramMap.get("logisticUserCode"));
					if (paramMap.containsKey("logisticsName") && StringUtils.isNotBlank(paramMap.get("logisticsName").toString())) {
						sql.append(" AND s.name like :logisticsName");
						param.put("logisticsName", "%" + paramMap.get("logisticsName") + "%");
					}
				}
			}else{
				sql.append("FROM ORDER_MAS om WHERE om.MAS_CODE = 'SALES'");
			}
			
			if (paramMap.containsKey("userNo") && StringUtils.isNotBlank(paramMap.get("userNo").toString())) {
				sql.append(" AND om.USER_NO=:userNo");
				param.put("userNo", paramMap.get("userNo"));
			}
			if (paramMap.containsKey("vendorUserNo") && StringUtils.isNotBlank(paramMap.get("vendorUserNo").toString())) {
				sql.append(" AND om.VENDOR_USER_NO=:vendorUserNo");
				param.put("vendorUserNo", paramMap.get("vendorUserNo"));
			}
			if (paramMap.containsKey("whC") && StringUtils.isNotBlank(paramMap.get("whC").toString())) {
				sql.append(" AND om.WH_C=:whC");
				param.put("whC", paramMap.get("whC"));
			}
			if (paramMap.containsKey("masNo") && StringUtils.isNotBlank(paramMap.get("masNo").toString())) {
				sql.append(" AND om.MAS_NO like :masNo");
				param.put("masNo", "%" + paramMap.get("masNo") + "%");
			}
			if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())) {
				sql.append(" AND om.STATUS_FLG in (:statusFlg)");
				String statusFlg[] = paramMap.get("statusFlg").toString().split(",");
				param.put("statusFlg", statusFlg);
			}
			if (paramMap.containsKey("subStatus") && StringUtils.isNotBlank(paramMap.get("subStatus").toString())) {
				sql.append(" AND om.SUB_STATUS=:subStatus");
				param.put("subStatus", paramMap.get("subStatus"));
			}
			if (paramMap.containsKey("payStatus") && StringUtils.isNotBlank(paramMap.get("payStatus").toString())) {
				sql.append(" AND om.PAY_STATUS=:payStatus");
				param.put("payStatus", paramMap.get("payStatus"));
				if(paramMap.get("payStatus").toString().equals("WAITPAYMENT"))
				{
						sql.append(" AND batch_id is null ");
				}
			}
			if (paramMap.containsKey("logisticCode") && StringUtils.isNotBlank(paramMap.get("logisticCode").toString())) {
				//TODO 临时关闭2015-08-07
//				sql.append(" AND om.LOGISTIC_CODE =(select user_name from scuser where user_no=:logisticCode)");
				sql.append(" AND om.LOGISTIC_CODE = :logisticCode");
				param.put("logisticCode", paramMap.get("logisticCode"));
			}
			
			if (paramMap.containsKey("AND1") && StringUtils.isNotBlank(paramMap.get("AND1").toString())) {
				sql.append(" AND nvl(om.modifyqty2_flg,'Y')<>'N'");
			}
			
			// 判断时间是否为空，为空不拼接
			if (paramMap.containsKey("startDate")
					&& StringUtils.isNotBlank(paramMap.get("startDate").toString())
					&& paramMap.containsKey("endDate")
					&& StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" AND to_char(om.CREATE_DATE ,'yyyy-mm-dd') >=:startDate AND to_char(om.CREATE_DATE ,'yyyy-mm-dd') <=:endDate");
				param.put("startDate", paramMap.get("startDate"));
				param.put("endDate", paramMap.get("endDate"));
			}
			
			if (paramMap.containsKey("pkNo") && StringUtils.isNotBlank(paramMap.get("pkNo").toString())) {
				sql.append(" AND om.PK_NO=:pkNo");
				param.put("pkNo", paramMap.get("pkNo"));
			}
			if (paramMap.containsKey("routeCode") && StringUtils.isNotBlank(paramMap.get("routeCode").toString())) {
				sql.append(" AND om.route_Code=:routeCode");
				param.put("routeCode", paramMap.get("routeCode"));
			}
			
			
			if (StringUtils.isNotBlank((String)paramMap.get("orderby"))) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	/**
	 * 根据订单NO更新订单明细中的实际收货数量 (QTY2)
	 * @param
	 * @return
	 */
	public int upOrderItemQty(Map<String, Object> paramMap){
		Map<String, Object> param = new HashMap<String, Object>();
		String sql="";
		if(paramMap.containsKey("upqty1"))
		{
			sql="update ORDER_ITEM set QTY1 = NVL(UOM_QTY, 0) where MAS_PK_NO in(:pkNos)";
			param.put("pkNos", paramMap.get("pkNos"));
		}else{
			sql="update ORDER_ITEM set QTY2 = NVL(QTY1, 0) where MAS_PK_NO in(:pkNos) and  QTY2 is null";
			param.put("pkNos", paramMap.get("pkno").toString().split(","));
		}
		return super.createSQLQuery(sql, param).executeUpdate();
	}
	
	/**
	 * 根据订单NO更新订单明细中的实际收货数量 (QTY2)
	 * @param
	 * @return
	 * -update ORDER_MAS set PICK_FLG = 'A' where pk_no in(13684,13683,13682,13681,13680)
	 */
	public int upOrderMas(Map<String, Object> paramMap){
		Map<String, Object> param = new HashMap<String, Object>();
		String sql="update ORDER_ITEM set QTY2 = NVL(QTY1, 0) where MAS_PK_NO in(:pkNos) and  QTY2 is null";
		param.put("pkNos", paramMap.get("pkno").toString().split(","));
		if(paramMap.containsKey("upqty1"))
		{
			sql="update ORDER_ITEM set QTY1 = NVL(UOM_QTY, 0) where MAS_PK_NO in(:pkNos)";
			param.put("pkNos", paramMap.get("pkno").toString().split(","));
			
		}
		if(paramMap.containsKey("qty1"))
		{
			BigDecimal qty1 = new BigDecimal(0);
			if(ValidateUtil.isBigDecimal(paramMap.get("qty1").toString()))
			{
				qty1 = new BigDecimal(paramMap.get("qty1").toString());
				sql="update ORDER_ITEM set QTY1 = " + qty1 + " where MAS_PK_NO = :pkno";
				param.put("pkno", paramMap.get("pkno"));
			}
		}
		return super.createSQLQuery(sql, param).executeUpdate();
	}
	
	
	/**
	 * 根据订单no订单表中的差异数据
	 * 差异数据为：订单金额 - 订单明细表中的 商品单价*实际收货数量-拆零扣减金额 amount-（netPrice*qty2-diffMiscAmt）
	 * @param params
	 * @return
	 */
	public int upOrderMasDiff(Map<String, Object> paramMap){
		Map<String, Object> param = new HashMap<String, Object>();
		String[] pkNos = paramMap.get("pkno").toString().split(",");
		StringBuffer sql = new StringBuffer("update ORDER_MAS set STATUS_FLG = 'SUCCESS'," +
//				" DIFF_MISC_AMT = (SELECT T2.AMOUNT - (SELECT SUM(NVL(QTY2, 0)*NVL(NET_PRICE, 0)-nvl(DIFF_MISC_AMT,0)) FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO) FROM ORDER_MAS T2 WHERE T2.PK_NO = :pkNos), " +
				" DIFF_MISC_AMT = (SELECT SUM((UOM_QTY-NVL(QTY2, 0))*NET_PRICE + NVL(DIFF_MISC_AMT, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = :pkNos), " +
//				" DIFF_MISC_AMT = "+ paramMap.get("diffamt") +", " +
				" DIFF_RET_FLG = case when (SELECT SUM(NVL(QTY1, 0) - NVL(QTY2, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = :pkNos) <> 0 THEN 'Y' ELSE 'N' end ");
		if(paramMap.containsKey("cno"))
		{
			sql.append(", MISC_PAY_AMT = 0, CUST_CLOSE_DATE = sysdate, CUST_CLOSE_DESC = '配送人员-"+ paramMap.get("cno") +"-终止了发货'");
		}else{
			if(paramMap.containsKey("ramount"))
			{
				sql.append(", MISC_PAY_AMT = MISC_PAY_AMT - " + paramMap.get("ramount"));
			}
		}
		sql.append(" WHERE PK_NO = :pkNos");


		/**
		String sql="update ORDER_MAS set STATUS_FLG = 'SUCCESS'," +
//				" DIFF_MISC_AMT = (SELECT T2.AMOUNT - (SELECT SUM(NVL(QTY2, 0)*NVL(NET_PRICE, 0)-nvl(DIFF_MISC_AMT,0)) FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO) FROM ORDER_MAS T2 WHERE T2.PK_NO = :pkNos), " +
				" DIFF_MISC_AMT = (SELECT SUM((UOM_QTY-NVL(QTY2, 0))*NET_PRICE + NVL(DIFF_MISC_AMT, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = :pkNos), " +
				" DIFF_RET_FLG = case when (SELECT SUM(NVL(QTY1, 0) - NVL(QTY2, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = :pkNos) <> 0 THEN 'Y' ELSE 'N' end " +
				" WHERE PK_NO = :pkNos";
		**/		
		if(pkNos.length > 1)
		{
//			sql = new StringBuffer(
//					"update ORDER_MAS T1 set STATUS_FLG = 'SUCCESS'," +
//					" DIFF_MISC_AMT = (SELECT (SELECT SUM((UOM_QTY-NVL(QTY2, 0)) * NET_PRICE + NVL(DIFF_MISC_AMT, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO) DIFF_MISC_AMT FROM ORDER_MAS T2 WHERE T1.PK_NO = T2.PK_NO)," +
//					" DIFF_RET_FLG = (CASE WHEN (SELECT (SELECT SUM(NVL(QTY1, 0) - NVL(QTY2, 0))FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO) FROM ORDER_MAS T2 WHERE T1.PK_NO = T2.PK_NO) <> 0 THEN 'Y' ELSE 'N' END)" +
//					" WHERE exists(select 1 from ORDER_MAS T3 where T1.PK_NO = T3.PK_NO and T3.PK_NO in(:pkNos))"
//					);
			sql = new StringBuffer(
					"update ORDER_MAS set STATUS_FLG = 'SUCCESS', DIFF_MISC_AMT = 0, DIFF_RET_FLG = 'N' " +
					"WHERE PK_NO in(:pkNos)"
					);
					
		}
		param.put("pkNos", pkNos);
		return super.createSQLQuery(sql.toString(), param).executeUpdate();
	}
	
	/**
	 * 1.根据订单NO,配送员编号获取订单差异金额，便于确认订单效验
	 * @param
	 * @return
	 */
	public Map<String, Object> getOrderMasDiff(Map<String, Object> paramMap) {
		StringBuffer sql = new StringBuffer("SELECT T2.PK_NO, T2.MAS_NO, T2.USER_NO, T2.AMOUNT as AMOUNT_MAS, ORG_NO, COM_NO, LOC_NO, CUST_CODE, PAY_STATUS, PAYMENT_TYPE,RECEIVER_NAME, " +
				"NVL((SELECT SUM(NVL(CASE WHEN QTY2 is null THEN QTY1 else QTY2 end, 0) * NVL(NET_PRICE, 0) - NVL(DIFF_MISC_AMT, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO), 0)AS AMOUNT, " +
				"NVL((SELECT SUM((UOM_QTY-NVL((CASE WHEN qty2 is  NULL THEN qty1 else qty2 END),0))*NET_PRICE + NVL(DIFF_MISC_AMT, 0)) FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO), 0)AS DIFF_MISC_AMT, " +
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'Y' and MAS_PK_NO = T2.PK_NO), 0)AS COUPON_AMOUNT, " +
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'P' and MAS_PK_NO = T2.PK_NO), 0)AS POINTS_AMOUNT, " +
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'B' and MAS_PK_NO = T2.PK_NO), 0)AS B_AMOUNT, " +
				"(SELECT USER_NAME FROM SCUSER  WHERE USER_NO = T2.USER_NO)as USER_NAME, " +
				"NVL(FREIGHT,0)as FREIGHT, NVL(MISC_PAY_AMT, 0)as MISC_PAY_AMT, nvl(CUST_NAME, 0) as CUST_NAME " +
				"FROM ORDER_MAS T2 " +
				"WHERE T2.PK_NO = :pkno");
		//配送员编号
		if(paramMap.containsKey("cno")) {
			if(null != paramMap.get("cno") && !"".equals(paramMap.get("cno"))) {
				sql.append(" AND LOGISTIC_USER_CODE = :cno ");
			}
		}
		//订单状态
		if(paramMap.containsKey("statusflg")) {
			if(null != paramMap.get("statusflg") && !"".equals(paramMap.get("statusflg"))) {
				paramMap.put("statusflg", paramMap.get("statusflg").toString().split(","));
				sql.append(" AND STATUS_FLG in(:statusflg)");
			}
		}
		//付款状态
		if(paramMap.containsKey("paystatus")) {
			if(null != paramMap.get("paystatus") && !"".equals(paramMap.get("paystatus"))) {
				sql.append(" AND PAY_STATUS = :paystatus");
			}
		}
		Query query = super.createSQLQuery(sql.toString(), paramMap);
		Map<String, Object> order = (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
		if(order != null)
		{
			//TODO：因运费不是从数据库中提取，暂时修改为0 切记
			order.put("FREIGHT", 0);
		}
		return order;
	}
	@Override
	public void updateOrderStatusByBatchId(Map<String,Object> params) {
		Map<String, Object> param = new HashMap<String, Object>();
//		String sql = "UPDATE ORDER_MAS T SET T.PAY_STATUS = 'PAID' WHERE T.BATCH_ID = :batchId'";
		StringBuffer sql = new StringBuffer("UPDATE ORDER_MAS T SET T.BATCH_ID = T.MAS_NO , T.PAYMENT_DATE = :paymentDate ");
		param.put("paymentDate", (Timestamp)params.get("paymentDate"));
		if(params != null ){
			if(params.containsKey("statusFlg") && StringUtils.isNotBlank((String)params.get("statusFlg"))){
				sql.append(" ,T.STATUS_FLG = :statusFlg ");
				param.put("statusFlg", (String)params.get("statusFlg"));
			}
			if(params.containsKey("payStatus") && StringUtils.isNotBlank((String)params.get("payStatus"))){
				sql.append(" ,T.PAY_STATUS = :payStatus ");
				param.put("payStatus", (String)params.get("payStatus"));
			}
		}
		sql.append(" WHERE T.MAS_NO = :batchId ");
		param.put("batchId", (String)params.get("batchId"));
		super.createSQLQuery(sql.toString(), param).executeUpdate();
	}


	@Override
	public List<Map<String,Object>> getOrderItemListById(BigDecimal pkNo) {
		String sql = "SELECT oi.*,sm.plu_c FROM ORDER_MAS om , ORDER_ITEM oi ,STK_MAS sm WHERE om.PK_NO = oi.MAS_PK_NO AND oi.STK_C= sm.STK_C" +
				"  AND om.PK_NO = :pkNo";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		query.setBigDecimal("pkNo", pkNo);
		return (List<Map<String, Object>>)query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	/**
	  * 根据源订单id查询退单主键
	  * @author: lj
	  * @param srcMasNo
	  * @return
	  * @date : 2015-8-13下午2:07:21
	  */
	 @Override
	 public Object findOrderMasBySrcMasNo(BigDecimal srcMasNo) {
		  String sql = "SELECT o.PK_NO from ORDER_MAS o where  o.MAS_CODE='RETURN' AND o.SRC_PK_NO = ? ";
		  Query query = super.createSQLQuery(sql);
		  query.setBigDecimal(0, srcMasNo);
	      return query.uniqueResult();
	 }
	/**
	  * 查询异常订单
	  * @author: lj
	  * @param params
	  * @param orderby
	  * @return
	  * @date : 2015-8-12下午2:38:02
	  */
	 @Override
	 public Page<Map<String, Object>> queryExceptionOrderPage(
		  Map<String, Object> params, LinkedHashMap<String, String> orderby) {
		  StringBuffer sql = new StringBuffer("SELECT M.*,(SELECT s.STM_NAME from SETTLEMENT_METHOD s where s.STM_CODE = m.PAYMENT_TYPE)as STM_NAME,");
          sql.append("(select u.NAME from SCUSER u where u.USER_NO = m.LOGISTIC_USER_CODE) as USER_NAME FROM ORDER_MAS M WHERE 1=1");
		  Map<String, Object> parms = new HashMap<String, Object>();
		  
		  if(null!=params){
			  if(params.containsKey("statusFlg") && StringUtils.isNotBlank(params.get("statusFlg").toString())) {
				  sql.append(" AND M.STATUS_FLG=:statusFlg");
				  parms.put("statusFlg", params.get("statusFlg"));
			  }
			   if(params.containsKey("vendorCode") && StringUtils.isNotBlank(params.get("vendorCode").toString())) {
			      sql.append(" AND M.WH_C in (select WH_C from WH_MAS a where a.ACC_CODE = :vendorCode) ");
			      parms.put("vendorCode", params.get("vendorCode"));
			   }
			   if(params.containsKey("whC") && StringUtils.isNotBlank(params.get("whC").toString())) {
				      sql.append(" AND M.WH_C=:whC");
				      parms.put("whC", params.get("whC"));
				   }
			   if (params.containsKey("diffRetFlg") && StringUtils.isNotBlank(params.get("diffRetFlg").toString())) {
				   sql.append(" and M.DIFF_RET_FLG=:diffRetFlg");
				   parms.put("diffRetFlg",  params.get("diffRetFlg"));
			   }
			   if (params.containsKey("masNo") && StringUtils.isNotBlank(params.get("masNo").toString())) {
			       sql.append(" and M.MAS_NO like :masNo");
			       parms.put("masNo", "%" + params.get("masNo") + "%");
			   }
			   if(params.containsKey("orderType") && StringUtils.isNotBlank(params.get("orderType").toString())) {
			       sql.append(" AND M.ORDER_TYPE=:orderType");
			       parms.put("orderType", params.get("orderType"));
			   }
			 }
			 sql.append(" AND EXISTS (SELECT 1 FROM ORDER_ITEM I WHERE I.MAS_PK_NO = M.PK_NO AND NVL(I.QTY1,0) <> NVL(I.QTY2,0))");
			 if (StringUtils.isNotBlank((String)params.get("orderby"))) {
			   orderby = new LinkedHashMap<String, String>();
			   orderby.put(params.get("orderby").toString(), params.get("sord").toString());
			}
		  
		  return super.sqlqueryForpage(sql.toString(), parms, orderby);
	    }

		@Override
		public List<Map<String, Object>> getOrderlistByIds(String [] ids) {
			SQLQuery query = getSession().createSQLQuery("select sc.NAME,(t.AMOUNT - NVL(abs(t.DIFF_MISC_AMT),0) - NVL(t.MISC_PAY_AMT,0) + NVL(t.FREIGHT,0)) AS AMOUNT_CN,t.* from ORDER_MAS t left join SCUSER sc on t.LOGISTIC_USER_CODE = sc.USER_NO where t.PK_NO in (:ids) order by t.MAS_NO DESC");
			query.setParameterList("ids", ids);
			return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		}
		
		@Override
		public String getOrderRemarks(BigDecimal orderId) {
			Query query = getSession().createSQLQuery("SELECT B2B_MISC_UTIL.GET_ORDER_CAN_DELIVER(:orderId) from dual");
			query.setParameter("orderId", orderId);
			return query.uniqueResult().toString();
		}

		@Override
		public void completeReserve(BigDecimal pkNo,String userName,String flag){
			try{
				Connection conn = super.getSession().connection();
				CallableStatement call = conn.prepareCall("{Call CORE_STKIO_UTIL.complete_reserve(?,?,?,?)}");
				call.setBigDecimal(1, pkNo);
				call.setString(2, userName);
				call.setString(3, flag);
				call.registerOutParameter(4, oracle.jdbc.OracleTypes.VARCHAR);
				call.execute();
				String info = call.getString(4);
				log.info("发货环节执行预留结果: pkNo=[+"+pkNo.toString()+"],info="+info);
				System.out.println("发货环节执行预留结果: pkNo=[+"+pkNo.toString()+"],info="+info);
			}catch (Exception e){
				log.info(e);
				System.out.println(e);
			}
		}
	@Override
	public Page<Map<String, Object>> queryOrderDifferencePage(Map<String, Object> params, LinkedHashMap<String, String> orderby) {
	    StringBuffer sql = new StringBuffer("select t.PK_NO, t.OM_PK_NO, t.MAS_NO, t.CUST_USER_NO, t.PTS_AMOUNT, t.PTS_CHG_DESC, t.BAL_AMOUNT, t.BAL_CHG_DESC, t.CHANGE_STATE, t.CREATE_DATE,t1.USER_NAME  from TRANSIT_PAYMENT_CHG t,SCUSER t1  where t.CUST_USER_NO=t1.USER_NO and t.CHANGE_STATE = 'N' and (t.PTS_AMOUNT>0 or t.BAL_AMOUNT>0) ");
		
		Map<String, Object> parms = new HashMap<String, Object>();
		
		if(null!=params){
//			if(params.containsKey("payStatus") && StringUtils.isNotBlank(params.get("payStatus").toString())) {
//				sql.append(" AND t.PAY_STATUS=:payStatus");
//				parms.put("payStatus", params.get("payStatus"));
//			}
//			if(params.containsKey("statusFlg") && StringUtils.isNotBlank(params.get("statusFlg").toString())) {
//				sql.append(" AND t.STATUS_FLG=:statusFlg");
//				parms.put("statusFlg", params.get("statusFlg"));
//			}
//			if(params.containsKey("logisticUserCode") && StringUtils.isNotBlank(params.get("logisticUserCode").toString())) {
//				sql.append(" AND t.LOGISTIC_USER_CODE=:logisticUserCode");
//				parms.put("logisticUserCode", params.get("logisticUserCode"));
//			}
//			if(params.containsKey("logisticCode") && StringUtils.isNotBlank(params.get("logisticCode").toString())) {
//				sql.append(" AND t.LOGISTIC_CODE=:logisticCode");
//				parms.put("logisticCode", params.get("logisticCode"));
//			}
//			if(params.containsKey("logisticusername") && StringUtils.isNotBlank(params.get("logisticusername").toString())) {
//				sql.append(" AND t1.NAME=:logisticusername");
//				parms.put("logisticusername", params.get("logisticusername"));
//			}
//			if(params.containsKey("masDate") && StringUtils.isNotBlank(params.get("masDate").toString())) {
//				sql.append(" AND to_char(t.MAS_DATE,'yyyy-MM-dd')=:masDate");
//				parms.put("masDate", params.get("masDate"));
//			}
//			if(params.containsKey("startDate") && StringUtils.isNotBlank(params.get("startDate").toString())) {
//				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
//				sql.append(" AND  t.MAS_DATE >=:startDate");
//				try {
//					parms.put("startDate", sdf.parse(params.get("startDate").toString()+" 00:00:00"));
//				} catch (ParseException e) {
//					e.printStackTrace();
//				}
//			}
//			if(params.containsKey("endDate") && StringUtils.isNotBlank(params.get("endDate").toString())) {
//				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
//				sql.append(" AND  t.MAS_DATE <=:endDate");
//				try {
//					parms.put("endDate", sdf.parse(params.get("endDate").toString()+" 23:59:59"));
//				} catch (ParseException e) {
//					e.printStackTrace();
//				}
//			}
//			
//			if (params.containsKey("masNo") && StringUtils.isNotBlank(params.get("masNo").toString())) {
//				sql.append(" and t.MAS_NO like :masNo");
//				parms.put("masNo", "%" + params.get("masNo") + "%");
//			}
//			if (params.containsKey("pkNo") && StringUtils.isNotBlank(params.get("pkNo").toString())) {
//				sql.append(" and t.PK_NO = :pkNo");
//				parms.put("pkNo", params.get("pkNo"));
//			}
			
			if(params.containsKey("custUserNo") && StringUtils.isNotBlank(params.get("custUserNo").toString())) {
				sql.append(" AND t.CUST_USER_NO=:custUserNo");
				parms.put("custUserNo", params.get("custUserNo"));
			}
			
			if(params.containsKey("masNo") && StringUtils.isNotBlank(params.get("masNo").toString())) {
				sql.append(" AND t.MAS_NO=:masNo");
				parms.put("masNo", params.get("masNo"));
			}
					
			if(params.containsKey("refUserName") && StringUtils.isNotBlank(params.get("refUserName").toString())) {
				sql.append(" AND t1.REF_USER_NAME=:refUserName");
				parms.put("refUserName", params.get("refUserName"));
			}
			
			if(params.containsKey("userName") && StringUtils.isNotBlank(params.get("userName").toString())) {
				sql.append(" AND t1.USER_NAME=:userName");
				parms.put("userName", params.get("userName"));
			}
		}
		orderby = new LinkedHashMap<String, String>();
		if (StringUtils.isNotBlank((String)params.get("orderby"))) {
			orderby.put(params.get("orderby").toString(), params.get("sord").toString());
		}else{
			orderby.put("t.CREATE_DATE", "desc");
		}
		
		return super.sqlqueryForpage(sql.toString(), parms, orderby);
	}

	@Override
	public Map<String, Object> queryOrderCount(String sql, String username) {
//		String sqltop = "select OM.SUB_STATUS,OM.VENDOR_NAME,OM.MAS_NO,OM.ORDER_TYPE,(case DELIVERY_TYPE when 'L' then '货到付款' when 'S' then '在线支付' ELSE '其他' END) as DM_NAME,OM.STATUS_FLG,OM.CUST_CODE,OM.AMOUNT,OM.MISC_PAY_AMT,OM.DIFF_MISC_AMT,WM.NAME as WHNAME from ORDER_MAS om left join WH_MAS wm on OM.WH_C = WM.WH_C";
		
		SQLQuery query = super.getSession().createSQLQuery(sql);
		Map map = new HashMap();
		map.put("username", username);
		this.setParames(map, query);
		System.out.println(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}
	
	@Override
	public Page getStatisticsOrderMasList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby, String username) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				" select SC.NAME AS LOGISTIC_NAME,T1.NAME AS LOGISTIC_USER_NAME,to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DAT,om.mas_code, OM.SUB_STATUS,OM.VENDOR_NAME,OM.MAS_NO,OM.ORDER_TYPE,(case DELIVERY_TYPE when 'L' then '货到付款' when 'S' then '在线支付' ELSE '其他' END) as DM_NAME,OM.STATUS_FLG,OM.CUST_CODE,OM.CUST_NAME,OM.AMOUNT,OM.MISC_PAY_AMT,OM.DIFF_MISC_AMT,WM.NAME as WHNAME " +
				"from ORDER_MAS om left join WH_MAS wm on OM.WH_C = WM.WH_C " +
				"LEFT JOIN SCUSER t1 on OM.LOGISTIC_USER_CODE = t1.USER_NO " +
				"LEFT JOIN SCUSER SC ON SC.USER_NO = om.LOGISTIC_CODE " +
				"left join (select t.TREE_PATH || t.AREA_ID || ',' as area,t.AREA_ID from AREA_MAS_WEB t) a on a.AREA_ID = OM.AREA_ID ");
		if (null != paramMap) {
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "vendorWaitReceive".equals(paramMap.get("type"))) {
				sql.append(" WHERE ((MAS_CODE='SALES' AND ORDER_TYPE IN ('SOP','LBP') AND STATUS_FLG='WAITDELIVER') OR (MAS_CODE='RETURN' AND ORDER_TYPE ='LBP' and status_flg='DELIVERED'))");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "vendorWaitDeliver".equals(paramMap.get("type"))) {
				sql.append("WHERE MAS_CODE = 'SALES' AND ORDER_TYPE IN ('SOP','LBP') AND STATUS_FLG = 'INPROCESS' and vendor_merge_flg in('N','Y')");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "warehouseWaitReceive".equals(paramMap.get("type"))) {
				sql.append("WHERE STATUS_FLG = 'INPROCESS'  and ((MAS_CODE = 'SALES' AND ORDER_TYPE IN ('FBP','LBP') AND pk_no in(select source_pk_no from MERGE_ORDER where mas_pk_no in (select mm.pk_no from MERGE_ORDER_MAS mm where mm.status_flg='D'))) or (order_type='FBP' and mas_code='RETURN'))");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "warehouseWaitDeliver".equals(paramMap.get("type"))) {
				sql.append("where status_flg='INPROCESS' and pk_no not in(select pk_no from order_mas WHERE STATUS_FLG = 'INPROCESS' and ((MAS_CODE = 'SALES' AND ORDER_TYPE IN ('FBP','LBP') AND pk_no in(select source_pk_no from MERGE_ORDER where mas_pk_no in (select mm.pk_no from MERGE_ORDER_MAS mm where mm.status_flg='D'))) or (order_type='FBP' and mas_code='RETURN')))");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "warehouseException".equals(paramMap.get("type"))) {
				sql.append(" where MAS_CODE = 'SALES' AND STATUS_FLG = 'SUCCESS' AND DIFF_RET_FLG = 'Y'");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "logisticsWaitDistribution".equals(paramMap.get("type"))) {
				sql.append("WHERE MAS_CODE='SALES' AND STATUS_FLG in('DELIVERED') and internal_flg='N' and logistic_user_code is null ");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "logisticsDistribution".equals(paramMap.get("type"))) {
				sql.append("WHERE MAS_CODE='SALES' AND STATUS_FLG not in('SUCCESS','CLOSE') and logistic_user_code is not null");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "waitCollection".equals(paramMap.get("type"))) {
				sql.append("WHERE MAS_CODE='SALES' AND STATUS_FLG ='SUCCESS' and pay_status='WAITPAYMENT'");
			}
			
			if (paramMap.containsKey("type") && StringUtils.isNotBlank(paramMap.get("type").toString()) 
					&& "financeException".equals(paramMap.get("type"))) {
				sql.append("where Status_flg='SUCCESS' and pay_status='PAID' and diff_misc_amt>0 and payment_type='4028b88146176a290146176a8ebc0000' and REFUND_FLG ='Y' and diff_ret_flg in('P','N')");
			}
			
			if (paramMap.containsKey("masNo") && StringUtils.isNotBlank(paramMap.get("masNo").toString())) {
				sql.append(" and OM.MAS_NO = :masNo");
				param.put("masNo", paramMap.get("masNo"));
			}
			
			if (paramMap.containsKey("vendor") && StringUtils.isNotBlank(paramMap.get("vendor").toString())) {
				sql.append(" and OM.VENDOR_USER_NO = :vendor");
				param.put("vendor", paramMap.get("vendor"));
			}
			
			if (paramMap.containsKey("wh") && StringUtils.isNotBlank(paramMap.get("wh").toString())) {
				sql.append(" and OM.WH_C = :wh");
				param.put("wh", paramMap.get("wh"));
			}
			
			if (paramMap.containsKey("logistics") && StringUtils.isNotBlank(paramMap.get("logistics").toString())) {
				sql.append(" and OM.LOGISTIC_CODE = :logistics");
				param.put("logistics", paramMap.get("logistics"));
			}
			
			if (paramMap.containsKey("areaId") && StringUtils.isNotBlank(paramMap.get("areaId").toString())) {
				sql.append(" and a.area like:areaId");
				param.put("areaId", "%," + paramMap.get("areaId") + ",%");
			} 

			sql.append(" and om.area_id in (SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:username)) ");
			param.put("username", username);
		}
   		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public List<Map<String, Object>> getOrderAmtByBatchId(BigDecimal batchId) {
		StringBuffer sql = new StringBuffer(
				"select o.PK_NO,(o.AMOUNT+o.FREIGHT-o.DIFF_MISC_AMT-MISC.MISC_PAY) as amt from ORDER_MAS o left join (select MAS_PK_NO,sum(PAY_AMOUNT) as misc_pay from ORDER_PAYMENT GROUP BY MAS_PK_NO) misc on o.PK_NO = MISC.MAS_PK_NO where o.BATCH_ID = ?");
		Query query = super.getSession().createSQLQuery(sql.toString())
				.setBigDecimal(0, batchId);
		return (List<Map<String, Object>>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

/**
	 * 通过参数集合条件，获取子订单列表（与用户相关）
	 * 
	 * @param paramMap 参数集合
	 * @param
	 *  排序
	 * @return Page分页对象
	 */
	@Override
	public List<Map<String,Object>> getChildOrderList(Map<String, Object> paramMap){
		StringBuilder sql = new StringBuilder(
				" SELECT to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,om.*,sm.STM_NAME,TO_CHAR(om.MAS_NO) CHAR_MAS_NO,op.PAY_AMOUNT,sc.NAME, " +
				" NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'Y' and MAS_PK_NO = om.PK_NO), 0)AS COUPON_AMOUNT," + 
				" NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'P' and MAS_PK_NO = om.PK_NO), 0)AS POINTS_AMOUNT," + 
				" NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'B' and MAS_PK_NO = om.PK_NO), 0)AS B_AMOUNT," + 
				" NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'O' and MAS_PK_NO = om.PK_NO), 0)AS O_AMOUNT" + 
				" FROM ORDER_MAS om " +
				" LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE " +
				" LEFT JOIN ORDER_PAYMENT op ON op.MAS_PK_NO=om.MAS_NO " +
				" LEFT JOIN SCUSER sc ON om.LOGISTIC_USER_CODE = sc.USER_NO  WHERE 1=1 ");
		List<Object> paras = new ArrayList<Object>();
		if (null != paramMap) {
			if (paramMap.containsKey("userNo") && StringUtils.isNotBlank(paramMap.get("userNo").toString())) {
				sql.append(" AND om.USER_NO=?");
				paras.add(paramMap.get("userNo"));
			}
			if (paramMap.containsKey("refPkNo") && paramMap.get("refPkNo") == null) {
				sql.append(" AND om.REF_PK_NO is null");
			} else {
				sql.append(" AND om.REF_PK_NO =?");
				paras.add(paramMap.get("refPkNo"));
			}
		}
		Query query = super.createSQLQuery(sql.toString(), paras.toArray());
		return (List<Map<String, Object>>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	/**
	 * 1.根据订单NO,获取商品评价、订单明细金额
	 * @param
	 * @return
	 */
	public Map<String, Object> getOrderMasComment(Map<String, Object> paramMap){
		StringBuffer sql = new StringBuffer("SELECT T2.PK_NO, T2.MAS_NO, T2.USER_NO, T2.AMOUNT as AMOUNT_MAS, ORG_NO, COM_NO, LOC_NO, CUST_CODE, LOGISTICS_COMMENT_FLG, COMMENT_FLG,DIFF_MISC_AMT, " +
				"NVL((SELECT SUM(CASE COMMENT_FLG WHEN 'Y' THEN 0 ELSE 1 END) FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO), 0)AS COMMENT_FLG_CN, " +
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'O' and MAS_PK_NO = T2.PK_NO), 0)AS O_AMOUNT, " +
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'B' and MAS_PK_NO = T2.PK_NO), 0)AS B_AMOUNT, " +
				"NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'T' and MAS_PK_NO = T2.PK_NO), 0)AS T_AMOUNT, " +
				"(SELECT USER_NAME FROM SCUSER  WHERE USER_NO = T2.USER_NO)as USER_NAME, " +
				"MAS_CODE " +
				"FROM ORDER_MAS T2 " +
				"WHERE T2.PK_NO = :pkno");
		//订单状态
		if(paramMap.containsKey("statusflg")) {
			if(null != paramMap.get("statusflg") && !"".equals(paramMap.get("statusflg"))) {
				paramMap.put("statusflg", paramMap.get("statusflg").toString().split(","));
				sql.append(" AND STATUS_FLG in(:statusflg)");
			}
		}
		//付款状态
		if(paramMap.containsKey("paystatus")) {
			if(null != paramMap.get("paystatus") && !"".equals(paramMap.get("paystatus"))) {
				sql.append(" AND PAY_STATUS = :paystatus");
			}
		}
		//订单主表商品评价字段
		if(paramMap.containsKey("commentflg")) {
			if(StringUtils.isNotBlank((String)paramMap.get("commentflg"))) {
				sql.append(" AND COMMENT_FLG = :commentflg");
			}
		}
		//物流评论
		if(paramMap.containsKey("lcommentflg")) {
			if(StringUtils.isNotBlank((String)paramMap.get("lcommentflg"))) {
				sql.append(" AND LOGISTICS_COMMENT_FLG = :lcommentflg");
			}
		}
		Query query = super.createSQLQuery(sql.toString(), paramMap);
		Map<String, Object> order = (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
		return order;
	}
	
	/**
	 * 根据订单NO更新订单表中的CommentFlg评论状态
	 * @param params
	 * @return
	 */
	public int upOrderCommentFlg(Map<String, Object> paramMap){
		Map<String, Object> param = new HashMap<String, Object>();
		String[] pkNos = paramMap.get("pkno").toString().split(",");
		StringBuffer sql = new StringBuffer("update ORDER_MAS set COMMENT_FLG = 'Y' where PK_NO = :pkNos ");
		param.put("pkNos", pkNos);
		return super.createSQLQuery(sql.toString(), param).executeUpdate();
	}
	@Override
	public BigDecimal getToReceiveOrderCount(String userName) {
		String sql = "select count(*) from order_mas om WHERE ((MAS_CODE='SALES' AND ORDER_TYPE IN ('SOP','LBP') AND STATUS_FLG='WAITDELIVER')  OR (MAS_CODE='RETURN' AND ORDER_TYPE ='LBP' and status_flg='DELIVERED')) and om.vendor_code=?";
		Query query = super.createSQLQuery(sql);
		query.setString(0, userName);
	    return (BigDecimal)query.uniqueResult();
	}

	@Override
	public BigDecimal getToSendOrderCount(String userName) {
		String sql = "select count(*) from order_mas WHERE MAS_CODE = 'SALES' AND ORDER_TYPE IN ('SOP','LBP') AND STATUS_FLG = 'INPROCESS' and vendor_merge_flg in('N','Y') and vendor_code=?";
		Query query = super.createSQLQuery(sql);
		query.setString(0, userName);
	    return (BigDecimal)query.uniqueResult();
	}

	@Override
	public BigDecimal getToCheckOrderCount(String userName) {
		String sql = "select count(*) from paybill_dtl pd where pd.check_state='01' and pd.bizend_time<=trunc(sysdate) and pd.payeecust_id=?";
		Query query = super.createSQLQuery(sql);
		query.setString(0, userName);
	    return (BigDecimal)query.uniqueResult();
	}

	@Override
	public Map<String, Object> getOrderCount(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("select count(*) as count,sum(om.amount-om.diff_misc_amt) AS AMT from order_mas om WHERE MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (Map<String, Object>)query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public List<Map<String, Object>> getOrderCountByDate(
			Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("select to_Char(om.mas_date,'yyyy-MM-dd') as mas_date,count(*) as count ,sum(om.amount-om.diff_misc_amt) as amt from order_mas om WHERE MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by om.mas_date ORDER BY MAS_DATE");
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>)query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public Page getOrderCountByDay(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("SELECT * FROM (select to_Char(om.mas_date,'yyyy-MM-dd') as mas_date,count(*) as count,sum(om.amount-om.diff_misc_amt) as amt from order_mas om WHERE MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by om.mas_date)");
   		return super.sqlqueryForpage(sql.toString(), param, null);
	}

	@Override
	public Page getOrderCountByArea(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("SELECT * FROM (select ba.一级区域 as A1,ba.二级区域 AS A2,ba.三级区域 AS A3 ,count(*) AS COUNT ,sum(om.amount-om.diff_misc_amt)  AS AMT from order_mas om,bi_area_mas ba WHERE om.area_id=ba.id3 and MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y'");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,ba.三级区域 order by 1,2,3)");
   		return super.sqlqueryForpage(sql.toString(), param, null);
	}

	@Override
	public Page getOrderCountByStk(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("SELECT * FROM ( select ba.一级区域 as A1,ba.二级区域 as A2,oi.stk_c,oi.stk_name,oi.uom,sum(oi.stk_qty) as stk_qty,sum(oi.stk_qty*oi.net_price) as amt,sum(oi.qty2) as  qty2, sum(oi.qty2*oi.net_price) as amt2 from order_mas om,order_item oi,bi_area_mas ba WHERE om.pk_no=oi.mas_pk_no and om.MAS_CODE='SALES' AND ba.id3=om.area_id AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,oi.stk_c,oi.stk_name,oi.uom order by 1)");
   		return super.sqlqueryForpage(sql.toString(), param, null);
	}
	
	@Override
	public List<Map<String, Object>> getStkCountByWarehouse(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("select W.NAME,SUM(C.STK_QTY) as STK_QTY,SUM(C.STK_QTY*M.NET_PRICE) as amt,SUM(C.RES_QTY) as RES_QTY from core_stk_wh c,stk_mas m,WH_MAS W where c.stk_c=m.stk_c AND C.WH_C=W.WH_C ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and c.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
		}
		sql.append(" group by W.NAME ");
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>)query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	/**
	 * 按日期导数据表
	 */
	@Override
	public List<Map<String, Object>> getOrderCountByDayExcel(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("SELECT * FROM (select count(*) as count,to_Char(om.mas_date,'yyyy-MM-dd') as mas_date,sum(om.amount-om.diff_misc_amt) as amt from order_mas om WHERE MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by om.mas_date)");
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>)query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	/**
	 * 按区域查询订单数/销售额   导表
	 */
	@Override
	public List<Map<String, Object>> getOrderCountByAreaExcel(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("SELECT * FROM (select ba.二级区域 AS A2,ba.一级区域 as A1,ba.三级区域 AS A3 ,count(*) AS COUNT ,sum(om.amount-om.diff_misc_amt)  AS AMT from order_mas om,bi_area_mas ba WHERE om.area_id=ba.id3 and MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y'");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,ba.三级区域 order by 1,2,3)");
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>)query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	/**
	 * 按区域、商品汇总查询数量/金额  导表
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getOrderCountByStkExcel(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		StringBuilder sql = new StringBuilder("SELECT * FROM ( select ba.二级区域 as A2,ba.一级区域 as A1,oi.stk_c,oi.stk_name,oi.uom,sum(oi.stk_qty) as stk_qty,sum(oi.stk_qty*oi.net_price) as amt,sum(oi.qty2) as  qty2, sum(oi.qty2*oi.net_price) as amt2 from order_mas om,order_item oi,bi_area_mas ba WHERE om.pk_no=oi.mas_pk_no and om.MAS_CODE='SALES' AND ba.id3=om.area_id AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString()) ) {
				sql.append(" and om.vendor_code=:userName ");
				param.put("userName", paramMap.get("userName"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString()) ) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,oi.stk_c,oi.stk_name,oi.uom order by 1)");
		Query query = super.getSession().createSQLQuery(sql.toString());
		setParames(param, query);
		return (List<Map<String, Object>>)query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> getLogisticOrder(
			Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
//		StringBuilder sql = new StringBuilder("" +
//				"select USER_NO,CUST_NAME,sum(AMOUNT) as AMOUNT,count(PK_NO) as COUNT " +
//				"from ORDER_MAS " +
//				"where INTERNAL_FLG='N' ");
		StringBuilder sql = new StringBuilder("" +
				"select T.USER_NO,CUST_NAME,sum(AMOUNT) as AMOUNT,count(PK_NO) as COUNT, SORT_NO, SU.LATITUDE, SU.LONGITUDE " +
				"from ORDER_MAS T " +
				"LEFT JOIN SCUSER SU ON SU.USER_NO = T.USER_NO " +
				"where INTERNAL_FLG='N' ");
		if (paramMap.containsKey("lucode") && StringUtils.isNotBlank(paramMap.get("lucode").toString())) {
			sql.append(" and LOGISTIC_USER_CODE=:lucode");
			param.put("lucode", paramMap.get("lucode"));
		}
		if (paramMap.containsKey("custname") && StringUtils.isNotBlank(paramMap.get("custname").toString())) {
			sql.append(" and CUST_NAME like :custname");
			param.put("custname","%"+ paramMap.get("custname")+ "%");
		}
		if (paramMap.containsKey("inprocess") && StringUtils.isNotBlank(paramMap.get("inprocess").toString())) {
			sql.append(" and (STATUS_FLG=:deliverde  or STATUS_FLG=:inprocess)");
			param.put("inprocess", paramMap.get("inprocess"));
			param.put("deliverde", paramMap.get("deliverde"));
		}
		sql.append(" group by T.USER_NO, CUST_NAME, SORT_NO, SU.LATITUDE, SU.LONGITUDE");
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List<Map<String, Object>> getLogisticItem(
			Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select PK_NO,MAS_NO,USER_NO,CUST_NAME,(AMOUNT - abs(NVL(DIFF_MISC_AMT,0)) - NVL(MISC_PAY_AMT,0) + NVL(FREIGHT,0)) as S_AMOUNT,AMOUNT from ORDER_MAS  where  1=1   and INTERNAL_FLG='N' ");
		if (paramMap.containsKey("lucode") && StringUtils.isNotBlank(paramMap.get("lucode").toString())) {
			sql.append(" and LOGISTIC_USER_CODE=:lucode");
			param.put("lucode", paramMap.get("lucode"));
		}
		if (paramMap.containsKey("userno") && StringUtils.isNotBlank(paramMap.get("userno").toString())) {
			sql.append(" and USER_NO=:userno");
			param.put("userno", paramMap.get("userno"));
		}
		if (paramMap.containsKey("inprocess") && StringUtils.isNotBlank(paramMap.get("inprocess").toString())) {
			sql.append(" and (STATUS_FLG=:deliverde  or STATUS_FLG=:inprocess)");
			param.put("inprocess", paramMap.get("inprocess"));
			param.put("deliverde", paramMap.get("deliverde"));
		}
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public void orderUpdate(BigDecimal logisticUserCode, BigDecimal refPkNo) {
		StringBuffer sql = new StringBuffer("update ORDER_MAS set LOGISTIC_USER_CODE= ?");
		sql.append(" where REF_PK_NO = ? and (STATUS_FLG = 'INPROCESS' or STATUS_FLG = 'DELIVERED') and LOGISTIC_USER_CODE is null");
		super.createSQLQuery(sql.toString()).setBigDecimal(0, logisticUserCode).setBigDecimal(1, refPkNo).executeUpdate();
	}
	
	/**
	 * 1.根据主订单NO,获取子订单中是否存在非法数据（订单状态：WAITDELIVER，子订单已绑定配送员）
	 * @param
	 * @return
	 */
	public Map<String, Object> getOrderMas(BigDecimal refPkNo){
		String sql = "select REF_PK_NO, " +
				"(SELECT COUNT(PK_NO) FROM ORDER_MAS t WHERE STATUS_FLG='WAITDELIVER' and T.REF_PK_NO = om.REF_PK_NO ) WAITDELIVER_CN," +
				"(SELECT COUNT(PK_NO) FROM ORDER_MAS t WHERE LOGISTIC_USER_CODE is not null and T.REF_PK_NO = om.REF_PK_NO ) LOGISTIC_CN " +
				" from ORDER_MAS om " +
				"where om.REF_PK_NO = ? group by REF_PK_NO";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, refPkNo).uniqueResult();
	}
	
	/**
	 * 根据订单收货地址检查是否存在负责该3级区域配送任务的仓库
	 * @param areaID 3级区域
	 * SELECT COUNT(1)as ISTRUE FROM DS_AREA WHERE area_id = 1
	 */
	public Map<String, Object> getDS_AREA(BigDecimal areaID){
		String sql = "SELECT COUNT(1)as ISTRUE " +
				"FROM DS_AREA " +
				"WHERE area_id = ?";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return (Map<String, Object>) query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, areaID).uniqueResult();
	}

	@Override
	public Page getLogisticsStatistics(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("select s.NAME,om.LOGISTIC_USER_CODE,s.USER_NAME as USER_NAME_S,s.crm_Mobile,(select mm.user_name from MGT_EMPLOYEE mm WHERE mm.account_name=s.REF_USER_NAME) as USER_NAME_ME,count(case when OM.STATUS_FLG <> 'CLOSE' then OM.STATUS_FLG end) as total,SUM(case when OM.STATUS_FLG <> 'CLOSE' then OM.AMOUNT end) as AMOUNT,count(case OM.STATUS_FLG when 'SUCCESS' then 'SUCCESS' end) as SUCCESS,count(case when OM.STATUS_FLG <> 'CLOSE' then OM.STATUS_FLG end)-count(case OM.STATUS_FLG when 'SUCCESS' then 'SUCCESS' end) as wei from ORDER_MAS om left join SCUSER s ON om.LOGISTIC_USER_CODE=s.user_no where LOGISTIC_USER_CODE in (select s.USER_NO from MGT_EMPLOYEE me left join SCUSER s ON me.ACCOUNT_name=s.user_name where 1=1 ");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString()) ) {
				sql.append(" AND me.merchant_code=:merchantCode ");
				param.put("merchantCode", paramMap.get("merchantCode"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())&&
					paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" AND to_char(om.CREATE_DATE,'yyyy-mm-dd') >=:startDate AND to_char(om.CREATE_DATE,'yyyy-mm-dd') <=:endDate");
				param.put("startDate", paramMap.get("startDate"));
				param.put("endDate", paramMap.get("endDate"));
			}
			if (paramMap.containsKey("minDate") && StringUtils.isNotBlank(paramMap.get("minDate").toString())&&
					paramMap.containsKey("maxDate") && StringUtils.isNotBlank(paramMap.get("maxDate").toString())) {
				sql.append(" AND to_char(om.CREATE_DATE,'yyyy-mm-dd') >=:minDate AND to_char(om.CREATE_DATE,'yyyy-mm-dd') <=:maxDate");
				param.put("minDate", paramMap.get("minDate"));
				param.put("maxDate", paramMap.get("maxDate"));
			}
		}
		sql.append(" and  s.LOGISTICS_PROVIDER_FLG='Y') ");
		if(paramMap != null){
			if (paramMap.containsKey("mounthDate") && StringUtils.isNotBlank(paramMap.get("mounthDate").toString()) ) {
				sql.append(" AND to_char(om.CREATE_DATE,'yyyy-mm')=:mounthDate ");
				param.put("mounthDate", paramMap.get("mounthDate"));
			}
		}
		sql.append(" GROUP BY s.NAME,s.crm_Mobile,om.LOGISTIC_USER_CODE,s.USER_NAME,s.REF_USER_NAME ");
		return super.sqlqueryForpage(sql.toString(),param,null);
	}
	
	@Override
	public Page getSalerStatistics(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("SELECT om.SP_NAME,s.USER_NAME as USER_NAME_S,s.crm_Mobile,(select mm.user_name from MGT_EMPLOYEE mm WHERE mm.account_name=s.REF_USER_NAME) as USER_NAME_ME," +
	    "count(case when OM.STATUS_FLG <> 'CLOSE' then OM.STATUS_FLG end) as total," +
	    "SUM(case when OM.STATUS_FLG <> 'CLOSE' then OM.AMOUNT end) as AMOUNT," +
	    "count(case OM.STATUS_FLG when 'SUCCESS' then 'SUCCESS' end) as SUCCESS," +
	    "count(case when OM.STATUS_FLG <> 'CLOSE' then OM.STATUS_FLG end)-count(case OM.STATUS_FLG when 'SUCCESS' then 'SUCCESS' end) as wei " +
	    "FROM ORDER_MAS om RIGHT JOIN SCUSER s ON om.SP_USER_NO=s.USER_NO " +
	    "LEFT JOIN MGT_EMPLOYEE me ON me.ACCOUNT_name=s.user_name WHERE 1=1 and om.internal_flg = 'N'");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString()) ) {
				sql.append(" AND me.merchant_code=:merchantCode ");
				param.put("merchantCode", paramMap.get("merchantCode"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())&&
					paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" AND to_char(om.CREATE_DATE,'yyyy-mm-dd') >=:startDate AND to_char(om.CREATE_DATE,'yyyy-mm-dd') <=:endDate");
				param.put("startDate", paramMap.get("startDate"));
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" GROUP BY om.SP_NAME,s.USER_NAME,s.crm_Mobile,s.REF_USER_NAME  ORDER BY om.SP_NAME ASC");
		return super.sqlqueryForpage(sql.toString(),param,null);
	}
	
	@Override
	public Page<Map<String, Object>> getSopOrderList(
			Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"SELECT to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,AM.ADDRESS1,om.*,sm.STM_NAME,TO_CHAR(om.MAS_NO) CHAR_MAS_NO," +
				"(case DELIVERY_TYPE when 'L' then '物流' when 'S' then '自提' ELSE '其他' END) as DM_NAME FROM ORDER_MAS om " +
				"LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE LEFT JOIN ADDRESS_MAS AM ON AM.PK_NO=om.ADDRESS_NO " +
				"WHERE ORDER_TYPE = 'SOP' AND INTERNAL_FLG = 'N' AND om.MAS_CODE = 'SALES' ");
		if (null != paramMap) {
			if (paramMap.containsKey("vendorUserNo") && StringUtils.isNotBlank(paramMap.get("vendorUserNo").toString())) {
				sql.append(" AND om.VENDOR_USER_NO=:vendorUserNo");
				param.put("vendorUserNo", paramMap.get("vendorUserNo"));
			}
			if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString()) && !"ORDER".equals(paramMap.get("statusFlg").toString())) {
				if("WAITDELIVER".equals(paramMap.get("statusFlg").toString())){
					sql.append(" AND ((sm.STM_NAME IN ('货到付款','上门自提')AND om.STATUS_FLG IN ('WAITDELIVER', 'WAITPAYMENT')) " +
						"OR (sm.STM_NAME='在线支付' AND om.STATUS_FLG='WAITDELIVER')) ");
				}
				if("INPROCESS".equals(paramMap.get("statusFlg").toString())){
					sql.append(" AND om.STATUS_FLG='INPROCESS' ");
					if("WAITPRINT".equals(paramMap.get("sub_status_radio").toString())){
						sql.append(" AND om.SUB_STATUS='WAITPRINT' ");
					}else if("WAITDELIVER".equals(paramMap.get("sub_status_radio").toString())){
						sql.append(" AND om.SUB_STATUS='WAITDELIVER' ");
					}
					if (paramMap.containsKey("pickCheckValue") && StringUtils.isNotBlank(paramMap.get("pickCheckValue").toString())) {
						sql.append(" AND om.PICK_FLG=:pickCheckValue");
						param.put("pickCheckValue", paramMap.get("pickCheckValue"));
					}
				}
				if("DELIVERED".equals(paramMap.get("statusFlg").toString())){
					sql.append(" AND om.STATUS_FLG='DELIVERED' ");
				}
				//2015年12月7日15:41:10 RJY 加入已完成订单tab页
				if("SUCCESS".equals(paramMap.get("statusFlg").toString())){
					sql.append(" AND om.STATUS_FLG='SUCCESS' ");
				}
				//2015年12月7日16:59:18 RJY SOP已完成订单时间条件和编码查询
				if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())&&
						paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
					sql.append(" AND to_char(om.CREATE_DATE,'yyyy-mm-dd') >=:startDate AND to_char(om.CREATE_DATE,'yyyy-mm-dd') <=:endDate");
					param.put("startDate", paramMap.get("startDate"));
					param.put("endDate", paramMap.get("endDate"));
				}
				if (paramMap.containsKey("masNo") && StringUtils.isNotBlank(paramMap.get("masNo").toString())) {
					sql.append(" AND om.MAS_NO like :masNo");
					param.put("masNo", "%" + paramMap.get("masNo") + "%");
				}
				//2015年12月8日17:35:40 RJY SOP已完成订单店铺条件
				if(paramMap.containsKey("userNo") && StringUtils.isNotBlank(paramMap.get("userNo").toString())){
					sql.append(" AND om.USER_NO=:userNo ");
					param.put("userNo", paramMap.get("userNo"));
				}
			}
		}
		if (StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
			orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}


	@Override
	public Page findSubOrderMasByParams(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"  SELECT to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') OM_CREATE_DATE,om.*,sm.STM_NAME,TO_CHAR(om.MAS_NO) CHAR_MAS_NO,op.PAY_AMOUNT,sc.NAME," +
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'Y' and MAS_PK_NO = om.PK_NO), 0)AS COUPON_AMOUNT," + //优惠劵
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'P' and MAS_PK_NO = om.PK_NO), 0)AS POINTS_AMOUNT," + //积分
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'B' and MAS_PK_NO = om.PK_NO), 0)AS B_AMOUNT," + //余额
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'T' and MAS_PK_NO = om.PK_NO), 0)AS T_AMOUNT," + //代缴货款
				"  NVL((SELECT SUM(PAY_AMOUNT) FROM ORDER_PAYMENT  WHERE PAY_TYPE = 'O' and MAS_PK_NO = om.PK_NO), 0)AS O_AMOUNT" + //银行卡
				"  FROM ORDER_MAS om " +
				"  LEFT JOIN SETTLEMENT_METHOD sm ON sm.STM_CODE=om.PAYMENT_TYPE " +
				"  LEFT JOIN ORDER_PAYMENT op ON op.MAS_PK_NO=om.MAS_NO " +
				"  LEFT JOIN SCUSER sc ON om.LOGISTIC_USER_CODE = sc.USER_NO  WHERE om.MAS_CODE = 'SALES' "+
		        "  and  INTERNAL_FLG ='N'  ");
		
		if (null != paramMap) {

			if (paramMap.containsKey("statusFlg")) {
				Object statusFlg = paramMap.get("statusFlg");
				if (statusFlg != null && "DOING".equals(statusFlg.toString())) {
					sql.append("  AND (om.STATUS_FLG in('WAITPAYMENT','INPROCESS', 'WAITDELIVER', 'DELIVERED', 'RETURNSING') " +
							   "  OR  om.STATUS_FLG in('SUCCESS') AND om.PAY_STATUS NOT IN('PAID'))");
				}
				if (statusFlg != null && "SUCCESS".equals(statusFlg.toString())) {
					sql.append("  AND (om.STATUS_FLG in('SUCCESS') AND om.PAY_STATUS in('PAID'))" );
				}
				if (statusFlg != null && "CLOSE".equals(statusFlg.toString())) {
					sql.append("  AND (om.STATUS_FLG in('CLOSE'))");
				}
			}
			
			if (paramMap.containsKey("userNo") && StringUtils.isNotBlank(paramMap.get("userNo").toString())) {
				sql.append(" AND om.USER_NO=:userNo");
				param.put("userNo", paramMap.get("userNo"));
			}
			
			if (StringUtils.isNotBlank((String)paramMap.get("orderby"))) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
   		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}
	
	@Override
	public BigDecimal pickOrderCount(Map<String, Object> params) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("SELECT  COUNT(*) QTY FROM ORDER_MAS WHERE INTERNAL_FLG = 'N' AND  STATUS_FLG='INPROCESS' ");
		if (null != params) {
			// 判断供应商是否为空，为空不拼接
			if (params.containsKey("vendoruserno")
					&& StringUtils.isNotBlank(params.get("vendoruserno").toString())) {
				sql.append(" AND VENDOR_USER_NO =:vendoruserno");
				param.put("vendoruserno", params.get("vendoruserno"));
			}
			// 判断订单拣货状态属性是否为空，为空不拼接
			if (params.containsKey("pickflg")
					&& StringUtils.isNotBlank(params.get("pickflg").toString())) {
				sql.append(" AND PICK_FLG =:pickflg");
				param.put("pickflg", params.get("pickflg"));
			}
			// 判断仓库属性是否为空，为空不拼接
			if (params.containsKey("whc")
					&& StringUtils.isNotBlank(params.get("whc").toString())) {
				sql.append(" AND WH_C =:whc");
				param.put("whc", params.get("whc"));
			}
			if (params.containsKey("userno")
					&& StringUtils.isNotBlank(params.get("userno").toString())) {
				sql.append(" AND PICK_USER_NO =:userno");
				param.put("userno", params.get("userno"));
			}
		}
		List list = super.createSQLQuery(sql.toString(),param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		if(list!=null&&list.size()>0){
			Map map= (Map) list.get(0);
			return  (BigDecimal) map.get("QTY");
		}
		return  null;
	}


	@Override
	public List<Map<String, Object>> getOrderByStkc(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("SELECT  oi.UOM_QTY,oi.MAS_PK_NO,oi.PK_NO,om.MAS_NO,om.RECEIVER_NAME,om.RECEIVER_ADDRESS " +
				"from " +
				"ORDER_MAS om left join ORDER_ITEM oi on om.PK_NO=oi.MAS_PK_NO  " +
				"  WHERE 1=1 AND om.pick_flg='A' AND om.INTERNAL_FLG = 'N' ");
		
		if (null != paramMap) {
			if (paramMap.containsKey("stkC") && StringUtils.isNotBlank(paramMap.get("stkC").toString())) {
				sql.append(" and oi.STK_C=:stkC");
				param.put("stkC", paramMap.get("stkC"));
			}
			if (paramMap.containsKey("pickUserNo") && StringUtils.isNotBlank(paramMap.get("pickUserNo").toString())) {
				sql.append(" and om.PICK_USER_NO=:pickUserNo");
				param.put("pickUserNo", paramMap.get("pickUserNo"));
			}
			if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())) {
				sql.append(" and om.STATUS_FLG in (:statusFlg)");
				String statusFlg[] = paramMap.get("statusFlg").toString().split(",");
				param.put("statusFlg", statusFlg);
			}
		}
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();

	}


	@Override
	public BigDecimal orderCountByStkc(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("SELECT  count(om.MAS_NO) QTY from ORDER_MAS om left join ORDER_ITEM oi on om.PK_NO=oi.MAS_PK_NO  " +
				"  WHERE 1=1 AND om.pick_flg='A' AND om.INTERNAL_FLG = 'N' AND om.STATUS_FLG='INPROCESS' ");
		
		if (null != paramMap) {
			if (paramMap.containsKey("stkC") && StringUtils.isNotBlank(paramMap.get("stkC").toString())) {
				sql.append(" and oi.STK_C=:stkC");
				param.put("stkC", paramMap.get("stkC"));
			}
			if (paramMap.containsKey("pickUserNo") && StringUtils.isNotBlank(paramMap.get("pickUserNo").toString())) {
				sql.append(" and om.PICK_USER_NO=:pickUserNo");
				param.put("pickUserNo", paramMap.get("pickUserNo"));
			}
		}
		
		List list= super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
		if(list!=null&&list.size()>0){
			Map map= (Map) list.get(0);
			return  (BigDecimal) map.get("QTY");
		}
		return  null;
	}


	@Override
	public Page<Map<String, Object>> getPickingList(Map<String, Object> params) {
		LinkedHashMap<String, String> order = new LinkedHashMap<String, String>();
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuffer sql = new StringBuffer("SELECT " +
				"PK_NO,MAS_NO,QTY,AMOUNT,VENDOR_USER_NO,RECEIVER_NAME,RECEIVER_ADDRESS,CUST_NAME,rm.ROUTE_NAME," +
				"to_char(om.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') CREATE_DATE, " +
				"(select (select AREA_NAME from AREA_MAS_WEB where GRADE = 2 and instr(a.TREE_PATH,',' || AREA_ID || ',') > 0)  || AREA_NAME  from AREA_MAS_WEB a where a.AREA_ID = om.AREA_ID ) as AREA_NAME, " +
				"NVL((select sum(QTY1) from ORDER_ITEM oi where oi.MAS_PK_NO = om.PK_NO ), 0) as QTY1 " +
				"FROM ORDER_MAS om " +
				"LEFT JOIN B2B_ROUTE_MAS rm ON om.ROUTE_CODE = rm.ROUTE_CODE and om.VENDOR_CODE = rm.LOGISTIC_CODE " +
				"WHERE " +
				"INTERNAL_FLG='N' AND om.STATUS_FLG='INPROCESS' ");

		// 判断供应商是否为空，为空不拼接
		if (params.containsKey("vendoruserno")
				&& StringUtils.isNotBlank(params.get("vendoruserno").toString())) {
			sql.append(" AND VENDOR_USER_NO =:vendoruserno");
			param.put("vendoruserno", params.get("vendoruserno"));
		}
		// 判断订单拣货状态属性是否为空，为空不拼接
		if (params.containsKey("pickflg")
				&& StringUtils.isNotBlank(params.get("pickflg").toString())) {
			sql.append(" AND PICK_FLG =:pickflg");
			param.put("pickflg", params.get("pickflg"));
			/*if(params.get("pickflg").toString().equals("Y")){
				order.put("MAS_NO", "DESC");
			}*/
		}
		// 判断仓库属性是否为空，为空不拼接
		if (params.containsKey("whc")
				&& StringUtils.isNotBlank(params.get("whc").toString())) {
			sql.append(" AND WH_C =:whc");
			param.put("whc", params.get("whc"));
		}
		if (params.containsKey("userno")
				&& StringUtils.isNotBlank(params.get("userno").toString())) {
			sql.append(" AND PICK_USER_NO =:userno");
			param.put("userno", params.get("userno"));
		}
		if (params.containsKey("masCode") && StringUtils.isNotBlank(params.get("masCode").toString())) {
			sql.append(" and om.MAS_CODE = :masCode");
			param.put("masCode", params.get("masCode"));
		}
		
		if (params.containsKey("routeCode") && StringUtils.isNotBlank(params.get("routeCode").toString())) {
			sql.append(" and om.ROUTE_CODE = :routeCode");
			param.put("routeCode", params.get("routeCode"));
		}
		order.put("MAS_NO", "ASC");
		// order.put("om.CREATE_DATE", "DESC");
		return super.sqlqueryForpage(sql.toString(), param, order);
	}

	@Override
	public void updatePickingUser(Map<String, Object> param) {
		StringBuffer sql = new StringBuffer("update ORDER_MAS set pick_user_no = :userno,pick_flg=:pickflg");
		sql.append(" where PK_No IN (:pkno)");
		super.createSQLQuery(sql.toString(), param).executeUpdate();
	}
	
	/**
	 * 查询订单的当前状态
	 * @param param
	 * @author zy
	 * @date 2015年12月15日
	 * @return Map
	 */
	public Map<String, Object> getOrderPick(Map<String, Object> param){
		StringBuilder sql = new StringBuilder("SELECT " +
				"T2.PK_NO, T2.MAS_NO, PICK_USER_NO, PICK_FLG, STATUS_FLG, " +
				"(SELECT SUM(CASE WHEN qty1 is not NULL THEN 1 else 0 END) FROM ORDER_ITEM WHERE MAS_PK_NO = T2.PK_NO) AS SET_QTY, " +
				"(SELECT USER_NAME FROM SCUSER  WHERE USER_NO = T2.PICK_USER_NO)AS PICK_USER_NAME " +
				"FROM ORDER_MAS T2 " +
				"WHERE T2.PK_NO = :pkNo");
		return (Map<String, Object>)super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public BigDecimal findUomQtyByParams(Map<String, Object> params) {
			Query query = getSession().createSQLQuery(
					    "select sum(T3.UOM_QTY) + nvl(:uomQty, 0) "+
						"from ORDER_ITEM t3                          "+
						"left join ORDER_MAS t4                      "+
						"on T3.MAS_PK_NO = T4.PK_NO                  "+
						"left join WEB_PROM_ITEM1 t5                 "+
						"on T3.PROM_ITEM_PK_NO = t5.pk_no            "+
						"where                                       "+
						"T3.STK_C = :stkC and                     "+
						"t4.USER_NO = :userNo and                 "+
						"t3.prom_item_pk_no= :promItemPkNo AND   "+
						"T4.STATUS_FLG <> 'CLOSE' AND                "+
						"T4.CREATE_DATE >= t5.BEGIN_DATE AND         "+
						"T4.CREATE_DATE <= t5.END_DATE");
			query.setParameter("uomQty", params.get("uomQty"));
			query.setParameter("stkC", params.get("stkC"));
			query.setParameter("userNo", params.get("userNo"));
			query.setParameter("promItemPkNo", params.get("promItemPkNo"));
		return new BigDecimal(query.uniqueResult().toString());
	}

	@Override
	public BigDecimal findUomQtyByPromItemPkNo(BigDecimal promItemPkNo) {
		Query query = getSession().createSQLQuery(
		"select nvl(sum(Tt.UOM_QTY),0) as SUM_QTY "
		+ "from ORDER_ITEM tt "
		+ "left join ORDER_MAS ttt "
		+ "on tt.MAS_PK_NO = tTT.PK_NO  "
		+ "where   ttt.STATUS_FLG <> 'CLOSE' "
		+ "and tt.PROM_ITEM_PK_NO = :promItemPkNo");
	query.setParameter("promItemPkNo", promItemPkNo);
	return new BigDecimal(query.uniqueResult().toString());
	}
	

	/**
	 * 获取订单(订单金额/订单数量/商品品种数)统计数据(按时间/区域统计)
	 * @author honghui
	 * @date   2016-03-23
	 * @param  paramMap 查询参数 时间段/统计方式(按日/周/月)/统计类别(1-订单金额/2-订单数量/3-商品品种数)/用户集合
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getOrderStatistics(Map<String, Object> paramMap) {
		StringBuffer sql = new StringBuffer("select");
		if(paramMap.containsKey("staTimeType") && StringUtils.isNotBlank(paramMap.get("staTimeType").toString())){
			String staTimeType = paramMap.get("staTimeType").toString();
			if("day".equalsIgnoreCase(staTimeType)){
				sql.append(" TO_CHAR(orderMas.create_date,'yyyy-mm-dd') as day");
			}
			if("month".equalsIgnoreCase(staTimeType)){
				sql.append(" TO_CHAR(orderMas.create_date,'yyyy-mm') as month");			
			}
			if("week".equalsIgnoreCase(staTimeType)){
				sql.append(" TO_CHAR(orderMas.create_date,'yyyy-IW') as week");
			}
		}
		if(null != paramMap && paramMap.containsKey("statisticType") && StringUtils.isNotBlank(paramMap.get("statisticType").toString())){
			int statisticType = Integer.parseInt(paramMap.get("statisticType").toString());
			//订单金额
			if(statisticType == 1){
				sql.append(",sum(orderMas.amount - orderMas.diff_misc_amt) order_amount");
			}
			//订单数量
			if(statisticType == 2){
				sql.append(",count(*) order_num");			
			}
			//商品品种数
			if(statisticType == 3){
				sql.append(",count(stkMas.VENDOR_CAT_C) order_masCat_num");	
			}
		}
		sql.append(" from order_mas orderMas ");
		//统计商品品种数需关联order_item和stk_mas
		if(null != paramMap && paramMap.containsKey("statisticType") && StringUtils.isNotBlank(paramMap.get("statisticType").toString())){
			int statisticType = Integer.parseInt(paramMap.get("statisticType").toString());
			if(statisticType == 3){
				sql.append(" left join order_item orderItem on orderMas.PK_NO = orderItem.MAS_PK_NO");
				sql.append(" left join STK_MAS stkMas on orderItem.STK_C = stkMas.STK_C and stkMas.VENDOR_CAT_C is not null");
			}
		}
		sql.append(" where 1=1 and orderMas.MAS_CODE = 'SALES' and orderMas.STATUS_FLG not in('CLOSE','WAITPAYMENT') and orderMas.internal_flg<>'Y' ");
		if(paramMap.containsKey("userName") && null != paramMap.get("userName")){
			sql.append(" and orderMas.AREA_ID IN (SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id =parent_id"+
						" START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name='"+paramMap.get("userName").toString()+"'))");
		}
		
		if (paramMap.containsKey("startDate") && paramMap.containsKey("endDate")  
				&& StringUtils.isNotBlank(paramMap.get("startDate").toString()) 
				&& StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
			sql.append(" and orderMas.create_date > TO_DATE('"+paramMap.get("startDate").toString()+"','yyyy-mm-dd') and orderMas.create_date < TO_DATE('"+paramMap.get("endDate").toString()+"','yyyy-mm-dd')");
		}
		if(paramMap.containsKey("staTimeType") && StringUtils.isNotBlank(paramMap.get("staTimeType").toString())){
			String staTimeType = paramMap.get("staTimeType").toString();
			if("day".equalsIgnoreCase(staTimeType)){
				sql.append(" group by to_char(orderMas.create_date,'yyyy-mm-dd')");
				sql.append(" order by to_char(orderMas.create_date,'yyyy-mm-dd')");
			}
			if("month".equalsIgnoreCase(staTimeType)){
				sql.append(" group by to_char(orderMas.create_date,'yyyy-mm')");
				sql.append(" order by to_char(orderMas.create_date,'yyyy-mm')");		
			}
			if("week".equalsIgnoreCase(staTimeType)){
				sql.append(" group by to_char(orderMas.create_date,'yyyy-IW')");
				sql.append(" order by to_char(orderMas.create_date,'yyyy-IW')");
			}
		}
		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public Page getOrderCountForOperator(Map<String, Object> paramMap, String username) {
		StringBuilder sql = new StringBuilder(
				"SELECT * FROM (select ba.一级区域 as A1,ba.二级区域 AS A2,ba.三级区域 AS A3 ,count(*) AS COUNT ,sum(om.amount-om.diff_misc_amt)  AS AMT from order_mas om,bi_area_mas ba WHERE om.area_id=ba.id3 and MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y'");
		Map<String, Object> param = new HashMap<String, Object>();
		AreaSetSqlUtil.setSqlAndParam(sql, param, username);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,ba.三级区域 ");
		LinkedHashMap<String, String> orderby = null;
		if (StringUtils.isNotBlank((String) paramMap.get("orderby"))) {
			sql.append("order by " + paramMap.get("orderby").toString() + " " + paramMap.get("sord").toString() + ")");
		} else {
			sql.append("order by 1,2,3)");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public List<Map<String,Object>> getSalerStatisticsMasDetail(Map<String, Object> paramMap) {
		StringBuffer sql = new StringBuffer("select om.sp_name,sc.cat_name as cat_name,sm.name as mas_name,"+
				"sm.plu_c as plu_c,sm.list_price as list_price,sb.name as brand_name,"+
				"count(case when oi.mas_code = 'SALES' then oi.pk_no end)  as sales_num,"+
				"sum(case when oi.mas_code = 'SALES' then oi.net_price else 0 end)  as sales_price,"+
				"count(case when oi.mas_code = 'RETURN' then oi.pk_no end)  as return_num,"+
				"sum(case when oi.mas_code = 'RETURN' then oi.net_price else 0 end)  as return_price,"+
				"om.MAS_NO,to_char(om.MAS_DATE,'yyyy-MM-dd') as mas_date,sm.OLD_CODE,omuser.USER_NAME as order_user_name"+
				" from order_mas om "+
				" left join order_item oi on om.pk_no = oi.mas_pk_no "+
				" left join STK_MAS sm on oi.stk_c = sm.stk_c "+
				" left join STK_BRAND sb on sm.brand_c = sb.brand_c "+
				" left join stk_category sc on sm.cat_id = sc.cat_id "+
				" right join SCUSER s on om.SP_USER_NO=s.USER_NO "+
				" left join SCUSER omuser on om.USER_NO = omuser.USER_NO "+
				" left join MGT_EMPLOYEE me ON me.ACCOUNT_name=s.user_name "+
				"where 1=1");
		Map<String, Object> param = new HashMap<String, Object>();
		if(paramMap != null){
			if (paramMap.containsKey("merchantCode") && StringUtils.isNotBlank(paramMap.get("merchantCode").toString()) ) {
				sql.append(" and me.merchant_code=:merchantCode ");
				param.put("merchantCode", paramMap.get("merchantCode"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())&&
					paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and to_char(om.CREATE_DATE,'yyyy-mm-dd') >=:startDate AND to_char(om.CREATE_DATE,'yyyy-mm-dd') <=:endDate ");
				param.put("startDate", paramMap.get("startDate"));
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by om.sp_name,sm.name,sm.plu_c,sm.list_price,sb.name,sc.cat_name,om.MAS_NO,om.MAS_DATE,sm.OLD_CODE,omuser.USER_NAME order by om.sp_name asc ");
		return super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	
	@Override
	public List<Map<String, Object>> getSOPList(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select to_char(m.MAS_DATE,'yyyy-mm-dd') as mas_date,m.mas_no,cust_code,m.cust_name,m.vendor_code,m.vendor_name,m.source," +
				"m.receiver_mobile,m.receiver_address,m.sp_name,m.misc_pay_amt,s.plu_c,i.stk_c,i.stk_name,i.uom,i.uom_qty,i.list_price,i.net_price,i.qty1,(i.qty1*i.net_price) as deliverPay,s.ref2 from order_mas m," +
				"order_item i,stk_mas s where m.pk_no=i.mas_pk_no and i.stk_c=s.stk_c and m.org_no=m.org_no");
		if (paramMap.containsKey("vendorUserNo") && StringUtils.isNotBlank(paramMap.get("vendorUserNo").toString())) {
			sql.append(" and m.VENDOR_USER_NO=:vendorUserNo");
			param.put("vendorUserNo", paramMap.get("vendorUserNo"));
		}
		if (paramMap.containsKey("beginDate") && StringUtils.isNotBlank(paramMap.get("beginDate").toString())) {
			sql.append(" and to_char(m.MAS_DATE,'yyyy-mm-dd')>=:beginDate");
			param.put("beginDate", paramMap.get("beginDate"));
		}
		if (paramMap.containsKey("overDate") && StringUtils.isNotBlank(paramMap.get("overDate").toString())) {
			sql.append(" and to_char(m.MAS_DATE,'yyyy-mm-dd')<=:overDate");
			param.put("overDate", paramMap.get("overDate"));
		}
		if (paramMap.containsKey("statusFlg") && StringUtils.isNotBlank(paramMap.get("statusFlg").toString())) {
			sql.append(" and m.status_flg =:statusFlg");
			param.put("statusFlg", paramMap.get("statusFlg"));
		}
		if (paramMap.containsKey("subStatus") && StringUtils.isNotBlank(paramMap.get("subStatus").toString())) {
			sql.append(" and m.SUB_STATUS=:subStatus");
			param.put("subStatus", paramMap.get("subStatus"));
		}
		sql.append(" order by m.MAS_NO");
		return (List<Map<String, Object>>) super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
}
