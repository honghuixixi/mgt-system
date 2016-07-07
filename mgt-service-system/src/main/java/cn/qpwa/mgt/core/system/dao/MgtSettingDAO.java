package cn.qpwa.mgt.core.system.dao;


import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtSetting;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 系统参数访问层接口，提供CRUD操作
 * @author TheDragonLord
 *
 */
@SuppressWarnings("all")
public interface MgtSettingDAO extends EntityDao<MgtSetting>{
	

	/**
	 * 获取系统参数列表
	 * @param paramMap
	 * 			查询条件参数集合
	 * @param orderby
	 * 			排序条件
	 * @return
	 * 			返回页面信息
	 */
	Page mgtSettingList(Map<String, Object> paramMap,
						LinkedHashMap<String, String> orderby);

	/**
	 * 查找最大的Id
	 * @return
	 */
	BigDecimal findMaxId();
	
	/**
	 * 查找最大的排序
	 * @return
	 */
	public BigDecimal findMaxSort();
	
	/**
	 * 查询所有的系统参数
	 * @author:lj
	 * @date 2015-7-28 上午9:38:42
	 * @return
	 */
	List<Map<String,Object>> querySettingListByItemNo(String itemNo);

	/**
	 * 获取制定参数是否有效 
	 * @param code
	 * 	编码
	 * @return Y or N
	 */
	public Map<String,Object> calcUsersetting(String strUserName, BigDecimal itemNo);
}
