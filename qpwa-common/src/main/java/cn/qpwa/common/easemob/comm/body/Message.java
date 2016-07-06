package cn.qpwa.common.easemob.comm.body;

public class Message {

	private String type;
	private String msg;
	
	public Message(String type, String msg) {
		super();
		this.type = type;
		this.msg = msg;
	}
	
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public String getMsg() {
		return msg;
	}
	public void setMsg(String msg) {
		this.msg = msg;
	}
}
