package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.User;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户管理数据访问层接口
 */
@SuppressWarnings("rawtypes")
public interface UserDao extends EntityDao<User> {
	/**
	 * 判断用户名是否存在
	 * 
	 * @param username
	 *            用户名(忽略大小写)
	 * @return boolean
	 */
	public boolean usernameExists(String username);

	/**
	 * 判断E-mail是否存在
	 * 
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return boolean
	 */
	boolean emailExists(String email);

	/**
	 * 根据用户名查找会员
	 * 
	 * @param username
	 *            用户名(忽略大小写)
	 * @return User
	 */
	User findByUsername(String username);
	
	/**
	 * 根据用户名查找员工
	 * 
	 * @param username
	 *            用户名(忽略大小写)
	 * @return User
	 */
	Map<String, Object> findEmployeeByUsername(String username);
	
	/**
	 * 根据手机号查找会员
	 * 
	 * @param crmMobile
	 *            用户手机号
	 * @return User
	 */
	User findByCrmMobile(String crmMobile);
	
	/**
	 * 根据手机号查找会员
	 * 
	 * @param crmMobile
	 *            用户手机号
	 * @return User
	 */
	Map<String,Object> findUserByCrmMobile(String crmMobile);

	/**
	 * 根据E-mail查找会员
	 * 
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return User
	 */
	List<User> findListByEmail(String email);
	
	/**
	 * 根据ID查找会员
	 * 
	 * @param userNo
	 *            用户名(忽略大小写)
	 * @return User
	 */
	public User findByUserNo(BigDecimal userNo);

	/**
	 * 查找会员消费信息
	 * 
	 * @param beginDate
	 *            起始日期
	 * @param endDate
	 *            结束日期
	 * @param count
	 *            数量
	 * @return List
	 */
//	List<Object[]> findPurchaseList(Date beginDate, Date endDate, Integer count);
	
	/**
	 * 获取加密密码
	 * @param password
	 * 	密码
	 * @return  BigDecimal password
	 */
	BigDecimal getPassword(String password);
	
	/**
	 * 更新会员密码
	 *@param password
	 *	密码
	 *@param userName
	 *	用户名
	 *@return int
	 */
	int updatePass(BigDecimal password, String userName) ;
	
	/**
	 * 更新会员注册信息
	 *@param user
	 *	用户
	 */
	void update(User user);
	
	/**
	 * 更新会员AREA_ID
	 *@param paramMap
	 *	用户
	 */
	int upAreaID(Map<String, Object> paramMap);
	
	/**
	 * 获取组织机构信息
	 * @param user
	 * 用户
	 * @return
	 */
	User findOrgInfo(User user);
	
	/**
	 * 获取新品供应商
	 * @param days
	 * 	天数
	 * @return List
	 */
	List findSupplys(BigDecimal days);
	
	/**
	 * 获取每日特价供应商
	 * @return List
	 */
	List findDailySupplys();
	
	/**
	 * 获取所有用户  page
	 * @param paramMap 查询参数
	 * @param orderby	排序参数
	 * @return page分页对象
	 */
	public Page findAllUserPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	
	/**
	 *  caow 2015年1月21日
	 * 根据用户ID获取当前用户的下级用户集(移动办公)
	 * 
	 * @param userNo
	 *            用户名ID
	 * @return List
	 */
	List<User> findEmployeeByNo(BigDecimal userNo);
	
	/**
	 * 获取当前登录用户所负责的店铺列表
	 * @param userNo
	 * @return
	 */
	List<Map<String,Object>> findShopByEmployeeNo(BigDecimal userNo, String name);
	
	/**
	 * 获取某个店铺的具体信息
	 * @param pkNo
	 * @return
	 */
	Map<String,Object> findShopByPkNo(BigDecimal pkNo);
	
	/**
	 * 根据关键字查找微店
	 * @param key
	 *           
	 * @return Page
	 */
	public Page findShopByKeyword(String key);
	
	/**
	 * 根据用户名查找店铺信息
	 * 
	 * @param username
	 *            用户名(忽略大小写)
	 * @return Map
	 */
	Map<String, Object> findShopByUsername(String username);
	
	/**
	 * 根据用户id查找店铺信息
	 * 
	 * @param userno
	 *            用户id
	 * @return Map
	 */
	Map<String, Object> findShopByUserNo(BigDecimal userno);
	
	/**
	 * 获取当前登录用户附近店铺列表
	 * @param userNo
	 * @return
	 */
	List<Map<String,Object>> findShopByLonLat(BigDecimal userNo, String name, BigDecimal longitude, BigDecimal latitude);
	
	/**
	 * 获取当前登录用户附近店铺列表
	 * @param userNo
	 * @return
	 */
	Page<Map<String,Object>> findShopByLonLat(Map<String, Object> paramMap);
	
	/**
	 * 根据条件查询员工列表
	 * @param param
	 * 		Map<String, Object>类型参数集合，包括商品id，投诉状态和用户类型
	 * @return PageView<Map<String, Object>>
	 */
	Page<Map<String, Object>> getEmployByName(Map<String, Object> param);
	/**
	 * 根据绑定手机号查找会员
	 * @param bundingMobile
	 *            用户手机号
	 * @author:liujing
	 * @date:2015-08-24 11:18
	 * @return User
	 */
	User findByBundingMobile(String bundingMobile);
	/**
	 * 判断绑定手机号是否存在
	 * @author: lj
	 * @param bundingMobile
	 * @return
	 * @date : 2015-8-24下午5:04:56
	 */
	boolean bundingMobileExists(String bundingMobile);
	/**
	 * 通过userNo查询userName
	 */
	public Map<String, Object> findUsername(String userNo);
	
	/**
	 * 通过订单ID获取所属店铺位置
	 * @param orderId
	 * @return
	 */
	public List<Map<String,Object>> getLocationByOrderId(BigDecimal[] ids);
	
	/**
	 * 查询系统供应商列表
	 * @return
	 */
	public List<Map<String,Object>> findSupp();
	
	/**
	 * 查询系统物流商列表
	 * @return
	 */
	public List<Map<String,Object>> findLogistics();
	/**
	 * 获取B2c所有用户(供应商和店铺)  page
	 * @param paramMap 查询参数
	 * @param orderby	排序参数
	 * @author lj
	 * @date 2015-10-21 19:16
	 * @return page分页对象
	 */
	public Page findB2cUserPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

	/**
	 * @Description 获取B2c所有用户(供应商和店铺)
	 * @return
	 * @date 2015-11-2 下午1:47:57
	 */
	public List<Map<String, Object>> getUser(Map<String, Object> paramMap);
	
	/**
	 * 查询业务员
	 * @param jsonObject
	 */
	public List<Map<String, Object>> getSalesmenUser(Map<String, Object> params);
	
	/**
	 * 根据用户编号，查找相对应的业务员
	 * @author: lj
	 * @param userNo
	 * @return
	 * @date : 2015-11-6上午10:42:00
	 */
	public Map<String,Object> findSPUserByUserNo(BigDecimal userNo);
	
	/**
	 * 通过masNo查询物流人员信息
	 * @param masNo
	 * 		订单ID
	 * @return
	 */
	public Map<String, Object> findLogisticsUserByOrderID(BigDecimal orderId);

	/***显示业务员当前客户数（负责的店铺个数），销售额（负责的店铺销售总 额）和 排名
	 * 按照日 ,周  ，月（date）
	 * @param userNo
	 * @return
	 */
	public  Map<String,Object> findRankInfo(BigDecimal userNo, String date);

	/***显示业务员当前客户数（负责的店铺个数），销售额（负责的店铺销售总 额）和 排名
	 * 按照日（D） ,周(W)  ，月(M)（date）
	 * @param userNo
	 * @return
	 */
	public Map<String,Object> findLogisticsInfo(BigDecimal userNo, String date);

	/**显示物流人员当前业绩排名
	 * @param map
	 * @return
	 */
	public Map<String,Object> findLogisticsRank(BigDecimal userNo);

	/**显示业务员当前业绩排名
	 * @param map
	 * @return
	 */
	public Map<String,Object> getRank(BigDecimal userNo);
	
	/**
	 * 获取当前登录供应商旗下的店铺列表
	 * @param userNo
	 * @return
	 */
	public List<Map<String,Object>> findShopByEmployeeNo(BigDecimal userNo);

	/**
	 * 2015-12-10
	 * 查询拣货员的供应商及仓库（仓库为null则表示SOP）
	 * @param 
	 */
	public Map<String, Object> getUserVENDOR_CODE(Map<String, Object> params);
	
	/**
	 * 2015年12月29日17:40:35
	 * 获取运营中心用户信息
	 * @author RJY
	 * @param param
	 * @return
	 */
	public Page<Map<String, Object>> getOperationsCenter(Map<String, Object> param);
	
	/**
	 * 通过userName检查是否重名
	 * @param userName
	 * @return
	 * @author RJY
	 * @data 2016年1月14日10:52:01
	 */
	public List findByUserName(String userName);

	/**
	 * @Description 查询供应商列表
	 * @param params
	 * @return
	 * @date 2016-1-25 上午10:53:26
	 */
	public List findVendor(Map<String, Object> params);

	/**
	 * @Description 查找供应商列表
	 * @param params
	 * @return
	 * @date 2016-1-27 下午5:55:37
	 */
	public List<Map<String, Object>> findPromVendorList(
			Map<String, Object> params);
	
	/**
	 * 获取某一区域内的供应商列表
	 * @author SY
	 * @data 2016年1月27日
	 * @param paramMap
	 */
	public List findSupplyByAreaId(Map<String, Object> paramMap);
	
	/**
	 * 获取用户是否O2O店铺  
	 * 0否 1是 2审核中
	 * @param jobj
	 * @return
	 * 2016-02-01 zy
	 */
	public Map<String, Object> getUserO2OFlg(Map<String, Object> paramMap);
	
	/**
	 * 获取商户(店铺/供应商/物流商/O2O店铺/消费者)统计数据(按时间/区域统计)
	 * @author honghui
	 * @date   2016-03-18
	 * @param  paramMap 查询参数 时间段/区域
	 * @return
	 */
	public List<Map<String,Object>> getMerchantsStatistics(Map<String, Object> paramMap);
	
	/**
	 * 获取指定区域下所有商户(店铺/供应商/物流商/O2O店铺/消费者)USER_NO
	 * @author honghui
	 * @date   2016-03-23
	 * @param  paramMap 区域集合
	 * @return
	 */
	public List<BigDecimal> getAllUsersNoInAreas(List<BigDecimal> areaIds);
	
	/**
	 * 根据区域和时间来查询供货商数量
	 * 
	 * @param paramMap
	 * @param areaIds
	 * @return
	 */
	Page getSupplyCountByOperator(Map<String, Object> paramMap, String username);
	
	/**
	 * 根据区域和时间来查询客户数量
	 * @param paramMap
	 * @param areaIds
	 * @return
	 */
	Page getCustomerCountByOperator(Map<String, Object> paramMap, String username);

	/**
	 * 为运营中心获取区域商品信息
	 * 
	 * @param paramMap
	 * @param areaIds
	 * @return
	 */
	Page getStkMasCountForOperator(Map<String, Object> paramMap, String username);

	/**
	 * 根据区域来查询店铺，供应商，物流商，o2o店铺，消费者等统计信息
	 * 
	 * @param paramMap
	 * @param areaIds
	 * @return
	 */
	Page getCountDataByOperations(Map<String, Object> paramMap, String username);

	/**
	 * 根据区域来查询店铺，供应商，物流商，o2o店铺，消费者等sum信息
	 * 
	 * @param paramMap
	 * @param areaIds
	 * @return
	 */
	Object getSumCountDataByOperations(Map<String, Object> paramMap, String username);

	/**
	 * 根据refUserName查询user
	 * @param refUserName
	 * @return
	 */
	public List<User> findUserByRefUserNameAndMerchantCode(String refUserName, String merchantCode);
	
	/**
	 * 根据refUserName查询user_no
	 * @param refUserName
	 * @return
	 */
	public List<BigDecimal> findUserNosByRefUserName(String refUserName);

	/**
	 * 根据区域来查询店铺，供应商，物流商，o2o店铺的经纬度信息
	 * 
	 * @param paramMap
	 * @param areaIds
	 * @return
	 */
	List<Map<String, Object>> getCountMapTudeDataByOperations(Map<String, Object> paramMap, BigDecimal areaIds);
	
	
	
	/**
	 * 用于增加时配送员列表
	 * @param refUserName
	 * @return
	 */
	public List<User> findUserByRefUserNameCredit(String refUserName);
}