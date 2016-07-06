package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.Subaccount;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

public interface SubaccountDAO extends EntityDao<Subaccount> {
	
	/**
	 * 通过用户名、更新余额积分
	 * @param orderID
	 * 			订单id
	 * @return 
	 * @return CouponMas
	 */
	public boolean upSubaccountAmount(String custId, BigDecimal amount, BigDecimal points);
	/**
     * 获取账户信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
    
    /**
     * 获取附属账户列表
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page queryAAMList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 批量删去账户信息
     * 
     * @param ids
     *            资源ID字符串，使用逗号分割
     */
    public void delete(Long[] ids);
    
    /**
     * 查询
     * @param paramMap
     * @param orderby
     * @return
     */
    public Page queryBalanceSubaccounts(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
    
    /**
     * 查询交易明细
     * @param paramMap
     * @param orderby
     * @return
     */
    public Page queryBalanceSubaccountDetails(Map<String, Object> paramMap,
                                              LinkedHashMap<String, String> orderby);
    
    public Map<String,Object> reportAccountInOut(Map<String, Object> paramMap);
    
    public Map<String,Object> reportAmtSpread(Map<String, Object> paramMap);
}
