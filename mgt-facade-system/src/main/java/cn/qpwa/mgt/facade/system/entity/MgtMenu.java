package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.io.Serializable;
import java.util.Date;

/**
 * 菜单据库访问实体类
 */
@Entity
@Table(name = "MGT_MENU")
public class MgtMenu implements Serializable {

	private static final long serialVersionUID = 8101378185861361450L;
	/* 菜单名称 */
	private String name;
	/* 菜单code */
	private String code;
	/* 背景图 */
	private String imgSrc;
	/* 菜单URL */
	private String url;
	/* 父菜单 */
	private String pId;
	/* 排序 */
	private Integer sortby;
	/* 是否可见1.可见，0.不可见 */
	private String visible;
	/*内容*/
	private String content;
	/*描述*/
	private String description;
	/*菜单关联模块信息*/
	private Integer moduleId;

	@Column(name = "DESCRIPTION")
	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}


	@Column(name = "CONTENT")
	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public MgtMenu() {
	}

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

	@Column(name = "NAME", length = 82)
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name = "URL", length = 300)
	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	@Column(name = "CODE", length = 32)
	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	@Column(name = "IMGSRC", length = 32)
	public String getImgSrc() {
		return imgSrc;
	}

	public void setImgSrc(String imgSrc) {
		this.imgSrc = imgSrc;
	}

	@Column(name = "PID", length = 32)
	public String getPId() {
		return pId;
	}

	public void setPId(String pId) {
		this.pId = pId;
	}

	@Column(name = "SORTBY", length = 8)
	public Integer getSortby() {
		return sortby;
	}

	public void setSortby(Integer sortby) {
		this.sortby = sortby;
	}

	@Column(name = "VISIBLE", length = 20)
	public String getVisible() {
		return visible;
	}

	public void setVisible(String visible) {
		this.visible = visible;
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

	@Column(name = "MODULE_ID")
	public Integer getModuleId() {
		return moduleId;
	}

	public void setModuleId(Integer moduleId) {
		this.moduleId = moduleId;
	}
}
