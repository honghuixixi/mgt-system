package cn.qpwa.mgt.facade.system.service.impl;


import cn.qpwa.common.utils.ValidateUtil;
import cn.qpwa.mgt.core.system.dao.AreaMasWebDAO;
import cn.qpwa.mgt.core.system.dao.ScuserAreaDAO;
import cn.qpwa.mgt.facade.system.entity.ScuserArea;
import cn.qpwa.mgt.facade.system.service.ScuserAreaService;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Ehcache;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

@Service("ScuserAreaService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class ScuserAreaServiceImpl implements ScuserAreaService{
	@Autowired
	private ScuserAreaDAO scuserAreaDAO;
	@Autowired
	private AreaMasWebDAO areaMasWebDAO;
	/** CacheManager */
	private static final CacheManager cacheManager = CacheManager.create();

	@Override
	public void removeUnused(String paramString) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public ScuserArea get(String paramString) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void saveOrUpdate(ScuserArea paramT) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public List<Map<String, Object>> findScuserAreaByUserName(String userName){
		return scuserAreaDAO.findByUserName(userName);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String,Object>> getAreaMasWebListByUserName(String userName){
		Ehcache cache = cacheManager.getEhcache(ScuserArea.CACHE_NAME);
		net.sf.ehcache.Element cacheElement = cache.get(userName);
		List<Map<String,Object>> list = null;
		if (cacheElement != null) {
			list = (List<Map<String,Object>>) cacheElement.getObjectValue();
		} else {
			list = new ArrayList<>();
			List<String> areaidsList = new ArrayList<>();
			List<Map<String,Object>> arealist = scuserAreaDAO.findByUserName(userName);
			for(Map<String,Object> areaMap : arealist){
				areaidsList.add(areaMap.get("AREA_ID").toString());
			}
			list = areaMasWebDAO.findAllAreaId(areaidsList.toArray(new String[0]));
		}
		cache.put(new net.sf.ehcache.Element(userName, list));
		return list;
	}

	@Override
	public Set<BigDecimal> getAreaByUserName(String userName) {
		Set<BigDecimal> set = new HashSet<BigDecimal>();
		List<Map<String,Object>> arealist = getAreaMasWebListByUserName(userName);
		if(null != arealist){
			for(Map<String,Object> areaMap : arealist){
				if(StringUtils.isNotBlank((String)areaMap.get("TREE_PATH"))){
					String[] trr = areaMap.get("TREE_PATH").toString().split(",");
					for(String id : trr){
						if(ValidateUtil.isBigDecimal(id)){
							set.add(new BigDecimal(id));
						}
					}
				}
				set.add((BigDecimal)areaMap.get("AREA_ID"));
			}
		}
		return set;
	}
}
