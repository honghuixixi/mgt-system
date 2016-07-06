package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.Subaccountseq;

import java.util.LinkedHashMap;
import java.util.Map;

public interface SubaccountseqDAO extends EntityDao<Subaccountseq> {
	/**
	 * 通过自定义参数删除记录
	 * @param hql
	 * @param values
	 * @return
	 */
	public int remove(String hql, Object[] values);
	/**
	 * 通过订单删除记录
	 * @param orderId
	 * @param changeType
	 * @param seqflag
	 */
	public void deleteByOrderId(String orderId, String changeType, String seqflag);
	/**
	 * 删除附属账号流水记录
	 * @param subaccountId
	 * @param workDate
	 */
	public void deleteByWorkDate(String subaccountId, String workdate);
	  /**
     * 获取账户流水
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
    
    /**
	 * 根据参数查询用户的账户余额变动列表
	 * @author: lj
	 * @param paramMap：{userName:用户名，status：时间过滤（近三个月=0，三个月前=1）}
	 * @return
	 * @date : 2015-11-4下午3:29:13
	 */
	public Page querySubaccountByPage(Map<String, Object> paramMap);
	

	/**
	 * 根据用户查询用户的账户余额和已经消费的金额
	 * @author: lj
	 * @param userName
	 * @return
	 * @date : 2015-11-5上午11:02:03
	 */
	public Map<String, String> querySubaccountByUser(String userName);
 
	/**
	 * 统计收入支出金额
	 * @param paramMap
	 * @return
	 */
    public Map<String,Object> countTranAmount(Map<String, Object> paramMap);
    
    /**
     * 交易明细
     * @param paramMap
     * @param orderby
     * @return
     */
    public Page queryDetails(Map<String, Object> paramMap,
							 LinkedHashMap<String, String> orderby);
}
