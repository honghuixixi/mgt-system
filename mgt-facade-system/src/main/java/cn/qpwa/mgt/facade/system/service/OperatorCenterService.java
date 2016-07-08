package cn.qpwa.mgt.facade.system.service;


import cn.qpwa.common.page.Page;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 运营中心数据分析相关操作
 * 
 * @author HeWei
 */
@SuppressWarnings("rawtypes")
public interface OperatorCenterService {

	/**
	 * 为运营中心获取订单销售情况
	 * 
	 * @param paramMap
	 * @return
	 */
	Page getOrderForOperator(Map<String, Object> paramMap, String userName);

	/**
	 * 为运营中心获取供应商统计信息
	 * 
	 * @param paramMap
	 * @param userName
	 * @return
	 */
	Page getVendorForOperator(Map<String, Object> paramMap, String userName);

	/**
	 * 为运营中心获取物流商统计信息
	 * 
	 * @param paramMap
	 * @param userName
	 * @return
	 */
	Page getCustomerForOperator(Map<String, Object> paramMap, String userName);

	/**
	 * 为运营中心获取商品统计信息
	 * 
	 * @param paramMap
	 * @param userName
	 * @return
	 */
	Page getStkForOperator(Map<String, Object> paramMap, String userName);

	/**
	 * 运营中心订单导出
	 * 
	 * @param paramMap
	 * @param fileName
	 * @param out
	 * @param userName
	 */
	void exportExcelForOperator(Map<String, Object> paramMap, String fileName, OutputStream out, String userName);

	/**
	 * 运营中心供货商统计信息导出
	 * 
	 * @param paramMap
	 * @param fileName
	 * @param out
	 * @param userName
	 */
	void exportExcelVendorForOperator(Map<String, Object> paramMap, String fileName, OutputStream out, String userName);
	
	/**
	 * 运营中心物流商统计信息导出
	 * 
	 * @param paramMap
	 * @param fileName
	 * @param out
	 * @param userName
	 */
	void exportExcelCustomerForOperator(Map<String, Object> paramMap, String fileName, OutputStream out, String userName);

	/**
	 * 运营中心商品统计信息导出
	 * 
	 * @param paramMap
	 * @param fileName
	 * @param out
	 * @param userName
	 */
	void exportExcelStkForOperator(Map<String, Object> paramMap, String fileName, OutputStream out, String userName);
	
	/**
	 * 运营中心商铺 供货商 物流商 o2o店铺 消费者统计信息导出
	 * 
	 * @param paramMap
	 * @param fileName
	 * @param out
	 * @param userName
	 */
	void exportExcelMapDataForOperator(Map<String, Object> paramMap, String fileName, OutputStream out, String userName);

	/**
	 * 运营中心获取所有商铺 供货商 物流商 o2o店铺 消费者 分页信息
	 * 
	 * @param params
	 * @param userName
	 * @return
	 */
	Page getUserCountDataForOperations(Map<String, Object> params, String userName);

	/**
	 * 运营中心获取所有商铺 供货商 物流商 o2o店铺 消费者 总和信息
	 * 
	 * @param paramMap
	 * @param userName
	 * @return
	 */
	Object getSumCountDataForOperations(Map<String, Object> paramMap, String userName);

	/**
	 * 运营中心获取经纬度信息
	 * 
	 * @param params
	 * @param userName
	 * @return
	 */
	List<Map<String, Object>> getUserCountMapTudeDataForOperations(Map<String, Object> params, String userName, BigDecimal areaId);

}
