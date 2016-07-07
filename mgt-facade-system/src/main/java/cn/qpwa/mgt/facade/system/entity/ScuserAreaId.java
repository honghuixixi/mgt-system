package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.Column;
import javax.persistence.Embeddable;
import java.math.BigDecimal;

/**
 * ScuserAreaId entity. @author MyEclipse Persistence Tools
 */
@Embeddable
public class ScuserAreaId implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = -2469261210535000398L;
	private String userName;
	private BigDecimal areaId;

	// Constructors

	/** default constructor */
	public ScuserAreaId() {
	}

	/** full constructor */
	public ScuserAreaId(String userName, BigDecimal areaId) {
		this.userName = userName;
		this.areaId = areaId;
	}

	// Property accessors

	@Column(name = "USER_NAME", nullable = false, length = 16)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "AREA_ID", nullable = false, precision = 22, scale = 0)
	public BigDecimal getAreaId() {
		return this.areaId;
	}

	public void setAreaId(BigDecimal areaId) {
		this.areaId = areaId;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ScuserAreaId))
			return false;
		ScuserAreaId castOther = (ScuserAreaId) other;

		return ((this.getUserName() == castOther.getUserName()) || (this
				.getUserName() != null && castOther.getUserName() != null && this
				.getUserName().equals(castOther.getUserName())))
				&& ((this.getAreaId() == castOther.getAreaId()) || (this
						.getAreaId() != null && castOther.getAreaId() != null && this
						.getAreaId().equals(castOther.getAreaId())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getUserName() == null ? 0 : this.getUserName().hashCode());
		result = 37 * result
				+ (getAreaId() == null ? 0 : this.getAreaId().hashCode());
		return result;
	}

}