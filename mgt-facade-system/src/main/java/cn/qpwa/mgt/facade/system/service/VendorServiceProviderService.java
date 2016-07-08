package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.mgt.facade.system.entity.VendorServiceProvider;
import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import net.sf.json.JSONObject;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author honghui
 * @date   2016-05-25
 */
@SuppressWarnings("all")
public interface VendorServiceProviderService extends BaseService<VendorServiceProvider>{
	
	/**
	 * 根据参数集合，获取客服分页列表
	 * @param paramsMap
	 * @param orderby
	 * @return
	 */
	public Page findPage(Map<String, Object> paramsMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 根据名称及供应商编码查询
	 * @param name
	 * @return
	 */
	public List<VendorServiceProvider> findByName(String name, String vendorCode);
	
	/**
	 * 预览
	 */
	public List<VendorServiceProvider> preview(String vendorCode);
	
	/**
     * 删去客服
     * @param ids 价格本ID字符串，使用逗号分割
     */
    public void delete(String[] ids);
    
    /**
     * 启用/停用客服
     * @param params
     */
	public Map<String,String> editStatus(JSONObject params);
	
	/**
	 * 根据主键查询
	 * @param pkNo
	 * @return
	 */
	public VendorServiceProvider findByPkNo(BigDecimal pkNo);
}
