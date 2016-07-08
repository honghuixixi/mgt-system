package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.mgt.facade.system.entity.VendorServiceProvider;
import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author honghui
 * @date   2016-05-25
 */
@SuppressWarnings("all")
public interface VendorServiceProviderDAO extends EntityDao<VendorServiceProvider>{

	/**
	 * 根据参数集合，获取客服分页列表
	 * @param paramsMap
	 * @param orderby
	 * @return
	 */
	public Page findPage(Map<String, Object> paramsMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 删除客服
	 * @param ids
	 */
	public void delete(String[] ids);
	
	/**
	 * 预览
	 */
	List<VendorServiceProvider> preview(String vendorCode);
	
	
}
