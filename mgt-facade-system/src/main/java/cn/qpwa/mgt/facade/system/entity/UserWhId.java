package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.Column;

/**
 * UserWhId entity. @author MyEclipse Persistence Tools
 */

public class UserWhId implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String userName; //为SCUSER.USER_NAME，即所有可登录平台的供应商/物流商主账户及下属账户
	private String whC; //仓库

	// Constructors

	/** default constructor */
	public UserWhId() {
	}

	/** full constructor */
	public UserWhId(String userName, String whC) {
		this.userName = userName;
		this.whC = whC;
	}

	// Property accessors

	@Column(name = "USER_NAME", nullable = false, length = 16)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "WH_C", nullable = false, length = 16)
	public String getWhC() {
		return this.whC;
	}

	public void setWhC(String whC) {
		this.whC = whC;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof UserWhId))
			return false;
		UserWhId castOther = (UserWhId) other;

		return ((this.getUserName() == castOther.getUserName()) || (this
				.getUserName() != null && castOther.getUserName() != null && this
				.getUserName().equals(castOther.getUserName())))
				&& ((this.getWhC() == castOther.getWhC()) || (this.getWhC() != null
						&& castOther.getWhC() != null && this.getWhC().equals(
						castOther.getWhC())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getUserName() == null ? 0 : this.getUserName().hashCode());
		result = 37 * result
				+ (getWhC() == null ? 0 : this.getWhC().hashCode());
		return result;
	}

}