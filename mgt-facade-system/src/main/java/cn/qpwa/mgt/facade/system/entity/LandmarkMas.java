package cn.qpwa.mgt.facade.system.entity;

import org.hibernate.annotations.GenericGenerator;

import javax.persistence.*;
import java.math.BigDecimal;
import java.sql.Timestamp;

/**
 * 地标主数据
 * LandmarkMas entity. @author MyEclipse Persistence Tools
 */
@Entity
@Table(name = "LANDMARK_MAS")
public class LandmarkMas implements java.io.Serializable {

	private static final long serialVersionUID = -6597819559183970269L;
	/**
	 *当前主键 
	 */
	private String uuid;
	/**
	 * 代码，不可重复
	 */
	private String code;
	/**
	 * 名称
	 */
	private String name;
	/**
	 * 介绍
	 */
	private String description;
	
	/**
	 * 经度
	 */
	private BigDecimal longitude;
	/**
	 * 纬度
	 */
	private BigDecimal latitude;
	/**
	 * 所属三级区域ID
	 */
	private BigDecimal areaId;
	/**
	 * 冗余字段，选择/修改三级区域时自动填充
	 */
	private BigDecimal areaIdL2;
	/**
	 * 冗余字段，选择/修改三级区域时自动填充
	 */
	private BigDecimal areaIdL1;
	/**
	 * 是否启用，默认Y启用
	 */
	private String statusFlg;
	/**
	 * 该地标选中的合作物流点，从店铺主数据里选择
	 */
	private String userName;
	/**
	 * 创建时间
	 */
	private Timestamp createDate;
	/**
	 * 负责人
	 */
	private BigDecimal picNo;
	/**
	 * 地址
	 */
	private String address;

	public LandmarkMas() {
	}

	public LandmarkMas(String uuid, String code, String name,
					   String description, BigDecimal longitude, BigDecimal latitude,
					   BigDecimal areaId, BigDecimal areaIdL2, BigDecimal areaIdL1,
					   String statusFlg, String userName, Timestamp createDate, BigDecimal picNo, String address) {
		this.uuid = uuid;
		this.code = code;
		this.name = name;
		this.description = description;
		this.longitude = longitude;
		this.latitude = latitude;
		this.areaId = areaId;
		this.areaIdL2 = areaIdL2;
		this.areaIdL1 = areaIdL1;
		this.statusFlg = statusFlg;
		this.userName = userName;
		this.createDate = createDate;
		this.picNo = picNo;
		this.address = address;
	}

 
	@Id
	@GeneratedValue(generator = "system-uuid")
	@GenericGenerator(name = "system-uuid", strategy = "uuid")
	@Column(name = "UUID", unique = true, nullable = false, precision = 22, scale = 0, length = 32)
	public String getUuid() {
		return this.uuid;
	}

	public void setUuid(String uuid) {
		this.uuid = uuid;
	}

	@Column(name = "CODE", unique = true, length = 32)
	public String getCode() {
		return this.code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	@Column(name = "NAME", length = 256)
	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Column(name = "DESCRIPTION", length = 1024)
	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	@Column(name = "LONGITUDE", precision = 22, scale = 0)
	public BigDecimal getLongitude() {
		return this.longitude;
	}

	public void setLongitude(BigDecimal longitude) {
		this.longitude = longitude;
	}

	@Column(name = "LATITUDE", precision = 22, scale = 0)
	public BigDecimal getLatitude() {
		return this.latitude;
	}

	public void setLatitude(BigDecimal latitude) {
		this.latitude = latitude;
	}

	@Column(name = "AREA_ID", precision = 22, scale = 0)
	public BigDecimal getAreaId() {
		return this.areaId;
	}

	public void setAreaId(BigDecimal areaId) {
		this.areaId = areaId;
	}

	@Column(name = "AREA_ID_L2", precision = 22, scale = 0)
	public BigDecimal getAreaIdL2() {
		return this.areaIdL2;
	}

	public void setAreaIdL2(BigDecimal areaIdL2) {
		this.areaIdL2 = areaIdL2;
	}

	@Column(name = "AREA_ID_L1", precision = 22, scale = 0)
	public BigDecimal getAreaIdL1() {
		return this.areaIdL1;
	}

	public void setAreaIdL1(BigDecimal areaIdL1) {
		this.areaIdL1 = areaIdL1;
	}

	@Column(name = "STATUS_FLG", length = 1)
	public String getStatusFlg() {
		return this.statusFlg;
	}

	public void setStatusFlg(String statusFlg) {
		this.statusFlg = statusFlg;
	}

	@Column(name = "USER_NAME", length = 16)
	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	@Column(name = "CREATE_DATE", length = 7)
	public Timestamp getCreateDate() {
		return this.createDate;
	}

	public void setCreateDate(Timestamp createDate) {
		this.createDate = createDate;
	}

	@Column(name = "PIC_NO", precision = 22, scale = 0)
	public BigDecimal getPicNo() {
		return this.picNo;
	}

	public void setPicNo(BigDecimal picNo) {
		this.picNo = picNo;
	}
	
	@Column(name = "ADDRESS", length = 256)
	public String getAddress() {
		return this.address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

}