package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * 支付交易表
 * @author Administrator
 *
 */
@Entity
@Table(name = "PAYBILL")
public class Paybill implements java.io.Serializable {

	private static final long serialVersionUID = 1639731052236861421L;
	private String pkNo;                     //非强制性主键 //UUID
	private String sn;                       //交易流水 //银行交易流水
	private String bankSn;                   //银行交易流水号 //
	private String srccustId;                //发起方客户编号
	private String changePayercust;          //换名支付付款方代码
	private String subaccountType;           //子账号类型
	private String payerIfkftcust;           //付款方是否平台客户
	private String payercustId;              //付款方客户编号
	private String payercustName;            //付款方户名
	private String payerbankType;            //付款方开户行行别
	private String payerbankCode;            //行号
	private String payerbankname;            //付款方开户行行名
	private String payerbankaddrno;          //付款方开户行地区代码
	private String payerbankcardno;          //付款方账号
	private String payerbankcardname;        //付款方账号户名
	private String tranType;                 //交易类型
	private String feetype;                  //费用类型代码
	private String channelId;                //渠道编号
	private String channelPayflag;           //费用支付规则
	private String channelAccount;           //费用支付方
	private BigDecimal channelAmount;        //渠道应扣金额
	private BigDecimal channelFee;           //渠道手续费
	private BigDecimal channelActualAmount;  //渠道实扣金额
	private String channelCheckState;        //对账状态
	private String checkdate;                //渠道结算日期
	private BigDecimal cashAmount;           //可提现金额
	private BigDecimal uncashAmount;         //不可提现金额
	private String freezesn;                 //账务冻结变动流水
	private String feefreezesn;              //实时手续费账务冻结变动流水
	private String orderid;                  //订单号
	private String ordernote;                //订单说明
	private String payeeIfkftcust;           //收款方是否是平台客户
	private String payeecustId;              //收款方客户号
	private String payeecustName;            //收款方平台户名
	private String payeebankType;            //收款方开户行行别
	private String payeebankCode;            //行号
	private String payeebankname;            //收款方开户行行名
	private String payeebankaddrno;          //收款方开户行地区代码
	private String payeebankcardno;          //收款方账号
	private String payeebankcardname;        //收款方账号户名
	private Date createTime;                 //创建时间
	private Date expireTime;                 //未支付失效时间
	private String resultcode;               //返回码
	private String resultnote;               //返回备注
	private String settledate;               //结算日期
	private String rechargeState;            //资金归集状态
	private String rechargeSn;               //资金归集交易流水
	private String guaranteeState;           //担保交易状态
	private String state;                    //交易状态
	private String netNo;                    //支付场次
	private String payState;                 //支付状态
	private String batchid;                  //批次号
	private String srcbatchid;               //发起方批次号
	private String detailid;                 //批量业务明细序号
	private String balanceState;             //记账账户变动状态
	private BigDecimal tranamount;           //交易金额
	private String checkState;               //对账状态
	private String bankResultcode;           //银行返回码
	private String bankResultnote;           //银行返回备注
	private Date bankTime;                   //银行回执更新时间
	private String workdate;                 //会计日期
	private BigDecimal fee;                  //手续费
	private String feeCustId;                //手续费付费方
	private String feeState;                 //手续费状态
	private String undoState;                //撤销状态
	private String pgurl;						
	private String bgurl;
	private String rechargedtlStatus; 
	private String tranNote;//交易说明
	private String channelCheckType; //Y-自动对帐   N-手动对帐
	private String tranDate;//银行交易时间
	private String tranSubtype;//交易子类型
	private String lineType;
	private String sourceCode;//订单来源 B2B  B2C
	public Paybill() {
	}
 
	@Id
	@GeneratedValue(generator="system-uuid")
	@GenericGenerator(name="system-uuid", strategy = "uuid")
	@Column(name = "PK_NO", nullable = false, length = 32)
	public String getPkNo() {
		return this.pkNo;
	}

	public void setPkNo(String pkNo) {
		this.pkNo = pkNo;
	}
	@Column(name = "SN", length = 32)
	public String getSn() {
		return this.sn;
	}

	public void setSn(String sn) {
		this.sn = sn;
	}

	@Column(name = "BANK_SN", length = 20)
	public String getBankSn() {
		return this.bankSn;
	}

	public void setBankSn(String bankSn) {
		this.bankSn = bankSn;
	}

	@Column(name = "SRCCUST_ID", length = 20)
	public String getSrccustId() {
		return this.srccustId;
	}

	public void setSrccustId(String srccustId) {
		this.srccustId = srccustId;
	}

	@Column(name = "CHANGE_PAYERCUST", length = 20)
	public String getChangePayercust() {
		return this.changePayercust;
	}

	public void setChangePayercust(String changePayercust) {
		this.changePayercust = changePayercust;
	}

	@Column(name = "SUBACCOUNT_TYPE", length = 4)
	public String getSubaccountType() {
		return this.subaccountType;
	}

	public void setSubaccountType(String subaccountType) {
		this.subaccountType = subaccountType;
	}

	@Column(name = "PAYER_IFKFTCUST", length = 1)
	public String getPayerIfkftcust() {
		return this.payerIfkftcust;
	}

	public void setPayerIfkftcust(String payerIfkftcust) {
		this.payerIfkftcust = payerIfkftcust;
	}

	@Column(name = "PAYERCUST_ID", length = 20)
	public String getPayercustId() {
		return this.payercustId;
	}

	public void setPayercustId(String payercustId) {
		this.payercustId = payercustId;
	}

	@Column(name = "PAYERCUST_NAME", length = 100)
	public String getPayercustName() {
		return this.payercustName;
	}

	public void setPayercustName(String payercustName) {
		this.payercustName = payercustName;
	}

	@Column(name = "PAYERBANK_TYPE", length = 7)
	public String getPayerbankType() {
		return this.payerbankType;
	}

	public void setPayerbankType(String payerbankType) {
		this.payerbankType = payerbankType;
	}

	@Column(name = "PAYERBANK_CODE", length = 12)
	public String getPayerbankCode() {
		return this.payerbankCode;
	}

	public void setPayerbankCode(String payerbankCode) {
		this.payerbankCode = payerbankCode;
	}

	@Column(name = "PAYERBANKNAME", length = 128)
	public String getPayerbankname() {
		return this.payerbankname;
	}

	public void setPayerbankname(String payerbankname) {
		this.payerbankname = payerbankname;
	}

	@Column(name = "PAYERBANKADDRNO", length = 4)
	public String getPayerbankaddrno() {
		return this.payerbankaddrno;
	}

	public void setPayerbankaddrno(String payerbankaddrno) {
		this.payerbankaddrno = payerbankaddrno;
	}

	@Column(name = "PAYERBANKCARDNO", length = 32)
	public String getPayerbankcardno() {
		return this.payerbankcardno;
	}

	public void setPayerbankcardno(String payerbankcardno) {
		this.payerbankcardno = payerbankcardno;
	}

	@Column(name = "PAYERBANKCARDNAME", length = 100)
	public String getPayerbankcardname() {
		return this.payerbankcardname;
	}

	public void setPayerbankcardname(String payerbankcardname) {
		this.payerbankcardname = payerbankcardname;
	}

	@Column(name = "TRAN_TYPE", length = 4)
	public String getTranType() {
		return this.tranType;
	}

	public void setTranType(String tranType) {
		this.tranType = tranType;
	}

	@Column(name = "FEETYPE", length = 10)
	public String getFeetype() {
		return this.feetype;
	}

	public void setFeetype(String feetype) {
		this.feetype = feetype;
	}

	@Column(name = "CHANNEL_ID", length = 16)
	public String getChannelId() {
		return this.channelId;
	}

	public void setChannelId(String channelId) {
		this.channelId = channelId;
	}

	@Column(name = "CHANNEL_PAYFLAG", length = 1)
	public String getChannelPayflag() {
		return this.channelPayflag;
	}

	public void setChannelPayflag(String channelPayflag) {
		this.channelPayflag = channelPayflag;
	}

	@Column(name = "CHANNEL_ACCOUNT", length = 32)
	public String getChannelAccount() {
		return this.channelAccount;
	}

	public void setChannelAccount(String channelAccount) {
		this.channelAccount = channelAccount;
	}

	@Column(name = "CHANNEL_AMOUNT", precision = 22, scale = 2)
	public BigDecimal getChannelAmount() {
		return this.channelAmount;
	}

	public void setChannelAmount(BigDecimal channelAmount) {
		this.channelAmount = channelAmount;
	}

	@Column(name = "CHANNEL_FEE", precision = 22, scale = 2)
	public BigDecimal getChannelFee() {
		return this.channelFee;
	}

	public void setChannelFee(BigDecimal channelFee) {
		this.channelFee = channelFee;
	}

	@Column(name = "CHANNEL_ACTUAL_AMOUNT", precision = 22, scale = 2)
	public BigDecimal getChannelActualAmount() {
		return this.channelActualAmount;
	}

	public void setChannelActualAmount(BigDecimal channelActualAmount) {
		this.channelActualAmount = channelActualAmount;
	}

	@Column(name = "CHANNEL_CHECK_STATE", length = 2)
	public String getChannelCheckState() {
		return this.channelCheckState;
	}

	public void setChannelCheckState(String channelCheckState) {
		this.channelCheckState = channelCheckState;
	}

	@Column(name = "CHECKDATE", length = 8)
	public String getCheckdate() {
		return this.checkdate;
	}

	public void setCheckdate(String checkdate) {
		this.checkdate = checkdate;
	}

	@Column(name = "CASH_AMOUNT", precision = 22, scale = 2)
	public BigDecimal getCashAmount() {
		return this.cashAmount;
	}

	public void setCashAmount(BigDecimal cashAmount) {
		this.cashAmount = cashAmount;
	}

	@Column(name = "UNCASH_AMOUNT", precision = 22, scale = 2)
	public BigDecimal getUncashAmount() {
		return this.uncashAmount;
	}

	public void setUncashAmount(BigDecimal uncashAmount) {
		this.uncashAmount = uncashAmount;
	}

	@Column(name = "FREEZESN", length = 20)
	public String getFreezesn() {
		return this.freezesn;
	}

	public void setFreezesn(String freezesn) {
		this.freezesn = freezesn;
	}

	@Column(name = "FEEFREEZESN", length = 20)
	public String getFeefreezesn() {
		return this.feefreezesn;
	}

	public void setFeefreezesn(String feefreezesn) {
		this.feefreezesn = feefreezesn;
	}

	@Column(name = "ORDERID", length = 32)
	public String getOrderid() {
		return this.orderid;
	}

	public void setOrderid(String orderid) {
		this.orderid = orderid;
	}

	@Column(name = "ORDERNOTE", length = 500)
	public String getOrdernote() {
		return this.ordernote;
	}

	public void setOrdernote(String ordernote) {
		this.ordernote = ordernote;
	}

	@Column(name = "PAYEE_IFKFTCUST", length = 1)
	public String getPayeeIfkftcust() {
		return this.payeeIfkftcust;
	}

	public void setPayeeIfkftcust(String payeeIfkftcust) {
		this.payeeIfkftcust = payeeIfkftcust;
	}

	@Column(name = "PAYEECUST_ID", length = 20)
	public String getPayeecustId() {
		return this.payeecustId;
	}

	public void setPayeecustId(String payeecustId) {
		this.payeecustId = payeecustId;
	}

	@Column(name = "PAYEECUST_NAME", length = 100)
	public String getPayeecustName() {
		return this.payeecustName;
	}

	public void setPayeecustName(String payeecustName) {
		this.payeecustName = payeecustName;
	}

	@Column(name = "PAYEEBANK_TYPE", length = 7)
	public String getPayeebankType() {
		return this.payeebankType;
	}

	public void setPayeebankType(String payeebankType) {
		this.payeebankType = payeebankType;
	}

	@Column(name = "PAYEEBANK_CODE", length = 12)
	public String getPayeebankCode() {
		return this.payeebankCode;
	}

	public void setPayeebankCode(String payeebankCode) {
		this.payeebankCode = payeebankCode;
	}

	@Column(name = "PAYEEBANKNAME", length = 128)
	public String getPayeebankname() {
		return this.payeebankname;
	}

	public void setPayeebankname(String payeebankname) {
		this.payeebankname = payeebankname;
	}

	@Column(name = "PAYEEBANKADDRNO", length = 4)
	public String getPayeebankaddrno() {
		return this.payeebankaddrno;
	}

	public void setPayeebankaddrno(String payeebankaddrno) {
		this.payeebankaddrno = payeebankaddrno;
	}

	@Column(name = "PAYEEBANKCARDNO", length = 32)
	public String getPayeebankcardno() {
		return this.payeebankcardno;
	}

	public void setPayeebankcardno(String payeebankcardno) {
		this.payeebankcardno = payeebankcardno;
	}

	@Column(name = "PAYEEBANKCARDNAME", length = 100)
	public String getPayeebankcardname() {
		return this.payeebankcardname;
	}

	public void setPayeebankcardname(String payeebankcardname) {
		this.payeebankcardname = payeebankcardname;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATE_TIME", length = 20)
	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "EXPIRE_TIME", length = 20)
	public Date getExpireTime() {
		return this.expireTime;
	}

	public void setExpireTime(Date expireTime) {
		this.expireTime = expireTime;
	}

	@Column(name = "RESULTCODE", length = 12)
	public String getResultcode() {
		return this.resultcode;
	}

	public void setResultcode(String resultcode) {
		this.resultcode = resultcode;
	}

	@Column(name = "RESULTNOTE", length = 100)
	public String getResultnote() {
		return this.resultnote;
	}

	public void setResultnote(String resultnote) {
		this.resultnote = resultnote;
	}

	@Column(name = "SETTLEDATE", length = 8)
	public String getSettledate() {
		return this.settledate;
	}

	public void setSettledate(String settledate) {
		this.settledate = settledate;
	}

	@Column(name = "RECHARGE_STATE", length = 2)
	public String getRechargeState() {
		return this.rechargeState;
	}

	public void setRechargeState(String rechargeState) {
		this.rechargeState = rechargeState;
	}

	@Column(name = "RECHARGE_SN", length = 20)
	public String getRechargeSn() {
		return this.rechargeSn;
	}

	public void setRechargeSn(String rechargeSn) {
		this.rechargeSn = rechargeSn;
	}

	@Column(name = "GUARANTEE_STATE", length = 2)
	public String getGuaranteeState() {
		return this.guaranteeState;
	}

	public void setGuaranteeState(String guaranteeState) {
		this.guaranteeState = guaranteeState;
	}

	@Column(name = "STATE", length = 2)
	public String getState() {
		return this.state;
	}

	public void setState(String state) {
		this.state = state;
	}

	@Column(name = "NET_NO", length = 10)
	public String getNetNo() {
		return this.netNo;
	}

	public void setNetNo(String netNo) {
		this.netNo = netNo;
	}

	@Column(name = "PAY_STATE", length = 2)
	public String getPayState() {
		return this.payState;
	}

	public void setPayState(String payState) {
		this.payState = payState;
	}

	@Column(name = "BATCHID", length = 32)
	public String getBatchid() {
		return this.batchid;
	}

	public void setBatchid(String batchid) {
		this.batchid = batchid;
	}

	@Column(name = "SRCBATCHID", length = 32)
	public String getSrcbatchid() {
		return this.srcbatchid;
	}

	public void setSrcbatchid(String srcbatchid) {
		this.srcbatchid = srcbatchid;
	}

	@Column(name = "DETAILID", length = 8)
	public String getDetailid() {
		return this.detailid;
	}

	public void setDetailid(String detailid) {
		this.detailid = detailid;
	}

	@Column(name = "BALANCE_STATE", length = 1)
	public String getBalanceState() {
		return this.balanceState;
	}

	public void setBalanceState(String balanceState) {
		this.balanceState = balanceState;
	}

	@Column(name = "TRANAMOUNT", precision = 22, scale = 2)
	public BigDecimal getTranamount() {
		return this.tranamount;
	}

	public void setTranamount(BigDecimal tranamount) {
		this.tranamount = tranamount;
	}

	@Column(name = "CHECK_STATE", length = 2)
	public String getCheckState() {
		return this.checkState;
	}

	public void setCheckState(String checkState) {
		this.checkState = checkState;
	}

	@Column(name = "BANK_RESULTCODE", length = 10)
	public String getBankResultcode() {
		return this.bankResultcode;
	}

	public void setBankResultcode(String bankResultcode) {
		this.bankResultcode = bankResultcode;
	}

	@Column(name = "BANK_RESULTNOTE", length = 100)
	public String getBankResultnote() {
		return this.bankResultnote;
	}

	public void setBankResultnote(String bankResultnote) {
		this.bankResultnote = bankResultnote;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "BANK_TIME", length = 20)
	public Date getBankTime() {
		return this.bankTime;
	}

	public void setBankTime(Date bankTime) {
		this.bankTime = bankTime;
	}

	@Column(name = "WORKDATE", length = 8)
	public String getWorkdate() {
		return this.workdate;
	}

	public void setWorkdate(String workdate) {
		this.workdate = workdate;
	}

	@Column(name = "FEE", precision = 22, scale = 0)
	public BigDecimal getFee() {
		return this.fee;
	}

	public void setFee(BigDecimal fee) {
		this.fee = fee;
	}

	@Column(name = "FEE_CUST_ID", length = 20)
	public String getFeeCustId() {
		return this.feeCustId;
	}

	public void setFeeCustId(String feeCustId) {
		this.feeCustId = feeCustId;
	}

	@Column(name = "FEE_STATE", length = 2)
	public String getFeeState() {
		return this.feeState;
	}

	public void setFeeState(String feeState) {
		this.feeState = feeState;
	}

	@Column(name = "UNDO_STATE", length = 2)
	public String getUndoState() {
		return this.undoState;
	}

	public void setUndoState(String undoState) {
		this.undoState = undoState;
	}

	@Column(name = "PGURL", length = 200)
	public String getPgurl() {
		return this.pgurl;
	}

	public void setPgurl(String pgurl) {
		this.pgurl = pgurl;
	}

	@Column(name = "BGURL", length = 200)
	public String getBgurl() {
		return this.bgurl;
	}

	public void setBgurl(String bgurl) {
		this.bgurl = bgurl;
	}
	@Column(name = "RECHARGEDTL_STATUS", length = 1)
	public String getRechargedtlStatus() {
		return rechargedtlStatus;
	}

	public void setRechargedtlStatus(String rechargedtlStatus) {
		this.rechargedtlStatus = rechargedtlStatus;
	}
	@Column(name = "TRAN_NOTE", length = 32)
	public String getTranNote() {
		return tranNote;
	}

	public void setTranNote(String tranNote) {
		this.tranNote = tranNote;
	}
	@Column(name = "CHANNEL_CHECK_TYPE", length = 1)
	public String getChannelCheckType() {
		return channelCheckType;
	}

	public void setChannelCheckType(String channelCheckType) {
		this.channelCheckType = channelCheckType;
	}

	@Column(name = "TRAN_DATE", length = 20)
	public String getTranDate() {
		return tranDate;
	}

	public void setTranDate(String tranDate) {
		this.tranDate = tranDate;
	}
	@Column(name = "TRAN_SUBTYPE")
	public String getTranSubtype() {
		return tranSubtype;
	}

	public void setTranSubtype(String tranSubtype) {
		this.tranSubtype = tranSubtype;
	}
	@Column(name = "LINE_TYPE")
	public String getLineType() {
		return lineType;
	}

	public void setLineType(String lineType) {
		this.lineType = lineType;
	}
	@Column(name = "SOURCE_CODE")
	public String getSourceCode() {
		return sourceCode;
	}

	public void setSourceCode(String sourceCode) {
		this.sourceCode = sourceCode;
	}
	
}