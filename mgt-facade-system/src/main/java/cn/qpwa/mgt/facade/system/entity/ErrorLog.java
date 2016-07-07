package cn.qpwa.mgt.facade.system.entity;
// default package

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.sql.Clob;
import java.sql.Timestamp;

/**
 * 异常日志数据库访问实体类
 * ErrorLog entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "ERROR_LOG")
public class ErrorLog implements java.io.Serializable {

	private static final long serialVersionUID = -8979867734579123786L;
	/*错误编码*/
	private String errorCode;
	/*错误等级  一般：1,严重：2 */
	private String grade;
	/*操作类型 订单：1，支付：2*/
	private String appCode;
	/*错误内容*/
	private String description;
	/*错误返回码*/
	private Clob returnCode;
	/*状态 创建：1，已处理：2*/
	private String statusFlg;
	/*创建时间*/
	private Timestamp createDate;
	/*处理人*/
	private String userName;
	/*解决时间*/
	private Timestamp workDate;
	/*处理结果*/
	private String workResult;
	/*处理人id*/
	private Double userNo;

	// Constructors

	/** default constructor */
	public ErrorLog() {
	}

	/** minimal constructor */
	public ErrorLog(String errorCode) {
		this.errorCode = errorCode;
	}

	/** full constructor */
	public ErrorLog(String errorCode, String grade, String appCode,
					String description, Clob returnCode, String statusFlg,
					Timestamp createDate, String userName, Timestamp workDate,
					String workResult, Double userNo) {
		super();
		this.errorCode = errorCode;
		this.grade = grade;
		this.appCode = appCode;
		this.description = description;
		this.returnCode = returnCode;
		this.statusFlg = statusFlg;
		this.createDate = createDate;
		this.userName = userName;
		this.workDate = workDate;
		this.workResult = workResult;
		this.userNo = userNo;
	}
	// Property accessors
	@Id
	@Column(name = "ERROR_CODE", unique = true, nullable = false, length = 32)
	public String getErrorCode() {
		return this.errorCode;
	}

	public void setErrorCode(String errorCode) {
		this.errorCode = errorCode;
	}

	@Column(name = "GRADE", length = 8)
	public String getGrade() {
		return this.grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	@Column(name = "APP_CODE", length = 32)
	public String getAppCode() {
		return this.appCode;
	}

	public void setAppCode(String appCode) {
		this.appCode = appCode;
	}

	@Column(name = "DESCRIPTION", length = 256)
	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Column(name = "RETURN_CODE")
	public Clob getReturnCode() {
		return this.returnCode;
	}

	public void setReturnCode(Clob returnCode) {
		this.returnCode = returnCode;
	}

	@Column(name = "STATUS_FLG", length = 16)
	public String getStatusFlg() {
		return this.statusFlg;
	}

	public void setStatusFlg(String statusFlg) {
		this.statusFlg = statusFlg;
	}

	@Column(name = "CREATE_DATE", length = 7)
	public Timestamp getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Timestamp createDate) {
		this.createDate = createDate;
	}

	@Column(name = "USER_NAME",length=40)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "WORK_DATE", length = 7)
	public Timestamp getWorkDate() {
		return this.workDate;
	}

	public void setWorkDate(Timestamp workDate) {
		this.workDate = workDate;
	}

	@Column(name = "WORK_RESULT", length = 256)
	public String getWorkResult() {
		return this.workResult;
	}

	public void setWorkResult(String workResult) {
		this.workResult = workResult;
	}
	
	@Column(name = "USER_NO", precision = 0)
	public Double getUserNo() {
		return userNo;
	}

	public void setUserNo(Double userNo) {
		this.userNo = userNo;
	}
	
	

}