package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.MgtSettingDtl;

import java.util.List;
import java.util.Map;

/**
 * 系统参数设置表
 * @author liujing
 *
 */
@SuppressWarnings("rawtypes")
public interface MgtSettingDtlDAO extends EntityDao<MgtSettingDtl>{

	/**
	 * 根据系统参数主键和商家编号查询系统参数
	 * @author:lj
	 * @date 2015-7-24 下午4:46:24
	 * @param itemNo
	 * @param merchantCode
	 * @return
	 */
	public MgtSettingDtl findMgtSettingByItemNoAndCode(String itemNo, String merchantCode);
	
	/**
	 * 根据参数查询用户系统参数配置的分页列表
	 * @author:lj
	 * @date 2015-7-27 上午9:39:04
	 * @param param
	 * @return
	 */
	public List<Map<String, Object>> queryMgtSettingDtlList(Map<String, Object> param);

}
