package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.util.Date;

/**
 * SubaccountOper entity. @author MyEclipse Persistence Tools
 * 客户子账户冻结/注销流水
 */
@Entity
@Table(name = "SUBACCOUNT_OPER")
public class SubaccountOper implements java.io.Serializable {

	private static final long serialVersionUID = 4373641943816169240L;
	/**主键id 流水号*/
	private Long id;
	/**客户号*/
	private String custId;
	/**客户名*/
	private String custName;
	/**子账户类型*/
	private String subaccountType;
	/**操作类型*/
	private String opertype;
	/**操作时间*/
	private Date createTime;
	/**操作员*/
	private String operator;
	/**备注*/
	private String remark;

	public SubaccountOper() {
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

	@Column(name = "CUST_NAME", length = 100)
	public String getCustName() {
		return this.custName;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	@Column(name = "SUBACCOUNT_TYPE", length = 4)
	public String getSubaccountType() {
		return this.subaccountType;
	}

	public void setSubaccountType(String subaccountType) {
		this.subaccountType = subaccountType;
	}

	@Column(name = "OPERTYPE", length = 1)
	public String getOpertype() {
		return this.opertype;
	}

	public void setOpertype(String opertype) {
		this.opertype = opertype;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "CREATE_TIME", length = 7)
	public Date getCreateTime() {
		return this.createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	@Column(name = "OPERATOR", length = 20)
	public String getOperator() {
		return this.operator;
	}

	public void setOperator(String operator) {
		this.operator = operator;
	}

	@Column(name = "REMARK", length = 100)
	public String getRemark() {
		return this.remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}