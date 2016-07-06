package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.SubaccountseqDAO;
import cn.qpwa.mgt.facade.system.entity.Subaccountseq;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;

@Repository("subaccountseqDAO")
public class SubaccountseqDAOImpl extends HibernateEntityDao<Subaccountseq> implements SubaccountseqDAO{

	@Override
	public void deleteByOrderId(String orderId, String changeType,String seqflag) {
		
		Query query = getSession().createQuery("delete from Subaccountseq where orderId=:orderId and changeType=:changeType and seqflag=:seqflag");
		query.setParameter("orderId", orderId);
		query.setParameter("changeType", changeType);
		query.setParameter("seqflag", seqflag);
		query.executeUpdate();
		
	}
	@Override
	public void deleteByWorkDate(String subaccountId, String workdate) {
		
		Query query = getSession().createQuery("delete from Subaccountseq where subaccountId=:subaccountId and workdate=:workdate ");
		query.setParameter("subaccountId", subaccountId);
		query.setParameter("workdate", workdate);
		query.executeUpdate();
		
	}
	@Override
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select t.* from SUBACCOUNTSEQ t   where 1=1");
		if (null != paramMap) {

			if (paramMap.containsKey("refAccountName") && StringUtils.isNotBlank(paramMap.get("refAccountName").toString())) {
				sql.append(" and t.REF_ACCOUNT_NAME like :refAccountName");
				param.put("refAccountName", "%" + paramMap.get("refAccountName") + "%");
			}
			if (paramMap.containsKey("refAccountCode") && StringUtils.isNotBlank(paramMap.get("refAccountCode").toString())) {
				sql.append(" and t.REF_ACCOUNT_CODE=:refAccountCode");
				param.put("refAccountCode", paramMap.get("refAccountCode"));
			}
			if (paramMap.containsKey("subaccountId") && StringUtils.isNotBlank(paramMap.get("subaccountId").toString())) {
				sql.append(" and t.SUBACCOUNT_ID=:subaccountId");
				param.put("subaccountId", paramMap.get("subaccountId"));
			}
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and t.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
			if (paramMap.containsKey("custName") && StringUtils.isNotBlank(paramMap.get("custName").toString())) {
				sql.append(" and t.CUST_NAME like '%"+paramMap.get("custName").toString()+"%'");
			}
			if (paramMap.containsKey("subaccountType") && StringUtils.isNotBlank(paramMap.get("subaccountType").toString())) {
				sql.append(" and t.SUBACCOUNT_TYPE=:subaccountType");
				param.put("subaccountType", paramMap.get("subaccountType"));
			}
			if (paramMap.containsKey("seqflag") && StringUtils.isNotBlank(paramMap.get("seqflag").toString())) {
				sql.append(" and t.SEQFLAG=:seqflag");
				param.put("seqflag", paramMap.get("seqflag"));
			}
			if (paramMap.containsKey("minamount") && StringUtils.isNotBlank(paramMap.get("minamount").toString())) {
				sql.append(" and (case WHEN t.SEQFLAG='0' then AMOUNT-PREAMOUNT else PREAMOUNT-AMOUNT end  )>=:minamount");
				param.put("minamount", paramMap.get("minamount"));
			}
			
			if (paramMap.containsKey("maxamount") && StringUtils.isNotBlank(paramMap.get("maxamount").toString())) {
				sql.append(" and (case WHEN t.SEQFLAG='0' then AMOUNT-PREAMOUNT else PREAMOUNT-AMOUNT end  )<=:maxamount");
				param.put("maxamount", paramMap.get("maxamount"));
			}

			if (paramMap.containsKey("workdate") && StringUtils.isNotBlank(paramMap.get("workdate").toString())) {
				SimpleDateFormat dft = new SimpleDateFormat("yyyyMMdd");
				Date beginDate = new Date();
				Calendar date = Calendar.getInstance();
				date.setTime(beginDate);
				date.set(Calendar.DATE, date.get(Calendar.DATE) - Integer.parseInt(paramMap.get("workdate").toString()));
				String dateStr = dft.format(date.getTime());
				sql.append(" AND TO_DATE(WORKDATE, 'yyyyMMdd')>=TO_DATE(:startWorkDate,'yyyyMMdd') and  TO_DATE(WORKDATE, 'yyyyMMdd')<=TO_DATE(:endWorkDate,'yyyyMMdd')");
				param.put("startWorkDate", dateStr);
				param.put("endWorkDate", dft.format(new Date()));
			}
			
			
			if (paramMap.containsKey("changeTypes") && StringUtils.isNotBlank(paramMap.get("changeTypes").toString())) {
				String[] changeTypes = StringUtils.split(paramMap.get("changeTypes").toString(), ",");
				sql.append(" AND CHANGE_TYPE in(:changeTypes)");
				param.put("changeTypes", changeTypes);
			}
			
			if(paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" AND TO_DATE(WORKDATE, 'yyyyMMdd')>=TO_DATE(:startDate,'yyyy-MM-dd') ");
					param.put("startDate",  paramMap.get("startDate").toString());
			}
			if(paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" AND  TO_DATE(WORKDATE, 'yyyyMMdd')<=TO_DATE(:endDate,'yyyy-MM-dd')");
					param.put("endDate", paramMap.get("endDate").toString());
			}
			
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
		 
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}else{
			//排序规则:交易日期+流水号 倒序排序
			orderby = new LinkedHashMap<String,String>();
			orderby.put("WORKDATE", "DESC");
			orderby.put("SN", "DESC");

		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	/**
	 * 根据用户查询用户的账户余额和已经消费的金额
	 * @author: lj
	 * @param userName
	 * @return
	 * @date : 2015-11-5上午11:02:03
	 */
	@Override
	public Map<String, String> querySubaccountByUser(String userName) {
		StringBuilder sql = new StringBuilder(
				"select T1.AMOUNT, " +
				"(select nvl(sum(PREAMOUNT - AMOUNT), 0) from SUBACCOUNTSEQ T2 where CHANGE_TYPE = '02' and T2.CUST_ID = T1.CUST_ID) as CONSUMPTION_AMOUNT, " +
				" POINTS, " +
				"(select nvl(sum(PTS_AMOUNT), 0) from USER_PTS_DETAIL T3 where PTS_TRANS_TYPE = 'A' and T3.USER_NAME = T1.CUST_ID) as CONSUMPTION_POINTS " +
				"from SUBACCOUNT T1 " +
				"where T1.CUST_ID = ?");
		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
		return (Map<String, String>) query.setString(0, userName).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public Page querySubaccountByPage(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select " +
				"se.CHANGE_TYPE, se.CUST_ID, se.NOTE, se.ORDERID, to_char(se.CREATE_TIME,'YYYY-MM-DD HH24:MI:SS')as CREATE_TIME, se.PREAMOUNT, se.AMOUNT, se.SEQFLAG, " +
				"(CASE se.SEQFLAG WHEN '1' THEN nvl(se.PREAMOUNT,0) - nvl(se.AMOUNT, 0) ELSE nvl(se.AMOUNT, 0) - nvl(se.PREAMOUNT,0) END)as SALE_AMOUNT " +
				"from SUBACCOUNTSEQ se ,SUBACCOUNT s where SE.SUBACCOUNT_ID = s.ID and s.SUBACCOUNT_TYPE = '9001' ");
				
		if (null != paramMap) {
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString())) {
				sql.append(" and  s.CUST_ID=:userName");
				param.put("userName", paramMap.get("userName"));
			}
			
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				if ("0".equals(paramMap.get("status").toString())) {
					sql.append(" and se.CREATE_TIME>add_months(sysdate,-3)");
				}else if ("1".equals(paramMap.get("status").toString())) {
					sql.append(" and se.CREATE_TIME<add_months(sysdate,-3)");
				}
			}
		}
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("se.CREATE_TIME", "DESC");
		Page page = super.sqlqueryForpage(sql.toString(), param, orderby);
		return page;
	}
	@Override
	public Map<String, Object> countTranAmount(Map<String, Object> paramMap) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select nvl(sum(decode(SEQFLAG,'0', AMOUNT-PREAMOUNT,0)),0) as INCOME ,nvl(sum(decode(SEQFLAG,'1', PREAMOUNT-AMOUNT,0)),0) as EXPENDITURE  from SUBACCOUNTSEQ t   where 1=1");
		if (null != paramMap) {

			if (paramMap.containsKey("refAccountName") && StringUtils.isNotBlank(paramMap.get("refAccountName").toString())) {
				sql.append(" and t.REF_ACCOUNT_NAME like :refAccountName");
				param.put("refAccountName", "%" + paramMap.get("refAccountName") + "%");
			}
			if (paramMap.containsKey("refAccountCode") && StringUtils.isNotBlank(paramMap.get("refAccountCode").toString())) {
				sql.append(" and t.REF_ACCOUNT_CODE=:refAccountCode");
				param.put("refAccountCode", paramMap.get("refAccountCode"));
			}
			if (paramMap.containsKey("subaccountId") && StringUtils.isNotBlank(paramMap.get("subaccountId").toString())) {
				sql.append(" and t.SUBACCOUNT_ID=:subaccountId");
				param.put("subaccountId", paramMap.get("subaccountId"));
			}
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and t.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
			if (paramMap.containsKey("subaccountType") && StringUtils.isNotBlank(paramMap.get("subaccountType").toString())) {
				sql.append(" and t.SUBACCOUNT_TYPE=:subaccountType");
				param.put("subaccountType", paramMap.get("subaccountType"));
			}
			if (paramMap.containsKey("seqflag") && StringUtils.isNotBlank(paramMap.get("seqflag").toString())) {
				sql.append(" and t.SEQFLAG=:seqflag");
				param.put("seqflag", paramMap.get("seqflag"));
			}
			if (paramMap.containsKey("minamount") && StringUtils.isNotBlank(paramMap.get("minamount").toString())) {
				sql.append(" and (case WHEN t.SEQFLAG='0' then AMOUNT-PREAMOUNT else PREAMOUNT-AMOUNT end  )>=:minamount");
				param.put("minamount", paramMap.get("minamount"));
			}
			
			if (paramMap.containsKey("maxamount") && StringUtils.isNotBlank(paramMap.get("maxamount").toString())) {
				sql.append(" and (case WHEN t.SEQFLAG='0' then AMOUNT-PREAMOUNT else PREAMOUNT-AMOUNT end  )<=:maxamount");
				param.put("maxamount", paramMap.get("maxamount"));
			}

			if (paramMap.containsKey("workdate") && StringUtils.isNotBlank(paramMap.get("workdate").toString())) {
				SimpleDateFormat dft = new SimpleDateFormat("yyyyMMdd");
				Date beginDate = new Date();
				Calendar date = Calendar.getInstance();
				date.setTime(beginDate);
				date.set(Calendar.DATE, date.get(Calendar.DATE) - Integer.parseInt(paramMap.get("workdate").toString()));
				String dateStr = dft.format(date.getTime());
				sql.append(" AND TO_DATE(WORKDATE, 'yyyyMMdd')>=TO_DATE(:startWorkDate,'yyyyMMdd') and  TO_DATE(WORKDATE, 'yyyyMMdd')<=TO_DATE(:endWorkDate,'yyyyMMdd')");
				param.put("startWorkDate", dateStr);
				param.put("endWorkDate", dft.format(new Date()));
			}
			
			
			if (paramMap.containsKey("changeTypes") && StringUtils.isNotBlank(paramMap.get("changeTypes").toString())) {
				String[] changeTypes = StringUtils.split(paramMap.get("changeTypes").toString(), ",");
				sql.append(" AND CHANGE_TYPE in(:changeTypes)");
				param.put("changeTypes", changeTypes);
			}
			
			if(paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				sql.append(" AND  t.CREATE_TIME >=:startDate");
				try {
					param.put("startDate", sdf.parse(paramMap.get("startDate").toString()+" 00:00:00"));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			if(paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
				sql.append(" AND  t.CREATE_TIME <=:endDate");
				try {
					param.put("endDate", sdf.parse(paramMap.get("endDate").toString()+" 23:59:59"));
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
			
		}
	 
		return super.sqlqueryForMap(sql.toString(), param);
	}
	
	public Page queryDetails(Map<String, Object> paramMap,
		LinkedHashMap<String, String> orderby) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select se.WORKDATE, se.CHANGE_TYPE, se.REFSN, se.CUST_ID, se.NOTE, se.ORDERID, to_char(se.CREATE_TIME,'YYYY-MM-DD HH24:MI:SS')as CREATE_TIME, se.PREAMOUNT, se.AMOUNT, se.SEQFLAG, " +
				"(CASE se.SEQFLAG WHEN '1' THEN nvl(se.PREAMOUNT,0) - nvl(se.AMOUNT, 0) ELSE nvl(se.AMOUNT, 0) - nvl(se.PREAMOUNT,0) END)as SALE_AMOUNT, " +
				"se.REF_ACCOUNT_CODE,se.REF_ACCOUNT_NAME from subaccount s, subaccountseq se where se.subaccount_id=s.id and s.subaccount_type='9001' ");
		if (null != paramMap) {

			if (paramMap.containsKey("refAccountName") && StringUtils.isNotBlank(paramMap.get("refAccountName").toString())) {
				sql.append(" and se.REF_ACCOUNT_NAME like :refAccountName");
				param.put("refAccountName", "%" + paramMap.get("refAccountName") + "%");
			}
			if (paramMap.containsKey("refAccountCode") && StringUtils.isNotBlank(paramMap.get("refAccountCode").toString())) {
				sql.append(" and se.REF_ACCOUNT_CODE=:refAccountCode");
				param.put("refAccountCode", paramMap.get("refAccountCode"));
			}
			if (paramMap.containsKey("subaccountId") && StringUtils.isNotBlank(paramMap.get("subaccountId").toString())) {
				sql.append(" and se.SUBACCOUNT_ID=:subaccountId");
				param.put("subaccountId", paramMap.get("subaccountId"));
			}
			if (paramMap.containsKey("custId") && StringUtils.isNotBlank(paramMap.get("custId").toString())) {
				sql.append(" and se.CUST_ID=:custId");
				param.put("custId", paramMap.get("custId"));
			}
			if (paramMap.containsKey("subaccountType") && StringUtils.isNotBlank(paramMap.get("subaccountType").toString())) {
				sql.append(" and se.SUBACCOUNT_TYPE=:subaccountType");
				param.put("subaccountType", paramMap.get("subaccountType"));
			}
			if (paramMap.containsKey("seqflag") && StringUtils.isNotBlank(paramMap.get("seqflag").toString())) {
				sql.append(" and se.SEQFLAG=:seqflag");
				param.put("seqflag", paramMap.get("seqflag"));
			}
			if (paramMap.containsKey("minamount") && StringUtils.isNotBlank(paramMap.get("minamount").toString())) {
				sql.append(" and (case WHEN se.SEQFLAG='0' then se.AMOUNT-PREAMOUNT else se.PREAMOUNT-AMOUNT end  )>=:minamount");
				param.put("minamount", paramMap.get("minamount"));
			}
			
			if (paramMap.containsKey("maxamount") && StringUtils.isNotBlank(paramMap.get("maxamount").toString())) {
				sql.append(" and (case WHEN se.SEQFLAG='0' then AMOUNT-PREAMOUNT else PREAMOUNT-AMOUNT end  )<=:maxamount");
				param.put("maxamount", paramMap.get("maxamount"));
			}

			if (paramMap.containsKey("workdate") && StringUtils.isNotBlank(paramMap.get("workdate").toString())) {
				SimpleDateFormat dft = new SimpleDateFormat("yyyyMMdd");
				Date beginDate = new Date();
				Calendar date = Calendar.getInstance();
				date.setTime(beginDate);
				date.set(Calendar.DATE, date.get(Calendar.DATE) - Integer.parseInt(paramMap.get("workdate").toString()));
				String dateStr = dft.format(date.getTime());
				sql.append(" AND TO_DATE(WORKDATE, 'yyyyMMdd')>=TO_DATE(:startWorkDate,'yyyyMMdd') and  TO_DATE(WORKDATE, 'yyyyMMdd')<=TO_DATE(:endWorkDate,'yyyyMMdd')");
				param.put("startWorkDate", dateStr);
				param.put("endWorkDate", dft.format(new Date()));
			}
			
			
			if (paramMap.containsKey("changeTypes") && StringUtils.isNotBlank(paramMap.get("changeTypes").toString())) {
				String[] changeTypes = StringUtils.split(paramMap.get("changeTypes").toString(), ",");
				sql.append(" AND CHANGE_TYPE in(:changeTypes)");
				param.put("changeTypes", changeTypes);
			}
			
			if(paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" AND TO_DATE(WORKDATE, 'yyyyMMdd')>=TO_DATE(:startDate,'yyyy-MM-dd') ");
					param.put("startDate",  paramMap.get("startDate").toString());
			}
			if(paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" AND  TO_DATE(WORKDATE, 'yyyyMMdd')<=TO_DATE(:endDate,'yyyy-MM-dd')");
					param.put("endDate", paramMap.get("endDate").toString());
			}
			
		}
		if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
			orderby = new LinkedHashMap<String, String>();
		 
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
		}else{
			orderby = new LinkedHashMap<String, String>();
			orderby.put("se.WORKDATE", "DESC");

		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

}
