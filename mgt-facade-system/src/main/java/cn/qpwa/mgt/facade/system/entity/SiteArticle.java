package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * SiteArticle entity. 
 * @author sunyang
 */
@Entity
@Table(name = "SITE_ARTICLE")
public class SiteArticle implements java.io.Serializable {

	private static final long serialVersionUID = -6661118734343133057L;
	/* 文章ID */
	private BigDecimal artId;
	/* 创建时间 */
	private Date createDate;
	/* 修改时间 */
	private Date modifyDate;
	/* 作者 */
	private String author;
	/* 内容 */
	private String content;
	/* 点击次数 */
	private BigDecimal hits;
	/* 是否发布 */
	private BigDecimal isPublication;
	/* 是否置顶 */
	private BigDecimal isTop;
	/* 搜索描述 */
	private String seoDescription;
	/* 搜索关键词 */
	private String seoKeywords;
	/* 搜索标题 */
	private String seoTitle;
	/* 文章标题 */
	private String artTitle;
	/* 所属类别ID */
	private BigDecimal acId;
	/* 排序 */
	private Long orders;


	/** default constructor */
	public SiteArticle() {
	}

	/** minimal constructor */
	public SiteArticle(Date createDate, Date modifyDate, BigDecimal hits,
			BigDecimal isPublication, BigDecimal isTop, String artTitle,
			BigDecimal acId) {
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.hits = hits;
		this.isPublication = isPublication;
		this.isTop = isTop;
		this.artTitle = artTitle;
		this.acId = acId;
	}

	/** full constructor */
	public SiteArticle(Date createDate, Date modifyDate, String author,
			String content, BigDecimal hits, BigDecimal isPublication,
			BigDecimal isTop, String seoDescription, String seoKeywords,
			String seoTitle, String artTitle, BigDecimal acId, Long orders) {
		this.createDate = createDate;
		this.modifyDate = modifyDate;
		this.author = author;
		this.content = content;
		this.hits = hits;
		this.isPublication = isPublication;
		this.isTop = isTop;
		this.seoDescription = seoDescription;
		this.seoKeywords = seoKeywords;
		this.seoTitle = seoTitle;
		this.artTitle = artTitle;
		this.acId = acId;
		this.orders = orders;
	}

	// Property accessors
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "SITE_ARTICLE_SEQ_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "ART_ID", unique = true, nullable = false, scale = 0)
	public BigDecimal getArtId() {
		return this.artId;
	}

	public void setArtId(BigDecimal artId) {
		this.artId = artId;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATE_DATE", nullable = false, length = 7)
	public Date getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "MODIFY_DATE", nullable = false, length = 7)
	public Date getModifyDate() {
		return this.modifyDate;
	}

	public void setModifyDate(Date modifyDate) {
		this.modifyDate = modifyDate;
	}

	@Column(name = "AUTHOR")
	public String getAuthor() {
		return this.author;
	}

	public void setAuthor(String author) {
		this.author = author;
	}

	@Column(name = "CONTENT")
	public String getContent() {
		return this.content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	@Column(name = "HITS", nullable = false, scale = 0)
	public BigDecimal getHits() {
		return this.hits;
	}

	public void setHits(BigDecimal hits) {
		this.hits = hits;
	}

	@Column(name = "IS_PUBLICATION", nullable = false, precision = 1, scale = 0)
	public BigDecimal getIsPublication() {
		return this.isPublication;
	}

	public void setIsPublication(BigDecimal isPublication) {
		this.isPublication = isPublication;
	}

	@Column(name = "IS_TOP", nullable = false, precision = 1, scale = 0)
	public BigDecimal getIsTop() {
		return this.isTop;
	}

	public void setIsTop(BigDecimal isTop) {
		this.isTop = isTop;
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

	@Column(name = "ART_TITLE", nullable = false)
	public String getArtTitle() {
		return this.artTitle;
	}

	public void setArtTitle(String artTitle) {
		this.artTitle = artTitle;
	}

	@Column(name = "AC_ID", nullable = false, scale = 0)
	public BigDecimal getAcId() {
		return this.acId;
	}

	public void setAcId(BigDecimal acId) {
		this.acId = acId;
	}

	@Column(name = "ORDERS", precision = 10, scale = 0)
	public Long getOrders() {
		return this.orders;
	}

	public void setOrders(Long orders) {
		this.orders = orders;
	}

}