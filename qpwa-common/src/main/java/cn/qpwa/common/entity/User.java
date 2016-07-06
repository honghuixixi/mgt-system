package cn.qpwa.common.entity;

import java.math.BigDecimal;


/**
 * 用户信息前台展示对象，用于web前台数据交互
 */
public class User {

	/** 用户ID */
	private BigDecimal userNo;
	
	/** 用户登录账号 */
	private String accountName;
	
	/** 用户名 */
	private String username;

	public BigDecimal getUserNo() {
		return userNo;
	}

	public void setUserNo(BigDecimal userNo) {
		this.userNo = userNo;
	}

	public String getAccountName() {
		return accountName;
	}

	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}
	
}
