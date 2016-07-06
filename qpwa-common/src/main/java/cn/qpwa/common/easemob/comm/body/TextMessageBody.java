package cn.qpwa.common.easemob.comm.body;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ContainerNode;
import cn.qpwa.common.easemob.comm.constant.MsgType;

import java.util.Map;

public class TextMessageBody extends MessageBody {
	//private String msg;
	private Message msg;

	public TextMessageBody(String targetType, String[] targets, String from, Map<String, String> ext, String content) {
		super(targetType, targets, from, ext);
		this.msg = new Message(MsgType.TEXT,content);
		//this.msg = msg;
	}

	public Message getMsg() {
		return msg;
	}

    public ContainerNode<?> getBody() {
        if(!isInit()){
            //this.getMsgBody().put("type", MsgType.TEXT);
            //this.getMsgBody().put("msg", this.getMsg());
           
            ObjectMapper mapper = new ObjectMapper();
            JsonNode jsonNode;
			try {
				jsonNode = mapper.readTree(mapper.writeValueAsString(this.getMsg()));
				this.getMsgBody().put("msg",jsonNode);
			} catch (Exception e) {
				e.printStackTrace();
			}
            this.setInit(true);
        }

        return this.getMsgBody();
    }

    public Boolean validate() {
		//return super.validate() && StringUtils.isNotBlank(msg);
    	return false;
	}

}
