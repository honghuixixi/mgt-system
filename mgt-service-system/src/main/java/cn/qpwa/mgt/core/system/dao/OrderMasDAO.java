package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.OrderMas;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 主订单数据访问层接口，提供CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface OrderMasDAO extends EntityDao<OrderMas> {

	/**
	 * 通过用户ID、订单状态,获取此用户订单集合<br/>
	 * 参看相关的覆盖方法
	 * 
	 * @see #findOrderMas(Map , LinkedHashMap )
	 * 
	 * @param obj
	 *            参数集合；可入参：用户ID(userNo)、订单状态(statusFlg)
	 * 
	 * @return Page<Map<String, Object>> 订单分页集合
	 */
	@Deprecated
	public Page<Map<String, Object>> findOrderMas(Map<String, Object> obj);

	/**
	 * 通过参数集合条件，获取订单列表
	 * 
	 * @param paramMap
	 *            参数集合，可入参：用户ID(userNo)、订单编号(masNo)、订单状态(statusFlg)、商户ID(
	 *            vendorUserNo)
	 * @param orderby
	 *            排序条件集合
	 * 
	 * @return 订单分页集合
	 */
	public Page findOrderMas(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 通过参数集合条件，获取汇总单列表
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page findOrderMasGather(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * “仓库” 获取“汇总单”列表
	 * 
	 * @param paramMap 参数集合
	 * @param orderby 排序
	 * @return List
	 */
	public Page getMergeOrderMas(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 获取源订单
	 * @param pKNo
	 * @return
	 */
	public List<Map<String, Object>> getOrigOrderMas(BigDecimal pKNo);

	/**
	 * 通过用户ID，获取此用户各订单状态的个数。 <br/>
	 * TOTAL 订单总数量；DOING 进行中数量； WAITDELIVER 待发货数量 ；DELIVERED 已发货数量；<br/>
	 * SUCCESS 交易成功数量 ；RETURNSING 退单中数量；CLASE 已关闭数量；<br/>
	 * WAITPAYMENT 待支付数量；PAID 已支付数量；PAYMENTPROCESS 支付中数量；REFUNDMENT 已退款数量；
	 * 
	 * @param userID
	 *            用户ID
	 * 
	 * @return 此用户各订单状态的个数
	 */
	public Map<String, String> findOrderMasStatusCount(BigDecimal userID);

	/**
	 * 通过商户ID，获取此商户各订单状态的个数。 <br/>
	 * INPROCESS 处理中；WAITDELIVER 待发货数量 ；DELIVERED 已发货数量；<br/>
	 * SUCCESS 交易成功数量 ；RETURNSING 退单中数量；CLASE 已关闭数量；<br/>
	 * WAITPAYMENT 待支付数量；PAID 已支付数量；PAYMENTPROCESS 支付中数量；REFUNDMENT 已退款数量；
	 * 
	 * @param merchantCode
	 *            商户ID
	 * 
	 * @return 此商户各订单状态的个数
	 */
	public Map<String, String> findOrderMasStatusCountByMerchantCode(BigDecimal merchantCode);

	/**
	 * 通过用户ID、订单ID,获取此用户订单信息
	 * 
	 * @param userID
	 *            用户ID
	 * @param orderID
	 *            订单ID
	 * 
	 * @return OrderMas订单对象
	 */
	public Map<String, Object> findUniqueOrderMas(BigDecimal userID, BigDecimal orderID);

	/**
	 * 通过订单ID,进行分单操作，相同的供应商供应的商品必须在一个订单
	 * 
	 * @param orderId
	 *            订单ID
	 * 
	 */
	public void executeSplitOrder(BigDecimal orderId) throws SQLException;

	/**
	 * 通过订单ID,状态操作编码，操作用户，改变订单状态、子状态并记录操作日志
	 * 
	 * @param orderIds
	 *            订单ID字符串以逗号分割
	 * @param actionCode
	 *            状态操作编码（VENDORCONFIRM接收订单；VENDORPRINT打印订单；VENDORDELIVER发货）
	 * @param accountName
	 *            用户表MgtEmployee的用户登录账号
	 */
	public void executeUpdateStatus(String orderIds, String actionCode, String accountName) throws SQLException;

	/**
	 * 通过订单ID,状态操作编码，改变订单状态、子状态(仓库相关)
	 * 
	 * @param orderIds
	 *            订单ID字符串以逗号分割
	 * @param actionCode
	 *            状态操作编码（待打印WAITPRINT、待发货WAITDELIVER、已发货DELIVERED）
	 */
	public void whUpdateStatus(String orderIds, String actionCode);
	
	/**
	 * 通过用户ID,查询已经完成的订单
	 * 
	 * @param params
	 *            参数集合
	 * @return Page<Map<String, Object>> 订单分页集合
	 */
	public Page<Map<String, Object>> findOrderMasByTime(Map<String, Object> params);

	/**
	 * 获取全部已完成订单总额（与用户和时间段有关）
	 * @param params
	 * 查询参数
	 * @return
	 */
	public Map<String, String> getAmountSum(Map<String, Object> params);
	
	/**
	 * 订单待发货一段时间后自动改为已完成
	 * @param date
	 *  订单时间
	 * @return
	 */
	public List<OrderMas> completeOrder(Date date);
	
	/**
	 * 通过参数集合条件，获取订单对账列表
	 * @param paramMap
	 * 	查询条件
	 * @param orderby
	 * 	排序
	 * @return
	 */
	public Page getReconciliationList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

	/**
	 * 获取用户购买的所有订单不同状态商品总数
	 * @param params
	 * 			参数，包含用户id和订单状态
	 * @return Map<String, Object>数目
	 */
	public Map<String, Object> findAll(Map<String, Object> params);
	
	/**
	 * 通过接口类型代码查询一段时间内的订单日志
	 * @param typeCode 接口类型代码
	 * @param statDate 起始时间
	 * @param endDate 结束时间
	 * @return
	 */
	public List<Map<String, Object>> getOrderActionLog(String typeCode, BigDecimal interval);
	
	/**
	 * 通过参数集合条件，获取供应商订单列表（与用户相关）
	 * 
	 * @param paramMap 参数集合
	 * @param orderby
	 *  排序
	 * @return Page分页对象
	 */
	public List<Map<String,Object>> getSupplierOrderList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 通过参数集合条件，获取仓库管理后台订单列表
	 * 
	 * @param paramMap 参数集合
	 * @param orderby
	 *  排序
	 * @return Page分页对象
	 */
	public Page<Map<String, Object>> getWarehouseOrderList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 获取“仓库”待合并汇总单（与用户相关）
	 * 
	 * @param paramMap 参数集合
	 * @param orderby
	 *  排序
	 * @return Page分页对象
	 */
	public List<Map<String,Object>> getWhcOrderList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

	/**
	 * 根据条件查询订单列表
	 * @param params 查询条件，包含的参数有：spUserNo 业务员id
	 * 								fromdate 起始时间
	 * 								todate 截止时间
	 * 								statusFlg 订单状态
	 *  							shopname 店铺名称
	 *  @param
	 *  	排序
	 * @return
	 */
	public Page queryOrderMasList(Map<String, Object> params, LinkedHashMap<String, String> orderby);
	
	public List<Map<String,Object>> findOrderListByIds(String ids);
	
	/**
	 * 根据特价商品的ID，客户ID，查询客户历史购买数量
	 * @param promPkNo
	 * @param userNo
	 * @return
	 */
	public Map<String,Object> getBoughtQty(BigDecimal promPkNo, BigDecimal userNo);
	/**
	 * 缴纳代收货款
	 * @param params
	 * @param orderby
	 * @return
	 */
	public Page<Map<String, Object>> queryPayOrderPage(Map<String, Object> params, LinkedHashMap<String, String> orderby);
	/**
	 * 通过流水号查询订单
	 * @param batchId
	 * @return
	 */
	public List<OrderMas> findByBatchId(String batchId);
	/**
	 * 
	 * @param pkNos
	 * @return
	 */
	public Integer countOrderMasByPayStatus(BigDecimal[] pkNos);
	
	/**
	 * 根据订单ID获取订单详情（分页）
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page findOrderitem(Map<String, Object> paramMap,
							  LinkedHashMap<String, String> orderby);
	
	/**
	 * 根据订单ID获取订单详情（分页）
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public List findOrderitem(Map<String, Object> paramMap);

	/**
	 * 根据订单id获取商品列表
	 * @author TheDragonLord
	 * @param pkNo
	 * @return
	 */
	public List<Map<String,Object>> getOrderItemListById(BigDecimal pkNo);

	/**
	  * 根据源订单id查询退单主键
	  * @author: lj
	  * @param srcMasNo
	  * @return
	  * @date : 2015-8-13下午2:07:21
	  */
	 public Object findOrderMasBySrcMasNo(BigDecimal srcMasNo);
	 /**
	  * 查询异常订单
	  * @author: lj
	  * @param params
	  * @param orderby
	  * @return
	  * @date : 2015-8-12下午2:38:02
	  */
	 public Page<Map<String, Object>> queryExceptionOrderPage(Map<String, Object> params, LinkedHashMap<String, String> orderby);

	 	/**
		 * 批量修改订单状态
		 * picFlg 拣货员设置、statusFlg订单状态 2015-12-11
		 * @param jsStr
		 * @return
		 */
	public void orderUpdate(Map<String, Object> paramMap);
		
		/**
		 * 修改订单详情
		 * @param jsStr
		 * @return
		 */
	public void orderDetailsUpdate(Map<String, Object> paramMap);

		
		/**
		 * 获取物流订单列表
		 * @param params
		 * @return
		 */
	public Page findLogisticsOrderMas(Map<String, Object> paramMap,
									  LinkedHashMap<String, String> orderby);
		
		/**
		 * 根据订单NO更新订单明细中的实际收货数量 (QTY2)/QTY1批量/QTY1单独
		 * @param params upqty1表示做qty1批量更新 qty1表示做单独更新
		 * @return
		 */
	public int upOrderItemQty(Map<String, Object> paramMap);
		
		/**
		 * 订单表中的差异数据
		 * 差异数据为：订单金额 - 订单明细表中的 商品单价*实际收货数量-拆零扣减金额 amount-（netPrice*qty2-diffMiscAmt）
		 * @param params
		 * @return
		 */
	public int upOrderMasDiff(Map<String, Object> paramMap);
		
		/**
		 * 1.根据订单NO,配送员编号获取订单差异金额，便于确认订单效验
		 * @param params
		 * @return
		 */
	public Map<String, Object> getOrderMasDiff(Map<String, Object> paramMap);
		
		/**
		 * 根据batchId更新订单状态
		 * @param batchId
		 */
	public void updateOrderStatusByBatchId(Map<String, Object> params);
		/**
		 * 释放库存
		 * @param p_pk_no 订单主键
		 * @param p_mas_code 销售订单标识=SALES
		 * @param p_action_type 类型，取消订单=C
		 */
	public void executeReleaseInventory(BigDecimal p_pk_no, String p_mas_code, char p_action_type) throws SQLException;

		/**
		 * 获取订单备注字符串，判断是否可发
		 * @param orderId
		 * @return
		 */
	public String getOrderRemarks(BigDecimal orderId);
	
	/**
	 * 订单差异查询
	 * @param params
	 * @param orderby
	 * @return
	 */
	public Page<Map<String, Object>> queryOrderDifferencePage(Map<String, Object> params, LinkedHashMap<String, String> orderby);
	

	/**
	 * 仓库角色发货环节执行预留
	 * @param orderId
	 */
	public void completeReserve(BigDecimal pkNo, String userName, String flag);
	
	/**
	 * 查询订单监控信息总数
	 * @param sql
	 * @return
	 */
	public Map<String, Object> queryOrderCount(String sql, String username);
	
	/**
	 * 获取订单列表
	 * @param ids
	 */
	public List<Map<String, Object>> getOrderlistByIds(String[] ids);
	
	/**
	 * 通过参数集合条件，获取订单列表(订单监控)
	 * 
	 * @param paramMap
	 *            参数集合，可入参：监控类型
	 * @param orderby
	 *            排序条件集合
	 * 
	 * @return 订单分页集合
	 */
	public Page getStatisticsOrderMasList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby,
										  String username);
	
	/**
	 * 通过batchid获取各订单的实际支付金额
	 * @param batchId
	 * @return
	 */
	public List<Map<String,Object>> getOrderAmtByBatchId(BigDecimal batchId);
		
	/**
	 * 通过参数集合条件，获取子订单列表（与用户相关）
	 * 
	 * @param paramMap 参数集合
	 * @param orderby
	 *  排序
	 * @return Page分页对象
	 */
	public List<Map<String,Object>> getChildOrderList(Map<String, Object> paramMap);
	

	/**
	 * 1.根据订单NO,获取商品评价、订单明细金额
	 * @param params
	 * @return
	 */
	public Map<String, Object> getOrderMasComment(Map<String, Object> paramMap);
	
	/**
	 * 根据订单NO更新订单表中的CommentFlg评论状态
	 * @param params
	 * @return
	 */
	public int upOrderCommentFlg(Map<String, Object> paramMap);
	
	/**
	 * 供应商待接收订单数量
	 * @param userName
	 * @return
	 */
	public BigDecimal getToReceiveOrderCount(String userName);
	
	/**
	 * 供应商待发货订单数量
	 * @param userName
	 * @return
	 */
	public BigDecimal getToSendOrderCount(String userName);
	
	/**
	 * 供应商待对账订单数量
	 * @param userName
	 * @return
	 */
	public BigDecimal getToCheckOrderCount(String userName);
	
	/**
	 * 根据时间段查询订单数量金额
	 * @param userName
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Map<String,Object> getOrderCount(Map<String, Object> param);
	
	/**
	 * 根据时间段查询每天的订单数量金额
	 * @param userName
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public List<Map<String,Object>> getOrderCountByDate(Map<String, Object> param);
	
	/**
	 * 按天查询订单数/金额
	 * @param userName
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Page getOrderCountByDay(Map<String, Object> param, LinkedHashMap<String, String> orderby);
	
	
	/**
	 * 按区域查询订单数/销售额
	 * @param userName
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Page getOrderCountByArea(Map<String, Object> param, LinkedHashMap<String, String> orderby);
	
	/**
	 * 按区域、商品汇总查询数量/金额
	 * @param userName
	 * @param startDate
	 * @param endDate
	 * @return
	 */
	public Page getOrderCountByStk(Map<String, Object> param, LinkedHashMap<String, String> orderby);
	
	/**
	 * 按仓库汇总供应商商品总数量及总金额
	 * @param userName
	 * @return
	 */
	public List<Map<String, Object>> getStkCountByWarehouse(Map<String, Object> param);
	
	/**
	 * 按日期导数据表
	 */
	public List<Map<String, Object>> getOrderCountByDayExcel(Map<String, Object> paramMap,
															 LinkedHashMap<String, String> orderby);
	
	/**
	 * 按区域查询订单数/销售额   导表
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public List<Map<String, Object>> getOrderCountByAreaExcel(Map<String, Object> paramMap,
															  LinkedHashMap<String, String> orderby);
	
	/**
	 * 按区域、商品汇总查询数量/金额  导表
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public List<Map<String, Object>> getOrderCountByStkExcel(Map<String, Object> paramMap,
															 LinkedHashMap<String, String> orderby);
	
	/**
	 * 根据主订单编号设置所有子订单的配送人员
	 * @param logisticUserCode 配送员ID
	 *		  refPkNo 主订单ID
	 * @return
	 */
	public void orderUpdate(BigDecimal logisticUserCode, BigDecimal refPkNo);
	
	/**
	 * 1.根据主订单NO,获取子订单中是否存在非法数据（订单状态：WAITDELIVER，子订单已绑定配送员）
	 * @param params
	 * @return
	 */
	public Map<String, Object> getOrderMas(BigDecimal refPkNo);
	
	/**
	 * 获取配送员所有店铺列表
	 * @param lucode 配送员ID
	 */
	public List<Map<String, Object>> getLogisticOrder(Map<String, Object> paramMap);

	/**
	 * 获取配送员店铺订单列表(订单详情)
	 * @param lucode 配送员ID
	 * 			userno 下单用户id
	 */
	public List<Map<String, Object>> getLogisticItem(Map<String, Object> paramMap);
	
	/**
	 * 根据订单收货地址检查是否存在负责该3级区域配送任务的仓库
	 * @param areaID 3级区域
	 */
	public Map<String, Object> getDS_AREA(BigDecimal areaID);
	
	/**
	 * 配送员订单数统计
	 * @param paramMap
	 * @author rjy
	 * @date 2015年11月19日10:19:01
	 */
	public Page getLogisticsStatistics(Map<String, Object> paramMap);
	
	/**
	 * 业务员订单数统计
	 * @param paramMap
	 * @author rjy
	 * @date 2015年11月24日16:07:58
	 */
	public Page getSalerStatistics(Map<String, Object> paramMap);
	
	/**
	 * 通过参数集合条件，获取供应商SOP订单列表（与用户相关）
	 * 
	 * @param paramMap 参数集合
	 * @param orderby
	 * @author RJY
	 * @date 2015年11月30日10:12:07
	 *  排序
	 * @return Page分页对象
	 */
	public Page<Map<String, Object>> getSopOrderList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 批量修改订单详情
	 * @param paramMap
	 * @author ZLD
	 * @date 2015年12月08日15:53:34
	 * @return
	 */
	public void orderDetailsUpdate(String paramMap);
	
	/**
	 * 根据条件查询用户的子订单列表
	 * @author: lj
	 * @param paramMap
	 * @param orderby
	 * @return
	 * @date : 2015-12-8下午5:58:55
	 */
	public Page findSubOrderMasByParams(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**获取拣货人订单的数量 
	 * @author  lly
	 * @date 创建时间：2015-12-11 上午9:56:29 
	 * @parameter  
	 * @return 
	 */
	public BigDecimal pickOrderCount(Map<String, Object> paramMap);
	
	/**捡货中商品对应订单列表查询
	 *  * @author  lly
	 * @date 创建时间：2015-12-10 下午3:05:14 
	 * @parameter  
	 * @return 
	 */
	public List<Map<String, Object>> getOrderByStkc(Map<String, Object> paramMap);
	
	/** 通过stkc得到订单的总数 
	 * * @author  lly
	 * @date 创建时间：2015-12-10 下午5:04:47 
	 * @parameter  
	 * @return 
	 */
	public BigDecimal orderCountByStkc(Map<String, Object> paramMap);
	
	/**
	 * 查询拣货信息(分页)
	 * @param paramMap
	 * @author ZLD
	 * @date 2015年12月11日
	 * @return
	 */
	public Page<Map<String, Object>> getPickingList(Map<String, Object> params);

	/**
	 * 绑定或取消拣货员
	 * @param paramMap
	 * @author ZLD
	 * @date 2015年12月11日
	 * @return
	 */
	public void updatePickingUser(Map<String, Object> param);
	
	/**
	 * 获取多张订单拣货 数据、TYPE：是否可以绑定1 订单是否可以被拣货员释放绑定 2 是否可以提交确认捡货结果3
	 * @param paramMap type， pkNos数组
	 * @author zy
	 * @date 2015年12月15日
	 * @return null表示成功否则是失败原因
	 */
	/**
	 * 查询订单的当前状态
	 * @param param
	 * @author zy
	 * @date 2015年12月15日
	 * @return Map
	 */
	public Map<String, Object> getOrderPick(Map<String, Object> param);
	
	/**
	 * 
	 * @param params
	 * @return
	 */
	public BigDecimal findUomQtyByParams(Map<String, Object> params);
	/**
	 * 
	 * @param promItemPkNo
	 * @return
	 */
	public BigDecimal findUomQtyByPromItemPkNo(BigDecimal promItemPkNo);
	
	/**
	 * 获取订单(订单金额/订单数量/商品品种数)统计数据(按时间/区域统计)
	 * @author honghui
	 * @date   2016-03-23
	 * @param  paramMap 查询参数 时间段/统计方式(按日/周/月)/统计类别(订单金额/订单数量/商品品种数)/用户集合
	 * @return
	 */
	public List<Map<String,Object>> getOrderStatistics(Map<String, Object> paramMap);
	
	Page getOrderCountForOperator(Map<String, Object> paramMap, String username);
	
	/**
	 * 业务员订单中商品明细统计
	 * @param paramMap
	 * @author honghui
	 * @date   2016-05-03
	 */
	public List<Map<String,Object>> getSalerStatisticsMasDetail(Map<String, Object> paramMap);
	
	/**
	 * 获取sopList
	 * @param paramMap
	 * @author sy
	 * @date   2016-05-6
	 */
	public List<Map<String, Object>> getSOPList(Map<String, Object> paramMap);
	
}

