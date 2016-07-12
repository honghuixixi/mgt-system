package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.easemob.comm.constant.PusherType;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.message.MessageUtil;
import cn.qpwa.mgt.core.system.dao.MessageContentDAO;
import cn.qpwa.mgt.core.system.dao.MgtEmployeeDao;
import cn.qpwa.mgt.core.system.dao.MsgTempletDAO;
import cn.qpwa.mgt.facade.system.entity.MessageContent;
import cn.qpwa.mgt.facade.system.entity.MgtEmployee;
import cn.qpwa.mgt.facade.system.entity.MsgTemplet;
import cn.qpwa.mgt.facade.system.service.MessageContentService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

@Service("messageContentService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
@SuppressWarnings("all")
public class MessageContentServiceImpl implements MessageContentService {
	private static final String SESSION_USER_PARAM = "user";
	
	@Autowired
	private MessageContentDAO messageDAO;
	
	@Autowired
	private MsgTempletDAO msgTempletDAO;
	
	@Autowired
	private MgtEmployeeDao employeeDao;

	@Override
	public void saveMessage(MessageContent message) {
		if (null != message) {
			message.setReadTime(null);
			messageDAO.save(message);
		}
	}

	@Override
	public void setMessageAsRead(String owner, BigDecimal pkNo) {
		if (null != pkNo) {
			messageDAO.setMessageRead(owner,pkNo);
		}
	}
	
	@Override
	public void setMessageAsRead(String owner, Collection<BigDecimal> pkNos) {
		if (null != pkNos && pkNos.size() > 0) {
			messageDAO.setMessageRead(owner,pkNos);
		}
	}

	@Override
	public void delMessage(String owner,BigDecimal pkNo) {
		messageDAO.delMessage(owner,pkNo);
	}
	
	@Override
	public PageView findMessageWithOrderPage(Map<String, Object> paramMap, String owner) {
		Page recPage = messageDAO.findMessageWithOrderPage(paramMap, owner);
		if(null == recPage.getItems()|| recPage.getItems().size() == 0){
			if(SystemContext.getOffset().intValue() > 1){
				SystemContext.setOffset(SystemContext.getOffset().intValue() - 1);
				recPage = messageDAO.findMessageWithOrderPage(paramMap, owner);
			}
		}
		List<MessageContent> list = messageDAO.messageList(owner, "N", "N");
		for(MessageContent map: list){
			messageDAO.setMessageRead(owner,map.getPkNo());
		}
		PageView result = new PageView(SystemContext.getPagesize(),SystemContext.getOffset());
		result.setQueryResult(recPage);
		return result;
	}
	
	@Override
	public PageView findMessagePage(Map<String, Object> paramMap, String owner, int page, int pageSize) {
		SystemContext.setOffset(page);
		SystemContext.setPagesize(pageSize);
		Page recPage = messageDAO.findMessagePage(paramMap,owner);
		PageView result = new PageView(pageSize, page);
		result.setQueryResult(recPage);
		return result;
	}
	
	@Override
	public MessageContent findById(String owner, BigDecimal pkNo) {
		MessageContent messageContent = messageDAO.findUniqueBy(MessageContent.class, new String[] { "owner", "pkNo" },
				new Object[] { owner, pkNo });
		if(null != messageContent && null == messageContent.getReadTime()){
			setMessageAsRead(owner, pkNo);
		}
		return messageContent;
	}
	
	@Override
	public Page messageNoReadList(String owner) {
		return messageDAO.findMessageNoReadList(owner);
	}
	
	@Override
	public void sendTempletMessage(Map<String, String> paramMap, Map<String, String> tempMap,
			Map<String, Object> msgMap) {
		if(tempMap.containsKey("busiCode") && null != tempMap.get("busiCode") && null != msgMap){
			/*组装消息体*/
			MsgTemplet msgTemplet = msgTempletDAO.findMsgTempletByBusiCode(tempMap.get("busiCode"));
			if(null != msgTemplet){
				//通过模板组装消息体
				try {
					String content = buildMessageBody(tempMap,msgTemplet.getContent());
					if(null != content){
						msgMap.put("content", content);
						//发送给买家
						if(paramMap.containsKey("toBuyer") && "Y".equals(paramMap.get("toBuyer"))){
							String[] receivers = {msgMap.get("owner").toString()};
							sendMessage(paramMap,msgMap,receivers);
						}
						//发送给供应商
				        if(paramMap.containsKey("toVendor") && "Y".equals(paramMap.get("toVendor"))){
				        	String[] receivers = {msgMap.get("owner").toString()};
							sendMessage(paramMap,msgMap,receivers);
						}
						//发送给业务员
				        if(paramMap.containsKey("toStaff") && "Y".equals(paramMap.get("toStaff"))){
				        	List<BigDecimal> merchantCodes = new ArrayList<BigDecimal>();
				        	merchantCodes.add( new BigDecimal(msgMap.get("ownerId").toString()) );
				        	List<MgtEmployee> list = employeeDao.findEmployeeByMerchantCode(merchantCodes);
				        	if(null != list && list.size() > 0){
				        		String[] receivers = new String[list.size()];
					        	for(int i=0;i<list.size();i++){
					        		if( "Y".equals(list.get(i).getSalesmenFlg()))
					        			receivers[i]= list.get(i).getAccountName();
					        	}
					        	sendMessage(paramMap,msgMap,receivers);
				        	}
						}
						//发送给配送员
				        if(paramMap.containsKey("toDistribut") && "Y".equals(paramMap.get("toDistribut"))){
				        	String[] receivers = {msgMap.get("owner").toString()};
							sendMessage(paramMap,msgMap,receivers);
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
	}
	
	//发送消息
	void sendMessage(Map<String, String> paramMap,Map<String, Object> msgMap,String[] receivers) throws Exception{
		//站内信
		if(paramMap.containsKey("isMail")&& "Y".equals(paramMap.get("isMail"))){
			for(int i=0;i<receivers.length;i++){
				/*组装消息*/
				MessageContent message = buildMessageContent(msgMap);
				message.setOwner(receivers[i]);
				message.setCreator(message.getSender());
				message.setCreateDate(new Date());
				message.setIsRead("N");
				message.setIsDelete("N");
				saveMessage(message);//保存消息
			}
		}
		//即时通讯-APP推送
		if( paramMap.containsKey("isInstant") || paramMap.containsKey("isAppPush") ){
			String sender = "Y".equals(paramMap.get("isInstant"))? msgMap.get("sender").toString():null;
			String pusher = null;
			if("Y".equals(paramMap.get("isAppPush"))){
				String busiType = msgMap.get("busiType").toString();
				if("SYS_WL".equals(busiType)|| "SYS_DD".equals(busiType))
					pusher = PusherType.LOGISTICS.getCode();
				else if("SYS_TZ".equals(busiType))
					pusher = PusherType.NOTICE.getCode();
				else if("SYS_TX".equals(busiType))
					pusher = PusherType.INSTANT.getCode();
				else if("SYS_HD".equals(busiType))
					pusher = PusherType.ACTIVITY.getCode();
			}
			//链接参数 -- 扩展参数
			Map<String,String> urlParam = new HashMap<String,String>();
			urlParam.put("masNo", msgMap.get("busiId").toString());
			
			MessageUtil.sendMessage(sender,pusher, receivers,msgMap.get("content").toString(),urlParam);
		}
		
	}
	
	/**
	 * 组装消息体
	 * @author lifangpeng    
	 * @return MessageContent   
	 */
	public MessageContent buildMessageContent(Map<String, Object> paramMap){
		if(null == paramMap) return null;
		MessageContent message = new MessageContent();
		if(paramMap.containsKey("pkNo") && null != paramMap.get("pkNo") 
				&& StringUtils.isNotBlank(paramMap.get("pkNo").toString())){
			message.setPkNo(new BigDecimal( paramMap.get("pkNo").toString()));
		}
		if(paramMap.containsKey("title") && null != paramMap.get("title") 
				&& StringUtils.isNotBlank(paramMap.get("title").toString())){
			message.setTitle(paramMap.get("title").toString());
		}
		if(paramMap.containsKey("content") && null != paramMap.get("content") 
				&& StringUtils.isNotBlank(paramMap.get("content").toString())){
			message.setContent(paramMap.get("content").toString());
		}
		if(paramMap.containsKey("source") && null != paramMap.get("source") 
				&& StringUtils.isNotBlank(paramMap.get("source").toString())){
			message.setSource(paramMap.get("source").toString());
		}
		if(paramMap.containsKey("sourceType") && null != paramMap.get("sourceType") 
				&& StringUtils.isNotBlank(paramMap.get("sourceType").toString())){
			message.setSourceType(paramMap.get("sourceType").toString());
		}
		if(paramMap.containsKey("system") && null != paramMap.get("system") 
				&& StringUtils.isNotBlank(paramMap.get("system").toString())){
			message.setSystem(paramMap.get("system").toString());
		}
		if(paramMap.containsKey("sender") && null != paramMap.get("sender") 
				&& StringUtils.isNotBlank(paramMap.get("sender").toString())){
			message.setSender(paramMap.get("sender").toString());
		}
		if(paramMap.containsKey("receiver") && null != paramMap.get("receiver") 
				&& StringUtils.isNotBlank(paramMap.get("receiver").toString())){
			message.setReceiver(paramMap.get("receiver").toString());
		}
		if(paramMap.containsKey("sendType") && null != paramMap.get("sendType") 
				&& StringUtils.isNotBlank(paramMap.get("sendType").toString())){
			message.setSendType(paramMap.get("sendType").toString());
		}
		if(paramMap.containsKey("busiType") && null != paramMap.get("busiType") 
				&& StringUtils.isNotBlank(paramMap.get("busiType").toString())){
			message.setBusiType(paramMap.get("busiType").toString());
		}
		if(paramMap.containsKey("busiId") && null != paramMap.get("busiId") 
				&& StringUtils.isNotBlank(paramMap.get("busiId").toString())){
			message.setBusiId(paramMap.get("busiId").toString());
		}
		
		return message;
	}

	public String buildMessageBody(Map<String, String> tempMap,String tempContent){
		if(null != tempContent && StringUtils.isNotBlank(tempContent)){
			Set set = tempMap.keySet();
			Iterator iterator = set.iterator();
			while(iterator.hasNext()){
				Object key = iterator.next();
				String value = tempMap.get(key)==null?"":tempMap.get(key);
				String regex = "##"+key.toString()+"##";
				if(tempContent.indexOf(regex)>-1)
					tempContent = tempContent.replaceAll(regex, value);
			}
			return tempContent;
		}
		return null;
	}

}
