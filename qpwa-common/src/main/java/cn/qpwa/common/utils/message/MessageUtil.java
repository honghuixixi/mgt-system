/**
 * 
 */
package cn.qpwa.common.utils.message;

import cn.qpwa.common.easemob.EaseMobAPI;
import org.apache.log4j.Logger;

import java.util.Map;

/**
 * @author wlw-62
 * 2016年5月16日
 */
public class MessageUtil {
	public static final Logger log = Logger.getLogger(MessageUtil.class);
	
	public static void sendMessage(String sender,String pusherCode,String[] receivers,
			String content,Map<String,String> ext){
		try {
			EaseMobAPI.sendMessage(sender, pusherCode, receivers, content, ext);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	
}
