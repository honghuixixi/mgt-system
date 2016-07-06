package cn.qpwa.common.easemob.api;

import cn.qpwa.common.easemob.comm.body.*;

/**
 * @author honghui
 * @date 2016年4月29日
 */
public interface SendMessageAPI {

	/**
	 * 发送消息 POST
	 * 
	 * @param payload
	 *            消息体
	 * @return
	 * @see MessageBody
	 * @see TextMessageBody
	 * @see ImgMessageBody
	 * @see AudioMessageBody
	 * @see VideoMessageBody
	 * @see CommandMessageBody
	 */
	Object sendMessage(Object payload);

}
