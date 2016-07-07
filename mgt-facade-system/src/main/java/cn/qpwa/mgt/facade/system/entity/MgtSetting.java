package cn.qpwa.mgt.facade.system.entity;
// default package

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import java.math.BigDecimal;

/**
 * 系统参数对象
 * @author liujing
 *
 */
@Entity
@Table(name = "MGT_SETTING")
public class MgtSetting implements
		java.io.Serializable {

	    private static final long serialVersionUID = -4394616086847722325L;

	    /**系统参数表的主键id*/
		private BigDecimal itemNo;
	    /**后台管理功能的ID，如果为全局参数，定义为-1*/
		private String menuId;
		/**后台管理功能的名称，如果没有，置为-1*/
		private String menuName;
		/**描述*/
		private String description;
		/**默认设置项，可以为Y，N，默认为N*/
		private String defFlg;
		/**默认值，一般情况下def_flg='Y'时才会使用*/
		private String defValue;
		/**是否允许用户设置，默认为Y*/
		private String userFlg;
		
		private BigDecimal sortNo;

		public MgtSetting() {
		}

		public MgtSetting(BigDecimal itemNo) {
			this.itemNo = itemNo;
		}

		/** full constructor */
		public MgtSetting(BigDecimal itemNo, String menuId,
						  String menuName, String description, String defFlg,
						  String defValue, String userFlg) {
			this.itemNo = itemNo;
			this.menuId = menuId;
			this.menuName = menuName;
			this.description = description;
			this.defFlg = defFlg;
			this.defValue = defValue;
			this.userFlg = userFlg;
		}

		@Column(name = "SORT_NO", length = 32)
		public BigDecimal getSortNo() {
			return sortNo;
		}

		public void setSortNo(BigDecimal sortNo) {
			this.sortNo = sortNo;
		}

		@Id
		@Column(name = "ITEM_NO", unique = true, nullable = false, precision = 20, scale = 0)
		public BigDecimal getItemNo() {
			return this.itemNo;
		}

		public void setItemNo(BigDecimal itemNo) {
			this.itemNo = itemNo;
		}

		@Column(name = "MENU_ID", length = 32)
		public String getMenuId() {
			return this.menuId;
		}

		public void setMenuId(String menuId) {
			this.menuId = menuId;
		}

		@Column(name = "MENU_NAME", length = 82)
		public String getMenuName() {
			return this.menuName;
		}

		public void setMenuName(String menuName) {
			this.menuName = menuName;
		}

		@Column(name = "DESCRIPTION", length = 128)
		public String getDescription() {
			return this.description;
		}

		public void setDescription(String description) {
			this.description = description;
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

		@Column(name = "USER_FLG", length = 1)
		public String getUserFlg() {
			return this.userFlg;
		}

		public void setUserFlg(String userFlg) {
			this.userFlg = userFlg;
		}
}
