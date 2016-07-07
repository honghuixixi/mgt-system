package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.page.PageView;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.common.utils.setting.Setting;
import cn.qpwa.common.utils.setting.SettingUtils;
import cn.qpwa.mgt.core.system.dao.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.service.UserService;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Ehcache;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.Assert;

import java.math.BigDecimal;
import java.util.*;

/**
 * 用户接口实现类
 * 
 * 
 */
@Service("userServiceImpl")
@SuppressWarnings("rawtypes")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class UserServiceImpl implements UserService {

	@Autowired
    UserDao userDao;
	@Autowired
	AreaMasWebDAO areaMasWebDAO;
	@Autowired
	ScuserAreaDAO scuserAreaDAO;
	@Autowired
	MgtEmployeeDao mgtEmployeeDao;
	@Autowired
	SubaccountDAO subaccountDAO;

	/** CacheManager */
	private static final CacheManager cacheManager = CacheManager.create();
	/**
	 * 获取所有用户
	 * @return
	 */
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<User> getAllUser() {
		return userDao.getAll();
	}

	/**
	 * 判断用户名是否存在
	 * @param username
	 *            用户名(忽略大小写)
	 * @return boolean
	 */
	public boolean usernameExists(String username) {
		return userDao.usernameExists(username);
	}

	/**
	 * 判断用户名是否禁用
	 * @param username
	 *            用户名(忽略大小写)
	 * @return boolean
	 */
	public boolean usernameDisabled(String username) {
		Assert.hasText(username);
		Setting setting = SettingUtils.get();
		if (setting.getDisabledUsernames() != null) {
			for (String disabledUsername : setting.getDisabledUsernames()) {
				if (StringUtils.containsIgnoreCase(username, disabledUsername)) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * 判断E-mail是否存在
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return boolean
	 */
	public boolean emailExists(String email) {
		// TODO Auto-generated method stub
		return false;
	}

	/**
	 * 判断E-mail是否唯一
	 * @param previousEmail
	 *            修改前E-mail(忽略大小写)
	 * @param currentEmail
	 *            当前E-mail(忽略大小写)
	 * @return boolean
	 */
	public boolean emailUnique(String previousEmail, String currentEmail) {
		// TODO Auto-generated method stub
		return false;
	}

	/**
	 * 保存会员
	 * @param user
	 *            会员
	 */
	public void save(User user) {
		
		userDao.save(user);
	}
	
	/**
	 * 更新会员密码
	 * @param password
	 * 	密码
	 * @param userName
	 * 	用户名
	 * @return
	 */
	public int updatePass(BigDecimal password, String userName) {	
		return userDao.updatePass(password,userName);
	}
	
	/**
	 * 更新会员AREA_ID
	 *@param paramMap
	 *	用户
	 */
	public int upAreaID(Map<String, Object> paramMap){
		return userDao.upAreaID(paramMap);
	}
	
	/**
	 * 更新会员注册信息
	 *@param user
	 *	会员实体
	 */
	public void update(User user) {	
		userDao.update(user);
	}

	/**
	 * 根据用户名查找会员
	 * @param username
	 *            用户名(忽略大小写)
	 * @return User
	 */
	public User findByUsername(String username) {

		return userDao.findByUsername(username);
	}
	
	/**
	 * 根据移动电话查找会员
	 * @param crmMobile
	 *            电话号码
	 * @return User
	 */
	public User findByCrmMobile(String crmMobile) {

		return userDao.findByCrmMobile(crmMobile);
	}

	/**
	 * 根据userNo查找会员
	 * @param userNo
	 * 	会员编号
	 */
	public User findByUserNo(BigDecimal userNo) {
		User user = null;
		user = userDao.findByUserNo(userNo);
		return user;
	}

	/**
	 * 根据E-mail查找会员
	 * @param email
	 *            E-mail(忽略大小写)
	 * @return User
	 */
	public List<User> findListByEmail(String email) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 查找会员消费信息
	 * @param beginDate
	 *            起始日期
	 * @param endDate
	 *            结束日期
	 * @param count
	 *            数量
	 * @return List
	 */
	public List<Object[]> findPurchaseList(Date beginDate, Date endDate,
			Integer count) {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 判断会员是否登录
	 * @return boolean
	 */
	public boolean isAuthenticated() {
		// TODO Auto-generated method stub
		return false;
	}

	/**
	 * 获取当前登录会员
	 * @return User
	 */
	public User getCurrent() {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 获取当前登录用户名
	 * @return username
	 */
	public String getCurrentUsername() {
		// TODO Auto-generated method stub
		return null;
	}

	/**
	 * 获取加密密码
	 * @param password
	 * 	密码
	 */
	public BigDecimal getPassword(String password) {
		return userDao.getPassword(password);
	}

	/**
	 * 获取组织机构信息
	 * @param user
	 * 会员实体
	 */
	public User findOrgInfo(User user) {
		return userDao.findOrgInfo(user);
	}
	
	@Override
	public List findSupplys(BigDecimal days) {
		return userDao.findSupplys(days);
	}
	
	@Override
	public List findDailySupplys() {
		return userDao.findDailySupplys();
	}
	
    @Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public PageView findAllUserPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby){
		if (null != paramMap && paramMap.containsKey("orderby")
				&& ("SC_CREATE_DATE".equals(paramMap.get("orderby").toString())
				|| "".equals(paramMap.get("orderby").toString()))) {
			paramMap.put("orderby", "sc.CREATE_DATE");
		}
			Page page = userDao.findAllUserPage(paramMap, orderby);
			// 拼装分页信息
			PageView result = new PageView(SystemContext.getPagesize(),
					SystemContext.getOffset());
			result.setQueryResult(page);
			return result;
		
	}

	@Override
	public User findByOpenId(String openID) {
		return userDao.findUniqueBy(User.class, "openID", openID);
	}

	@Override
	public Map<String, Object> findEmployeeByUsername(String username) {
		return userDao.findEmployeeByUsername(username);
	}

	@Override
	public List<User> findEmployeeByNo(BigDecimal userNo) {
		return userDao.findEmployeeByNo(userNo);
	}

	@Override
	public List<Map<String, Object>> findShopByEmployeeNo(BigDecimal userNo,String name) {
		return userDao.findShopByEmployeeNo(userNo,name);
	}

	@Override
	public Map<String, Object> findShopByPkNo(BigDecimal pkNo) {
		return userDao.findShopByPkNo(pkNo);
	}

	@Override
	public void saveLongitudeLatitude(User user) {
		userDao.save(user);
	}

	@Override
	public Page findShopByKeyword(String key) {
		return userDao.findShopByKeyword(key);
	}

	@Override
	public Map<String, Object> findShopByUsername(String username) {
		return userDao.findShopByUsername(username);
	}
	
	@Override
	public Map<String, Object> findShopByUserNo(BigDecimal userno) {
		return userDao.findShopByUserNo(userno);
	}
//
//	@Deprecated
//	public List<Map<String, Object>> findShopByLonLat(BigDecimal userNo,String name,
//			BigDecimal longitude, BigDecimal latitude) {
//		return userDao.findShopByLonLat(userNo,name, longitude, latitude);
//	}
	
	@Override
	public PageView<Map<String, Object>> findShopByLonLat(Map<String, Object> paramMap) {
		Page<Map<String, Object>> page = userDao.findShopByLonLat(paramMap);
		PageView<Map<String, Object>> result = new PageView<Map<String, Object>>(SystemContext.getPagesize(), SystemContext.getOffset());
		result.setQueryResult(page);
		return result;
//		return userDao.findShopByLonLat(paramMap);
	}

	@Override
	public List<User> findAll() {
		return userDao.getAll();
	}

	@Override
	public PageView<Map<String, Object>> getEmployByName(
			Map<String, Object> param) {
		Page<Map<String, Object>> page = null;
		PageView<Map<String, Object>> pageView = null;
		if(!param.isEmpty() && param.size() > 0) {
			// 设置每页显示10条记录
			SystemContext.setPagesize(10);
			page = userDao.getEmployByName(param);
		}
		if (null != page) {
			pageView = new PageView<Map<String, Object>>(SystemContext.getPagesize(), SystemContext.getOffset());
			pageView.setQueryResult(page);
		}
		return pageView;
	}

	@Override
	public Map<String, Object> findUserByCrmMobile(String crmMobile) {
		return userDao.findUserByCrmMobile(crmMobile);
	}
	/**
	 * 根据绑定手机号查找会员
	 * @param bundingMobile
	 *            用户手机号
	 * @author:liujing
	 * @date:2015-08-24 11:18
	 * @return User
	 */
	@Override
	public User findByBundingMobile(String bundingMobile){
		return userDao.findByBundingMobile(bundingMobile);
	}
	/**
	 * 判断绑定手机号是否存在
	 * @author: lj
	 * @param bundingMobile
	 * @return
	 * @date : 2015-8-24下午5:04:56
	 */
	@Override
	public boolean bundingMobileExists(String bundingMobile){
		return userDao.bundingMobileExists(bundingMobile);
	}

	@Override
	public List<Map<String,Object>> findSupp() {
		return userDao.findSupp();
	}

	@Override
	public List<Map<String,Object>> findLogistics() {
		return userDao.findLogistics();
	}
	/**
	 * 获取B2c所有用户(供应商和店铺)  page
	 * @param paramMap 查询参数
	 * @param orderby	排序参数
	 * @author lj
	 * @date 2015-10-21 19:16
	 * @return page分页对象
	 */
	@Override
	public Page queryB2cUsers(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){
		return userDao.findB2cUserPage(paramMap, orderby);
	}

	@Override
	public List<Map<String, Object>> getUsers(Map<String, Object> paramMap) {
		return userDao.getUser(paramMap);
	}

	@Override
	public List<Map<String, Object>> getSalesmenUser(Map<String, Object> params) {
		return userDao.getSalesmenUser(params);
	}
	@Override
	public Map<String, Object> findUsername(String userNo) {
		return userDao.findUsername(userNo);
	}	

	@Override
	public Map<String, Object> findLogisticsUserByOrderId(BigDecimal orderId) {
		return userDao.findLogisticsUserByOrderID(orderId);
	}

	/***显示业务员当前客户数（负责的店铺个数），销售额（负责的店铺销售总 额）和 排名
	 * 按照日 ,周  ，月（date）
	 * @param userNo
	 * @return
	 */
	@Override
	public  Map<String,Object> findRankInfo(BigDecimal userNo,String date){
		return userDao.findRankInfo(userNo, date);
	}
	
	/***显示业务员当前客户数（负责的店铺个数），销售额（负责的店铺销售总 额）和 排名
	 * 按照日（D） ,周(W)  ，月(M)（date）
	 * @param userNo
	 * @return
	 */
	@Override
	public Map<String,Object> findLogisticsInfo(BigDecimal userNo, String date){
		return userDao.findLogisticsInfo(userNo, date);
	}

	/**显示物流人员当前业绩排名
	 * @param map
	 * @return
	 */
	@Override
	public Map<String,Object> findLogisticsRank(BigDecimal userNo){
		return userDao.findLogisticsRank(userNo);
	}

	/**显示业务员当前业绩排名
	 * @param map
	 * @return
	 */
	@Override
	public Map<String,Object> getRank(BigDecimal userNo){
		return userDao.getRank(userNo);
	}
	
	@Override
	public List<Map<String,Object>> findShopByEmployeeNo(BigDecimal userNo){
		return userDao.findShopByEmployeeNo(userNo);
	}
	
	/**
	 * 2015-12-10
	 * 查询拣货员的供应商及仓库（仓库为null则表示SOP）
	 * @param 
	 * select (SELECT USER_NAME FROM SCUSER WHERE USER_NO =  T2.MERCHANT_CODE) AS VENDOR_CODE, T2.WH_C 
	 * from 
	 * SCUSER T1 
	 * LEFT JOIN MGT_EMPLOYEE T2 ON T1.USER_NAME = T2.ACCOUNT_NAME  and T2.PICK_FLG ='Y'
	 * where T1.USER_NAME='ST-SOP'
	 */
	@Override
	public Map<String, Object> getUserVENDOR_CODE(Map<String,Object> params){
		return userDao.getUserVENDOR_CODE(params);
	}
	
	@Override
	public Page<Map<String, Object>> getOperationsCenter(Map<String, Object> param) {
		return userDao.getOperationsCenter(param);
	}
	
	@Override
	public void addArea(Map<String, Object> paramMap){
		String userName = (String) paramMap.get("userName");
		//清空分配区域
		scuserAreaDAO.deleteByUserName(userName);
		//清空缓存
		Ehcache cache = cacheManager.getEhcache(ScuserArea.CACHE_NAME);
		cache.remove(userName);
//		cache.put(new net.sf.ehcache.Element(userName, null));
		if (paramMap.containsKey("areaIds") && StringUtils.isNotBlank(paramMap.get("areaIds").toString())) {
			String[] areaIds = StringUtils.split(paramMap.get("areaIds").toString(), ",");
			for (String areaId : areaIds) {
			    List<AreaMasWeb> areaMasWeb = areaMasWebDAO.findBy(AreaMasWeb.class, "areaId", new BigDecimal(areaId));
				ScuserArea scuserArea = new ScuserArea();
				ScuserAreaId scuserAreaId = new ScuserAreaId();
				scuserAreaId.setUserName(userName);
				scuserAreaId.setAreaId(new BigDecimal(areaId));
				scuserArea.setId(scuserAreaId);
				scuserArea.setAreaGrade(areaMasWeb.get(0).getGrade());
				scuserArea.setCreateDate(DateUtil.toTimestamp(new Date()));
				scuserAreaDAO.save(scuserArea);
			}
		}
	}
	
	@Override
	public List findByUserName(String userName) {
		return userDao.findByUserName(userName);
	}
	
	@Override
	public void addUserAndEmployee(Map<String, Object> paramMap ,String merchantCode){

		BigDecimal password = userDao.getPassword(paramMap.get("userPassword").toString());
		User user = new User();
		user.setUserName(paramMap.get("userName").toString());
		user.setUserPassword(password);
		user.setName(paramMap.get("name").toString());
		user.setCrmPic(paramMap.get("crmPic").toString());
		user.setCrmMobile(paramMap.get("crmMobile").toString());
		user.setAreaId(new BigDecimal( paramMap.get("areaId").toString()));
		user.setShowFlg("Y");
		user.setOpcFlg("Y");
		user.setHqFlg(paramMap.get("hqFlg").toString());
		user.setShowFlg("Y");
		user.setBlockFlg("N");
		user.setOrgNo(new BigDecimal("100"));
		user.setCreateDate(DateUtil.toTimestamp(new Date()));
		if(merchantCode!=null){
			user.setParentAcc(new BigDecimal(merchantCode));
		}
		user.setCrmAddress1(paramMap.get("address").toString());
		user.setEmail(paramMap.get("email").toString());
		user.setRemark(paramMap.get("reMark").toString());
		user.setCrmZip(paramMap.get("crmZip").toString());
		user.setCrmFax(paramMap.get("crmFax").toString());
		userDao.save(user);
		MgtEmployee employee = new MgtEmployee();
		employee.setAccountName(user.getUserName());
		employee.setBlockFlg(user.getBlockFlg());
		employee.setStatus("1");
		employee.setMobile(user.getCrmMobile());
		employee.setMerchantCode(user.getUserNo().toString());
		employee.setPassword(user.getUserPassword().toString());
		employee.setUserCode(user.getUserName());
		employee.setUserName(user.getName());
		employee.setCreateDate(user.getCreateDate());
		employee.setEmail(paramMap.get("email").toString());
		employee.setAddress(paramMap.get("address").toString());
		employee.setMemo(paramMap.get("reMark").toString());
		mgtEmployeeDao.save(employee);
//		Subaccount subaccount = new Subaccount();
//		subaccount.setCustId(user.getUserName());
//		subaccount.setSubaccountType("9001");
//		subaccount.setCustName(user.getName());
//		subaccount.setCreateTime(user.getCreateDate());
//		subaccount.setAmount(new BigDecimal("0"));
//		subaccount.setCashAmount(new BigDecimal("0"));
//		subaccount.setUncashAmount(new BigDecimal("0"));
//		subaccount.setFreezeCashAmount(new BigDecimal("0"));
//		subaccount.setFreezeUncashAmount(new BigDecimal("0"));
//		subaccount.setProperty("1");
//		subaccount.setState("00");
//		subaccountDAO.save(subaccount);
		
	}
	
	@Override
	public void editUserAndEmployee(Map<String, Object> paramMap){
		BigDecimal userNo = new BigDecimal(paramMap.get("userNo").toString());
		BigDecimal areaId = new BigDecimal(paramMap.get("areaId").toString());
		User user = userDao.findByUserNo(userNo);
		user.setName(paramMap.get("name").toString());
		user.setCrmPic(paramMap.get("crmPic").toString());
		user.setCrmMobile(paramMap.get("crmMobile").toString());
		user.setHqFlg(paramMap.get("hqFlg").toString());
		user.setAreaId(areaId);
		user.setCrmAddress1(paramMap.get("address").toString());
		user.setEmail(paramMap.get("email").toString());
		user.setRemark(paramMap.get("reMark").toString());
		user.setCrmZip(paramMap.get("crmZip").toString());
		user.setCrmFax(paramMap.get("crmFax").toString());
		userDao.save(user);
		MgtEmployee employee = mgtEmployeeDao.findUniqueBy(MgtEmployee.class, "accountName", user.getUserName());
		if(employee!=null){
			employee.setUserName(user.getName());
			employee.setMobile(user.getCrmMobile());
			employee.setEmail(paramMap.get("email").toString());
			employee.setAddress(paramMap.get("address").toString());
			employee.setMemo(paramMap.get("reMark").toString());
			mgtEmployeeDao.save(employee);
		}
		
		Subaccount subaccount = subaccountDAO.findUniqueBy(Subaccount.class, "custId", user.getUserName());
		if(subaccount!=null){
			subaccount.setCustName(user.getName());
			subaccount.setLastupdateTime(DateUtil.toTimestamp(new Date()));
			subaccountDAO.save(subaccount);
		}
	}

	@Override
	public List findVendor(Map<String, Object> params) {
		return userDao.findVendor(params);
	}

	@Override
	public List<User> findBy(String name, Object value) {
		return userDao.findBy(User.class, name, value);
	}

	@Override
	public List<Map<String, Object>> findPromVendorList(
			Map<String, Object> params) {
		return userDao.findPromVendorList(params);
	}
	
	@Override
	public List findSupplyByAreaId(Map<String, Object> paramMap) {
		return userDao.findSupplyByAreaId(paramMap);
	}
	
	@Override
	public Map<String, Object> getUserO2OFlg(Map<String, Object> paramMap) {
		return userDao.getUserO2OFlg(paramMap);
	}
	
	@Override
	public List<Map<String, Object>> getMerchantsStatistics(Map<String, Object> paramMap) {
		//获取数据库统计数据
		List<Map<String, Object>> daoList = userDao.getMerchantsStatistics(paramMap); 
		List<Map<String,Object>> list = new ArrayList<Map<String,Object>>();
		//按日，周，月统计时 补充间断时间
		if (paramMap.containsKey("startDate") && paramMap.containsKey("endDate")  
				&& StringUtils.isNotBlank(paramMap.get("startDate").toString()) 
				&& StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
			//商户类型
			int merchantType = 0;
			if(paramMap.containsKey("merchantType") && StringUtils.isNotBlank(paramMap.get("merchantType").toString())){
				merchantType = Integer.parseInt(paramMap.get("merchantType").toString());
			}
			if(paramMap.containsKey("staTimeType") && StringUtils.isNotBlank(paramMap.get("staTimeType").toString())){
				String staTimeType = paramMap.get("staTimeType").toString();
				//按日统计
				if("day".equalsIgnoreCase(staTimeType)){
					String[] allDays = DateUtil.getEveryDayBetween(paramMap.get("startDate").toString(), paramMap.get("endDate").toString());
					String[] days = new String[daoList.size()];
					for (int i=0 ; i < daoList.size();i++) {
						days[i] = (String) daoList.get(i).get("DAY");
					}
					for(int j=0; j < allDays.length; j++){
						if(!Arrays.asList(days).contains(allDays[j])){
							//创建
							Map<String,Object> item = new HashMap<String,Object>();
							item.put("DAY", allDays[j]);
							if(merchantType == 1){item.put("PUR_QTY", 0);}
							if(merchantType == 2){item.put("LGS_QTY", 0);}
							if(merchantType == 3){item.put("CUS_QTY", 0);}
							if(merchantType == 4){item.put("O2O_QTY", 0);}
							if(merchantType == 5){item.put("C_QTY", 0);}
							if(merchantType == 6){item.put("MAS_QTY", 0);}
							list.add(item);
						}else{
							//从集合中取
							for (Map<String,Object> map : daoList) {
								if(map.containsKey("DAY") && StringUtils.isNotBlank(map.get("DAY").toString()) && allDays[j].equals(map.get("DAY").toString())){
									Map<String,Object> item = new HashMap<String,Object>();
									item.put("DAY", map.get("DAY").toString());
									if(merchantType == 1){item.put("PUR_QTY", map.get("PUR_QTY"));}
									if(merchantType == 2){item.put("LGS_QTY", map.get("LGS_QTY"));}
									if(merchantType == 3){item.put("CUS_QTY", map.get("CUS_QTY"));}
									if(merchantType == 4){item.put("O2O_QTY", map.get("O2O_QTY"));}
									if(merchantType == 5){item.put("C_QTY", map.get("C_QTY"));}
									if(merchantType == 6){item.put("MAS_QTY", map.get("MAS_QTY"));}
									list.add(item);
								}
							}
						}
					}
				}
				//按月统计
				if("month".equalsIgnoreCase(staTimeType)){
					String[] allMonths = DateUtil.getEveryMonthBetween(paramMap.get("startDate").toString(), paramMap.get("endDate").toString());
					String[] months = new String[daoList.size()];
					for (int i=0 ; i < daoList.size();i++) {
						months[i] = (String) daoList.get(i).get("MONTH");
					}
					for(int j=0; j < allMonths.length; j++){
						if(!Arrays.asList(months).contains(allMonths[j])){
							//创建
							Map<String,Object> item = new HashMap<String,Object>();
							item.put("MONTH", allMonths[j]);
							if(merchantType == 1){item.put("PUR_QTY", 0);}
							if(merchantType == 2){item.put("LGS_QTY", 0);}
							if(merchantType == 3){item.put("CUS_QTY", 0);}
							if(merchantType == 4){item.put("O2O_QTY", 0);}
							if(merchantType == 5){item.put("C_QTY", 0);}
							if(merchantType == 6){item.put("MAS_QTY", 0);}
							list.add(item);
						}else{
							//从集合中取
							for (Map<String,Object> map : daoList) {
								if(map.containsKey("MONTH") && StringUtils.isNotBlank(map.get("MONTH").toString()) && allMonths[j].equals(map.get("MONTH").toString())){
									Map<String,Object> item = new HashMap<String,Object>();
									item.put("MONTH", map.get("MONTH").toString());
									if(merchantType == 1){item.put("PUR_QTY", map.get("PUR_QTY"));}
									if(merchantType == 2){item.put("LGS_QTY", map.get("LGS_QTY"));}
									if(merchantType == 3){item.put("CUS_QTY", map.get("CUS_QTY"));}
									if(merchantType == 4){item.put("O2O_QTY", map.get("O2O_QTY"));}
									if(merchantType == 5){item.put("C_QTY", map.get("C_QTY"));}
									if(merchantType == 6){item.put("MAS_QTY", map.get("MAS_QTY"));}
									list.add(item);
								}
							}
						}
					}
				}
				//按周统计
				if("week".equalsIgnoreCase(staTimeType)){
					String[] allWeeks = DateUtil.getEveryWeekBetween(paramMap.get("startDate").toString(), paramMap.get("endDate").toString());
					String[] weeks = new String[daoList.size()];
					for (int i=0 ; i < daoList.size();i++) {
						weeks[i] = (String) daoList.get(i).get("WEEK");
					}
					for(int j=0; j < allWeeks.length; j++){
						if(!Arrays.asList(weeks).contains(allWeeks[j])){
							//创建
							Map<String,Object> item = new HashMap<String,Object>();
							item.put("WEEK", allWeeks[j]);
							if(merchantType == 1){item.put("PUR_QTY", 0);}
							if(merchantType == 2){item.put("LGS_QTY", 0);}
							if(merchantType == 3){item.put("CUS_QTY", 0);}
							if(merchantType == 4){item.put("O2O_QTY", 0);}
							if(merchantType == 5){item.put("C_QTY", 0);}
							if(merchantType == 6){item.put("MAS_QTY", 0);}
							list.add(item);
						}else{
							//从集合中取
							for (Map<String,Object> map : daoList) {
								if(map.containsKey("WEEK") && StringUtils.isNotBlank(map.get("WEEK").toString()) && allWeeks[j].equals(map.get("WEEK").toString())){
									Map<String,Object> item = new HashMap<String,Object>();
									item.put("WEEK", map.get("WEEK").toString());
									if(merchantType == 1){item.put("PUR_QTY", map.get("PUR_QTY"));}
									if(merchantType == 2){item.put("LGS_QTY", map.get("LGS_QTY"));}
									if(merchantType == 3){item.put("CUS_QTY", map.get("CUS_QTY"));}
									if(merchantType == 4){item.put("O2O_QTY", map.get("O2O_QTY"));}
									if(merchantType == 5){item.put("C_QTY", map.get("C_QTY"));}
									if(merchantType == 6){item.put("MAS_QTY", map.get("MAS_QTY"));}
									list.add(item);
								}
							}
						}
					}
				
				}
			}
		}
		return list;
	}

	@Override
	public List<BigDecimal> getAllUsersNoInAreas(List<BigDecimal> areaIds) {
		return userDao.getAllUsersNoInAreas(areaIds);
	}

	@Override
	public List<BigDecimal> findUserNosByRefUserName(String refUserName) {
		return userDao.findUserNosByRefUserName(refUserName);
	}
	
	@Override
	public List<User> findUserByRefUserNameAndMerchantCode(String refUserName,String merchantCode) {
		return userDao.findUserByRefUserNameAndMerchantCode(refUserName,merchantCode);
	}

	@Override
	public List<User> findUserByRefUserNameCredit(String refUserName) {
		// TODO Auto-generated method stub
		return userDao.findUserByRefUserNameCredit(refUserName);
	}

}
