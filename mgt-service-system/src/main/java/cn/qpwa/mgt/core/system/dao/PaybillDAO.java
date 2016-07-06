package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.Paybill;

import java.sql.SQLException;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public interface PaybillDAO extends EntityDao<Paybill> {
	
	/**
	 * 
	 * @param obj
	 * @return
	 */
	public List findPayBillPrams(Map<String, Object> obj);
	
	public Page<Map<String, Object>> findPaybill(Map<String, Object> jobj);
	
	public List<Map<String, Object>> findBatchId(String batchid);
	/**
	 * 查询代收货款列表
	 * @param params
	 * @param orderby
	 * @return
	 */
	public Page<Map<String, Object>> queryPaybillPage(Map<String, Object> params, LinkedHashMap<String, String> orderby);
	/**
	  * 根据开始时间和结束时间查询账单列表
	  * @author:lj
	  * @return
	  * @date 2015-8-3 下午2:10:42
	  */
	 public List<Paybill> findPaybillByParam(Map<String, Object> params);
	/**
	 * 渠道对账--交易明细
	 * @author: sy
	 * @date : 2015-9-15
	 */
	 public Page<Map<String, Object>> PayMethodCheck(Map<String, Object> params, LinkedHashMap<String, String> orderby);
	 /**
	  * 渠道对账--交易明细（期初金额，期间支出，收入）
	  * @author: sy
	  * @date : 2015-9-24
	  */
	 public Map<String, Object> getAjaxTransDetail(Map<String, Object> params);
	 /**
	  * 查询每天的汇总记录集合（根据定时任务生成的记录）
	  * @author: lj
	  * @param jobj
	  * @return
	  * @date : 2015-8-5下午4:07:30
	  */
	 public Page<Map<String, Object>> querySummaryPaybillByPage(Map<String, Object> jobj);
	 /**
	  * 对账完成
	  * @author: lj
	  * @date : 2015-8-5下午5:02:13
	  */
	 public String checkPaybill(String sn, String bankSn)throws SQLException;
	 /**
	  * Paybill汇总
	  */
	 public void sumPaybillData();
	 /**
	  * 生成交易记录
	  */
	 public void paybillB2bData();
	 /**
	  * 费用计算
	  * @param obj
	  * @return
	  */
	 public String calcFee(Map<String, Object> obj);
	 
	/**更新其batchid的对账状态
	 *  * @author  lly
	 * @date 创建时间：2015-8-21 下午1:10:04 
	 * @parameter  
	 * @return 
	 */
	public void updatePaybill(String batchid);
	
	/**
	 * 渠道对账--汇总查询
	 * @author rjy
	 * @param jobj
	 * @return
	 * @date 2015年9月15日17:06:52
	 */
	public List<Map<String, Object>> ChannelSummary(Map<String, Object> jobj);
	/**
	 * 累计收支明细
	 * @author rjy
	 * @param jobj
	 * @return
	 * @date 2015年9月22日17:06:52
	 */
	public List<Map<String, Object>> CrDrdetail(Map<String, Object> jobj);
	/**
	 * 待支付数据
	 * @return
	 */
	public Map<String,Object> findWaitPayData();
	/**
	 * 交易类型数据
	 * @return
	 */
	public Map<String,Object> findTranTypeData(Map<String, Object> params);
	 
}
