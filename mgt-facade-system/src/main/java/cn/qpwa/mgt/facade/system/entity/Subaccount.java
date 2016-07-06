package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * Subaccount entity. @author MyEclipse Persistence Tools
 * 客户子账户表
 */
@Entity
@Table(name = "SUBACCOUNT")
public class Subaccount implements java.io.Serializable {

	private static final long serialVersionUID = -9106885991123972774L;
	/**主键  子账户ID*/
	private Long id;
	/**客户编号*/
	private String custId;
	/**子账户类型 默认9001*/
	private String subaccountType;
	/**客户名*/
	private String custName;
	/**总金额*/
	private BigDecimal amount;
	/**可提现金额*/
	private BigDecimal cashAmount;
	/**不可提现金额*/
	private BigDecimal uncashAmount;
	/**可提现冻结金额*/
	private BigDecimal freezeCashAmount;
	/**不可提现冻结金额*/
	private BigDecimal freezeUncashAmount;
	/**账户性质
	 * 对应scuser.com_flg，如果为'Y',则为2，如果为N，则为1
	 */
	private String property;
	/**状态 00有效 01冻结 02注销*/
	private String state;
	private Date createTime;
	/**计息基数*/
	private BigDecimal jixiBase;
	/**上期计息时间*/
	private String lasttermJixiDate;
	/**最新修改时间*/
	private Date lastupdateTime;
	/**上期总金额*/
	private BigDecimal lasttermAmount;
	/**校验码*/
	private String checkValue;
	/**渠道编号*/
	private String channelId;
	/**积分*/
	private BigDecimal points;
	/**附属帐户号*/
	private String attachedAccount;
	/**附属帐户属性
	 *  A-清算户
	 *	B-利息结算户
	 *	C-调帐帐户
	 *	D-初始化帐户
	 *	N-一般帐户
	 * */
	private String attachedAccounttype;

	// Constructors

	/** default constructor */
	public Subaccount() {
	}
 
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_SYS_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "ID", unique = true, nullable = false, precision = 20, scale = 0)
	public Long getId() {
		return this.id;
	}

	public void setId(Long id) {
		this.id = id;
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

	@Column(name = "FREEZE_CASH_AMOUNT", precision = 22, scale = 0)
	public BigDecimal getFreezeCashAmount() {
		return this.freezeCashAmount;
	}

	public void setFreezeCashAmount(BigDecimal freezeCashAmount) {
		this.freezeCashAmount = freezeCashAmount;
	}

	@Column(name = "FREEZE_UNCASH_AMOUNT", precision = 22, scale = 0)
	public BigDecimal getFreezeUncashAmount() {
		return this.freezeUncashAmount;
	}

	public void setFreezeUncashAmount(BigDecimal freezeUncashAmount) {
		this.freezeUncashAmount = freezeUncashAmount;
	}

	@Column(name = "PROPERTY", length = 1)
	public String getProperty() {
		return this.property;
	}

	public void setProperty(String property) {
		this.property = property;
	}

	@Column(name = "STATE", length = 2)
	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	@Column(name = "CREATE_TIME", length = 19)
	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Column(name = "JIXI_BASE", precision = 22, scale = 0)
	public BigDecimal getJixiBase() {
		return this.jixiBase;
	}

	public void setJixiBase(BigDecimal jixiBase) {
		this.jixiBase = jixiBase;
	}

	@Column(name = "LASTTERM_JIXI_DATE", length = 8)
	public String getLasttermJixiDate() {
		return this.lasttermJixiDate;
	}

	public void setLasttermJixiDate(String lasttermJixiDate) {
		this.lasttermJixiDate = lasttermJixiDate;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "LASTUPDATE_TIME", length = 7)
	public Date getLastupdateTime() {
		return this.lastupdateTime;
	}

	public void setLastupdateTime(Date lastupdateTime) {
		this.lastupdateTime = lastupdateTime;
	}

	@Column(name = "LASTTERM_AMOUNT", precision = 22, scale = 0)
	public BigDecimal getLasttermAmount() {
		return this.lasttermAmount;
	}

	public void setLasttermAmount(BigDecimal lasttermAmount) {
		this.lasttermAmount = lasttermAmount;
	}

	@Column(name = "CHECK_VALUE", length = 32)
	public String getCheckValue() {
		return this.checkValue;
	}

	public void setCheckValue(String checkValue) {
		this.checkValue = checkValue;
	}
	
	@Column(name = "CHANNEL_ID", length = 16)
	public String getChannelId() {
		return this.channelId;
	}
	@Column(name = "POINTS")
	public BigDecimal getPoints() {
		return points;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	public void setPoints(BigDecimal points) {
		this.points = points;
	}
	@Column(name = "ATTACHED_ACCOUNT")
	public String getAttachedAccount() {
		return attachedAccount;
	}

	public void setAttachedAccount(String attachedAccount) {
		this.attachedAccount = attachedAccount;
	}
	@Column(name = "ATTACHED_ACCOUNTTYPE")
	public String getAttachedAccounttype() {
		return attachedAccounttype;
	}

	public void setAttachedAccounttype(String attachedAccounttype) {
		this.attachedAccounttype = attachedAccounttype;
	}

}