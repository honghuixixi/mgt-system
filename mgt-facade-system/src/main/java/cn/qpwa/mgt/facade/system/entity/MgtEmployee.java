package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 *用户据库访问实体类 
 *
 */
@Entity
@Table(name = "MGT_EMPLOYEE")
public class MgtEmployee implements Serializable {
	private static final long serialVersionUID = -259071886274442159L;

	/* 所属商户编号 */
	private String merchantCode;
	/* 用户登录账号 */
	private String accountName;
	/* 用户真实姓名 */
	private String userName;
	/* 用户编号 6 位 */
	private String userCode;
	/* 邮件 */
	private String email;
	/* 手机 */
	private String mobile;
	/* 电话 */
	private String tel;
	/* 会员标识 */
	private String customId;
	/* 图片URL */
	private String picUrl;
	/* 登陆密码 */
	private String password;
	/* 状态0：未启用 1：已启用 2:已删除 */
	private String status;
	/* 性别 */
	private String sex;
	/* 主键ID */
	private String id;
	/* 仓库主键 */
	private String whC;
	/*上级编号*/
	private String pId;
	/*生日*/
	private String birthday;
	/*身份证*/
	private String  identityCard;
	/*住址*/
	private String  address;
	/*备注*/
	private String  memo;
	
	/** 是否是配送员，默认不是，该字段用以控制是物流管理人员或配送人员 Y*/
	private String logisticsProviderFlg="N";
	
	/**是否是采购员，默认不是Y*/
	private String purchaserFlg="N";
	/**是否是销售员，默认不是*/
	private String salesmenFlg="N";
	/**是否锁定（该账户不允许登录ERP也不允许登录MGT），默认不是，此处的账号=主账号及其下属员工账号*/
	private String blockFlg="N";
	/**是否是分拣员，默认不是*/
	private String pickFlg="N";
 
	@Id
	@GeneratedValue(generator = "system-uuid")
	@GenericGenerator(name = "system-uuid", strategy = "uuid")
	@Column(name = "ID", nullable = false, length = 32)
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	@Column(name = "PID", length = 32)
	public String getPId() {
		return pId;
	}

	@Column(name = "MEMO")
	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
	}

	public void setPId(String pId) {
		this.pId = pId;
	}

	@Column(name = "MERCHANT_CODE", length = 32)
	public String getMerchantCode() {
		return merchantCode;
	}

	public void setMerchantCode(String merchantCode) {
		this.merchantCode = merchantCode;
	}

	@Column(name = "CUSTOM_ID", length = 32)
	public String getCustomId() {
		return this.customId;
	}

	public void setCustomId(String customId) {
		this.customId = customId;
	}

	@Column(name = "USER_NAME", length = 60)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "USER_CODE", length = 32)
	public String getUserCode() {
		return this.userCode;
	}

	public void setUserCode(String userCode) {
		this.userCode = userCode;
	}

	@Column(name = "EMAIL", length = 32)
	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	@Column(name = "MOBILE", length = 16)
	public String getMobile() {
		return this.mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	@Column(name = "TEL", length = 20)
	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	@Column(name = "PIC_URL", length = 200)
	public String getPicUrl() {
		return this.picUrl;
	}

	public void setPicUrl(String picUrl) {
		this.picUrl = picUrl;
	}

	@Column(name = "PASSWORD", length = 64)
	public String getPassword() {
		return this.password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	@Column(name = "STATUS", length = 8)
	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Column(name = "ACCOUNT_NAME", length = 60)
	public String getAccountName() {
		return this.accountName;
	}

	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}

	@Column(name = "SEX", length = 8)
	public String getSex() {
		return this.sex;
	}

	public void setSex(String sex) {
		this.sex = sex;
	}

	/** 创建人ID */
	private String createBy;

	/** 创建日期 */
	private Date createDate = new Date();

	/** 修改人ID */
	private String updateBy;

	/** 修改日期 */
	private Date updateDate;

	/** 版本 */
	private Integer version;

	@Column(name = "CREATE_BY", length = 32)
	public String getCreateBy() {
		return createBy;
	}

	public void setCreateBy(String createBy) {
		this.createBy = createBy;
	}

	@Column(name = "CREATE_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Column(name = "UPDATE_BY", length = 32)
	public String getUpdateBy() {
		return updateBy;
	}

	public void setUpdateBy(String updateBy) {
		this.updateBy = updateBy;
	}

	@Column(name = "UPDATE_DATE")
	@Temporal(TemporalType.TIMESTAMP)
	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	@Column(name = "VERSION")
	public Integer getVersion() {
		return version;
	}

	public void setVersion(Integer version) {
		this.version = version;
	}

	
	@Column(name = "WH_C")
	public String getWhC() {
		return whC;
	}

	public void setWhC(String whC) {
		this.whC = whC;
	}

	
	@Column(name = "BIRTHDAY")
	public String getBirthday() {
		return birthday;
	}

	public void setBirthday(String birthday) {
		this.birthday = birthday;
	}

	@Column(name = "IDENTITY_CARD")
	public String getIdentityCard() {
		return identityCard;
	}

	public void setIdentityCard(String identityCard) {
		this.identityCard = identityCard;
	}

	@Column(name = "ADDRESS")
	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}
	@Column(name = "LOGISTICS_PROVIDER_FLG",length=1)
	public String getLogisticsProviderFlg() {
		return logisticsProviderFlg;
	}

	public void setLogisticsProviderFlg(String logisticsProviderFlg) {
		this.logisticsProviderFlg = logisticsProviderFlg;
	}
	@Column(name = "PURCHASER_FLG",length=1)
	public String getPurchaserFlg() {
		return purchaserFlg;
	}

	public void setPurchaserFlg(String purchaserFlg) {
		this.purchaserFlg = purchaserFlg;
	}
	@Column(name = "SALESMEN_FLG",length=1)
	public String getSalesmenFlg() {
		return salesmenFlg;
	}

	public void setSalesmenFlg(String salesmenFlg) {
		this.salesmenFlg = salesmenFlg;
	}
	@Column(name = "BLOCK_FLG",length=1)
	public String getBlockFlg() {
		return blockFlg;
	}

	public void setBlockFlg(String blockFlg) {
		this.blockFlg = blockFlg;
	}
	@Column(name = "PICK_FLG",length=1)
	public String getPickFlg() {
		return pickFlg;
	}

	public void setPickFlg(String pickFlg) {
		this.pickFlg = pickFlg;
	}

	@Override
	public String toString() {
		return "MgtEmployee [merchantCode=" + merchantCode + ", accountName=" + accountName + ", userName=" + userName
				+ ", userCode=" + userCode + ", email=" + email + ", mobile=" + mobile + ", tel=" + tel + ", customId="
				+ customId + ", picUrl=" + picUrl + ", password=" + password + ", status=" + status + ", sex=" + sex
				+ ", id=" + id + ", createBy=" + createBy + ", createDate=" + createDate + ", updateBy=" + updateBy
				+ ", updateDate=" + updateDate + ", version=" + version + "]";
	}
}