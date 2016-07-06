package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * SiteArticleCategory entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "SITE_ARTICLE_CATEGORY")
public class SiteArticleCategory implements java.io.Serializable {

	private static final long serialVersionUID = -6661118734343133057L;
	/* 类别ID */
	private BigDecimal acId;
	/* 创建时间 */
	private Date createDate;
	/* 修改时间 */
	private Date modifyDate;
	/* 排序 */
	private Long orders;
	/* 类别级别 */
	private Long grade;
	/* 类别名称 */
	private String name;
	/* 搜索描述 */
	private String seoDescription;
	/* 搜索关键字 */
	private String seoKeywords;
	/* 所搜标题 */
	private String seoTitle;
	/* 树路径 */
	private String treePath;
	/* 父类ID */
	private BigDecimal parentAcId;


	/** default constructor */
	public SiteArticleCategory() {
	}

	/** minimal constructor */
	public SiteArticleCategory(Date createDate, Date modifyDate, Long grade,
			String name, String treePath) {
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.grade = grade;
		this.name = name;
		this.treePath = treePath;
	}

	/** full constructor */
	public SiteArticleCategory(SiteArticleCategory siteArticleCategory,
			Date createDate, Date modifyDate, Long orders, Long grade,
			String name, String seoDescription, String seoKeywords,
			String seoTitle, String treePath,BigDecimal parentAcId) {
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.orders = orders;
		this.grade = grade;
		this.name = name;
		this.seoDescription = seoDescription;
		this.seoKeywords = seoKeywords;
		this.seoTitle = seoTitle;
		this.treePath = treePath;
		this.parentAcId = parentAcId;
	}

	// Property accessors
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SITE_ARTICLE_CATEGORY_SEQ_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "AC_ID", unique = true, nullable = false, scale = 0)
	public BigDecimal getAcId() {
		return this.acId;
	}

	public void setAcId(BigDecimal acId) {
		this.acId = acId;
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

	@Column(name = "ORDERS", precision = 10, scale = 0)
	public Long getOrders() {
		return this.orders;
	}

	public void setOrders(Long orders) {
		this.orders = orders;
	}

	@Column(name = "GRADE", nullable = false, precision = 10, scale = 0)
	public Long getGrade() {
		return this.grade;
	}

	public void setGrade(Long grade) {
		this.grade = grade;
	}

	@Column(name = "NAME", nullable = false)
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name = "SEO_DESCRIPTION")
	public String getSeoDescription() {
		return this.seoDescription;
	}

	public void setSeoDescription(String seoDescription) {
		this.seoDescription = seoDescription;
	}

	@Column(name = "SEO_KEYWORDS")
	public String getSeoKeywords() {
		return this.seoKeywords;
	}

	public void setSeoKeywords(String seoKeywords) {
		this.seoKeywords = seoKeywords;
	}

	@Column(name = "SEO_TITLE")
	public String getSeoTitle() {
		return this.seoTitle;
	}

	public void setSeoTitle(String seoTitle) {
		this.seoTitle = seoTitle;
	}

	@Column(name = "TREE_PATH", nullable = false)
	public String getTreePath() {
		return this.treePath;
	}

	public void setTreePath(String treePath) {
		this.treePath = treePath;
	}
	
	@Column(name = "PARENT_AC_ID")
	public BigDecimal getParentAcId() {
		return this.parentAcId;
	}
	
	public void setParentAcId(BigDecimal parentAcId) {
		this.parentAcId = parentAcId;
	}
}