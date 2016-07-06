package cn.qpwa.common.easemob;

import com.fasterxml.jackson.databind.node.ObjectNode;
import cn.qpwa.common.easemob.api.IMUserAPI;
import cn.qpwa.common.easemob.api.SendMessageAPI;
import cn.qpwa.common.easemob.comm.ClientContext;
import cn.qpwa.common.easemob.comm.EasemobRestAPIFactory;
import cn.qpwa.common.easemob.comm.body.IMUserBody;
import cn.qpwa.common.easemob.comm.body.IMUsersBody;
import cn.qpwa.common.easemob.comm.body.TextMessageBody;
import cn.qpwa.common.easemob.comm.constant.HttpCode;
import cn.qpwa.common.easemob.comm.constant.PusherType;
import cn.qpwa.common.easemob.comm.wrapper.BodyWrapper;
import cn.qpwa.common.easemob.comm.wrapper.ResponseWrapper;
import cn.qpwa.common.utils.Msg;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * @author honghui
 * @date   2016年5月4日
 */
public class EaseMobAPI {

	private static final Logger log = LoggerFactory.getLogger(EaseMobAPI.class);
	
	
	private static EasemobRestAPIFactory factory = ClientContext.getInstance().init(ClientContext.INIT_FROM_PROPERTIES).getAPIFactory();
	private static IMUserAPI user = (IMUserAPI)factory.newInstance(EasemobRestAPIFactory.USER_CLASS);
	//private static ChatMessageAPI chat = (ChatMessageAPI)factory.newInstance(EasemobRestAPIFactory.MESSAGE_CLASS);
	//private static FileAPI file = (FileAPI)factory.newInstance(EasemobRestAPIFactory.FILE_CLASS);
	private static SendMessageAPI message = (SendMessageAPI)factory.newInstance(EasemobRestAPIFactory.SEND_MESSAGE_CLASS);
	//private static ChatGroupAPI chatgroup = (ChatGroupAPI)factory.newInstance(EasemobRestAPIFactory.CHATGROUP_CLASS);
	//private static ChatRoomAPI chatroom = (ChatRoomAPI)factory.newInstance(EasemobRestAPIFactory.CHATROOM_CLASS);
	
	/**s
	 * 注册单个用户
	 * @param username  用户名
	 * @param password  密码
	 * @param nickname  昵称
	 * @return true|false 注册成功|注册失败 
	 */
	public static boolean register(String username,String password,String nickname){
		try {
			ResponseWrapper responseWrapper = (ResponseWrapper) user.createNewIMUserSingle(new IMUserBody(username, password, nickname));
			if (!responseWrapper.getResponseStatus().equals(HttpCode.SUCCESS.getCode())) {
				String uuid = ((ObjectNode) responseWrapper.getResponseBody()).get("entities").get(0).get("uuid")
						.asText();
				if (StringUtils.isNotBlank(uuid)) {
					return true;
				}
			} 
		} catch (Exception e) {
			//todo
		}
		return false;
	}
	
	/**
	 * 批量注册用户
	 * @param users
	 * @return
	 */
	public static Object registerBatch(BodyWrapper users){
		return user.createNewIMUserBatch(users);
	}
	
	/**
	 * 获取用户离线消息数
	 * @param username 用户名
	 * @return 离线消息数
	 */
	public static Integer getOfflineMsgCount(String username){
		int offLineMsgCount = 0;
		try {
			ResponseWrapper responseWrapper = (ResponseWrapper) user.getOfflineMsgCount(username);
			offLineMsgCount = ((ObjectNode) responseWrapper.getResponseBody()).get("data").get(username).asInt();
		} catch (Exception e) {
		}
		return offLineMsgCount;
	}
	
	/**
	 * 获取单个用户
	 * @param userName  用户名
	 * @return          用户uuid
	 */
	public static String getIMUsersByUserName(String userName){
		ResponseWrapper response = (ResponseWrapper)user.getIMUsersByUserName(userName);
		if(null != response && !response.getResponseStatus().equals(HttpCode.NOT_FOUND.getCode())){
			ObjectNode node = (ObjectNode)response.getResponseBody();
			return node.get("entities").get(0).get("uuid").asText();
		}
		return null;
	} 
	
	/**
	 * 添加好友
	 * @param userName
	 * @param friendName
	 * @return
	 */
	public static boolean addFriend(String userName,String friendName){
		ResponseWrapper response = (ResponseWrapper)user.addFriendSingle(userName, friendName);
		if(null != response && response.getResponseStatus().equals(HttpCode.SUCCESS.getCode())){
			ObjectNode node = (ObjectNode)response.getResponseBody();
			String uuid = node.get("entities").get(0).get("uuid").asText();
			if(StringUtils.isNotBlank(uuid)){
				return true;
			}
		}
		return false;
	}
	
	
	/**
	 * 消息即使通讯与消息推送
	 * @param sender      即时通讯发送者账号
	 * @param pusherCode  消息推送类型  101-物流服务,102-通知消息,103-即时通讯,104-物恋活动 
	 * @param receivers   接收者账户
	 * @param conent      消息内容
	 * @param ext         扩展参数
	 * @return
	 */
	public static Msg sendMessage(String sender,String pusherCode,String[] receivers,String content,
			Map<String,String> ext){
		Msg msg = new Msg();
		try {
			//1-注册消息接收者
			List<String[]> receiverList = null;
			if (null != receivers && receivers.length > 0) {
				List<IMUserBody> users = new ArrayList<IMUserBody>();
				for (String username : receivers) {
					IMUserBody userBody = new IMUserBody(username, username, "");
					users.add(userBody);
				}
				BodyWrapper usersBody = new IMUsersBody(users);
				registerBatch(usersBody);
				receiverList = split(receivers, 30);
			}
			//2-消息推送
			if (StringUtils.isNotBlank(pusherCode)) {
				//注册消息推送者
				String pusherName = PusherType.getUsername(pusherCode);
				BodyWrapper userBody = new IMUserBody(pusherName, pusherName, "");
				user.createNewIMUserSingle(userBody);
				//register(pusherName, pusherName, "");
				for (String[] receiverItems : receiverList) {
					TextMessageBody messageBody = new TextMessageBody("users", receiverItems, pusherName, ext, content);
					message.sendMessage(messageBody);
				}

			}
			//3-即时通讯
			if (StringUtils.isNotBlank(sender)) {
				//boolean registerFlg = register(sender, sender, "");
				BodyWrapper userBody = new IMUserBody(sender, sender, "");
				user.createNewIMUserSingle(userBody);
				for (String[] receiverItems : receiverList) {
					TextMessageBody messageBody = new TextMessageBody("users", receiverItems, sender, ext, content);
					message.sendMessage(messageBody);
				}
			} 
			msg.setSuccess(true);
		} catch (Exception e) {
			e.printStackTrace();
			msg.setSuccess(false);
			msg.setMsg("系统异常");
		}
		return msg;
	}
	
	/**
	 * 用户在线状态
	 * @param userName
	 * @return
	 */
	public static boolean onlineStatus(String userName){
		ResponseWrapper response = (ResponseWrapper)user.getIMUserStatus(userName);
		if(null != response && response.getResponseStatus().equals(HttpCode.SUCCESS.getCode())){
			ObjectNode node = (ObjectNode)response.getResponseBody();
			String status = node.get("data").get(userName).asText();
			if("offline".equals(status)){
				return false;
			}else{
				return true;
			}
		}
		return false;
	}
	
	public static List<String[]> split(String[] receivers,int count){
		if(receivers == null || count < 1){
		      return  null ;
		}
		List<String[]> ret = new ArrayList<String[]>();
		int size=receivers.length;
	    if(size <= count){    //数据量不足count指定的大小
	         ret.add(receivers);
	    }else{
			  int pre=size/count;
			  int last=size%count;
			  //前面pre个集合，每个大小都是count个元素
			  for(int i=0;i < pre;i++){
			    String[] itemList = new String[pre];
			    for(int j=0;j<count;j++){
			       itemList[j] = receivers[i*count+j];
			    }
			    ret.add(itemList);
			  }
			  //last的进行处理
			  if(last > 0){
			    String[] itemList = new String[last];
			    for(int i = 0;i < last; i++){
			      itemList[i] = receivers[pre*count+i];
			    }
			    ret.add(itemList);
			  }
	    }
	    return ret;
	}
	
	public static void main(String[] args) {
		//Object o = EaseMobAPI.register("SXWYSMGS", "SXWYSMGS", "绍兴物恋电子商务有限公司");
		//System.out.println(o.toString());
		//String uuid = EaseMobAPI.getIMUsersByUserName("honghui3");
		//System.out.println(uuid == null ? "未找到":uuid);
		/*boolean success = EaseMobAPI.addFriend("honghui", "BJMHJSM");
		System.out.println(success);*/
		
		//Msg msg = EaseMobAPI.sendMessage("honghui", "", new String[]{"BJMHJSM"}, "Hi,My name is honghui,nice to meet you!",null);
		//System.out.println(msg.isSuccess());
		
		//int msgCount = EaseMobAPI.getOfflineMsgCount("BJMHJSM");
		//System.out.println(msgCount);
		//boolean status = EaseMobAPI.onlineStatus("BJMHJSM");
		//System.out.println(status+"===");
		
		//BodyWrapper userBody = new IMUserBody("WLW_SYS_HD", "WLW_SYS_HD", "物恋活动");
		//user.createNewIMUserSingle(userBody);
		
		//消息推送测试
		sendMsg();
	}
	
	
	/**
	 * 消息推送测试
	 */
	public static void sendMsg(){
		for(int i=0; i<5;i++){
			Msg msg1 = EaseMobAPI.sendMessage("", "101", new String[]{"test009","test001"}, "物流服务-消息推送测试消息"+(i+1),null);
			System.out.println(msg1.isSuccess());
			Msg msg2 = EaseMobAPI.sendMessage("", "102", new String[]{"test009","test001"}, "通知消息-消息推送测试消息"+(i+1),null);
			System.out.println(msg2.isSuccess());
			Msg msg3 = EaseMobAPI.sendMessage("", "103", new String[]{"test009","test001"}, "即时通讯-消息推送测试消息"+(i+1),null);
			System.out.println(msg3.isSuccess());
			Msg msg4 = EaseMobAPI.sendMessage("", "104", new String[]{"test009","test001"}, "物恋活动-消息推送测试消息"+(i+1),null);
			System.out.println(msg4.isSuccess());
		}
	}
}
