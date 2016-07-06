package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.Date;

/**
 * 客户子账户与银行账户绑定表
 * Subaccountbindcard entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "SUBACCOUNTBINDCARD")
public class Subaccountbindcard implements java.io.Serializable {

	private static final long serialVersionUID = -4835062062514620926L;
	private String bankcardno;           //账号
	private String bankType;             //行别
	private String bankaddrno;           //地区
	private String bankcardname;         //户名
	private Date cardbindtime;           //绑定时间
	private String custId;				 //客户ID
	private String subaccountType;		 //子账户类型
	private String bankName;		 	 //银行行别
	private String bankCode;		 	 //银行名称
	private String userCertType;		//证件类型 (身份证,组织机构代码证)
	private String userCardNo;			//身份证号
	private String userBankMob;			//银行预留手机号
	private String bankCardType;		//卡种
	private String qpFlag;				//是否为快捷支付
	
	/* 主键ID */
	private String id;
	@Id
	@GeneratedValue(generator="system-uuid")
	@GenericGenerator(name="system-uuid", strategy = "uuid")
	@Column(name = "ID", nullable = false, length = 32)
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}


	// Constructors

	/** default constructor */
	public Subaccountbindcard() {
	}

	@Column(name = "CUST_ID", nullable = false, length = 20)
	public String getCustId() {
		return this.custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	@Column(name = "SUBACCOUNT_TYPE", nullable = false, length = 4)
	public String getSubaccountType() {
		return this.subaccountType;
	}

	public void setSubaccountType(String subaccountType) {
		this.subaccountType = subaccountType;
	}
 

	@Column(name = "BANKCARDNO", length = 32)
	public String getBankcardno() {
		return this.bankcardno;
	}

	public void setBankcardno(String bankcardno) {
		this.bankcardno = bankcardno;
	}

	@Column(name = "BANK_TYPE", length = 7)
	public String getBankType() {
		return this.bankType;
	}

	public void setBankType(String bankType) {
		this.bankType = bankType;
	}

	@Column(name = "BANKADDRNO", length = 4)
	public String getBankaddrno() {
		return this.bankaddrno;
	}

	public void setBankaddrno(String bankaddrno) {
		this.bankaddrno = bankaddrno;
	}

	@Column(name = "BANKCARDNAME", length = 200)
	public String getBankcardname() {
		return this.bankcardname;
	}

	public void setBankcardname(String bankcardname) {
		this.bankcardname = bankcardname;
	}

	@Column(name = "CARDBINDTIME")
	public Date getCardbindtime() {
		return this.cardbindtime;
	}

	public void setCardbindtime(Date cardbindtime) {
		this.cardbindtime = cardbindtime;
	}
	@Column(name = "BANK_NAME")
	public String getBankName() {
		return bankName;
	}

	public void setBankName(String bankName) {
		this.bankName = bankName;
	}
	@Column(name = "BANK_CODE")
	public String getBankCode() {
		return bankCode;
	}

	public void setBankCode(String bankCode) {
		this.bankCode = bankCode;
	}
	
	@Column(name = "USER_CERT_TYPE")
	public String getUserCertType() {
		return userCertType;
	}

	public void setUserCertType(String userCertType) {
		this.userCertType = userCertType;
	}
	
	@Column(name = "USER_CARDNO")
	public String getUserCardNo() {
		return userCardNo;
	}

	public void setUserCardNo(String userCardNo) {
		this.userCardNo = userCardNo;
	}
	
	@Column(name = "USER_BANKMOB")
	public String getUserBankMob() {
		return userBankMob;
	}

	public void setUserBankMob(String userBankMob) {
		this.userBankMob = userBankMob;
	}

	@Column(name = "BANKCARDTYPE")
	public String getBankCardType() {
		return bankCardType;
	}

	public void setBankCardType(String bankCardType) {
		this.bankCardType = bankCardType;
	}
	
	@Column(name = "QP_FLG")
	public String getQpFlag() {
		return qpFlag;
	}

	public void setQpFlag(String qpFlag) {
		this.qpFlag = qpFlag;
	}

}