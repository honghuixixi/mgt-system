package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;

@Entity
@Table(name = "SYS_LOGIN_LOG")
public class SysLoginLog implements java.io.Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 6151843633220354097L;
	/** 流水号SEQ_SYSLOG_PK_NO.NEXTVAL*/
	private BigDecimal pkNo;
	/** 当前人员ID*/
	private BigDecimal userNo;
	/** 当前人员登录名称*/
	private String userName;
	/** 当前人员真实名字*/
	private String name;
	/** 行动日期*/
	private Timestamp actionDate;
	/** 行动代码：LOGIN/LOGOUT*/
	private String actionCode;
	/** 行动名称：登录/退出*/
	private String actionName;
	/** 客户端IP地址*/
	private String ipAddress;
	/** 客户端机器名称*/
	private String machineName;
	/** 客户端信息（除主机和IP之外的信息）*/
	private String clientInfo;
	/** 客户端浏览器信息--可以考虑再拆出一些字段出来*/
	private String browserInfo;

	public SysLoginLog(){
	}
	
	/**full constructor**/
	public SysLoginLog(BigDecimal pkNo, BigDecimal userNo, String userName, String name, Timestamp actionDate,
					   String actionCode, String actionName, String ipAddress, String machineName, String clientInfo,
					   String browserInfo) {
		super();
		this.pkNo = pkNo;
		this.userNo = userNo;
		this.userName = userName;
		this.name = name;
		this.actionDate = actionDate;
		this.actionCode = actionCode;
		this.actionName = actionName;
		this.ipAddress = ipAddress;
		this.machineName = machineName;
		this.clientInfo = clientInfo;
		this.browserInfo = browserInfo;
	}
	
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

	@Column(name="ACTION_CODE",length = 32)
	public String getActionCode() {
		return actionCode;
	}

	public void setActionCode(String actionCode) {
		this.actionCode = actionCode;
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
