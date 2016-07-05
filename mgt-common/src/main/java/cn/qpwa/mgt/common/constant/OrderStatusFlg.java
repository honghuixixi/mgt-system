package cn.qpwa.mgt.common.constant;

/**
 * OrderMas订单实体，订单状态允许设置的值范围
 * 
 */
public enum OrderStatusFlg {
	// 利用构造函数赋值
	WAITDELIVER("WAITDELIVER"), // 未发货
	DELIVERED("DELIVERED"), // 已发货
	RETURNSING("RETURNSING"), // 退单中
	SUCCESS("SUCCESS"), // 交易成功
	CLOSE("CLOSE");// 交易关闭

	private String statusName;

	// 枚举类型私有构造函数
	private OrderStatusFlg(String statusName) {
		this.statusName = statusName;
	}

	@Override
	public String toString() {
		return String.valueOf(this.statusName);
	}

	/**
	 * 通过参数，判断是否为枚举类中的属性
	 * 
	 * @param str
	 *            字符串参数
	 * @return true为是枚举类中的属性
	 */
	public static boolean isproperties(String str) {
		boolean flag = false;
		for (OrderStatusFlg osf : OrderStatusFlg.values()) {
			if (osf.toString().equals(str)) {
				flag = true;
				break;
			}
		}
		return flag;
	}
}