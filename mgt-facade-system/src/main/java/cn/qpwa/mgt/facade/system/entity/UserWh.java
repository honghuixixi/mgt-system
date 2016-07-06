package cn.qpwa.mgt.facade.system.entity;

import javax.persistence.*;
import java.sql.Timestamp;

/**
 * UserWh 仓库和可操作人员关系表 @author zld
 */

@Entity
@Table(name = "USER_WH")
public class UserWh implements java.io.Serializable {

	// Fields

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private UserWhId id;
	private String createUserName; //本记录由哪个账户加进来
	private Timestamp createDate;  //本记录加入时间

	// Constructors

	/** default constructor */
	public UserWh() {
	}

	/** minimal constructor */
	public UserWh(UserWhId id) {
		this.id = id;
	}

	/** full constructor */
	public UserWh(UserWhId id, String createUserName, Timestamp createDate) {
		this.id = id;
		this.createUserName = createUserName;
		this.createDate = createDate;
	}

	// Property accessors
	@EmbeddedId
	@AttributeOverrides({
			@AttributeOverride(name = "userName", column = @Column(name = "USER_NAME", nullable = false, length = 16)),
			@AttributeOverride(name = "whC", column = @Column(name = "WH_C", nullable = false, length = 16)) })
	public UserWhId getId() {
		return this.id;
	}

	public void setId(UserWhId id) {
		this.id = id;
	}

	@Column(name = "CREATE_USER_NAME", length = 16)
	public String getCreateUserName() {
		return this.createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	@Column(name = "CREATE_DATE", length = 7)
	public Timestamp getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Timestamp createDate) {
		this.createDate = createDate;
	}

}