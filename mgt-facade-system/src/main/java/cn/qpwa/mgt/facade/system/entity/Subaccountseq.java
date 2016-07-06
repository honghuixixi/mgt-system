package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 客户子账号资金变动流水表
 * Subaccountseq entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "SUBACCOUNTSEQ")
public class Subaccountseq implements java.io.Serializable {

	private static final long serialVersionUID = 4686642212459937054L;
	private String sn;			     //流水码流水号 YYYYMMDD+帐务流水（每天1）
	private String subaccountId;	 //子账户ID	
	private String custId;			 //客户ID 客户编号 冗余
	private String subaccountType;	 //子账户类型  子账户号类型 冗余
	private String custName;         //客户名称 用户名 
	private String seqflag;          //账户变动方向   帐务变动方向 0-来帐 账号余额增加 1-往帐 账号余额减少
	private String changeType;       //类型 01充值、02支付03、提现04、内部调账05、结息06、利息税07、原交易退款08、原交易撤销
	private BigDecimal preamount;    //变动前总金额
	private BigDecimal amount;       //变动后总金额
	private BigDecimal cashAmount;   //可提现发生额
	private BigDecimal uncashAmount; //不可提现发生额
	private String refsn;            //关联流水ID
	private String refbatchid;       //关联批次号
	private String orderid;          //订单号  订单号 冗余
	private Date createTime;		 //创建时间
	private String note;             //备注	
	private String workdate;         //会计日期 会计日期 与会计凭证进行核算的日期
	private String refAccountCode;//对方账号
	private String refAccountName;//对方名称



	public Subaccountseq() {
	}

 

	@Id
	@Column(name = "SN", unique = true, nullable = false, length = 20)
	public String getSn() {
		return this.sn;
	}

	public void setSn(String sn) {
		this.sn = sn;
	}

	@Column(name = "SUBACCOUNT_ID", length = 12)
	public String getSubaccountId() {
		return this.subaccountId;
	}

	public void setSubaccountId(String subaccountId) {
		this.subaccountId = subaccountId;
	}

	@Column(name = "CUST_ID", length = 20)
	public String getCustId() {
		return this.custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	@Column(name = "SUBACCOUNT_TYPE", length = 4)
	public String getSubaccountType() {
		return this.subaccountType;
	}

	public void setSubaccountType(String subaccountType) {
		this.subaccountType = subaccountType;
	}

	@Column(name = "CUST_NAME", length = 100)
	public String getCustName() {
		return this.custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	@Column(name = "SEQFLAG", length = 1)
	public String getSeqflag() {
		return this.seqflag;
	}

	public void setSeqflag(String seqflag) {
		this.seqflag = seqflag;
	}

	@Column(name = "CHANGE_TYPE", length = 2)
	public String getChangeType() {
		return this.changeType;
	}

	public void setChangeType(String changeType) {
		this.changeType = changeType;
	}

	@Column(name = "PREAMOUNT", precision = 22, scale = 0)
	public BigDecimal getPreamount() {
		return this.preamount;
	}

	public void setPreamount(BigDecimal preamount) {
		this.preamount = preamount;
	}

	@Column(name = "AMOUNT", precision = 22, scale = 0)
	public BigDecimal getAmount() {
		return this.amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	@Column(name = "CASH_AMOUNT", precision = 22, scale = 0)
	public BigDecimal getCashAmount() {
		return this.cashAmount;
	}

	public void setCashAmount(BigDecimal cashAmount) {
		this.cashAmount = cashAmount;
	}

	@Column(name = "UNCASH_AMOUNT", precision = 22, scale = 0)
	public BigDecimal getUncashAmount() {
		return this.uncashAmount;
	}

	public void setUncashAmount(BigDecimal uncashAmount) {
		this.uncashAmount = uncashAmount;
	}

	@Column(name = "REFSN", length = 20)
	public String getRefsn() {
		return this.refsn;
	}

	public void setRefsn(String refsn) {
		this.refsn = refsn;
	}

	@Column(name = "REFBATCHID", length = 16)
	public String getRefbatchid() {
		return this.refbatchid;
	}

	public void setRefbatchid(String refbatchid) {
		this.refbatchid = refbatchid;
	}

	@Column(name = "ORDERID", length = 32)
	public String getOrderid() {
		return this.orderid;
	}

	public void setOrderid(String orderid) {
		this.orderid = orderid;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATE_TIME", length = 20)
	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Column(name = "NOTE", length = 100)
	public String getNote() {
		return this.note;
	}

	public void setNote(String note) {
		this.note = note;
	}

	@Column(name = "WORKDATE", length = 8)
	public String getWorkdate() {
		return this.workdate;
	}

	public void setWorkdate(String workdate) {
		this.workdate = workdate;
	}


	@Column(name = "REF_ACCOUNT_CODE")
	public String getRefAccountCode() {
		return refAccountCode;
	}



	public void setRefAccountCode(String refAccountCode) {
		this.refAccountCode = refAccountCode;
	}

	@Column(name = "REF_ACCOUNT_NAME")
	public String getRefAccountName() {
		return refAccountName;
	}

	public void setRefAccountName(String refAccountName) {
		this.refAccountName = refAccountName;
	}

}