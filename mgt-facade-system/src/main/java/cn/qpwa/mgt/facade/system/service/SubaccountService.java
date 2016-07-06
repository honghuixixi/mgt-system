package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.mgt.facade.system.entity.Subaccount;
import cn.qpwa.mgt.facade.system.entity.Subaccountbindcard;
import net.sf.json.JSONObject;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;


/**
 * 账户信息
 */
public interface SubaccountService extends BaseService<Subaccount> {
	
	/**
	 * 注册中信银行附属账户信息
	 * @param params 中信银行所需参数
	 * @param eciticSubaccount 附属账户信息
	 * @param subaccountbindcard 附属账户绑定卡信息
	 * @return
	 */
	public Msg registerSubaccountInfo(JSONObject params, Subaccount eciticSubaccount, Subaccountbindcard subaccountbindcard);
	
	/**
	 * 通过任意字段查询一条记录
	 * @param propertyName
	 * @param value
	 * @return
	 * 已废弃，因无法通过用户名获取唯一的数据 必须增加subaccountType = 9001的判断
	 * 2015-12-10
	 */
	@Deprecated
	public Subaccount findUniqueBy(String propertyName, Object value);
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
	 * 通过任意字段查询一条记录
	 * @param propertyName
	 * @param value
	 * @return
	 */
	public Subaccount findUniqueBy(String propertyName[], Object value[]);
	
	/**
	 * 判断附属账号是否存在
	 * @param accountNum
	 * @param randomNum
	 * @return
	 */
	public boolean isExist(String accountNum, String randomNum);
	
	/**
	 * 添加中信附属账号
	 * @param subaccountId
	 * @param attachedAccount
	 * @param subaccountbindcard
	 */
	public void save(Long subaccountId, String attachedAccount, Subaccountbindcard subaccountbindcard);
	/**
	 * 修改账户状态
	 * @param id
	 * @param state
	 * @param operator
	 */
	public void changeStatus(Long id, String state, String operator);
	
	/**
	 * 通过用户名、更新余额积分
	 * @param orderID
	 * 			订单id
	 * @return 
	 * @return CouponMas
	 */
	public boolean upSubaccountAmount(String custId, BigDecimal amount, BigDecimal points);
	/**
	 * 绑定银行卡
	 * @param subaccountId
	 * @param subaccountbindcard
	 */
	public String bindBankCard(Long subaccountId, Subaccountbindcard subaccountbindcard);
	/**
	 * 提现
	 * @param subaccountId
	 * @param tranamount
	 */
	public String takeCash(Long subaccountId, BigDecimal tranamount, String subaccountbindcardId);
	
	/**
	 * 处理B2B提现(附属户8001)的业务数据保存
	 * @author majh
	 * @data 2016-06-23 
	 * @param obj
	 * @return
	 */
	public String saveOutCashAttacc(JSONObject obj, Subaccount subaccount);
	
	/**
	   * 通过任意字段查询一条记录
	   * @param propertyName
	   * @param value
	   * @return
	   */
	public List<Subaccount> findBy(String propertyName[], Object value[]);
	 /**
	   * 通过任意字段查询一条记录
	   * @param propertyName
	   * @param value
	   * @return
	   */
	public List<Subaccount> findBy(String propertyName, Object value);
	
	/**
	 * 查询附属账户的余额信息
	 * @param username 用户名
	 * @param type 账户类型
	 * @return
	 */
	public String queryAmout(String username, String type);
	
	/**
	 * 查询余额类型账户集合
	 * @param
	 * @return
	 */
	public Page queryBalanceSubaccounts(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 查询某客户交易明细
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page queryBalanceSubaccountDetails(Map<String, Object> paramMap,
											  LinkedHashMap<String, String> orderby);
	
	/**
	 * 中信账户收支统计
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> reportAccountInOut(Map<String, Object> paramMap);
	
	/**
	 * 中信账户资金分布
	 * @param paramMap
	 * @return
	 */
	public Map<String, Object> reportAmtSpread(Map<String, Object> paramMap);
	
}
