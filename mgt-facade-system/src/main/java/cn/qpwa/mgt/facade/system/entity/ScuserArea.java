package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;

/**
 * ScuserArea entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "SCUSER_AREA")
public class ScuserArea implements java.io.Serializable {
	// Fields
	/** 缓存名称 */
	public static final String CACHE_NAME = "ScuserArea";
	/**
	 * 
	 */
	private static final long serialVersionUID = 3463883615199770807L;
	
	private ScuserAreaId id;
	private BigDecimal areaGrade;
	private String createByUser;
	private String createByName;
	private Date createDate;

	// Constructors

	/** default constructor */
	public ScuserArea() {
	}

	/** minimal constructor */
	public ScuserArea(ScuserAreaId id) {
		this.id = id;
	}

	/** full constructor */
	public ScuserArea(ScuserAreaId id,
			BigDecimal areaGrade, String createByUser, String createByName,
			Date createDate) {
		this.id = id;
		this.areaGrade = areaGrade;
		this.createByUser = createByUser;
		this.createByName = createByName;
		this.createDate = createDate;
	}

	// Property accessors
	@EmbeddedId
	@AttributeOverrides({
			@AttributeOverride(name = "userName", column = @Column(name = "USER_NAME", nullable = false, length = 16)),
			@AttributeOverride(name = "areaId", column = @Column(name = "AREA_ID", nullable = false, precision = 22, scale = 0)) })
	public ScuserAreaId getId() {
		return this.id;
	}

	public void setId(ScuserAreaId id) {
		this.id = id;
	}
	
	@Column(name = "AREA_GRADE", precision = 22, scale = 0)
	public BigDecimal getAreaGrade() {
		return this.areaGrade;
	}

	public void setAreaGrade(BigDecimal areaGrade) {
		this.areaGrade = areaGrade;
	}

	@Column(name = "CREATE_BY_USER", length = 16)
	public String getCreateByUser() {
		return this.createByUser;
	}

	public void setCreateByUser(String createByUser) {
		this.createByUser = createByUser;
	}

	@Column(name = "CREATE_BY_NAME", length = 256)
	public String getCreateByName() {
		return this.createByName;
	}

	public void setCreateByName(String createByName) {
		this.createByName = createByName;
	}

	@Temporal(TemporalType.DATE)
	@Column(name = "CREATE_DATE", length = 7)
	public Date getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

}