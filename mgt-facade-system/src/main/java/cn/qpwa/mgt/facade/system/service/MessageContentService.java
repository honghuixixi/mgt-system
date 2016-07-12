package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.mgt.facade.system.entity.MessageContent;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.Map;


/**
 * 消息相关接口
 * 
 * @author hewei
 * @version 1.0
 */
@SuppressWarnings("rawtypes")
public interface MessageContentService {
	/*保存消息*/
	void saveMessage(MessageContent message);
	
	/*标记已读消息*/
	void setMessageAsRead(String owner, BigDecimal pkNo);
	void setMessageAsRead(String owner, Collection<BigDecimal> pkNos);
	
	/*标记删除消息*/
	void delMessage(String owner, BigDecimal pkNo);
	
	/*查询所有消息*/
	PageView findMessageWithOrderPage(Map<String, Object> paramMap, String owner);
	
	/*查询所有消息*/
	PageView findMessagePage(Map<String, Object> paramMap, String owner, int page, int pageSize);

	/*查询单条消息*/
	MessageContent findById(String owner, BigDecimal pkNo);
	
	/*查询未读消息*/
	Page messageNoReadList(String owner); 
	
	/* 发送模板消息*/
	//void sendTempletMessage(boolean isSend,boolean isSave,String busiCode,Map<String, Object> paramMap );
	
	/* 发送模板消息*/
	void sendTempletMessage(Map<String, String> paramMap, Map<String, String> tempMap, Map<String, Object> msgMap);
	
}
