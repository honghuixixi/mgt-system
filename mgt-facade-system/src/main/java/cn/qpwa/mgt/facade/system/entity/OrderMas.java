package cn.qpwa.mgt.facade.system.entity;

// default package

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * OrderMas entity. 主订单数据库访问实体类
 */
@Entity
@Table(name = "ORDER_MAS")
public class OrderMas implements java.io.Serializable {
	

	/**
	 * 
	 */
	private static final long serialVersionUID = -2082900879290245843L;

	
	// Fields
	/** 主键 */
	private BigDecimal pkNo;
	/** 订单生成日期，仅年月日 */
	private Timestamp masDate;
	/** 订单编号 */
	private String masNo;
	/** 订单销售或者退单SALES，RETURN */
	private String masCode;
	/** 机构ID */
	private BigDecimal orgNo;
	/** 供应商注册生成 */
	private BigDecimal comNo;
	/** 供应商注册生成 */
	private BigDecimal locNo;
	/** 非子订单则为空，子订单时则为父订单的PK_NO */
	private BigDecimal refPkNo;
	/**
	 * 默认为N表示正常订单，若订单需要被拆分，则原订单该字段被改为Y,【我的订单】/其他涉及到订单统计的列表里都只显示INTERNAL_FLG =
	 * 'N'的订单，子订单该字段值为N。
	 */
	private String internalFlg;
	/** 如果该订单是退单，则该字段记录原订单的PK_NO */
	private BigDecimal srcPkNo;
	/** 下单用户id */
	private BigDecimal userNo;
	/** 下单用户名称 */
	private String custName;
	/**下单用户登录帐号*/
	private String custCode;
	/** 订单中商品的总数量 */
	private BigDecimal qty;
	/** 订单商品总金额,订单金额需要计算得出：订单商品总金额amount-diffMiscAmt(扣减金额)-优惠金额miscPayAmt+运费freight 
	 * 2015-07-29 商品单位数量*商品实际价格  不进行任何减扣操作
	 * */
	private BigDecimal amount;
	/** 差异总额 （（订单数量-实际收货数量）*单价 - 折零扣减） */
	private BigDecimal diffMiscAmt;
	/** 分单后商品的供应商ID */
	private BigDecimal vendorUserNo;
	/** 分单后商品的供应商名称 */
	private String vendorName;
	/**分单后供应商登录账号*/
	private String vendorCode;
	/** 网页(W)、移动(O)、POS(P)、WAP(A)、B2CAPP(C) 、B2BAPP(B) 
	 *  网页(W)、外勤360(O)、POS(P)、WAP(A)、B2CAPP(C) 、B2BAPP(B)、B2BAPP-IOS(F)、B2CAPP-IOS(G)、外勤360-IOS(H) 2016-03-21hz(zzx)*/
	private String source;
	/** 结算方式id，在线、货到付款 */
	private String paymentType;
	/** 配送方式标记，物流L、自提S */
	private String deliveryType;
	/** 自提站点id */
	private BigDecimal scPkNo;
	/** 订单类型，SOP/LBP/FBP */
	private String orderType;
	/** 发货仓库 */
	private String whC;
	/** 收货人名称 */
	private String receiverName;
	/** 收货人电话 */
	private String receiverTel;
	/** 收货人手机 */
	private String receiverMobile;
	/** 收货人地址 */
	private String receiverAddress;
	/** 收货人邮编 */
	private String receiverZip;
	/** 客户关闭订单时间 */
	private Timestamp custCloseDate;
	/** 客户关闭订单原因描述 */
	private String custCloseDesc;
	/** 供应商闭订单时间 */
	private Timestamp vendorCloseDate;
	/** 供应商闭订单原因描述 */
	private String vendorCloseDesc;
	/** 供付款时间 */
	private Timestamp paymentDate;
	/** 物流或快递公司代码 */
	private String logisticCode;
	/** 物流或快递运单号 */
	private String wayBillNo;
	/** 运费 */
	private BigDecimal freight;
	/** 送货时间，A不限B仅双休日C仅工作日 */
	private String deliveryDateLimit;
	/** 是否开票 */
	private String invoiceFlg;
	/** 发票抬头ID */
	private BigDecimal invTitleId;
	/** 发票抬头(公司名称) */
	private String invTitle;
	/** 当前状态下是否可修改订单 */
	private String canModifyFlg;
	/**
	 * 订单状态:</br>待支付WAITPAYMENT、处理中INPROCESS、未发货WAITDELIVER、已发货DELIVERED、
	 * 退单中RETURNSING、交易成功SUCCESS、交易关闭CLOSE</br>
	 * 在线支付未支付并提交订单时状态为待支付，支付并提交订单状态为未发货，方便后台处理
	 */
	private String statusFlg;
	/**
	 * 订单子状态:</br>待打印WAITPRINT、待发货WAITDELIVER、已发货DELIVERED</br>
	 * 当订单状态为INPROCESSD时，对应以上三个子状态，目前其他订单状态没有子状态
	 */
	private String subStatus;
	/** 付款状态，未支付WAITPAYMENT、已支付PAID、支付中（部分付款）PAYMENTPROCESS、已退款REFUNDMENT */
	private String payStatus;
	/** 买家备注 */
	private String remark;
	/** 订单生成日期 */
	private Timestamp createDate;
	/** 订单修日期 */
	private Timestamp modifyDate;
	/** 收货人地址ID */
	private BigDecimal addressNo;
	/** 订单优惠金额，如优惠券支付、积分支付 */
	private BigDecimal miscPayAmt;
	/**代店下单的业务员id*/
	private BigDecimal spUserNo;
	/**代店下单的业务员姓名*/
	private String spName;
	/**配送地址的3级区域的ID*/
	private BigDecimal areaId; 
	/**订单汇总状态*/
	private String vendorMergeFlg;
	/**优惠套餐code*/
	private String comboCode;
	/**优惠套餐购买数量*/
	private BigDecimal comboQty;
	/**中心仓按目标仓库合并发货标记*/
	private String whMergeFlg;
	/**目标接收仓库*/
	private String fbpLbpWhc; 
	private String batchId;
	/**配送人员编码*/
	private String logisticUserCode;
	/**配送人员姓名*/
	private String logisticUserName;
	/**异常订单标记*/
	private String diffRetFlg;
	private String modifyqty2Flg;
	private String refundFlg;
	private String refundSn;
	/**库存凭证*/
	private BigDecimal stkBatchNo;
	/** 订单主表商品评价字段是否已评价，默认为N,已评价为Y */
	private String commentFlg;
	/** 订单主表物流评价字段“Y”为已评价，默认为N,已评价为Y */
	private String logisticsCommentFlg;
	/** 订单主表拣货人员no */
	private BigDecimal pickUserNo;
	/** 订单是否拣货完成 ，默认"N"未成功 */
	private String pickFlg;
	/** 订单是否分账，完成的状态“E”*/
	private String disasmState;
	
	public OrderMas() {
	}
	
	
	/** full constructor */
	
	// Property accessors
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_ORDER_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "PK_NO", unique = true, nullable = false, precision = 22, scale = 0)
	public BigDecimal getPkNo() {
		return this.pkNo;
	}

	public OrderMas(BigDecimal pkNo, Timestamp masDate, String masNo,
					String masCode, BigDecimal orgNo, BigDecimal comNo,
					BigDecimal locNo, BigDecimal refPkNo, String internalFlg,
					BigDecimal srcPkNo, BigDecimal userNo, String custName,
					String custCode, BigDecimal qty, BigDecimal amount,
					BigDecimal vendorUserNo, String vendorName, String vendorCode,
					String source, String paymentType, String deliveryType,
					BigDecimal scPkNo, String orderType, String whC,
					String receiverName, String receiverTel, String receiverMobile,
					String receiverAddress, String receiverZip,
					Timestamp custCloseDate, String custCloseDesc,
					Timestamp vendorCloseDate, String vendorCloseDesc,
					Timestamp paymentDate, String logisticCode, String wayBillNo,
					BigDecimal freight, String deliveryDateLimit, String invoiceFlg,
					BigDecimal invTitleId, String invTitle, String canModifyFlg,
					String statusFlg, String subStatus, String payStatus,
					String remark, Timestamp createDate, Timestamp modifyDate,
					BigDecimal addressNo, BigDecimal miscPayAmt, BigDecimal diffMiscAmt, BigDecimal spUserNo,
					String spName, BigDecimal areaId, String vendorMergeFlg,
					String comboCode, BigDecimal comboQty, String whMergeFlg,
					String fbpLbpWhc, String logisticUserCode, String diffRetFlg, BigDecimal stkBatchNo, String logisticsCommentFlg,
					String commentFlg, BigDecimal pickUserNo, String pickFlg, String disasmState) {
		super();
		this.pkNo = pkNo;
		this.masDate = masDate;
		this.masNo = masNo;
		this.masCode = masCode;
		this.orgNo = orgNo;
		this.comNo = comNo;
		this.locNo = locNo;
		this.refPkNo = refPkNo;
		this.internalFlg = internalFlg;
		this.srcPkNo = srcPkNo;
		this.userNo = userNo;
		this.custName = custName;
		this.custCode = custCode;
		this.qty = qty;
		this.amount = amount;
		this.vendorUserNo = vendorUserNo;
		this.vendorName = vendorName;
		this.vendorCode = vendorCode;
		this.source = source;
		this.paymentType = paymentType;
		this.deliveryType = deliveryType;
		this.scPkNo = scPkNo;
		this.orderType = orderType;
		this.whC = whC;
		this.receiverName = receiverName;
		this.receiverTel = receiverTel;
		this.receiverMobile = receiverMobile;
		this.receiverAddress = receiverAddress;
		this.receiverZip = receiverZip;
		this.custCloseDate = custCloseDate;
		this.custCloseDesc = custCloseDesc;
		this.vendorCloseDate = vendorCloseDate;
		this.vendorCloseDesc = vendorCloseDesc;
		this.paymentDate = paymentDate;
		this.logisticCode = logisticCode;
		this.wayBillNo = wayBillNo;
		this.freight = freight;
		this.deliveryDateLimit = deliveryDateLimit;
		this.invoiceFlg = invoiceFlg;
		this.invTitleId = invTitleId;
		this.invTitle = invTitle;
		this.canModifyFlg = canModifyFlg;
		this.statusFlg = statusFlg;
		this.subStatus = subStatus;
		this.payStatus = payStatus;
		this.remark = remark;
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.addressNo = addressNo;
		this.miscPayAmt = miscPayAmt;
		this.diffMiscAmt = diffMiscAmt;
		this.spUserNo = spUserNo;
		this.spName = spName;
		this.areaId = areaId;
		this.vendorMergeFlg = vendorMergeFlg;
		this.comboCode = comboCode;
		this.comboQty = comboQty;
		this.whMergeFlg = whMergeFlg;
		this.fbpLbpWhc = fbpLbpWhc;
		this.logisticUserCode = logisticUserCode;
		this.diffRetFlg = diffRetFlg;
		this.stkBatchNo = stkBatchNo;
		this.logisticsCommentFlg = logisticsCommentFlg;
		this.commentFlg = commentFlg;
		this.pickUserNo = pickUserNo;
		this.pickFlg = pickFlg;
		this.disasmState = disasmState;
	}

	public void setPkNo(BigDecimal pkNo) {
		this.pkNo = pkNo;
	}

	@Column(name = "WH_MERGE_FLG")
	public String getWhMergeFlg() {
		return whMergeFlg;
	}

	public void setWhMergeFlg(String whMergeFlg) {
		this.whMergeFlg = whMergeFlg;
	}

	@Column(name = "FBP_LBP_WH_C")
	public String getFbpLbpWhc() {
		return fbpLbpWhc;
	}

	public void setFbpLbpWhc(String fbpLbpWhc) {
		this.fbpLbpWhc = fbpLbpWhc;
	}
	
	@Column(name = "VENDOR_MERGE_FLG")
	public String getVendorMergeFlg() {
		return vendorMergeFlg;
	}

	public void setVendorMergeFlg(String vendorMergeFlg) {
		this.vendorMergeFlg = vendorMergeFlg;
	}

	@Column(name = "MAS_DATE", length = 7)
	public Timestamp getMasDate() {
		return this.masDate;
	}

	public void setMasDate(Timestamp masDate) {
		this.masDate = masDate;
	}

	@Column(name = "MAS_NO", length = 32)
	public String getMasNo() {
		return this.masNo;
	}

	public void setMasNo(String masNo) {
		this.masNo = masNo;
	}

	@Column(name = "MAS_CODE", length = 16)
	public String getMasCode() {
		return this.masCode;
	}

	public void setMasCode(String masCode) {
		this.masCode = masCode;
	}

	@Column(name = "ORG_NO", precision = 22, scale = 0)
	public BigDecimal getOrgNo() {
		return this.orgNo;
	}

	public void setOrgNo(BigDecimal orgNo) {
		this.orgNo = orgNo;
	}

	@Column(name = "COM_NO", precision = 22, scale = 0)
	public BigDecimal getComNo() {
		return this.comNo;
	}

	public void setComNo(BigDecimal comNo) {
		this.comNo = comNo;
	}

	@Column(name = "LOC_NO", precision = 22, scale = 0)
	public BigDecimal getLocNo() {
		return this.locNo;
	}

	public void setLocNo(BigDecimal locNo) {
		this.locNo = locNo;
	}

	@Column(name = "REF_PK_NO", precision = 22, scale = 0)
	public BigDecimal getRefPkNo() {
		return this.refPkNo;
	}

	public void setRefPkNo(BigDecimal refPkNo) {
		this.refPkNo = refPkNo;
	}

	@Column(name = "INTERNAL_FLG", length = 1)
	public String getInternalFlg() {
		return this.internalFlg;
	}

	public void setInternalFlg(String internalFlg) {
		this.internalFlg = internalFlg;
	}

	@Column(name = "SRC_PK_NO", precision = 22, scale = 0)
	public BigDecimal getSrcPkNo() {
		return this.srcPkNo;
	}

	public void setSrcPkNo(BigDecimal srcPkNo) {
		this.srcPkNo = srcPkNo;
	}

	@Column(name = "USER_NO", precision = 22, scale = 0)
	public BigDecimal getUserNo() {
		return this.userNo;
	}

	public void setUserNo(BigDecimal userNo) {
		this.userNo = userNo;
	}

	@Column(name = "CUST_NAME", length = 256)
	public String getCustName() {
		return this.custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	@Column(name = "QTY", precision = 22, scale = 0)
	public BigDecimal getQty() {
		return this.qty;
	}

	public void setQty(BigDecimal qty) {
		this.qty = qty;
	}

	@Column(name = "AMOUNT", precision = 22, scale = 0)
	public BigDecimal getAmount() {
		return this.amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	@Column(name = "VENDOR_USER_NO", precision = 22, scale = 0)
	public BigDecimal getVendorUserNo() {
		return this.vendorUserNo;
	}

	public void setVendorUserNo(BigDecimal vendorUserNo) {
		this.vendorUserNo = vendorUserNo;
	}

	@Column(name = "VENDOR_NAME", length = 256)
	public String getVendorName() {
		return this.vendorName;
	}

	public void setVendorName(String vendorName) {
		this.vendorName = vendorName;
	}

	@Column(name = "SOURCE", length = 1)
	public String getSource() {
		return this.source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	@Column(name = "SC_PK_NO", precision = 22, scale = 0)
	public BigDecimal getScPkNo() {
		return scPkNo;
	}

	public void setScPkNo(BigDecimal scPkNo) {
		this.scPkNo = scPkNo;
	}

	@Column(name = "DELIVERY_TYPE", length = 1)
	public String getDeliveryType() {
		return this.deliveryType;
	}

	public void setDeliveryType(String deliveryType) {
		this.deliveryType = deliveryType;
	}

	@Column(name = "PAYMENT_TYPE", length = 256)
	public String getPaymentType() {
		return this.paymentType;
	}

	public void setPaymentType(String paymentType) {
		this.paymentType = paymentType;
	}

	@Column(name = "ORDER_TYPE", length = 16)
	public String getOrderType() {
		return this.orderType;
	}

	public void setOrderType(String orderType) {
		this.orderType = orderType;
	}

	@Column(name = "WH_C", length = 16)
	public String getWhC() {
		return this.whC;
	}

	public void setWhC(String whC) {
		this.whC = whC;
	}

	@Column(name = "RECEIVER_NAME", length = 128)
	public String getReceiverName() {
		return this.receiverName;
	}

	public void setReceiverName(String receiverName) {
		this.receiverName = receiverName;
	}

	@Column(name = "RECEIVER_TEL", length = 32)
	public String getReceiverTel() {
		return this.receiverTel;
	}

	public void setReceiverTel(String receiverTel) {
		this.receiverTel = receiverTel;
	}

	@Column(name = "RECEIVER_MOBILE", length = 32)
	public String getReceiverMobile() {
		return this.receiverMobile;
	}

	public void setReceiverMobile(String receiverMobile) {
		this.receiverMobile = receiverMobile;
	}

	@Column(name = "RECEIVER_ADDRESS", length = 512)
	public String getReceiverAddress() {
		return this.receiverAddress;
	}

	public void setReceiverAddress(String receiverAddress) {
		this.receiverAddress = receiverAddress;
	}

	@Column(name = "RECEIVER_ZIP", length = 16)
	public String getReceiverZip() {
		return this.receiverZip;
	}

	public void setReceiverZip(String receiverZip) {
		this.receiverZip = receiverZip;
	}

	@Column(name = "CUST_CLOSE_DATE", length = 7)
	public Timestamp getCustCloseDate() {
		return this.custCloseDate;
	}

	public void setCustCloseDate(Timestamp custCloseDate) {
		this.custCloseDate = custCloseDate;
	}

	@Column(name = "CUST_CLOSE_DESC", length = 512)
	public String getCustCloseDesc() {
		return this.custCloseDesc;
	}

	public void setCustCloseDesc(String custCloseDesc) {
		this.custCloseDesc = custCloseDesc;
	}

	@Column(name = "VENDOR_CLOSE_DATE", length = 7)
	public Timestamp getVendorCloseDate() {
		return this.vendorCloseDate;
	}

	public void setVendorCloseDate(Timestamp vendorCloseDate) {
		this.vendorCloseDate = vendorCloseDate;
	}

	@Column(name = "VENDOR_CLOSE_DESC", length = 512)
	public String getVendorCloseDesc() {
		return this.vendorCloseDesc;
	}

	public void setVendorCloseDesc(String vendorCloseDesc) {
		this.vendorCloseDesc = vendorCloseDesc;
	}

	@Column(name = "PAYMENT_DATE", length = 7)
	public Timestamp getPaymentDate() {
		return this.paymentDate;
	}

	public void setPaymentDate(Timestamp paymentDate) {
		this.paymentDate = paymentDate;
	}

	@Column(name = "LOGISTIC_CODE", length = 32)
	public String getLogisticCode() {
		return this.logisticCode;
	}

	public void setLogisticCode(String logisticCode) {
		this.logisticCode = logisticCode;
	}

	@Column(name = "WAY_BILL_NO", length = 64)
	public String getWayBillNo() {
		return this.wayBillNo;
	}

	public void setWayBillNo(String wayBillNo) {
		this.wayBillNo = wayBillNo;
	}

	@Column(name = "FREIGHT", precision = 22, scale = 0)
	public BigDecimal getFreight() {
		return this.freight;
	}

	public void setFreight(BigDecimal freight) {
		if(null==freight){
			freight=new BigDecimal(0);
		}
		this.freight = freight;
	}

	@Column(name = "DELIVERY_DATE_LIMIT", length = 1)
	public String getDeliveryDateLimit() {
		return this.deliveryDateLimit;
	}

	public void setDeliveryDateLimit(String deliveryDateLimit) {
		this.deliveryDateLimit = deliveryDateLimit;
	}

	@Column(name = "INVOICE_FLG", length = 1)
	public String getInvoiceFlg() {
		return this.invoiceFlg;
	}

	public void setInvoiceFlg(String invoiceFlg) {
		this.invoiceFlg = invoiceFlg;
	}

	@Column(name = "INV_TITLE_ID", precision = 22, scale = 0)
	public BigDecimal getInvTitleId() {
		return this.invTitleId;
	}

	public void setInvTitleId(BigDecimal invTitleId) {
		this.invTitleId = invTitleId;
	}

	@Column(name = "INV_TITLE", length = 512)
	public String getInvTitle() {
		return this.invTitle;
	}

	public void setInvTitle(String invTitle) {
		this.invTitle = invTitle;
	}

	@Column(name = "CAN_MODIFY_FLG", length = 1)
	public String getCanModifyFlg() {
		return this.canModifyFlg;
	}

	public void setCanModifyFlg(String canModifyFlg) {
		this.canModifyFlg = canModifyFlg;
	}

	@Column(name = "STATUS_FLG", length = 1)
	public String getStatusFlg() {
		return this.statusFlg;
	}

	public void setStatusFlg(String statusFlg) {
		this.statusFlg = statusFlg;
	}

	@Column(name = "SUB_STATUS", length = 1)
	public String getSubStatus() {
		return subStatus;
	}

	public void setSubStatus(String subStatus) {
		this.subStatus = subStatus;
	}

	@Column(name = "PAY_STATUS", length = 1)
	public String getPayStatus() {
		return this.payStatus;
	}

	public void setPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}

	@Column(name = "REMARK", length = 512)
	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	@Column(name = "CREATE_DATE", length = 7)
	public Timestamp getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Timestamp createDate) {
		this.createDate = createDate;
	}

	@Column(name = "MODIFY_DATE", length = 7)
	public Timestamp getModifyDate() {
		return this.modifyDate;
	}

	public void setModifyDate(Timestamp modifyDate) {
		this.modifyDate = modifyDate;
	}

	@Column(name = "ADDRESS_NO", precision = 22, scale = 0)
	public BigDecimal getAddressNo() {
		return this.addressNo;
	}

	public void setAddressNo(BigDecimal addressNo) {
		this.addressNo = addressNo;
	}

	@Column(name = "CUST_CODE", length = 32)
	public String getCustCode() {
		return custCode;
	}

	public void setCustCode(String custCode) {
		this.custCode = custCode;
	}

	@Column(name = "VENDOR_CODE", length = 32)
	public String getVendorCode() {
		return vendorCode;
	}
	
	public void setVendorCode(String vendorCode) {
		this.vendorCode = vendorCode;
	}

	@Column(name = "MISC_PAY_AMT", precision = 22, scale = 0)
	public BigDecimal getMiscPayAmt() {
		return this.miscPayAmt;
	}

	public void setMiscPayAmt(BigDecimal miscPayAmt) {
		if(null==miscPayAmt){
			miscPayAmt=new BigDecimal(0);
		}
		this.miscPayAmt = miscPayAmt;
	}
	
	@Column(name = "SP_USER_NO", precision = 22, scale = 0)
	public BigDecimal getSpUserNo() {
		return this.spUserNo;
	}

	public void setSpUserNo(BigDecimal spUserNo) {
		this.spUserNo = spUserNo;
	}

	@Column(name = "SP_NAME", length = 32)
	public String getSpName() {
		return this.spName;
	}

	public void setSpName(String spName) {
		this.spName = spName;
	}

	@Column(name = "AREA_ID")
	public BigDecimal getAreaId() {
		return areaId;
	}

	public void setAreaId(BigDecimal areaId) {
		this.areaId = areaId;
	}

	@Column(name = "COMBO_CODE", length = 32)
	public String getComboCode() {
		return comboCode;
	}

	public void setComboCode(String comboCode) {
		this.comboCode = comboCode;
	}

	@Column(name = "COMBO_QTY ", precision = 22, scale = 0)
	public BigDecimal getComboQty() {
		return comboQty;
	}

	public void setComboQty(BigDecimal comboQty) {
		this.comboQty = comboQty;
	}

	@Column(name = "DIFF_MISC_AMT", precision = 22, scale = 0)
	public BigDecimal getDiffMiscAmt() {
		return diffMiscAmt;
	}

	public void setDiffMiscAmt(BigDecimal diffMiscAmt) {
		if(null==diffMiscAmt){
			diffMiscAmt=new BigDecimal(0);
		}
		this.diffMiscAmt = diffMiscAmt;
	}

	@Column(name = "BATCH_ID", length = 32)
	public String getBatchId() {
		return batchId;
	}


	public void setBatchId(String batchId) {
		this.batchId = batchId;
	}

	@Column(name="LOGISTIC_USER_CODE",length=16)
	public String getLogisticUserCode() {
		return logisticUserCode;
	}

	public void setLogisticUserCode(String logisticUserCode) {
		this.logisticUserCode = logisticUserCode;
	}

	@Transient
	public String getLogisticUserName() {
		return logisticUserName;
	}

	public void setLogisticUserName(String logisticUserName) {
		this.logisticUserName = logisticUserName;
	}
	@Column(name = "DIFF_RET_FLG", length = 1)
	 public String getDiffRetFlg() {
	  return diffRetFlg;
	 }

	 public void setDiffRetFlg(String diffRetFlg) {
	  this.diffRetFlg = diffRetFlg;
	 }
	 
	@Column(name = "MODIFYQTY2_FLG", length = 1)
	public String getModifyqty2Flg() {
		return modifyqty2Flg;
	}

	public void setModifyqty2Flg(String modifyqty2Flg) {
		this.modifyqty2Flg = modifyqty2Flg;
	}	

	@Column(name = "REFUND_FLG", length = 1)
	public String getRefundFlg() {
		return refundFlg;
	}


	public void setRefundFlg(String refundFlg) {
		this.refundFlg = refundFlg;
	}

	@Column(name = "REFUND_SN", length = 32)
	public String getRefundSn() {
		return refundSn;
	}


	public void setRefundSn(String refundSn) {
		this.refundSn = refundSn;
	}

	@Column(name = "STK_BATCH_NO", precision = 22, scale = 0)
	public BigDecimal getStkBatchNo() {
		return stkBatchNo;
	}


	public void setStkBatchNo(BigDecimal stkBatchNo) {
		this.stkBatchNo = stkBatchNo;
	}
	
	@Column(name = "COMMENT_FLG", length = 1)
	public String getCommentFlg() {
		return this.commentFlg;
	}

	public void setCommentFlg(String commentFlg) {
		this.commentFlg = commentFlg;
	}
	
	@Column(name = "LOGISTICS_COMMENT_FLG", length = 1)
	public String getLogisticsCommentFlg() {
		return this.logisticsCommentFlg;
	}

	public void setLogisticsCommentFlg(String logisticsCommentFlg) {
		this.logisticsCommentFlg = logisticsCommentFlg;
	}
	
	@Column(name = "PICK_USER_NO", length = 1)
	public BigDecimal getPickUserNo() {
		return this.pickUserNo;
	}
	
	public void setPickUserNo(BigDecimal pickUserNo) {
		this.pickUserNo = pickUserNo;
	}
	
	@Column(name = "PICK_FLG", length = 1)
	public String getPickFlg() {
		return this.pickFlg;
	}
	
	public void setPickFlg(String pickFlg) {
		this.pickFlg = pickFlg;
	}
	
	@Column(name = "DISASM_STATE", length = 1)
	public String getDisasmState() {
		return this.disasmState;
	}
	
	public void setDisasmState(String disasmState) {
		this.disasmState = disasmState;
	}
	
}