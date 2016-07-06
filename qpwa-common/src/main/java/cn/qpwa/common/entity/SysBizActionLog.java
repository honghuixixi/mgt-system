package cn.qpwa.common.entity;

import java.math.BigDecimal;
import java.sql.Timestamp;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

/**
 * 系统业务行动日志
 * biz->business->业务
 */
@Entity
@Table(name = "SYS_BIZACTION_LOG")
public class SysBizActionLog implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5836486771415533538L;
	/** 流水号SEQ_SYSLOG_PK_NO.NEXTVAL */
	private BigDecimal pkNo;
	/** 当前人员ID */
	private BigDecimal userNo;
	/** 当前人员登录名称 */
	private String userName;
	/** 当前人员真实名字 */
	private String name;
	/** 行动日期 */
	private Timestamp actionDate;
	/** 业务模块 */
	private String bizModule;
	/** 业务名称 */
	private String bizName;
	/** 业务内容 -- 存储业务变化的object对象 */
	private String bizContent;
	/**业务ID，记录物流/订单的编号*/
	private String actionId;
	/** 行动代码 -- 业务CODE*/
	private String actionCode;
	/** 行动类型  insert update delete*/
	private String actionType;
	/** 行动名称：新增订单 修改订单 */
	private String actionName;
	/** 客户端IP地址 */
	private String ipAddress;
	/** 客户端机器名称 */
	private String machineName;
	/** 客户端信息（除主机和IP之外的信息） */
	private String clientInfo;
	/** 客户端浏览器信息--可以考虑再拆出一些字段出来 */
	private String browserInfo;
	


	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_SYSLOG_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "PK_NO", unique = true, nullable = false, precision = 22, scale = 0)
	public BigDecimal getPkNo() {
		return pkNo;
	}

	public void setPkNo(BigDecimal pkNo) {
		this.pkNo = pkNo;
	}

	@Column(name = "USER_NO", precision = 22, scale = 0)
	public BigDecimal getUserNo() {
		return userNo;
	}

	public void setUserNo(BigDecimal userNo) {
		this.userNo = userNo;
	}

	@Column(name = "USER_NAME", length = 32)
	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "NAME", length = 256)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name="ACTION_DATE",length = 7)
	public Timestamp getActionDate() {
		return actionDate;
	}

	public void setActionDate(Timestamp actionDate) {
		this.actionDate = actionDate;
	}

	@Column(name="BIZ_MODULE",length = 32)
	public String getBizModule() {
		return bizModule;
	}

	public void setBizModule(String bizModule) {
		this.bizModule = bizModule;
	}

	@Column(name="BIZ_NAME",length = 256)
	public String getBizName() {
		return bizName;
	}

	public void setBizName(String bizName) {
		this.bizName = bizName;
	}

	@Column(name="BIZ_CONTENT",length = 4000)
	public String getBizContent() {
		return bizContent;
	}

	public void setBizContent(String bizContent) {
		this.bizContent = bizContent;
	}

	@Column(name="ACTION_ID",length = 32)
	public String getActionId() {
		return actionId;
	}

	public void setActionId(String actionId) {
		this.actionId = actionId;
	}

	@Column(name="ACTION_CODE",length = 32)
	public String getActionCode() {
		return actionCode;
	}

	public void setActionCode(String actionCode) {
		this.actionCode = actionCode;
	}

	@Column(name="ACTION_TYPE",length = 32)
	public String getActionType() {
		return actionType;
	}

	public void setActionType(String actionType) {
		this.actionType = actionType;
	}

	@Column(name="ACTION_NAME",length = 256)
	public String getActionName() {
		return actionName;
	}

	public void setActionName(String actionName) {
		this.actionName = actionName;
	}

	@Column(name="IP_ADDRESS",length = 128)
	public String getIpAddress() {
		return ipAddress;
	}

	public void setIpAddress(String ipAddress) {
		this.ipAddress = ipAddress;
	}

	@Column(name="MACHINE_NAME",length = 256)
	public String getMachineName() {
		return machineName;
	}

	public void setMachineName(String machineName) {
		this.machineName = machineName;
	}

	@Column(name="CLIENT_INFO",length = 256)
	public String getClientInfo() {
		return clientInfo;
	}

	public void setClientInfo(String clientInfo) {
		this.clientInfo = clientInfo;
	}

	@Column(name="BROWSER_INFO",length = 2000)
	public String getBrowserInfo() {
		return browserInfo;
	}

	public void setBrowserInfo(String browserInfo) {
		this.browserInfo = browserInfo;
	}

}
