package cn.qpwa.mgt.facade.system.entity;

import org.apache.commons.lang.StringUtils;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * 商品分类  
 * 
 * @author sunyang
 */
@Entity
@Table(name = "STK_CATEGORY")
public class StkCategory implements java.io.Serializable {

	// Fields

	private static final long serialVersionUID = -1304287376469442363L;
	/** 商品类别ID */
	private BigDecimal catId;
	/** 组织代码 */
	private BigDecimal orgNo;
	/** 创建日期 */
	private Date createDate;
	/** 修改日期 */
	private Date modifyDate;
	/** 排序*/
	private BigDecimal sortNo;
	/** 商品类别级别 */
	private BigDecimal grade;
	/** 商品类别名称*/
	private String catName;
	private String seoDescription;
	private String seoKeywords;
	private String seoTitle;
	/** 商品类别树路径 */
	private String treePath;
	/** 商品类别对应图片链接 */
	private String href;
	/** 商品类别父类ID */
	private BigDecimal parentId;
	/** 树路径分隔符 */
	public static final String TREE_PATH_SEPARATOR = ",";
	/** 访问路径前缀 */
	private static final String PATH_PREFIX = "/product/list";
	/** 访问路径后缀 */
	private static final String PATH_SUFFIX = ".jhtml";
	/** B2B商品类别名称*/
	private String b2bappName;;
	/** B2B商品类别图片*/
	private String urlAddr;
	
	// Constructors

	/** default constructor */
	public StkCategory() {
	}

	/** minimal constructor */
	public StkCategory(BigDecimal catId, Timestamp createDate,
					   Timestamp modifyDate, BigDecimal grade, String catName,
					   String treePath) {
		this.catId = catId;
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.grade = grade;
		this.catName = catName;
		this.treePath = treePath;
	}

	/** full constructor */
	public StkCategory(BigDecimal catId, BigDecimal orgNo, Date createDate,
					   Date modifyDate, BigDecimal sortNo, BigDecimal grade,
					   String catName, String seoDescription, String seoKeywords,
					   String seoTitle, String treePath, String href, BigDecimal parentId, String b2bappName) {
		this.catId = catId;
		this.orgNo = orgNo;
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.sortNo = sortNo;
		this.grade = grade;
		this.catName = catName;
		this.seoDescription = seoDescription;
		this.seoKeywords = seoKeywords;
		this.seoTitle = seoTitle;
		this.treePath = treePath;
		this.href = href;
		this.parentId = parentId;
		this.b2bappName = b2bappName;
	}

	// Property accessors
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SEQ_STK_GROUP_PK_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "CAT_ID", unique = true, nullable = false, precision = 22, scale = 0)
	public BigDecimal getCatId() {
		return this.catId;
	}

	public void setCatId(BigDecimal catId) {
		this.catId = catId;
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

	@Column(name = "CAT_NAME", nullable = false)
	public String getCatName() {
		return this.catName;
	}

	public void setCatName(String catName) {
		this.catName = catName;
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
	
	@Column(name = "HREF", nullable = false)
	public String getHref() {
		return this.href;
	}
	
	public void setHref(String href) {
		this.href = href;
	}

	@Column(name = "PARENT_ID", scale = 0)
	public BigDecimal getParentId() {
		return this.parentId;
	}

	public void setParentId(BigDecimal parentId) {
		this.parentId = parentId;
	}

	/**
	 * 获取树路径
	 * 
	 * @return 树路径
	 */
	@Transient
	public List<Long> getTreePaths() {
		List<Long> treePaths = new ArrayList<Long>();
		String[] ids = StringUtils.split(getTreePath(), TREE_PATH_SEPARATOR);
		if (ids != null) {
			for (String id : ids) {
				treePaths.add(Long.valueOf(id));
			}
		}
		return treePaths;
	}
	
	/**
	 * 获取访问路径
	 * 
	 * @return 访问路径
	 */
	@Transient
	public String getPath() {
		if (getCatId() != null) {
			return PATH_PREFIX + "/" + getCatId() + PATH_SUFFIX;
		}
		return null;
	}

	@Column(name = "B2BAPP_NAME", scale = 64)
	public String getB2bappName() {
		return b2bappName;
	}

	public void setB2bappName(String b2bappName) {
		this.b2bappName = b2bappName;
	}

	@Column(name = "URL_ADDR", scale = 128)
	public String getUrlAddr() {
		return urlAddr;
	}

	public void setUrlAddr(String urlAddr) {
		this.urlAddr = urlAddr;
	}
	
}