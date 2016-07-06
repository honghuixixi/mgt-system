package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * 角色据库访问实体类
 * 
 */
@Entity
@Table(name = "MGT_ROLE")
public class MgtRole implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -6661118734343133057L;
	/* 名称 */
	private String name;
	/* 状态1.启动,0.禁用. */
	private String status;
	/* 描述 */
	private String memo;
	/* 所属商户编号 */
	private String merchantCode;
	/* 是否可见1.可见，0.不可见 */
	private String visible;
	/* 主键ID */
	private String id;

	@Id
	@GeneratedValue(generator="uuid2")
	@GenericGenerator(name="uuid2", strategy = "uuid")
	@Column(name = "ID", nullable = false, length = 32)
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	@Column(name = "MERCHANT_CODE", length = 32)
	public String getMerchantCode() {
		return merchantCode;
	}

	public void setMerchantCode(String merchantCode) {
		this.merchantCode = merchantCode;
	}

	@Column(name = "NAME", length = 32)
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name = "STATUS", length = 8)
	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	@Column(name = "MEMO", length = 500)
	public String getMemo() {
		return this.memo;
	}

	public void setMemo(String memo) {
		this.memo = memo;
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
	/** 角色工作域：1=superadmin，2=公共的角色，3=商家下私有角色 */
    private String scope ;
    
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

	@Column(name = "VISIBLE", length = 20)
	public String getVisible() {
		return visible;
	}

	public void setVisible(String visible) {
		this.visible = visible;
	}
	@Column(name = "SCOPE", length = 8)
	public String getScope() {
		return this.scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}
	
}