package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.AreaSetSqlUtil;
import cn.qpwa.common.utils.SqlUtil;
import cn.qpwa.common.utils.ValidateUtil;
import cn.qpwa.mgt.core.system.dao.UserDao;
import cn.qpwa.mgt.facade.system.entity.User;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.*;

/**
 * 用户管理数据访问层接口实现类
 * 
 */
@Repository("userDao")
@SuppressWarnings({"deprecation","rawtypes","unchecked"})
public class UserDaoImpl extends HibernateEntityDao<User> implements UserDao {
	
	/**
	 * 查询用户
	 * @param params 参数集合
	 * @param orderby	排序
	 * @return
	 */
	public Page queryUser(Map<String, Object> params,
			LinkedHashMap<String, String> orderby) {
		String sql = "select * from t_user u where username=?";
		return this.sqlQueryForPage(sql, new Object[] { params.get("username")}, orderby);
	}

	@Override
	public boolean usernameExists(String username) {
		User user = this.findUniqueBy("userName", username);
		return user != null;
	}

	@Override
	public boolean emailExists(String email) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public User findByUsername(String username) {
		
		if (username == null) {
			return null;
		}
		return this.findUniqueBy("userName", username);
	}
	
	@Override
	public User findByCrmMobile(String crmMobile) {
		if (crmMobile == null) {
			return null;
		}
		String sql = "select  * from SCUSER  where CRM_MOBILE ='" + crmMobile + "'  and ROWNUM = 1";
		Query query = super.createSQLQuery(sql).addEntity(User.class); //返回对象
		List list = query.list();
		if(list.size() == 1)
		{
			return (User)list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public User findByUserNo(BigDecimal userNo) {
		
		if (userNo == null) {
			return null;
		}
		return this.findUniqueBy("userNo", userNo);
	}

	@Override
	public List<User> findListByEmail(String email) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Override
	public int updatePass(BigDecimal password, String userName) {

		String sql="update SCUSER set USER_PASSWORD = ? where USER_NAME=?";
		return super.createSQLQuery(sql).setBigDecimal(0, password).setString(1, userName).executeUpdate();
	}	
	
	@Override
	public void update(User user) {
		
		String sql="update user set USER_PASSWORD = ?";
		this.getSession().update(sql, user);
	}	

	@Override
	public BigDecimal getPassword(String password) {
		String sql = "select NBBS_PWD('"+password+"') from dual";
	    SQLQuery query = this.getSession().createSQLQuery(sql);  
	    String str = query.uniqueResult().toString();  
	    return new BigDecimal(str); 
	}

	@Override
	public User findOrgInfo(User user) {
		if(user == null)
		{
			return null;
		}
		Connection conn = super.getSession().connection();
		try {
			CallableStatement call = conn
					.prepareCall("{Call B2B_SITE_UTIL.get_site_orginfo(?,?,?)}");
			call.registerOutParameter(1, oracle.jdbc.OracleTypes.NUMBER);
			call.registerOutParameter(2, oracle.jdbc.OracleTypes.NUMBER);
			call.registerOutParameter(3, oracle.jdbc.OracleTypes.NUMBER);
			call.execute();
			user.setLocNo((BigDecimal) call.getObject(1));
			user.setComNo((BigDecimal) call.getObject(2));
			user.setOrgNo((BigDecimal) call.getObject(3));
	    } catch (SQLException e) {
			e.printStackTrace();
		}
		return user;
	}
	
	@Override
	public List findSupplys(BigDecimal days) {
		String sql = "select su.USER_NAME,su.NAME,su.ALT_NAME,su.USER_NO from SCUSER su where su.USER_NAME in (select OLD_CODE from STK_MAS where(round(to_number(SYSDATE-CREATE_DATE)) < ?))";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, days).list();
	}
	
	@Override
	public List findDailySupplys() {
		String sql = "select su.USER_NAME,su.NAME,su.ALT_NAME,su.USER_NO from SCUSER su where su.USER_NAME in (SELECT sm.OLD_CODE"+
					" FROM WEB_PROM_ITEM1 wpi left join STK_MAS sm on WPI.STK_C = sm.STK_C WHERE wpi.STATUS_FLG = 'P' AND"+
					" (select to_char(sysdate,'yyyymmddhh24miss') from dual) >= to_char(wpi.BEGIN_DATE, 'yyyymmddhh24miss')"+ 
					" AND (select to_char(sysdate,'yyyymmddhh24miss') from dual) <= to_char(wpi.END_DATE, 'yyyymmddhh24miss' ))";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public Page findAllUserPage(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder(
				"select sc.CREATE_DATE,sc.USER_NO,sc.USER_NAME,sc.NAME,sc.CRM_ADDRESS1,sc.CRM_MOBILE,sc.CRM_PIC,"+
						"(case when mgt.id is null and (sc.PURCHASER_FLG='Y' or sc.LOGISTICS_PROVIDER_FLG='Y') then '未入驻' when mgt.id is null and sc.PURCHASER_FLG='N' then '--' else '已入驻' end) as join_flg,"+
						"(case when sc.SALESMEN_FLG='Y' and sc.PURCHASER_FLG='N' then '店铺' when sc.SALESMEN_FLG='N' and sc.PURCHASER_FLG='Y' then '供应商' when sc.SALESMEN_FLG='Y' and sc.PURCHASER_FLG='Y' then '供应+店铺' else '物流商' end) as bind_flg"+
				" from SCUSER sc left join MGT_EMPLOYEE mgt on to_char(sc.user_no) = mgt.merchant_code(+) where sc.COM_FLG='Y' and sc.BLOCK_FLG='N' and (sc.purchaser_flg = 'Y' or sc.logistics_provider_flg = 'Y')");
		if (null != paramMap) {
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString())) {
				sql.append(" and (sc.USER_NAME=:USER_NAME)");
				param.put("USER_NAME", paramMap.get("userName"));
			}
			if (paramMap.containsKey("typeFlg") && StringUtils.isNotBlank(paramMap.get("typeFlg").toString())) {
				if ("0".equals(paramMap.get("typeFlg").toString())) {
					sql.append(" and sc.SALESMEN_FLG ='Y' and sc.PURCHASER_FLG ='N'");
				}else if ("1".equals(paramMap.get("typeFlg").toString())) {
					sql.append(" and sc.PURCHASER_FLG ='Y'");
				}else if ("2".equals(paramMap.get("typeFlg").toString())) {
					sql.append(" and sc.LOGISTICS_PROVIDER_FLG is not null");
				}
			}
			if (paramMap.containsKey("status") && StringUtils.isNotBlank(paramMap.get("status").toString())) {
				if ("0".equals(paramMap.get("status").toString())) {
					sql.append(" and mgt.id is null");
				}else if ("1".equals(paramMap.get("status").toString())) {
					sql.append(" and mgt.id is not null");
				}
			}
			if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		Page page = super.sqlqueryForpage(sql.toString(), param, orderby);
		return page;
	}

	@Override
	public Map<String, Object> findEmployeeByUsername(String username) {
		String sql = "select T.AREA_ID, T.PICK_FLG,T.USER_NO,T.USER_NAME,T.USER_PASSWORD,T.GUEST_FLG,T.NAME,T.CRM_MOBILE,T.SALESMEN_FLG,T.DELIVERY_FLG,T.REF_USER_NAME,T.SHOW_FLG,T.BLOCK_FLG,T.PUBLIC_FLG,T.LOGISTICS_PROVIDER_FLG,T.WHKEEPER_FLG,t.REMARK1,t.BUNDING_MOBILE from scuser T where PUBLIC_FLG = 'N' AND SHOW_FLG = 'Y' AND T.USER_NAME=?";
		return (Map<String, Object>)this.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, username).uniqueResult();
	}


	@Override
	public List<User> findEmployeeByNo(BigDecimal userNo) {
		String sql  =  "Select SU.USER_NO,SU.USER_NAME,SU.NAME,SU.CRM_MOBILE,SU.SALESMEN_FLG,SU.DELIVERY_FLG,SU.WHKEEPER_FLG from SCUSER su " +
				"where su.PIC_NO =?";
		//List ls  =  this.getSession().createQuery(sql).list();
		List<User> ls  = super.createSQLQuery(sql).setBigDecimal(0, userNo).list();
		if(ls.size() > 0 && ls != null){
			return ls;
		}
		return null;
	}

	
	@Override
	public List<Map<String, Object>> findShopByEmployeeNo(BigDecimal userNo,String name) {
		// PUBLIC_FLG='Y'外部用户（供应商、店铺） ;COM_FLG='Y'公司;SALESMEN_FLG='Y'客户;GUEST_FLG='Y'已审核;BLOCK_FLG = 'N'未锁定;
		String sql = "select T.USER_NO,T.NAME,T.CRM_ADDRESS1,T.REMARK1,T.LATITUDE,T.LONGITUDE from SCUSER T where T.PUBLIC_FLG='Y' AND T.COM_FLG='Y' AND T.SALESMEN_FLG='Y' AND T.GUEST_FLG='Y' AND T.BLOCK_FLG = 'N' AND T.PIC_NO = ?";
		if(StringUtils.isNotEmpty(name)){
			sql = sql + " and T.NAME LIKE ?";
		}
		Query query = super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, userNo);
		if(StringUtils.isNotEmpty(name)){
			query.setString(1, "%" + name + "%");
		}
		return query.list();
	}

	@Override
	public Map<String, Object> findShopByPkNo(BigDecimal pkNo) {
		String sql = "select AC.NAME as TYPE_NAME,T.USER_NAME,T.USER_NO,T.NAME,T.CRM_ADDRESS1,T.AREA_ID,T.LATITUDE,T.LONGITUDE,T.REMARK,T.CRM_MOBILE,to_char(T.CREATE_DATE,'yyyy-mm-dd hh24:mi:ss') CREATE_DATE,T.CRM_PIC,T.REMARK1,T.REMARK4,(T.CRM_TEL)as TEL from SCUSER T left join ACC_CAT21 ac on T.ACC_CAT2 = AC.CODE where T.USER_NO = ?";
		return (Map<String, Object>) super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, pkNo).uniqueResult();
	}

	@Override
	public Page findShopByKeyword(String key) {
		String sql = "select T.REMARK1,T.NAME,T.CRM_ADDRESS1,T.USER_NAME,T.REMARK3,T.FREIGHT,T.reMark2 from SCUSER T where T.REF_STATUS = 'OPEN'";
		Map<String, String> para = new HashMap<String, String>();
		if(StringUtils.isNotEmpty(key)){
			sql = sql+" AND T.NAME LIKE :name ";
			para.put("name",  "%" + key + "%");
		}
		return super.sqlqueryForpage(sql, para, null);
	}	

	@Override
	public Map<String, Object> findShopByUsername(String username) {
		String sql = "select T.USER_NO,T.REMARK1,T.REMARK2,T.REMARK3,T.REF_STATUS,to_char(T.REF_DATE,'yyyy-mm-dd hh24:mi:ss') REF_DATE,T.ORDER_AMT,T.FREIGHT,T.NAME,T.CRM_ADDRESS1,T.AREA_ID,T.REMARK,T.LONGITUDE,T.LATITUDE from SCUSER T where T.USER_NAME = ?";
		return (Map<String, Object>)this.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, username).uniqueResult();
	}
	
	@Override
	public Map<String, Object> findShopByUserNo(BigDecimal userno) {
		String sql = "select T.USER_NO,T.REMARK1,T.REMARK2,T.REMARK3,T.REF_STATUS,to_char(T.REF_DATE,'yyyy-mm-dd hh24:mi:ss') REF_DATE,T.ORDER_AMT,T.FREIGHT,T.NAME from SCUSER T where T.USER_NO = ?";
		return (Map<String, Object>)this.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, userno).uniqueResult();
	}

	@Override
	public List<Map<String, Object>> findShopByLonLat(BigDecimal userNo,String name,
			BigDecimal longitude, BigDecimal latitude) {
		String sql = "select T.USER_NO,T.NAME,T.CRM_ADDRESS1 from SCUSER T where T.SALESMEN_FLG = 'Y' AND T.PIC_NO = ? ";
		if(StringUtils.isNotEmpty(name)){
			sql = sql+" AND T.NAME LIKE ? ORDER BY GET_DISTANCE_BY_LL(T.LONGITUDE,T.LATITUDE,?,?)";
			return super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, userNo).setString(1, "%" + name + "%")
					.setBigDecimal(2, longitude).setBigDecimal(3, latitude).list();
		}
		sql = sql+" ORDER BY GET_DISTANCE_BY_LL(T.LONGITUDE,T.LATITUDE,?,?)";
		return super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, userNo)
				.setBigDecimal(1, longitude).setBigDecimal(2, latitude).list();
	}
	
	@Override
	public Page<Map<String, Object>> findShopByLonLat(Map<String, Object> paramMap) {
		String sql = "select " +
				"USER_NO as SHOP_CODE, SHOP_NAME, ADDRESS,GET_DISTANCE_BY_LL(LONGITUDE,LATITUDE,:longitude,:latitude) AS DISTANCE, (CASE SHOP_TYPE WHEN 'PLATFORM' THEN 'Y' ELSE 'N' END)as SHOP_TYPE, SHOP_IMAGE " +
				"from APP_SHOP_MAS " +
				"where 1 = 1";
		Map<String, Object> param = new HashMap<String, Object>();
		LinkedHashMap<String, String> orderBy = new LinkedHashMap<String, String>();
		BigDecimal order = null;
		String shoptype = (String)paramMap.get("shoptype");
		//排序规则降序 默认降序
		if (!paramMap.containsKey("order") || paramMap.get("order") == null) {
			order = new BigDecimal(0);
		}else{
			order = new BigDecimal(paramMap.get("order").toString());
		}
		
		if(paramMap.containsKey("opcflg") && StringUtils.isNotBlank((String)paramMap.get("opcflg"))){
			sql += " AND SALESMEN_FLG = :opcflg";
			if(paramMap.get("opcflg").equals("Y")){
				param.put("opcflg", "Y");
			}
		}
		if(StringUtils.isEmpty((String)paramMap.get("name")) 
				&& (ValidateUtil.isBigDecimal((String)paramMap.get("longitude"))
						&& ValidateUtil.isBigDecimal((String)paramMap.get("latitude"))))
		{
			if (paramMap.containsKey("range") && paramMap.get("range") != null) {
				sql += " AND GET_DISTANCE_BY_LL(LONGITUDE,LATITUDE,:longitude,:latitude) < :range ";
				//判断用户提交距离，如果  == 0 初始化为1000 
				BigDecimal range = null;
				if (!paramMap.containsKey("range") || paramMap.get("range") == null) {
					range = new BigDecimal(1);
				}else{
					range = new BigDecimal((String)paramMap.get("range")).divide(new BigDecimal(1000));
				}
				if(range.intValue() <= 0)
				{
					range = new BigDecimal(1);
				}
				param.put("range", range);
			}
			param.put("longitude", paramMap.get("longitude"));
			param.put("latitude", paramMap.get("latitude"));
			if(paramMap.containsKey("picno") && StringUtils.isNotBlank((String)paramMap.get("picno")))
			{
				if(paramMap.containsKey("vendor") && StringUtils.isNotBlank((String)paramMap.get("vendor")))
				{
					sql += " AND PIC_NO in (select USER_NO from SCUSER where  REF_USER_NAME = :vendor)";
					param.put("vendor", paramMap.get("vendor"));
				}else{
					sql += " AND PIC_NO = :picno";
					param.put("picno", paramMap.get("picno"));
				}
				
			}
			if (order.intValueExact() > 0) {
				orderBy.put("GET_DISTANCE_BY_LL(LONGITUDE,LATITUDE,:longitude,:latitude)", "desc");
			}else{
				orderBy.put("GET_DISTANCE_BY_LL(LONGITUDE,LATITUDE,:longitude,:latitude)", "asc");
			}
			return super.sqlqueryForpage(sql.toString(), param, orderBy);
		}else{
			//按店铺名称
			if(StringUtils.isNotEmpty((String)paramMap.get("name"))){
				sql = sql+" AND SHOP_NAME LIKE :name ";
				param.put("name", "%" + paramMap.get("name") + "%");
			}
			//按店铺名称
			if(StringUtils.isNotEmpty((String)paramMap.get("userno"))){
				sql = sql+" AND USER_NO = :userno ";
				param.put("userno", paramMap.get("userno"));
			}
			//按店铺类型
			if (StringUtils.isNotEmpty(shoptype) && !shoptype.equals("0")) {
				//店铺类型0全部 1 PLATFORM 2 new
				if(shoptype.equals("2"))
				{
					shoptype = "NEW";
				}else{
					shoptype = "PLATFORM";
				}
				sql = sql+" AND SHOP_TYPE = :shoptype ";
				param.put("shoptype", shoptype);
			}
			//按区域id
			String areaid = (String)paramMap.get("areaid");
			if (StringUtils.isNotEmpty(areaid)) {
				//获取全国店铺
				if(!areaid.equals("-9999"))
				{
					sql = sql+" AND AREA_ID in(select AREA_ID from AREA_MAS_WEB WHERE TREE_PATH LIKE :areaid2 or AREA_ID = :areaid)";
					param.put("areaid", areaid);
					param.put("areaid2", "%," + areaid + ",%");
				}
			}
			if(paramMap.containsKey("picno") && StringUtils.isNotBlank((String)paramMap.get("picno")))
			{
				if(paramMap.containsKey("vendor") && StringUtils.isNotBlank((String)paramMap.get("vendor")))
				{
					sql += " AND PIC_NO in (select USER_NO from SCUSER where  REF_USER_NAME = :vendor)";
					param.put("vendor", paramMap.get("vendor"));
				}else{
					sql += " AND PIC_NO = :picno";
					param.put("picno", paramMap.get("picno"));
				}
				
			}
			
			
			
			if (order.intValueExact() > 0) {
				orderBy.put("AREA_ID, SHOP_NAME, SHOP_CODE", "desc");
			}else{
				orderBy.put("AREA_ID, SHOP_NAME, SHOP_CODE", "ASC");
			}
			return super.sqlqueryForpage(sql.toString(), param, orderBy);
		}
	}

	@Override
	public Page<Map<String, Object>> getEmployByName(
			Map<String, Object> param) {
		StringBuffer sql = new StringBuffer("select T.USER_NO,T.USER_NAME,T.USER_PASSWORD,T.GUEST_FLG,T.NAME,T.CRM_MOBILE,(CASE WHEN T.DELIVERY_FLG = 'Y' THEN '配送员' WHEN T.SALESMEN_FLG = 'Y' THEN '业务员'END) AS TYPE from scuser T where PUBLIC_FLG = 'N' AND SHOW_FLG = 'Y' AND SALESMEN_FLG = 'Y'");
		Map<String, Object> params = new HashMap<String, Object>(); 
		if (param.containsKey("userName") && StringUtils.isNotEmpty(param.get("userName").toString())) {
			sql.append(" AND T.NAME like :userName");
			params.put("userName", "%" + param.get("userName") + "%");
		}
		LinkedHashMap<String, String> orderBy = new LinkedHashMap<String, String>();
		orderBy.put("T.CREATE_DATE", "DESC");
		return super.sqlqueryForpage(sql.toString(), params, orderBy);
	}

	@Override
	public Map<String, Object> findUserByCrmMobile(String crmMobile) {
		if (crmMobile == null) {
			return null;
		}
		String sql = "select * from SCUSER  where CRM_MOBILE ='" + crmMobile + "'  and ROWNUM = 1";
		Query query = super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP); //返回对象
		List list = query.list();
		if(list.size() == 1)
		{
			return (Map<String, Object>) list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public Map<String, Object> findUsername(String userNo) {

		String sql="SELECT USER_NAME FROM SCUSER WHERE USER_NO=?";
		return (Map<String, Object>)this.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, userNo).uniqueResult();
	}	
	
	/**
	 * 更新会员AREA_ID
	 *@param paramMap
	 *	用户
	 *
	 */
	@Override
	public int upAreaID(Map<String, Object> paramMap)
	{
		//update： 2015-10-27 liujing，直接修改区域id，而不是通过查询地址主键
		String sql="update SCUSER set AREA_ID = :areaId  where  USER_NO=:userno";
		return super.createSQLQuery(sql, paramMap).executeUpdate();
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
		String sql = "select  * from SCUSER  where BUNDING_MOBILE ='" + bundingMobile + "'  and ROWNUM = 1";
		Query query = super.createSQLQuery(sql).addEntity(User.class); //返回对象
		List list = query.list();
		if(list.size() == 1)
		{
			return (User)list.get(0);
		}else{
			return null;
		}
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
		User user = this.findUniqueBy("bundingMobile", bundingMobile);
		return user == null?true:false;
	}

	@Override
	public List<Map<String,Object>> getLocationByOrderId(BigDecimal[] ids) {
		Map<String, Object> paramMap = new HashMap<String, Object>();
		String sql = "select u.NAME,u.LONGITUDE,u.LATITUDE from ORDER_MAS t left join scuser u on t.USER_NO = u.USER_NO where t.PK_NO IN (:orderIds)";
		paramMap.put("orderIds", ids);
		return super.createSQLQuery(sql,paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public List<Map<String,Object>> findSupp() {
		String sql = "select s.user_no,s.name from scuser s,stk_mas m where s.user_name=m.old_code and m.ep_flg='Y' group by s.user_no,s.name";
		return super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public List<Map<String,Object>> findLogistics() {
		String sql = "select s.user_no,s.name from scuser s where S.COM_FLG='Y' AND S.PUBLIC_FLG='Y' AND S.LOGISTICS_PROVIDER_FLG='Y'";
		return super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
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
	public Page findB2cUserPage(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("SELECT S.* FROM LM_SHOP L LEFT JOIN SCUSER S ON L.USER_NAME = S.USER_NAME WHERE LM_CODE IN ( select CODE from LANDMARK_MAS where AREA_ID in (SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR   area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:loginName)))"
				+ "and s.USER_NAME not in (select USER_NAME from B2C_PROM_USER where mas_pk_no = :masPkNo) ");
		param.put("loginName", paramMap.get("loginName"));
		param.put("masPkNo", paramMap.get("pkNo"));
		if (null != paramMap) {
			if (paramMap.containsKey("userName") && StringUtils.isNotBlank(paramMap.get("userName").toString())) {
				sql.append(" and (s.USER_NAME like :userName)");
				param.put("userName", "%" + paramMap.get("userName") + "%");
			}
			if (paramMap.containsKey("name") && StringUtils.isNotBlank(paramMap.get("name").toString())) {
				sql.append(" and (s.NAME like :name)");
				param.put("name", "%" + paramMap.get("name") + "%");
			}
			if (paramMap.containsKey("orderby") && StringUtils.isNotBlank(paramMap.get("orderby").toString())) {
				orderby = new LinkedHashMap<String, String>();
				orderby.put(paramMap.get("orderby").toString(), paramMap.get("sord").toString());
			}
		}
		Page page = super.sqlqueryForpage(sql.toString(), param, orderby);
		return page;
	}
	
	@Override
	public List<Map<String, Object>> getUser(Map<String, Object> param) {
		StringBuilder sql = new StringBuilder("SELECT S.* FROM LM_SHOP L LEFT JOIN SCUSER S ON L.USER_NAME = S.USER_NAME WHERE LM_CODE IN ( select CODE from LANDMARK_MAS where AREA_ID in (SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR   area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:loginName)))");
		 return super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public List<Map<String, Object>> getSalesmenUser(Map<String, Object> params) {
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql =new StringBuilder( "select me.*,s.USER_NO from MGT_EMPLOYEE me left join SCUSER s ON me.ACCOUNT_name=s.user_name where me.SALESMEN_FLG='Y' ");
		 if (params.containsKey("merchantCode") && !params.containsKey("super")) {
				sql.append(" AND me.merchant_code=:merchantCode ");
				param.put("merchantCode", params.get("merchantCode"));
			} 
		 return super.createSQLQuery(sql.toString(), param).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	

	@Override
	public Map<String, Object> getRank(BigDecimal userNo) {
		if(userNo==null){
			return null;
		}
		StringBuffer sql=new StringBuffer(" SELECT MAX(	CASE WHEN sp_user_no = ? THEN RANK ELSE 0 END )USER_RANK,MAX(RANK)RANK FROM(  ");
		sql.append(" SELECT om.sp_user_no,COUNT(DISTINCT om.cust_code)qty,SUM(om.amount)amt,RANK()OVER(ORDER BY SUM(amount) DESC)AS RANK FROM order_mas om ");
		
		sql.append(" WHERE om.status_flg<>'CLOSE' and om.internal_flg='N' and TRUNC(om.mas_date, 'mm')= TRUNC(SYSDATE, 'mm') AND om.sp_user_no IN(");
		
		sql.append(" SELECT user_no FROM	scuser WHERE ref_user_name IN( SELECT ref_user_name FROM scuser WHERE	user_no = ?	))");
		sql.append(" GROUP BY sp_user_no ORDER BY 3 DESC)");
		
		
		return (Map<String, Object>)super.createSQLQuery(sql.toString()).setBigDecimal(0, userNo).setBigDecimal(1, userNo).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();

	}


	@Override
	public Map<String, Object> findRankInfo(BigDecimal userNo, String date) {
		
		if(userNo==null||StringUtils.isBlank(date)){
			return null;
		}
		
		StringBuffer sql=new StringBuffer("select * from (select om.sp_user_no,count(distinct om.cust_code) qty,sum(om.amount) amt,RANK() OVER (ORDER BY SUM(amount) DESC) AS rank  from order_mas om where om.status_flg<>'CLOSE' and om.internal_flg='N' ");
		
		if(date.equals("D")){
			
			sql.append(" and  om.mas_date=trunc(sysdate) ");
		}else if(date.equals("W")){
			
			sql.append(" and  om.mas_date >=trunc(sysdate,'iw') ");
			
		}else if(date.equals("M")){
		
			sql.append(" and trunc(om.mas_date,'mm')=trunc(sysdate,'mm') ");
		}
		
		sql.append(" and om.sp_user_no in(select user_no from scuser where ref_user_name in(select ref_user_name from scuser where user_no=?)) ");
		
		sql.append(" group by sp_user_no order by 3 desc) where sp_user_no=?");
		
		System.out.println(sql.toString() );
		
		return (Map<String, Object>)super.createSQLQuery(sql.toString()).setBigDecimal(0, userNo).setBigDecimal(1, userNo).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
		

	}


	@Override
	public Map<String,Object> findLogisticsRank(BigDecimal userNo) {
		if(userNo==null){
			return null;
		}
		StringBuffer sql=new StringBuffer(" select max(case when logistic_user_code=? then rank else 0 end)user_rank,max(rank) rank from (select om.logistic_user_code,  ");
		sql.append(" RANK() OVER (ORDER BY count(om.mas_no) DESC) AS rank  from order_mas om where om.status_flg<>'CLOSE' and om.internal_flg='N' and trunc(om.mas_date,'mm')=trunc(sysdate,'mm') ");
		
		sql.append(" and om.logistic_user_code in(select user_no from scuser where ref_user_name in(select ref_user_name from scuser where user_no=?)) ");
		
		sql.append(" GROUP BY logistic_user_code ORDER BY 2 DESC)");
		
		System.out.println(sql.toString() );
		return (Map<String, Object>)super.createSQLQuery(sql.toString()).setBigDecimal(0, userNo).setBigDecimal(1, userNo).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();

	}

	@Override
	public Map<String,Object> findLogisticsInfo(BigDecimal userNo, String date) {
		if(userNo==null||StringUtils.isBlank(date)){
			return null;
		}
		
		StringBuffer sql=new StringBuffer("SELECT * FROM (SELECT om.logistic_user_code,COUNT(DISTINCT om.cust_code)qty,COUNT(om.mas_no)order_qty,RANK()OVER(ORDER BY SUM(amount) DESC)AS RANK FROM order_mas om WHERE  om.status_flg<>'CLOSE' and  om.internal_flg='N' ");
		
		if(date.equals("D")){
			
			sql.append(" and om.mas_date=trunc(sysdate) ");
		}else if(date.equals("W")){
			
			sql.append(" and om.mas_date >=trunc(sysdate,'iw') ");
			
		}else if(date.equals("M")){
		
			sql.append(" and  trunc(om.mas_date,'mm')=trunc(sysdate,'mm') ");
		}
		
		sql.append(" AND om.logistic_user_code IN(SELECT user_no FROM scuser WHERE ref_user_name IN(SELECT ref_user_name FROM scuser	WHERE user_no = ? )) ");
		
		sql.append(" GROUP BY	logistic_user_code ORDER BY 3 DESC) WHERE	logistic_user_code = ?");
		
		return (Map<String, Object>)super.createSQLQuery(sql.toString()).setBigDecimal(0, userNo).setBigDecimal(1, userNo).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	
	}
	

	@Override
	public Map<String, Object> findLogisticsUserByOrderID(BigDecimal orderId) {
		String sql = "SELECT s.name,s.remark1,s.user_no,s.BUNDING_MOBILE,(select name from scuser where user_name=s.ref_user_name) com_name FROM scuser s WHERE USER_NO = (SELECT om.LOGISTIC_USER_CODE FROM ORDER_MAS om WHERE om.PK_NO = ?)";
		return (Map<String, Object>) super.getSession().createSQLQuery(sql).setBigDecimal(0, orderId).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}

	@Override
	public Map<String, Object> findSPUserByUserNo(BigDecimal userNo) {
		String sql="select T1.USER_NO,T1.USER_NAME,T1.NAME from SCUSER T1 where T1.user_no = (select T2.pic_no from SCUSER T2 where T2.user_no = ?)";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return  (Map<String, Object>) query.setBigDecimal(0, userNo).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}
	
	@Override
	public List<Map<String, Object>> findShopByEmployeeNo(BigDecimal userNo) {
		String sql = "SELECT distinct om.USER_NO,om.CUST_NAME FROM ORDER_MAS om WHERE VENDOR_USER_NO=?";
		Query query = super.createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setBigDecimal(0, userNo);
		return query.list();
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
		StringBuffer sql = new StringBuffer(
				"select " +
				"(SELECT USER_NAME FROM SCUSER WHERE USER_NO =  T2.MERCHANT_CODE) AS VENDOR_NAME, " +
				"(SELECT NAME FROM SCUSER WHERE USER_NO =  T2.MERCHANT_CODE) AS V_NAME," +
				"(SELECT OPC_FLG FROM SCUSER WHERE USER_NO =  T2.MERCHANT_CODE) AS OPC_FLG," +
				"T2.WH_C, T1.NAME, T2.MERCHANT_CODE AS VENDOR_CODE " +
				"from " +
				"SCUSER T1 " +
				"LEFT JOIN MGT_EMPLOYEE T2 ON T1.USER_NAME = T2.ACCOUNT_NAME " +
				"where 1 = 1 ");
		if(params.containsKey("userName"))
		{
			sql.append(" AND T1.USER_NAME = :userName ");
		}
		if(params.containsKey("userNo"))
		{
			sql.append(" AND T1.USER_NO = :userNo ");
		}
		if(params.containsKey("pickFlg"))
		{
			sql.append(" AND T1.PICK_FLG = :pickFlg ");
		}
		if(params.containsKey("salesmenFlg"))
		{
			sql.append(" AND T1.SALESMEN_FLG = :salesmenFlg ");
		}
		return (Map<String, Object>)super.createSQLQuery(sql.toString(), params).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	}
	
	@Override
	public Page<Map<String, Object>> getOperationsCenter(
			Map<String, Object> param) {
		Map<String, Object> params = new HashMap<String, Object>(); 
		StringBuffer sql = new StringBuffer("select ");
				if (param.containsKey("userNo") && !param.containsKey("super")) {
					sql.append("(SELECT ss.HQ_FLG FROM SCUSER ss WHERE ss.USER_NO=:userNo) AS hq,");
					params.put("userNo", param.get("userNo"));
				}
				if(param.containsKey("super")){
					sql.append("('Y') AS hq,");
				}
				sql.append("me.ID,s.USER_NO,s.USER_NAME,s.NAME,s.CRM_PIC,s.CRM_MOBILE,(SELECT(SELECT x.area_name FROM AREA_MAS_WEB x WHERE x.area_id= (SELECT parent_id FROM AREA_MAS_WEB y WHERE y.area_id=z.parent_id))||(SELECT y.area_name FROM AREA_MAS_WEB y WHERE y.area_id=z.parent_id )||z.area_name FROM AREA_MAS_WEB z WHERE z.area_id=s.AREA_ID) AS AREA_NAME,s.CREATE_DATE,s.SHOW_FLG FROM SCUSER s LEFT JOIN MGT_EMPLOYEE me ON s.USER_NAME=me.ACCOUNT_NAME WHERE s.OPC_FLG='Y' ");
		if (param.containsKey("userNo") && !param.containsKey("super")) {
			sql.append("AND S.USER_NO != :userNo ");
			params.put("userNo", param.get("userNo"));
		}
		if (param.containsKey("areaId") && StringUtils.isNotBlank((String)param.get("areaId"))) {
			sql.append(" AND s.AREA_ID IN (SELECT amw.AREA_ID FROM AREA_MAS_WEB amw WHERE INSTR(amw.TREE_PATH,','||:areaId||',') > 0 or amw.AREA_ID=:areaId) ");
			params.put("areaId", param.get("areaId"));
		}
		if (param.containsKey("name") && StringUtils.isNotBlank((String)param.get("name"))) {
			sql.append(" and s.NAME like :name ");
			params.put("name", "%" + param.get("name") + "%");
		}
		if (param.containsKey("showFlg") && StringUtils.isNotBlank((String)param.get("showFlg"))) {
			sql.append(" AND s.SHOW_FLG=:showFlg ");
			params.put("showFlg", param.get("showFlg"));
		}
		if (param.containsKey("userNo") && !param.containsKey("super")) {
			sql.append(" START WITH s.USER_NO=:userNo CONNECT BY PRIOR s.USER_NO=s.PARENT_ACC");
			params.put("userNo", param.get("userNo"));
		}
		LinkedHashMap<String, String> orderBy = new LinkedHashMap<String, String>();
		orderBy.put("s.CREATE_DATE", "DESC");
		return super.sqlqueryForpage(sql.toString(), params, orderBy);
	}
	
	@Override
	public List findByUserName(String userName) {
		// String sql = "select * from t_role t where name=:name";
		String sql = "select * from SCUSER  s where USER_NAME=:userName";
		Query query = super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		query.setParameter("userName", userName);
		return query.list();
	}

	@Override
	public List findVendor(Map<String, Object> params) {
		String str = "SELECT su.USER_NAME, su. NAME,su.ALT_NAME, su.USER_NO FROM SCUSER su " +
				     "WHERE	su.USER_NAME IN ( SELECT OLD_CODE FROM STK_MAS 	WHERE EP_FLG='Y' "+
				     " and  stk_c IN (SELECT stk_c FROM STK_AREA SA WHERE SA.area_id ="+params.get("areaId")+
				     " OR EXISTS (SELECT 1 FROM AREA_MAS_WEB WHERE INSTR(tree_path,','||SA.area_id||',') > 0 AND area_id = "+params.get("areaId")+"))";
		StringBuffer sql = new StringBuffer(str);
		
		Map<String, Object> paramMap = new HashMap<String, Object>();
		if (params.get("days") != null) {
			sql.append("AND ROUND (	TO_NUMBER (SYSDATE - CREATE_DATE)	) < :days	 ");
			paramMap.put("days", params.get("days"));
		}
		if (params.get("catId") != null) {
			sql.append("AND  cat_id = :catId ");
			paramMap.put("catId", params.get("catId"));
		} 
		if (params.get("brandC") != null) {
			sql.append("AND  brand_C IN (:brandC) ");
			paramMap.put("brandC", params.get("brandC"));
		}
		sql.append(")");
		return super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	@Override
	public List<Map<String, Object>> findPromVendorList(
			Map<String, Object> params) {
		String str = "SELECT 	su.USER_NAME,	su. NAME,	su.ALT_NAME,	su.USER_NO FROM	SCUSER su WHERE	su.USER_NAME IN (		SELECT sm.OLD_CODE " +
				" FROM		WEB_PROM_ITEM1 wpi	LEFT JOIN STK_MAS sm ON WPI.STK_C = sm.STK_C	" +
				"left JOIN WEB_PROM_MAS wpm ON wpm.PK_NO = wpi.MAS_PK_NO   " +
				"WHERE	wpi.STATUS_FLG = 'P' AND (	SELECT TO_CHAR (SYSDATE, 'yyyymmddhh24miss')" +
				" FROM	dual	) >= TO_CHAR (wpi.BEGIN_DATE,	'yyyymmddhh24miss')	AND sm.ep_flg = 'Y'	AND sm.stk_c IN (	SELECT stk_c FROM	STK_AREA SA	WHERE	SA.area_id = " +params.get("areaId")+
				" OR EXISTS (	SELECT	1	FROM	AREA_MAS_WEB	WHERE	INSTR (	tree_path,',' || SA.area_id || ',') > 0	AND area_id = "+params.get("areaId")+"))AND (	SELECT TO_CHAR (SYSDATE, 'yyyymmddhh24miss')" +
				" FROM	dual) <= TO_CHAR (wpi.END_DATE,			'yyyymmddhh24miss')	";
		StringBuffer sql = new StringBuffer(str);
		Map<String, Object> paramMap = new HashMap<String, Object>();
		
		if (params.get("promPkNo") != null) {
			sql.append(" and wpi.pk_no=:promPkNo ");
			paramMap.put("promPkNo", params.get("promPkNo"));
		}
		if (params.get("masCode") != null) {
			sql.append(" AND wpi.mas_code = :masCode");
			paramMap.put("masCode", params.get("masCode"));
		}
		if (params.get("catId") != null) {
			sql.append("AND  sm.cat_id = :catId ");
			paramMap.put("catId", params.get("catId"));
		} 
		if (params.get("brandC") != null) {
			sql.append("AND sm.brand_c IN ("+params.get("brandC").toString()+") "); 
		}
		
		sql.append(")");
		return super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}
	
	@Override
	public List findSupplyByAreaId(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder(
			" select SC.* from scuser sc where sc.COM_FLG='Y' and sc.BLOCK_FLG='N' and sc.SALESMEN_FLG='Y' and PUBLIC_FLG='Y' and GUEST_FLG='Y' and SHOW_FLG='Y' and SC.purchaser_flg='Y'");
		if (null != paramMap) {
			if (paramMap.containsKey("areaIds") && StringUtils.isNotBlank(paramMap.get("areaIds").toString())) {
				sql.append(" and sc.AREA_ID in("+paramMap.get("areaIds")+")");
			}
		}
		Query query = super.createSQLQuery(sql.toString()).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP);
		return query.list();
	}	

	/**
	 * 获取用户是否O2O店铺  
	 * 0否 1是 2审核中
	 * @param jobj
	 * @return
	 * 2016-02-01 zy
	 */
	@Override
	public Map<String, Object> getUserO2OFlg(Map<String, Object> paramMap){

		StringBuffer sql = new StringBuffer(
				"select " +
				"O2O_FLG, (select STATUS_FLG from B2CAPP_LM_REQ where PK_NO = (select max(PK_NO) from B2CAPP_LM_REQ where USER_NAME = T1.USER_NAME))AS STATUS_FLG " +
				", (select ACTION_NAME from B2CAPP_LM_REQ_LOG where PK_NO = (select max(PK_NO) from B2CAPP_LM_REQ_LOG where ACTION_CODE = 'R' and ACTION_USER_NAME = T1.USER_NAME))AS ACTION_NAME " +
				"from SCUSER T1 " +
				"where " +
				"T1.user_name = :userName");
		return (Map<String, Object>)super.createSQLQuery(sql.toString(), paramMap).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).uniqueResult();
	
	}
	
	/**
	 * 运营中心商户分析统计 图表
	 * 
	 * @author honghui
	 * @date   2016-03-18
	 * @param  startDate='20160301'  开始时间
	 * 		   endDate='20160318'    截至时间
	 * 		   staTimeType           时间统计类型  按day-日,month-月,week-周 统计
	 * 		   merchantType          商户类型      1-供应商, 2-物流商, 3-店铺, 4-O2O店铺, 5-消费者
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getMerchantsStatistics(Map<String, Object> paramMap) {
		StringBuffer sql = new StringBuffer("SELECT");
		if(paramMap.containsKey("staTimeType") && StringUtils.isNotBlank(paramMap.get("staTimeType").toString())){
			String staTimeType = paramMap.get("staTimeType").toString();
			if("day".equalsIgnoreCase(staTimeType)){
				sql.append(" TO_CHAR(sc.create_date,'yyyy-mm-dd') as day");
			}
			if("month".equalsIgnoreCase(staTimeType)){
				sql.append(" TO_CHAR(sc.create_date,'yyyy-mm') as month");			
			}
			if("week".equalsIgnoreCase(staTimeType)){
				sql.append(" TO_CHAR(sc.create_date,'yyyy-IW') as week");
			}
		}
		int merchantType = 0;
		if(paramMap.containsKey("merchantType") && StringUtils.isNotBlank(paramMap.get("merchantType").toString())){
			merchantType = Integer.parseInt(paramMap.get("merchantType").toString());
			//供应商
			if(merchantType == 1){
				sql.append(",sum(case when sc.public_flg='Y' and sc.purchaser_flg='Y' then 1 else 0 end ) pur_qty");
			}
			//物流商
			if(merchantType == 2){
				sql.append(",sum(case when sc.public_flg='Y' and sc.logistics_provider_flg='Y' then 1 else 0 end ) lgs_qty");			
			}
			//店铺
			if(merchantType == 3){
				sql.append(",sum(case when sc.public_flg='Y' and sc.salesmen_flg='Y' then 1 else 0 end ) cus_qty");			
			}
			//O2O店铺
			if(merchantType == 4){
				sql.append(",sum(case when sc.o2o_flg='Y' then 1 else 0 end ) O2O_qty");			
			}
			//消费者数量
			if(merchantType == 5){
				sql.append(",sum(case when sc.public_flg='N' then 1 else 0 end ) c_qty");			
			}
			//商品数量
			if(merchantType == 6){
				sql.append(",count(*) mas_qty");
			}
		}
		if(merchantType == 6){
			sql.append(" from stk_mas sc where 1=1");
		}else{
			sql.append(" from scuser sc where 1=1");
		}
		/*if(paramMap.containsKey("areaIds") && null != paramMap.get("areaIds")){
			List<BigDecimal> list = (List)JSONArray.toCollection(JSONArray.fromObject(paramMap.get("areaIds").toString()), BigDecimal.class);  
			if(null != list && list.size() > 0){
				sql.append(" and ("+SqlUtil.getSqlIn(list, 1000, "sc.AREA_ID")+")");
			}
		}*/
		if(paramMap.containsKey("userName") && null != paramMap.get("userName")){
			//商品数量
			if(merchantType == 6){
				sql.append(" and sc.old_code in(select user_name from scuser where area_id"+
						" in(SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id =parent_id"+
						" START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name='"+paramMap.get("userName").toString()+"')))");
			}else{
				//供应商 物流商 店铺 O2O店铺 店铺 消费者
				sql.append(" and sc.AREA_ID IN (SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id =parent_id "+
						" START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name='"+paramMap.get("userName").toString()+"'))");
			}
		}
		if (paramMap.containsKey("startDate") && paramMap.containsKey("endDate")  
				&& StringUtils.isNotBlank(paramMap.get("startDate").toString()) 
				&& StringUtils.isNotBlank(paramMap.get("endDate").toString()) ) {
			sql.append(" and sc.create_date > TO_DATE('"+paramMap.get("startDate").toString()+"','yyyy-mm-dd') and sc.create_date < TO_DATE('"+paramMap.get("endDate").toString()+"','yyyy-mm-dd')");
		}
		if(paramMap.containsKey("staTimeType") && StringUtils.isNotBlank(paramMap.get("staTimeType").toString())){
			String staTimeType = paramMap.get("staTimeType").toString();
			if("day".equalsIgnoreCase(staTimeType)){
				sql.append(" group by to_char(sc.create_date,'yyyy-mm-dd')");
				sql.append(" order by to_char(sc.create_date,'yyyy-mm-dd')");
			}
			if("month".equalsIgnoreCase(staTimeType)){
				sql.append(" group by to_char(sc.create_date,'yyyy-mm')");
				sql.append(" order by to_char(sc.create_date,'yyyy-mm')");		
			}
			if("week".equalsIgnoreCase(staTimeType)){
				sql.append(" group by to_char(sc.create_date,'yyyy-IW')");
				sql.append(" order by to_char(sc.create_date,'yyyy-IW')");
			}
		}
		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();
	}

	/**
	 * 获取指定区域下所有商户(店铺/供应商/物流商/O2O店铺/消费者)USER_NO
	 * @author honghui
	 * @date   2016-03-23
	 * @param  paramMap 区域集合
	 * @return
	 */
	@Override
	public List<BigDecimal> getAllUsersNoInAreas(List<BigDecimal> areaIds) {
		StringBuffer sql = new StringBuffer("select sc.USER_NO from scuser sc where 1=1");
		if(null != areaIds && areaIds.size() > 0){
			sql.append(" and (" + SqlUtil.getSqlIn(areaIds, 1000, "sc.AREA_ID")+")");
		}
		SQLQuery query = super.getSession().createSQLQuery(sql.toString());
	    return query.list();
	}
	

	@Override
	public Page getSupplyCountByOperator(Map<String, Object> paramMap, String username) {
		StringBuilder sql = new StringBuilder(
				"SELECT * FROM (select ba.一级区域 as A1,ba.二级区域 AS A2,ba.三级区域 AS A3 ,sc.name as name,count(MAS_NO) AS COUNT,sum(om.amount-om.diff_misc_amt) as amount from scuser sc,bi_area_mas ba,order_mas om WHERE (sc.area_id=ba.id3 or sc.area_id=ba.id2 or sc.area_id=ba.id1) and sc.USER_NAME=om.VENDOR_CODE and sc.public_flg='Y' and sc.purchaser_flg='Y' and MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y'");
		Map<String, Object> param = new HashMap<String, Object>();
		AreaSetSqlUtil.setSqlAndParam(sql, param, username);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,ba.三级区域,sc.name ");
		LinkedHashMap<String, String> orderby = null;
		if (StringUtils.isNotBlank((String) paramMap.get("orderby"))) {
			sql.append("order by " + paramMap.get("orderby").toString() + " " + paramMap.get("sord").toString() + ")");
		} else {
			sql.append("order by 1,2,3)");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);

	}
	
	@Override
	public Page getCustomerCountByOperator(Map<String, Object> paramMap, String username) {
		/*StringBuilder sql = new StringBuilder(
				"SELECT * FROM (select ba.一级区域 as A1,ba.二级区域 AS A2,ba.三级区域 AS A3 ,sc.name as name,count(MAS_NO) AS COUNT,sum(om.amount-om.diff_misc_amt) as amount from order_mas om left join scuser sc on sc.user_name = om.cust_name left join bi_area_mas ba on (sc.area_id = ba.id3 or sc.area_id = ba.id2 or sc.area_id = ba.id1) "
				+ "WHERE MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' and om.vendor_code in (select s.user_name from scuser s where s.public_flg = 'Y' and s.purchaser_flg = 'Y'");
		Map<String, Object> param = new HashMap<String, Object>();
		sql.append(" and s.AREA_ID in (SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id = parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:username)))");
		param.put("username", username);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,ba.三级区域,sc.name ");
		LinkedHashMap<String, String> orderby = null;
		if (StringUtils.isNotBlank((String) paramMap.get("orderby"))) {
			sql.append("order by " + paramMap.get("orderby").toString() + " " + paramMap.get("sord").toString() + ")");
		} else {
			sql.append("order by 1,2,3)");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);*/
		
		Map<String, Object> param = new HashMap<String, Object>();
		StringBuilder sql = new StringBuilder("select k.一级区域 as A1,k.二级区域 as A2,k.三级区域 as A3,h.name,h.count,h.amount  from ");
		sql.append("(SELECT * FROM (select sc.name as name,om.area_id,count(MAS_NO) AS COUNT,sum(om.amount - om.diff_misc_amt) as amount"+
					" from order_mas om left join scuser sc on sc.user_name = om.cust_code and sc.com_flg = 'Y' WHERE MAS_CODE = 'SALES' AND STATUS_FLG = 'SUCCESS' "+
					" and om.internal_flg <> 'Y' and om.vendor_code in"+
					"(select s.user_name from scuser s where s.public_flg = 'Y' and s.purchaser_flg = 'Y' and s.AREA_ID in"+
                    "(SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id = parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name =:username)))");
		param.put("username", username);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}          
		sql.append(" group by sc.name,om.area_id order by COUNT desc))");
		sql.append(" h,bi_area_mas k where h.area_id = k.id3 ");
		LinkedHashMap<String, String> orderby = null;
		if (StringUtils.isNotBlank((String) paramMap.get("orderby"))) {
			sql.append("order by " + paramMap.get("orderby").toString() + " " + paramMap.get("sord").toString());
		} else {
			sql.append("order by 1,2,3");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public Page getStkMasCountForOperator(Map<String, Object> paramMap, String username) {

		StringBuilder sql = new StringBuilder(
				"SELECT * FROM (select ba.一级区域 as A1,ba.二级区域 AS A2,ba.三级区域 AS A3 ,(SELECT STK_NAME FROM ORDER_ITEM t WHERE t.stk_c=item.stk_c AND Rownum=1) NAME, SUM(item.stk_qty) AS COUNT, SUM(item.stk_qty * item.net_price - nvl(item.diff_misc_amt, 0)) AS amount from scuser sc,bi_area_mas ba,order_mas om,ORDER_ITEM item WHERE (sc.area_id=ba.id3 or sc.area_id=ba.id2 or sc.area_id=ba.id1) and om.VENDOR_CODE=sc.USER_NAME and sc.public_flg='Y' and om.PK_NO = item.MAS_PK_NO and om.MAS_CODE='SALES' AND STATUS_FLG not in('CLOSE','WAITPAYMENT') and om.internal_flg<>'Y' ");
		Map<String, Object> param = new HashMap<String, Object>();
		AreaSetSqlUtil.setSqlAndParam(sql, param, username);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and om.mas_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and om.mas_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.二级区域,ba.三级区域,item.stk_c ");
		LinkedHashMap<String, String> orderby = null;
		if (StringUtils.isNotBlank((String) paramMap.get("orderby"))) {
			sql.append("order by " + paramMap.get("orderby").toString() + " " + paramMap.get("sord").toString() + ")");
		} else {
			sql.append("order by 1,2,3)");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public Page getCountDataByOperations(Map<String, Object> paramMap, String username) {
		StringBuilder sql = new StringBuilder(
				"SELECT * FROM (select ba.id1 as ID1,ba.id2 as ID2,ba.id3 as ID3,ba.一级区域 as A1,ba.二级区域 AS A2,ba.三级区域 AS A3,sum(case when sc.public_flg='Y' and sc.purchaser_flg='Y' then 1 else 0 end ) pur_qty,sum(case when sc.public_flg='Y' and sc.salesmen_flg='Y' then 1 else 0 end ) cus_qty,sum(case when sc.public_flg='Y' and sc.logistics_provider_flg='Y' then 1 else 0 end ) lgs_qty,sum(case when sc.o2o_flg='Y' then 1 else 0 end ) O2O_qty,sum(case when sc.public_flg='N' then 1 else 0 end ) c_qty from scuser sc,bi_area_mas ba WHERE (sc.area_id=ba.id3 or sc.area_id=ba.id2 or sc.area_id=ba.id1)");
		Map<String, Object> param = new HashMap<String, Object>();
		AreaSetSqlUtil.setSqlAndParam(sql, param, username);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and sc.create_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and sc.create_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(" group by ba.一级区域,ba.id1,ba.二级区域,ba.id2,ba.三级区域,ba.id3 ");
		LinkedHashMap<String, String> orderby = null;
		if (StringUtils.isNotBlank((String) paramMap.get("orderby"))) {
			sql.append("order by " + paramMap.get("orderby").toString() + " " + paramMap.get("sord").toString() + ")");
		} else {
			sql.append("order by ba.id1,ba.id2,ba.id3)");
		}
		return super.sqlqueryForpage(sql.toString(), param, orderby);
	}

	@Override
	public Object getSumCountDataByOperations(Map<String, Object> paramMap, String username) {
		StringBuilder sql = new StringBuilder(
				"SELECT * FROM (select sum(case when sc.public_flg='Y' and sc.purchaser_flg='Y' then 1 else 0 end ) pur_qty,sum(case when sc.public_flg='Y' and sc.salesmen_flg='Y' then 1 else 0 end ) cus_qty,sum(case when sc.public_flg='Y' and sc.logistics_provider_flg='Y' then 1 else 0 end ) lgs_qty,sum(case when sc.o2o_flg='Y' then 1 else 0 end ) O2O_qty,sum(case when sc.public_flg='N' then 1 else 0 end ) c_qty from scuser sc,bi_area_mas ba WHERE (sc.area_id=ba.id3 or sc.area_id=ba.id2 or sc.area_id=ba.id1)");
		Map<String, Object> param = new HashMap<String, Object>();
		AreaSetSqlUtil.setSqlAndParam(sql, param, username);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and sc.create_date>=to_date(:startDate,'yyyy-mm-dd') ");
				param.put("startDate", paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and sc.create_date<=to_date(:endDate,'yyyy-mm-dd') ");
				param.put("endDate", paramMap.get("endDate"));
			}
		}
		sql.append(")");
		return super.sqlqueryForMap(sql.toString(), param);
	}

	@Override
	public List<Map<String, Object>> getCountMapTudeDataByOperations(Map<String, Object> paramMap, BigDecimal areaId) {
		StringBuilder sql = new StringBuilder(
				"select b.name as bname,b.crm_tel as btel,a.NAME,a.LATITUDE,a.LONGITUDE,a.purchaser_flg,a.salesmen_flg,a.logistics_provider_flg,a.o2o_flg,a.CRM_TEL,a.CRM_ADDRESS1,a.CRM_PIC,a.CRM_MOBILE "+""
						+ "from SCUSER a,SCUSER b where a.pic_no=b.user_no and (a.public_flg = 'Y' or a.o2o_flg='Y') "+
						"AND (a.LATITUDE IS NOT NULL AND a.LONGITUDE IS NOT NULL)");
		List<Object> param = new ArrayList<Object>(5);
		sql.append(" and (a.area_id= ? or exists (select id3 from bi_area_mas where id2=? and id3=a.AREA_ID))");
		param.add(areaId);
		param.add(areaId);
		if (paramMap != null) {
			if (paramMap.containsKey("startDate") && StringUtils.isNotBlank(paramMap.get("startDate").toString())) {
				sql.append(" and sc.create_date>=to_date(?,'yyyy-mm-dd') ");
				param.add(paramMap.get("startDate"));
			}
			if (paramMap.containsKey("endDate") && StringUtils.isNotBlank(paramMap.get("endDate").toString())) {
				sql.append(" and sc.create_date<=to_date(?,'yyyy-mm-dd') ");
				param.add(paramMap.get("endDate"));
			}
		}
		return super.sqlQueryForList(sql.toString(), param.toArray(), null);
	}

	@Override
	public List<User> findUserByRefUserNameAndMerchantCode(String refUserName,String merchantCode) {
		String sql = "select * from scuser where ref_user_name='"+refUserName+"' and user_name in (select account_name from mgt_employee t where t.merchant_code = '"+merchantCode+"')";
		return super.getSession().createSQLQuery(sql).addEntity(User.class).list();
	}
	
	@Override
	public List<BigDecimal> findUserNosByRefUserName(String refUserName) {
		String sql = "select sc.user_no from scuser sc where sc.ref_user_name='"+refUserName+"'";
		return super.getSession().createSQLQuery(sql).list();
	}

	@Override
	public List<User> findUserByRefUserNameCredit(String refUserName) {
		String sql = "select sc.* from scuser sc where sc.ref_user_name='"+refUserName+"' and  LOGISTICS_PROVIDER_FLG = 'Y' and sc.USER_NAME NOT IN (SELECT ACCOUNT_NAME FROM CreditPayment_Amount)";
		return super.getSession().createSQLQuery(sql).addEntity(User.class).list();
	}
}
