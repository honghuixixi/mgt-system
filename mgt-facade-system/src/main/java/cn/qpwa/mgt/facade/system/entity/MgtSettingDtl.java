package cn.qpwa.mgt.facade.system.entity;
// default package

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.math.BigDecimal;

/**
 * 系统参数设置对象（保存用户设置内容）
 * @author liujing
 *
 */
@Entity
@Table(name = "MGT_SETTING_DTL")
public class MgtSettingDtl implements
		java.io.Serializable {
	
	private static final long serialVersionUID = 8921972496505046715L;
	/**主键id，数据上，EMPLOYEE_ID+ITEM_NO不允许重复*/
	private String uuid;
	/**对应后台的角色，供应商、仓库、物流商等mechantCode*/
	private String employeeId;
	/**对应MGT_SETTING中的ITEM_NO*/
	private BigDecimal itemNo;
	/**默认设置项*/
	private String defFlg;
	/**默认值，一般情况下def_flg='Y'时才会使用*/
	private String defValue;
	// Constructors

	/** default constructor */
	public MgtSettingDtl() {
	}

	/** minimal constructor */
	public MgtSettingDtl(String uuid, String employeeId, BigDecimal itemNo) {
		this.uuid = uuid;
		this.employeeId = employeeId;
		this.itemNo = itemNo;
	}

	/** full constructor */
	public MgtSettingDtl(String uuid, String employeeId, BigDecimal itemNo,
						 String defFlg, String defValue) {
		this.uuid = uuid;
		this.employeeId = employeeId;
		this.itemNo = itemNo;
		this.defFlg = defFlg;
		this.defValue = defValue;
	}

	// Property accessors
		@Id
		@GeneratedValue(generator="system-uuid")
		@GenericGenerator(name="system-uuid", strategy = "uuid")
		@Column(name = "UUID", unique = true, nullable = false, length = 32)
		public String getUuid() {
			return this.uuid;
		}

		public void setUuid(String uuid) {
			this.uuid = uuid;
		}

		@Column(name = "EMPLOYEE_ID", nullable = false, length = 32)
		public String getEmployeeId() {
			return this.employeeId;
		}

		public void setEmployeeId(String employeeId) {
			this.employeeId = employeeId;
		}

		@Column(name = "ITEM_NO", nullable = false, precision = 20, scale = 0)
		public BigDecimal getItemNo() {
			return this.itemNo;
		}

		public void setItemNo(BigDecimal itemNo) {
			this.itemNo = itemNo;
		}

		@Column(name = "DEF_FLG", length = 1)
		public String getDefFlg() {
			return this.defFlg;
		}

		public void setDefFlg(String defFlg) {
			this.defFlg = defFlg;
		}

		@Column(name = "DEF_VALUE", length = 128)
		public String getDefValue() {
			return this.defValue;
		}

		public void setDefValue(String defValue) {
			this.defValue = defValue;
		}
}
