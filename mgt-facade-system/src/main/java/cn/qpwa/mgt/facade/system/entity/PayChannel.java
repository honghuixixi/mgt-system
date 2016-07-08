package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigDecimal;

/**
 * 渠道管理
 * PayChannel entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "PAY_CHANNEL")
public class PayChannel implements java.io.Serializable {

	private static final long serialVersionUID = -1684314909718562200L;
	/**主键*/
	private String channelId;
	private String channelTypeCode;
	/**商户号*/
	private String merchantNo;
	/**行别*/
	private String channelBankType;
	/**通讯方式*/
	private String linkType;
	/**交易URL*/
	private String url;
	private String ipaddress;
	private BigDecimal port;
	/**队列管理器名*/
	private String omName;
	/**实时接收队列*/
	private String realRecvQ;
	/**实时发送队列*/
	private String realSendQ;
	/**批量接收队列*/
	private String batchRecvQ;
	/**批量发送队列*/
	private String batchSendQ;
	/**冗余参数*/
	private String para;
	/**渠道描述*/
	private String note;
	/**渠道实现类名*/
	private String channelClass;
	/**最大业务并发数*/
	private BigDecimal maxNum;
	/**超时时间设置*/
	private BigDecimal timeOutSec;
	/** 用户名 */
	private String userName;
	/** 区域id */
	private BigDecimal areaId;
	/***/
	private String platformFlg;
	private String channelAccount;
	
	// Constructors

	/** default constructor */
	public PayChannel() {
	}

	/** minimal constructor */
	public PayChannel(String channelId) {
		this.channelId = channelId;
	}

	/** full constructor */
	public PayChannel(String channelId, String channelTypeCode,
					  String merchantNo, String channelBankType, String linkType,
					  String url, String ipaddress, BigDecimal port, String omName,
					  String realRecvQ, String realSendQ, String batchRecvQ,
					  String batchSendQ, String para, String note, String channelClass,
					  BigDecimal maxNum, BigDecimal timeOutSec, BigDecimal areaId,
					  String userName, String platformFlg) {
		this.channelId = channelId;
		this.channelTypeCode = channelTypeCode;
		this.merchantNo = merchantNo;
		this.channelBankType = channelBankType;
		this.linkType = linkType;
		this.url = url;
		this.ipaddress = ipaddress;
		this.port = port;
		this.omName = omName;
		this.realRecvQ = realRecvQ;
		this.realSendQ = realSendQ;
		this.batchRecvQ = batchRecvQ;
		this.batchSendQ = batchSendQ;
		this.para = para;
		this.note = note;
		this.channelClass = channelClass;
		this.maxNum = maxNum;
		this.timeOutSec = timeOutSec;
		this.areaId = areaId;
		this.userName = userName;
		this.platformFlg = platformFlg;
	}

	// Property accessors
	@Id
	@Column(name = "CHANNEL_ID", unique = true, nullable = false, length = 16)
	public String getChannelId() {
		return this.channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	@Column(name = "CHANNEL_TYPE_CODE", length = 3)
	public String getChannelTypeCode() {
		return this.channelTypeCode;
	}

	public void setChannelTypeCode(String channelTypeCode) {
		this.channelTypeCode = channelTypeCode;
	}

	@Column(name = "MERCHANT_NO", length = 20)
	public String getMerchantNo() {
		return this.merchantNo;
	}

	public void setMerchantNo(String merchantNo) {
		this.merchantNo = merchantNo;
	}

	@Column(name = "CHANNEL_BANK_TYPE", length = 7)
	public String getChannelBankType() {
		return this.channelBankType;
	}

	public void setChannelBankType(String channelBankType) {
		this.channelBankType = channelBankType;
	}

	@Column(name = "LINK_TYPE", length = 12)
	public String getLinkType() {
		return this.linkType;
	}

	public void setLinkType(String linkType) {
		this.linkType = linkType;
	}

	@Column(name = "URL", length = 512)
	public String getUrl() {
		return this.url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	@Column(name = "IPADDRESS", length = 20)
	public String getIpaddress() {
		return this.ipaddress;
	}

	public void setIpaddress(String ipaddress) {
		this.ipaddress = ipaddress;
	}

	@Column(name = "PORT", precision = 22, scale = 0)
	public BigDecimal getPort() {
		return port;
	}

	public void setPort(BigDecimal port) {
		this.port = port;
	}

	@Column(name = "OM_NAME", length = 12)
	public String getOmName() {
		return this.omName;
	}

	public void setOmName(String omName) {
		this.omName = omName;
	}

	@Column(name = "REAL_RECV_Q", length = 30)
	public String getRealRecvQ() {
		return this.realRecvQ;
	}

	public void setRealRecvQ(String realRecvQ) {
		this.realRecvQ = realRecvQ;
	}

	@Column(name = "REAL_SEND_Q", length = 30)
	public String getRealSendQ() {
		return this.realSendQ;
	}

	public void setRealSendQ(String realSendQ) {
		this.realSendQ = realSendQ;
	}

	@Column(name = "BATCH_RECV_Q", length = 30)
	public String getBatchRecvQ() {
		return this.batchRecvQ;
	}

	public void setBatchRecvQ(String batchRecvQ) {
		this.batchRecvQ = batchRecvQ;
	}

	@Column(name = "BATCH_SEND_Q", length = 30)
	public String getBatchSendQ() {
		return this.batchSendQ;
	}

	public void setBatchSendQ(String batchSendQ) {
		this.batchSendQ = batchSendQ;
	}

	@Column(name = "PARA", length = 128)
	public String getPara() {
		return this.para;
	}

	public void setPara(String para) {
		this.para = para;
	}

	@Column(name = "NOTE", length = 128)
	public String getNote() {
		return this.note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	@Column(name = "CHANNEL_CLASS", length = 128)
	public String getChannelClass() {
		return this.channelClass;
	}

	public void setChannelClass(String channelClass) {
		this.channelClass = channelClass;
	}

	@Column(name = "MAX_NUM", precision = 22, scale = 0)
	public BigDecimal getMaxNum() {
		return maxNum;
	}

	public void setMaxNum(BigDecimal maxNum) {
		this.maxNum = maxNum;
	}
	
	@Column(name = "TIME_OUT_SEC", precision = 22, scale = 0)
	public BigDecimal getTimeOutSec() {
		return timeOutSec;
	}

	public void setTimeOutSec(BigDecimal timeOutSec) {
		this.timeOutSec = timeOutSec;
	}

	@Column(name = "USER_NAME", length = 20)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "AREA_ID", length = 6)
	public BigDecimal getAreaId() {
		return areaId;
	}

	public void setAreaId(BigDecimal areaId) {
		this.areaId = areaId;
	}

	@Column(name = "PLATFORM_FLG", length = 1)
	public String getPlatformFlg() {
		return platformFlg;
	}

	public void setPlatformFlg(String platformFlg) {
		this.platformFlg = platformFlg;
	}

	@Column(name = "CHANNEL_ACCOUNT", length = 32)
	public String getChannelAccount() {
		return channelAccount;
	}

	public void setChannelAccount(String channelAccount) {
		this.channelAccount = channelAccount;
	}

}