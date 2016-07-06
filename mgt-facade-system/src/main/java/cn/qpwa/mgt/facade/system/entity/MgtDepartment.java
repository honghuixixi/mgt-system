package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * 部门据库访问实体类
 * 
 */
@Entity
 @Table(name = "MGT_DEPARTMENT")
public class MgtDepartment implements Serializable {

	private static final long serialVersionUID = 4345338315141135462L;
	/*
	 * 32 位部门编码
	 */
	private String departCode;
	/* 名称 */
	private String name;
	/* 所属商户编号 */
	private String merchantCode;
	/* 是否店面 0不是 1 是 */
	private String isStore = "0";
	/* 部门简称 */
	private String simpName;
	/* 父节点 */
	private String pId;
	/* 维度 */
	private String dimension;
	/* 经度 */
	private String longitude;
	/* 状态,1启用、2禁用 */
	private String status;
	/* 描述 */
	private String memo;
	/* 序号,用于记录部门树的层级 */
	private String seq;
	/* 来源渠道 本系统：qpwa 、 mgt */
	private String channel;
	/* 组织结构原code码 */
	private String originalCode;
	/* 织结构原父节点code码 */
	private String originalParentCode;
	/* 主键ID */
	private String id;

	public MgtDepartment() {

	}

	public MgtDepartment(String pId) {
		this.pId = pId;
	}


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

	@Column(name = "ORIGINAL_PARENT_CODE", length = 32)
	public String getOriginalParentCode() {
		return originalParentCode;
	}

	public void setOriginalParentCode(String originalParentCode) {
		this.originalParentCode = originalParentCode;
	}

	@Column(name = "MERCHANT_CODE", length = 32)
	public String getMerchantCode() {
		return merchantCode;
	}

	public void setMerchantCode(String merchantCode) {
		this.merchantCode = merchantCode;
	}

	@Column(name = "ORIGINAL_CODE", length = 32)
	public String getOriginalCode() {
		return originalCode;
	}

	public void setOriginalCode(String originalCode) {
		this.originalCode = originalCode;
	}

	@Column(name = "SIMP_NAME", length = 32)
	public String getSimpName() {
		return simpName;
	}

	public void setSimpName(String simpName) {
		this.simpName = simpName;
	}

	@Column(name = "IS_STORE", length = 2)
	public String getIsStore() {
		return isStore;
	}

	public void setIsStore(String isStore) {
		this.isStore = isStore;
	}

	@Column(name = "STATUS", length = 8)
	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Column(name = "DEPART_CODE")
	public String getDepartCode() {
		return departCode;
	}

	public void setDepartCode(String departCode) {
		this.departCode = departCode;
	}

	@Column(name = "MEMO", length = 500)
	public String getMemo() {
		return memo;
	}

	public void setMemo(String memo) {

		this.memo = memo;
	}

	@Column(name = "NAME", length = 255)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name = "PID", length = 32)
	public String getpId() {
		return pId;
	}

	public void setpId(String pId) {
		this.pId = pId;
	}

	@Column(name = "SEQ", length = 500)
	public String getSeq() {
		return seq;
	}

	public void setSeq(String seq) {
		this.seq = seq;
	}

	@Column(name = "DIMENSION", length = 30)
	public String getDimension() {
		return dimension;
	}

	public void setDimension(String dimension) {
		this.dimension = dimension;
	}

	@Column(name = "LONGITUDE", length = 30)
	public String getLongitude() {
		return longitude;
	}

	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}

	@Column(name = "CHANNEL", length = 30)
	public String getChannel() {
		return channel;
	}

	public void setChannel(String channel) {
		this.channel = channel;
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
}