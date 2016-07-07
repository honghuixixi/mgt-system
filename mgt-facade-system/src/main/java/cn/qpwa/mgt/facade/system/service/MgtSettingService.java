package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtSetting;
import net.sf.json.JSONObject;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * 系统参数业务逻辑接口
 * @author TheDragonLord
 *
 */
@SuppressWarnings("rawtypes")
public interface MgtSettingService extends BaseService<MgtSetting> {
	/**
	 * 首先检查MGT_SETTING_DTL中，是否存在该设置，如果存在，则使用，如果不存在，则使用MGT_SETTING中的记录
	 * @author:lj
	 * @date 2015-7-24 下午4:12:02
	 * @param jobj
	 *        参数包括：merchantCode:供应商编号，item_no：系统参数主键
	 * @return
	 */
	public JSONObject querySettingByParam(JSONObject jobj);

	/**
	 * 获取系统参数列表
	 * @param paramMap
	 * 			查询条件参数集合
	 * @param orderby
	 * 			排序条件
	 * @return
	 * 			页面信息
	 */
	public Page mgtSettingList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

	/**
	 * 删除系统参数信息
	 * @param idArray
	 * 			系统参数id数组
	 */
	public void mgtSettingDelete(String[] idArray);

	/**
	 * 查找最大的ID
	 * @return
	 */
	public BigDecimal findMaxId();
	/**
	 * 查找最大的排序
	 * @return
	 */
	public BigDecimal findMaxSort();

	/**
	 * 根据id查找系统参数
	 * @param itemNo
	 * @return
	 */
	public MgtSetting findById(BigDecimal itemNo);

	/**
	 * 获取制定参数是否有效 
	 * @param strUserName
	 * @param itemNo
	 * @return Y or N
	 */
	public Map<String,Object> calcUsersetting(String strUserName, BigDecimal itemNo);
}
