package cn.qpwa.mgt.facade.system.entity;


import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "ATTACHED_LUCKNUM")
public class AttachedLucknum implements java.io.Serializable {

	private static final long serialVersionUID = 1L;

	private String attachedAccount;

	/** default constructor */
	public AttachedLucknum() {
	}

	/** full constructor */
	public AttachedLucknum(String attachedAccount) {
		this.attachedAccount = attachedAccount;
	}

	@Id
	@Column(name = "ATTACHED_ACCOUNT")
	public String getAttachedAccount() {
		return attachedAccount;
	}

	public void setAttachedAccount(String attachedAccount) {
		this.attachedAccount = attachedAccount;
	}
}
