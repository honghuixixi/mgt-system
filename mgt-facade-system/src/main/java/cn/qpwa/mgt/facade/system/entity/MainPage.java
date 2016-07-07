package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;
import java.util.Date;

/**
 * MainPage entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "MAIN_PAGE")
public class MainPage implements java.io.Serializable {

	private static final long serialVersionUID = 2813591874522087657L;
	// Fields

	/**主键*/
	private BigDecimal pkNo;
	/**区域数据代号*/
	private String type;
	/**区域名称*/
	private String boxName;
	/***/
	private BigDecimal boxWidth;
	/**排序参数*/
	private BigDecimal sortNo;
	/**是否展示（"Y"：展示）*/
	private String showFlg;
	/**修改日期*/
	private Timestamp modifyDate;
	/**创建日期*/
	private Timestamp createDate;
	/**对应的大类类别Id*/
	private BigDecimal catId;
    /**平台类型**/
	private String prodType;
	/**一级区域Id*/
	private String areaId;
	// Constructors

	/** default constructor */
	public MainPage() {
	}

	/** full constructor */
	public MainPage(String type, String boxName, BigDecimal boxWidth,
					BigDecimal sortNo, String showFlg, Timestamp modifyDate,
					Timestamp createDate, BigDecimal catId, String prodType, String areaId) {
		this.type = type;
		this.boxName = boxName;
		this.boxWidth = boxWidth;
		this.sortNo = sortNo;
		this.showFlg = showFlg;
		this.modifyDate = modifyDate;
		this.createDate = createDate;
		this.catId = catId;
		this.prodType = prodType;
		this.areaId = areaId;
	}
	@Column(name = "AREA_ID", length = 16)
	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
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

	@Column(name = "TYPE", length = 8)
	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	@Column(name = "BOX_NAME", length = 256)
	public String getBoxName() {
		return this.boxName;
	}

	public void setBoxName(String boxName) {
		this.boxName = boxName;
	}

	@Column(name = "BOX_WIDTH", precision = 22, scale = 0)
	public BigDecimal getBoxWidth() {
		return this.boxWidth;
	}

	public void setBoxWidth(BigDecimal boxWidth) {
		this.boxWidth = boxWidth;
	}

	@Column(name = "SORT_NO", precision = 22, scale = 0)
	public BigDecimal getSortNo() {
		return this.sortNo;
	}

	public void setSortNo(BigDecimal sortNo) {
		this.sortNo = sortNo;
	}

	@Column(name = "SHOW_FLG", length = 1)
	public String getShowFlg() {
		return this.showFlg;
	}

	public void setShowFlg(String showFlg) {
		this.showFlg = showFlg;
	}

	@Column(name = "MODIFY_DATE", length = 7)
	public Date getModifyDate() {
		return this.modifyDate;
	}

	public void setModifyDate(Timestamp modifyDate) {
		this.modifyDate = modifyDate;
	}

	@Column(name = "CREATE_DATE", length = 7)
	public Date getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Timestamp createDate) {
		this.createDate = createDate;
	}

	@Column(name = "CAT_ID", precision = 22, scale = 0)
	public BigDecimal getCatId() {
		return this.catId;
	}

	public void setCatId(BigDecimal catId) {
		this.catId = catId;
	}
	@Column(name = "PROD_TYPE", length = 16)
	public String getProdType() {
		return prodType;
	}

	public void setProdType(String prodType) {
		this.prodType = prodType;
	}

	
}