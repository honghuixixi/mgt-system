package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.util.Date;

/**
 * LmShop entity.地标内的店铺列表
 */

@Entity
@Table(name = "LM_SHOP")
public class LmShop implements java.io.Serializable {

	private static final long serialVersionUID = 8413566293693020162L;
	/**
	 *当前主键
	 */
	private String uuid;
	/**
	 * 地标代码
	 */
	private String lmCode;
	/**
	 * 店铺代码
	 */
	private String userName;
	/**
	 * -是否启用，默认Y启用
	 */
	private String statusFlg;
	/**
	 * 创建时间
	 */
	private Date createDate;
	/**
	 * 承诺送货时间
	 */
	private String deliveryNote;

	// Constructors

	/** default constructor */
	public LmShop() {
	}

	/** minimal constructor */
	public LmShop(String uuid) {
		this.uuid = uuid;
	}

	/** full constructor */
	public LmShop(String uuid, String lmCode, String userName,
				  String statusFlg, Date createDate, String deliveryNote) {
		this.uuid = uuid;
		this.lmCode = lmCode;
		this.userName = userName;
		this.statusFlg = statusFlg;
		this.createDate = createDate;
		this.deliveryNote = deliveryNote;
	}

	@Id
	@GeneratedValue(generator = "system-uuid")
	@GenericGenerator(name = "system-uuid", strategy = "uuid")
	@Column(name = "UUID", unique = true, nullable = false, precision = 22, scale = 0)
		public String getUuid() {
		return this.uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	@Column(name = "LM_CODE", length = 32)
	public String getLmCode() {
		return this.lmCode;
	}

	public void setLmCode(String lmCode) {
		this.lmCode = lmCode;
	}

	@Column(name = "USER_NAME", length = 16)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "STATUS_FLG", length = 1)
	public String getStatusFlg() {
		return this.statusFlg;
	}

	public void setStatusFlg(String statusFlg) {
		this.statusFlg = statusFlg;
	}

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "CREATE_DATE", length = 7)
	public Date getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	@Column(name = "DELIVERY_NOTE", length = 512)
	public String getDeliveryNote() {
		return this.deliveryNote;
	}

	public void setDeliveryNote(String deliveryNote) {
		this.deliveryNote = deliveryNote;
	}

}