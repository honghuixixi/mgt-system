package cn.qpwa.common.utils.payment;

public enum UnionpayProductType {
	
	b2b("898111449000321","000202","07"),wap("898111448120129","000201","08"),b2c("898111448120120","000201","07");
	/** 商户号*/
	private String merId;
	/** 产品类型*/
	private String bizType;
	/** 移动(08)或者网面(07)*/
	private String channelType;
	
	UnionpayProductType(String merId,String bizType,String channelType){
		this.bizType = bizType;
		this.merId = merId;
		this.channelType = channelType;
	}
	public String getMerId() {
		return merId;
	}
	public void setMerId(String merId) {
		this.merId = merId;
	}
	public String getBizType() {
		return bizType;
	}
	public void setBizType(String bizType) {
		this.bizType = bizType;
	}
	public String getChannelType() {
		return channelType;
	}
	public void setChannelType(String channelType) {
		this.channelType = channelType;
	}
}
