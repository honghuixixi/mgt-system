package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.facade.system.service.VendorServiceProviderService;
import cn.qpwa.mgt.core.system.dao.VendorServiceProviderDAO;
import cn.qpwa.mgt.facade.system.entity.VendorServiceProvider;
import cn.qpwa.common.page.Page;
import net.sf.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @author honghui
 * @date   2016-05-25
 *
 */
@Service("vendorServiceProviderService")
@SuppressWarnings("all")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class VendorServiceProviderServiceImpl implements VendorServiceProviderService{

	@Autowired
	private VendorServiceProviderDAO vendorServiceProviderDAO;
	
	@Override
	public Page findPage(Map<String, Object> paramsMap, LinkedHashMap<String, String> orderby) {
		return vendorServiceProviderDAO.findPage(paramsMap, orderby);
	}

	@Override
	public List<VendorServiceProvider> findByName(String name,String vendorCode) {
		return vendorServiceProviderDAO.findBy(VendorServiceProvider.class, new String[]{"serviceName","vendorCode"}, new String[]{name,vendorCode});
	}

	@Override
	public void removeUnused(String paramString) {
		vendorServiceProviderDAO.remove(paramString);
	}

	@Override
	public VendorServiceProvider get(String paramString) {
		return vendorServiceProviderDAO.get(paramString);
	}

	@Override
	public void saveOrUpdate(VendorServiceProvider paramT) {
		vendorServiceProviderDAO.save(paramT);
	}
	
	@Override
	public void delete(String[] ids) {
		vendorServiceProviderDAO.delete(ids);
	}
	
	@Override
	public Map<String,String> editStatus(JSONObject params) {
		Map<String,String> map = new  HashMap<String,String>();
		VendorServiceProvider vendorServiceProvider = vendorServiceProviderDAO.get(new BigDecimal(params.getString("id")));
		if("A".equals(params.getString("status"))){
			List<VendorServiceProvider> list = vendorServiceProviderDAO.findBy(VendorServiceProvider.class, new String[]{"vendorCode","type","activeFlg"}, new String[]{vendorServiceProvider.getVendorCode(),vendorServiceProvider.getType(),"A"});
			if(null != list && list.size() >= 2){
				String type = "";
				if("1".equals(vendorServiceProvider.getType()))
					type = "售前";
				else if("2".equals(vendorServiceProvider.getType()))
					type = "售中";
				else if("3".equals(vendorServiceProvider.getType()))
					type = "售后";
				map.put("code", "error");
				map.put("msg", "启用中的"+type+"客服已经达到两个");
				return map;
			}
		}
		vendorServiceProvider.setActiveFlg(params.getString("status"));
		vendorServiceProviderDAO.save(vendorServiceProvider);
		map.put("code", "success");
		map.put("msg", "设置成功");
		return map;
	}
	
	@Override
	public VendorServiceProvider findByPkNo(BigDecimal pkNo) {
		return vendorServiceProviderDAO.findUniqueBy(VendorServiceProvider.class, "pkNo", pkNo);
	}

	@Override
	public List<VendorServiceProvider> preview(String vendorCode) {
		return vendorServiceProviderDAO.preview(vendorCode);
	}
}
