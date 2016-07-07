package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * MainPageBox entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "MAIN_PAGE_BOX")
public class MainPageBox implements java.io.Serializable {

	private static final long serialVersionUID = 2813591874522087657L;
	// Fields

	/**主键*/
	private BigDecimal pkNo;
	/**外键*/
	private BigDecimal masPkNo;
	/**区域数据代号*/
	private String boxType;
	/**区域数据名称*/
	private String boxDesc;
	/**商品图片链接*/
	private String boxImg;
	/**排序参数*/
	private BigDecimal sortNo;
	/**是否展示（"T":展示）*/
	private String showType;
	/**点击链接*/
	private String href;
	private BigDecimal tagId;
	private String tagName;
	/**商品主键*/
	private String stkC;
	/**商品名*/
	private String stkName;
	private Timestamp validDate;
	/**修改日期*/
	private Timestamp modifyDate;
	/**创建日期*/
	private Timestamp createDate;
	/**WAP  网站对应的链接*/
	private String hrefWap;

	// Constructors

	/** default constructor */
	public MainPageBox() {
	}

	/** full constructor */
	public MainPageBox(BigDecimal masPkNo, String boxType, String boxDesc,
					   String boxImg, BigDecimal sortNo, String showType, String href,
					   BigDecimal tagId, String tagName, String stkC, String stkName,
					   Timestamp validDate, Timestamp modifyDate, Timestamp createDate, String hrefWap) {
		this.masPkNo = masPkNo;
		this.boxType = boxType;
		this.boxDesc = boxDesc;
		this.boxImg = boxImg;
		this.sortNo = sortNo;
		this.showType = showType;
		this.href = href;
		this.tagId = tagId;
		this.tagName = tagName;
		this.stkC = stkC;
		this.stkName = stkName;
		this.validDate = validDate;
		this.modifyDate = modifyDate;
		this.createDate = createDate;
		this.hrefWap = hrefWap;
	}

	// Property accessors
	@Id
	@SequenceGenerator(name = "sequenceGenerator", sequenceName = "MAIN_PAGE_SEQ_NO")
	@GeneratedValue(strategy = GenerationType.AUTO, generator = "sequenceGenerator")
	@Column(name = "PK_NO", unique = true, nullable = false, precision = 22, scale = 0)
	public BigDecimal getPkNo() {
		return this.pkNo;
	}

	public void setPkNo(BigDecimal pkNo) {
		this.pkNo = pkNo;
	}

	@Column(name = "MAS_PK_NO", precision = 22, scale = 0)
	public BigDecimal getMasPkNo() {
		return this.masPkNo;
	}

	public void setMasPkNo(BigDecimal masPkNo) {
		this.masPkNo = masPkNo;
	}

	@Column(name = "BOX_TYPE", length = 8)
	public String getBoxType() {
		return this.boxType;
	}

	public void setBoxType(String boxType) {
		this.boxType = boxType;
	}

	@Column(name = "BOX_DESC", length = 256)
	public String getBoxDesc() {
		return this.boxDesc;
	}

	public void setBoxDesc(String boxDesc) {
		this.boxDesc = boxDesc;
	}

	@Column(name = "BOX_IMG", length = 1024)
	public String getBoxImg() {
		return this.boxImg;
	}

	public void setBoxImg(String boxImg) {
		this.boxImg = boxImg;
	}

	@Column(name = "SORT_NO", precision = 22, scale = 0)
	public BigDecimal getSortNo() {
		return this.sortNo;
	}

	public void setSortNo(BigDecimal sortNo) {
		this.sortNo = sortNo;
	}

	@Column(name = "SHOW_TYPE", length = 1)
	public String getShowType() {
		return this.showType;
	}

	public void setShowType(String showType) {
		this.showType = showType;
	}

	@Column(name = "HREF", length = 1024)
	public String getHref() {
		return this.href;
	}

	public void setHref(String href) {
		this.href = href;
	}

	@Column(name = "TAG_ID", precision = 22, scale = 0)
	public BigDecimal getTagId() {
		return this.tagId;
	}

	public void setTagId(BigDecimal tagId) {
		this.tagId = tagId;
	}

	@Column(name = "TAG_NAME", length = 512)
	public String getTagName() {
		return this.tagName;
	}

	public void setTagName(String tagName) {
		this.tagName = tagName;
	}

	@Column(name = "STK_C", length = 32)
	public String getStkC() {
		return this.stkC;
	}

	public void setStkC(String stkC) {
		this.stkC = stkC;
	}

	@Column(name = "STK_NAME", length = 512)
	public String getStkName() {
		return this.stkName;
	}

	public void setStkName(String stkName) {
		this.stkName = stkName;
	}

	@Column(name = "VALID_DATE", length = 7)
	public Timestamp getValidDate() {
		return this.validDate;
	}

	public void setValidDate(Timestamp validDate) {
		this.validDate = validDate;
	}

	@Column(name = "MODIFY_DATE", length = 7)
	public Timestamp getModifyDate() {
		return this.modifyDate;
	}

	public void setModifyDate(Timestamp modifyDate) {
		this.modifyDate = modifyDate;
	}

	@Column(name = "CREATE_DATE", length = 7)
	public Timestamp getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Timestamp createDate) {
		this.createDate = createDate;
	}

	@Column(name = "HREF_WAP", length = 1024)
	public String getHrefWap() {
		return this.hrefWap;
	}

	public void setHrefWap(String hrefWap) {
		this.hrefWap = hrefWap;
	}

}