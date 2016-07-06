package cn.qpwa.common.utils;

/**
 * HTTP协议POST请求方式JSON数据格式中的属性枚举类
 */
public enum RequestKey {
	/* 签名 */
	sign,
	/* 时间戳 */
	t,
	/* 密钥KEY */
	secret,
	/* 请求参数 */
	para,
	/* 业务数据返回结果 */
	data,
	/* 提示信息 */
	msg,
	/*
	 * 1(参数失败),2(认证失败),3(数据集为空),4(service不存在),5(方法不存在 ),6 (执行异常), 200（成功）
	 */
	code,
	/* 业务数据类型 ,service前缀名称 */
	type,
	/* 请求动作，service方法 */
	oper,
	/* 来源，B2B 、MGT、WAP、APP、P2C */
	source,
	/* 设备信息,如手机系统、系统版本、唯一标识等 */
	device,
	/* 分页信息 */
	pagination
}