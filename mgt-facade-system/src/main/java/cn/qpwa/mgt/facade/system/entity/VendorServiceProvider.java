package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 供应商客服
 * @author honghui
 * @ddate  2016-05-25
 */
@Entity
@Table(name="VENDOR_SERVICE_PROVIDER")
public class VendorServiceProvider implements Serializable{
	private static final long serialVersionUID = 1L;

	private BigDecimal pkNo;      //主键
	private String serviceName;   //客服名称
	private BigDecimal userNo;    //关联用户NO
	private String userName;      //关联用户登陆名称
	private BigDecimal userPassword;  //关联用户登陆密码
	private String name;          //用户名称
	private String vendorCode;    //供应商编码
	private String activeFlg = "P";     //状态 A:启用 P:未启用
	private Date workTimeFrom;    //工作时间起始时间
	private Date workTimeTo;      //工作时间截至时间
	private Date createDate = new Date();      //创建日期
	private BigDecimal sortNO;                 //排序
	private String type;          //类型  1-售前， 2-售中，3-售后
	
	public VendorServiceProvider() {
	}
	
	public VendorServiceProvider(BigDecimal pkNo, String serviceName, BigDecimal userNo, String userName,
								 BigDecimal userPassword, String name, String vendorCode, String activeFlg, Date workTimeFrom,
								 Date workTimeTo, Date createDate, BigDecimal sortNO, String type) {
		super();
		this.pkNo = pkNo;
		this.serviceName = serviceName;
		this.userNo = userNo;
		this.userName = userName;
		this.userPassword = userPassword;
		this.name = name;
		this.vendorCode = vendorCode;
		this.activeFlg = activeFlg;
		this.workTimeFrom = workTimeFrom;
		this.workTimeTo = workTimeTo;
		this.createDate = createDate;
		this.sortNO = sortNO;
		this.type = type;
	}

	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_APP_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "PK_NO", unique = true, nullable = false, precision = 22, scale = 0)
	public BigDecimal getPkNo() {
		return pkNo;
	}

	public void setPkNo(BigDecimal pkNo) {
		this.pkNo = pkNo;
	}

	@Column(name = "SERVICE_NAME", length = 16)
	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	@Column(name = "USER_NO", length = 20)
	public BigDecimal getUserNo() {
		return userNo;
	}

	public void setUserNo(BigDecimal userNo) {
		this.userNo = userNo;
	}

	@Column(name = "USER_NAME", length = 16)
	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "USER_PASSWORD", length = 20)
	public BigDecimal getUserPassword() {
		return userPassword;
	}

	public void setUserPassword(BigDecimal userPassword) {
		this.userPassword = userPassword;
	}

	@Column(name = "VENDOR_CODE", length = 16)
	public String getVendorCode() {
		return vendorCode;
	}

	public void setVendorCode(String vendorCode) {
		this.vendorCode = vendorCode;
	}

	@Column(name = "WORK_TIME_FROM")
	public Date getWorkTimeFrom() {
		return workTimeFrom;
	}

	public void setWorkTimeFrom(Date workTimeFrom) {
		this.workTimeFrom = workTimeFrom;
	}

	@Column(name = "WORK_TIME_TO")
	public Date getWorkTimeTo() {
		return workTimeTo;
	}

	public void setWorkTimeTo(Date workTimeTo) {
		this.workTimeTo = workTimeTo;
	}

	@Column(name = "CREATE_DATE")
	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Column(name = "ACTIVE_FLG", length = 1)
	public String getActiveFlg() {
		return activeFlg;
	}

	public void setActiveFlg(String activeFlg) {
		this.activeFlg = activeFlg;
	}

	@Column(name = "NAME", length = 200)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name = "SORT_NO")
	public BigDecimal getSortNO() {
		return sortNO;
	}

	public void setSortNO(BigDecimal sortNO) {
		this.sortNO = sortNO;
	}

	@Column(name = "TYPE",length = 1)
	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
}
