package cn.qpwa.mgt.facade.system.entity;
// default package

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * AreaMasWeb entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "AREA_MAS_WEB")
public class AreaMasWeb implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	/**区域id*/
	private BigDecimal areaId;
	/**组织代码*/
	private BigDecimal orgNo;
	/**创建日期*/
	private Date createDate;
	/**修改日期*/
	private Date modifyDate;
	/**排序参数*/
	private BigDecimal sortNo;
	/**区域级别（1、2、3）*/
	private BigDecimal grade;
	/**区域名*/
	private String areaName;
	/**树形结构*/
	private String treePath;
	/**上级区域id*/
	private BigDecimal parentId;
	/**是否启用 Y是 N否*/
	private String statusFlg;
	// Constructors

	/** default constructor */
	public AreaMasWeb() {
	}

	/** minimal constructor */
	public AreaMasWeb(BigDecimal areaId, Date createDate, Date modifyDate,
					  BigDecimal grade, String areaName, String treePath) {
		this.areaId = areaId;
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.grade = grade;
		this.areaName = areaName;
		this.treePath = treePath;
	}

	/** full constructor */
	public AreaMasWeb(BigDecimal areaId, BigDecimal orgNo, Date createDate,
					  Date modifyDate, BigDecimal sortNo, BigDecimal grade,
					  String areaName, String treePath, BigDecimal parentId, String statusFlg) {
		this.areaId = areaId;
		this.orgNo = orgNo;
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.sortNo = sortNo;
		this.grade = grade;
		this.areaName = areaName;
		this.treePath = treePath;
		this.parentId = parentId;
		this.statusFlg = statusFlg;
	}

	// Property accessors
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_SYS_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "AREA_ID", unique = true, nullable = false, precision = 22, scale = 0)
	public BigDecimal getAreaId() {
		return this.areaId;
	}

	public void setAreaId(BigDecimal areaId) {
		this.areaId = areaId;
	}

	@Column(name = "ORG_NO", precision = 22, scale = 0)
	public BigDecimal getOrgNo() {
		return this.orgNo;
	}

	public void setOrgNo(BigDecimal orgNo) {
		this.orgNo = orgNo;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "CREATE_DATE", nullable = false, length = 7)
	public Date getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "MODIFY_DATE", nullable = false, length = 7)
	public Date getModifyDate() {
		return this.modifyDate;
	}

	public void setModifyDate(Date modifyDate) {
		this.modifyDate = modifyDate;
	}

	@Column(name = "SORT_NO", precision = 22, scale = 0)
	public BigDecimal getSortNo() {
		return this.sortNo;
	}

	public void setSortNo(BigDecimal sortNo) {
		this.sortNo = sortNo;
	}

	@Column(name = "GRADE", nullable = false, precision = 22, scale = 0)
	public BigDecimal getGrade() {
		return this.grade;
	}

	public void setGrade(BigDecimal grade) {
		this.grade = grade;
	}

	@Column(name = "AREA_NAME", nullable = false, length = 100)
	public String getAreaName() {
		return this.areaName;
	}

	public void setAreaName(String areaName) {
		this.areaName = areaName;
	}

	@Column(name = "TREE_PATH", nullable = false)
	public String getTreePath() {
		return this.treePath;
	}

	public void setTreePath(String treePath) {
		this.treePath = treePath;
	}

	@Column(name = "PARENT_ID", precision = 22, scale = 0)
	public BigDecimal getParentId() {
		return this.parentId;
	}

	public void setParentId(BigDecimal parentId) {
		this.parentId = parentId;
	}

	@Column(name = "STATUS_FLG", length = 1)
	public String getStatusFlg() {
		return this.statusFlg;
	}

	public void setStatusFlg(String statusFlg) {
		this.statusFlg = statusFlg;
	}
}