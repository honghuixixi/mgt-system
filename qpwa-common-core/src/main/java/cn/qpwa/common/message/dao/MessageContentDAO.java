package cn.qpwa.common.message.dao;

import cn.qpwa.common.entity.MessageContent;
import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;

import java.math.BigDecimal;
import java.util.Collection;
import java.util.List;
import java.util.Map;

/**
 * 消息数据操作接口
 * 
 * @author TheDragonLord
 */
@SuppressWarnings("rawtypes")
public interface MessageContentDAO extends EntityDao<MessageContent> {
	
	/**
	 * 设置消息已经被读取
	 */
	void setMessageRead(String owner, Collection<BigDecimal> pkNos);
	void setMessageRead(String owner, BigDecimal pkNo);
	
	/**
	 * 设置消息已经被删除
	 */
	void delMessage(String owner, BigDecimal pkNo);

	/**
	 * 分页查询用户所有消息
	 */
	Page findMessageWithOrderPage(Map<String, Object> paramMap, String owner);
	
	/**
	 * 分页查询用户消息
	 */
	Page findMessagePage(Map<String, Object> paramMap, String owner);
	
	/**
	 * 分页查询用户未读消息
	 */
	Page findMessageNoReadList(String owner);
	
	/** 
	 * 查询用户所有未读消息
	 */
	 
	List<MessageContent> messageList(String owner, String isRead, String isDelete);
	
}