package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.core.system.dao.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.service.MgtSettingService;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统参数业务逻辑接口实现类
 * @author TheDragonLord
 *
 */
@Service("mgtSettingService")
@SuppressWarnings("all")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class MgtSettingServiceImpl implements MgtSettingService {

	@Autowired
	MgtSettingDtlDAO mgtSettingDtlDAO;
	@Autowired
	UserDao userDao;
	@Autowired
	MgtSettingDAO mgtSettingDAO;
	@Autowired
	MgtEmployeeDao mgtEmployeeDao;

	 /** 首先检查MGT_SETTING_DTL中，是否存在该设置，如果存在，则使用，如果不存在，则使用MGT_SETTING中的记录
	 * @author:lj
	 * @date 2015-7-24 下午4:12:02
	 * @param jobj
	 *        参数包括：merchantCode:供应商编号，item_no：系统参数主键
	 * @return
	 */
	@Override
	public JSONObject querySettingByParam(JSONObject jobj){
		//验证参数有效性
		String itemNo = (String)jobj.get("itemNo");
		String accountName = (String)jobj.get("accountName");
		if(StringUtils.isEmpty(accountName)||StringUtils.isEmpty(itemNo)){
			jobj.put("code", "100");
			jobj.put("message", "参数验证有误");
			return jobj;
		}
		//查询employee 
		MgtEmployee employee = mgtEmployeeDao.findByAccountName(accountName);
		if(employee == null){
			//如果用户为空。则查询系统表
			jobj.put("message", "用户不存在");				
			jobj.put("code", "100");
			return jobj;
		}else{
			String merchantCode = employee.getMerchantCode();
			//如果主键id为空，查询所有的系统参数
			if(StringUtils.isEmpty(itemNo)){
				List list = mgtSettingDAO.querySettingListByItemNo(itemNo);
				jobj.put("data",list);
				jobj.put("userFlg", "N");
				jobj.put("code", "200");
				
				return jobj;
			}else{
				//如果主键id不为空，商家code为空。查询系统参数列表
				if(StringUtils.isEmpty(merchantCode)){
					List<Map<String,Object>> list = mgtSettingDAO.querySettingListByItemNo(itemNo);
					jobj.put("data",list);
					jobj.put("userFlg", "N");
				}else{
					//如果参数都不为空。首先查询参数设置表。
					Map<String,Object> param = new HashMap<String,Object>();
					param.put("itemNo", itemNo);
					param.put("merchantCode", merchantCode);
					List<Map<String,Object>> settingDtlList = mgtSettingDtlDAO.queryMgtSettingDtlList(param);
					//如果用户系统参数设置表为空。则查询系统表，否则读取这个用户系统设置表
					if(settingDtlList == null || settingDtlList.size()==0){
						List<Map<String,Object>> list = mgtSettingDAO.querySettingListByItemNo(itemNo);
						jobj.put("userFlg", "N");
						jobj.put("data",list);
					}else{
						jobj.put("userFlg", "Y");
						jobj.put("data",settingDtlList);
					}
				}
				
				jobj.put("code", "200");
			}
			return jobj;
		}
		
		
	}



	@Override
	public Page mgtSettingList(Map<String, Object> paramMap,
			LinkedHashMap<String, String> orderby) {
		return mgtSettingDAO.mgtSettingList(paramMap,orderby);
	}

	@Override
	public void mgtSettingDelete(String[] ids) {
		for (String idArray : ids) {
			BigDecimal id = new BigDecimal(idArray);
			mgtSettingDAO.removeById(id);
		}
		
	}

	@Override
	public void removeUnused(String paramString) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public MgtSetting get(String paramString) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void saveOrUpdate(MgtSetting entity) {
		mgtSettingDAO.save(entity);
		
	}

	@Override
	public BigDecimal findMaxId() {
		return mgtSettingDAO.findMaxId();
	}
	
	@Override
	public BigDecimal findMaxSort() {
		return mgtSettingDAO.findMaxSort();
	}

	@Override
	public MgtSetting findById(BigDecimal itemNo) {
		return mgtSettingDAO.get(itemNo);
	}
	
	/**
	 * 获取制定参数是否有效 
	 * @param itemNo
	 * @param strUserName
	 * @return Y or N
	 */
	@Override
	public Map<String,Object> calcUsersetting(String strUserName, BigDecimal itemNo){
		return mgtSettingDAO.calcUsersetting(strUserName, itemNo);
	}
	
	
	
	
}
