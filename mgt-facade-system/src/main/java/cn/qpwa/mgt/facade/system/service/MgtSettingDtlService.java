package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.mgt.facade.system.entity.MgtSettingDtl;
import cn.qpwa.common.core.service.BaseService;

import java.util.List;
import java.util.Map;


@SuppressWarnings({"rawtypes"})
public interface MgtSettingDtlService extends BaseService<MgtSettingDtl>{

	/**
	 * 根据参数查询用户系统参数配置的分页列表
	 * @author:lj
	 * @date 2015-7-27 上午9:39:04
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> queryMgtSettingDtlList(Map<String, Object> param);
	/**
	 * 增加用户参数配置
	 * @author:lj
	 * @date 2015-7-27 上午9:42:40
	 * @param mgtSettingDtl
	 */
	public void addMgtSettingDtl(MgtSettingDtl mgtSettingDtl);
	/**
	 * 删除用户参数配置
	 * @author:lj
	 * @date 2015-7-27 上午9:45:21
	 * @param itemNo
	 * @param merchantCode
	 */
	public void deleteMgtSettingDtl(String itemNo, String merchantCode);
}
