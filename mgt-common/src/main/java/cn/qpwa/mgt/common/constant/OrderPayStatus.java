package cn.qpwa.mgt.common.constant;

/**
 * orderMas订单实体，订单支付状态允许的取值范围
 * @author L.Dragon
 * 
 */
@SuppressWarnings("all")
public enum OrderPayStatus {
	//利用构造函数赋值
	WAITPAYMENT("WAITPAYMENT"), //未支付
	
	PAID("PAID"), //已支付
	
	PAYMENTPROCESS("PAYMENTPROCESS"), //支付中
	
	REFUNDMENT("REFUNDMENT"); //已退款
	
	private String payStatus;
	
	private OrderPayStatus(String payStatus) {
		this.payStatus = payStatus;
	}
	
	@Override
	public String toString() {
		return String.valueOf(this.payStatus);
	}
	
	public static boolean isProperties (String str ) {
		boolean flag = false;
		for (OrderPayStatus ops : OrderPayStatus.values()) {
			if (ops.toString().equals(str)) {
				flag = true;
				break;
			}
		}
		return flag;
	}
	
}
