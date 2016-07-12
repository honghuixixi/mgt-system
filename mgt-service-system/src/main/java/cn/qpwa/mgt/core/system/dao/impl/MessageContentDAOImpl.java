package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MessageContentDAO;
import cn.qpwa.mgt.facade.system.entity.MessageContent;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.util.*;

@Repository("messageDAO")
@SuppressWarnings({ "rawtypes" })
public class MessageContentDAOImpl extends HibernateEntityDao<MessageContent> implements MessageContentDAO {

	@Override
	public void setMessageRead(String owner, BigDecimal pkNo) {
		setMessageRead(owner, Collections.singleton(pkNo));
	}

	@Override
	public void setMessageRead(String owner, Collection<BigDecimal> pkNos) {
		Query query = getSessionFactory().getCurrentSession().createQuery(
				"update MessageContent set readTime=:readTime ,isRead=:isRead where pkNo in(:pkNos) and owner=:owner ");
		query.setParameter("readTime", new Date());
		query.setParameter("owner", owner);
		query.setParameter("isRead", "Y");
		query.setParameterList("pkNos", pkNos);
		query.executeUpdate();
	}
	
	@Override
	public void delMessage(String owner, BigDecimal pkNo) {
		Query query = getSessionFactory().getCurrentSession().createQuery(
				"update MessageContent set isDelete=:isDelete where pkNo =:pkNo and owner=:owner ");
		query.setParameter("owner", owner);
		query.setParameter("isDelete", "Y");
		query.setParameter("pkNo", pkNo);
		query.executeUpdate();
	}


	@Override
	public Page findMessageWithOrderPage(Map<String, Object> paramMap, String owner) {
		StringBuilder sql = new StringBuilder("SELECT mc.*,oi.PRODUCT_THUMBNAIL,oi.PROM_ITEM_PK_NO,oi.STK_C,sc.CRM_MOBILE,om.PK_NO as ORDER_PK_NO");
		sql.append(" from MSG_CONTENT mc left join SCUSER sc on sc.USER_NAME = mc.CREATOR")
		   .append(" left join ORDER_MAS om on mc.BUSI_ID = om.MAS_NO")
		   .append(" left join ORDER_ITEM oi on oi.MAS_PK_NO = om.PK_NO")
		   .append(" where 1=1  and mc.IS_DELETE = 'N' ");
		
		Map<String, Object> param = new HashMap<String, Object>();
		if (null != owner) {
			sql.append(" and mc.OWNER=:owner");
			param.put("owner", owner);
		}
		if (paramMap != null) {
			if (paramMap.containsKey("busiCode") && StringUtils.isNotBlank(paramMap.get("busiCode").toString())) {
				sql.append(" and mc.BUSI_CODE =:busiCode ");
				param.put("busiCode", paramMap.get("busiCode"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and mc.CREATE_DATE>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and mc.CREATE_DATE<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" order by mc.CREATE_DATE desc");
		return super.sqlqueryForpage(sql.toString(), param, null);
	}
	
	@Override
	public Page findMessagePage(Map<String, Object> paramMap, String owner) {
		StringBuilder sql = new StringBuilder("SELECT m.* from MSG_CONTENT m where 1=1 and m.IS_DELETE = 'N' ");
		Map<String, Object> param = new HashMap<String, Object>();
		if (null != owner) {
			sql.append(" and m.owner=:owner");
			param.put("owner", owner);
		}
		if (paramMap != null) {
			if (paramMap.containsKey("busiCode") && StringUtils.isNotBlank(paramMap.get("busiCode").toString())) {
				sql.append(" and m.BUSI_CODE =:busiCode ");
				param.put("busiCode", paramMap.get("busiCode"));
			}
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and m.CREATE_DATE>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and m.CREATE_DATE<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" order by m.CREATE_DATE desc");
		return super.sqlqueryForpage(sql.toString(), param, null);
	}

	@Override
	public Page findMessageNoReadList(String owner) {
		StringBuilder sql = new StringBuilder("SELECT mc.*,oi.PRODUCT_THUMBNAIL,oi.PROM_ITEM_PK_NO,oi.STK_C,sc.CRM_MOBILE");
		sql.append(" from MSG_CONTENT mc left join SCUSER sc on sc.USER_NAME = mc.CREATOR")
		   .append(" left join ORDER_MAS om on mc.BUSI_ID = om.MAS_NO")
		   .append(" left join ORDER_ITEM oi on oi.MAS_PK_NO = om.PK_NO")
		   .append(" where 1=1 and mc.IS_READ = 'N' and mc.IS_DELETE = 'N' ");
		
		Map<String, Object> param = new HashMap<String, Object>();
		if (null != owner) {
			sql.append(" and mc.OWNER=:owner");
			param.put("owner", owner);
		}
		sql.append(" order by mc.CREATE_DATE desc");
		return super.sqlqueryForpage(sql.toString(), param, null);
	}

	@Override
	public List<MessageContent> messageList(String owner,String isRead,String isDelete) {
		return super.findBy(MessageContent.class, new String[]{"owner","isRead","isDelete"}, 
				new Object[]{owner,isRead,isDelete});
	}
	
	
	
}