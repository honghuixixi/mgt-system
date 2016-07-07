package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.mgt.core.system.dao.LandmarkMasDAO;
import cn.qpwa.mgt.core.system.dao.LmShopDAO;
import cn.qpwa.mgt.facade.system.entity.LandmarkMas;
import cn.qpwa.mgt.facade.system.entity.LmShop;
import cn.qpwa.mgt.facade.system.service.LandmarkMasService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * @Description 地标业务层接口实现类，提供业务逻辑相关操作
 * @author L.Dragon
 * @date 2015-10-25 下午3:37:38
 */
@Service("landmarkMasService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
@SuppressWarnings({"all"})
public class LandmarkMasServiceImpl implements LandmarkMasService {

	@Autowired
	LandmarkMasDAO landmarkMasDAO;
	@Autowired
	LmShopDAO lmShopDAO;
	
	
	@Override
	public List<Map<String, Object>> findLandmarkMasList() {
		return landmarkMasDAO.findLandmarkMasList();
	}

	@Override
	public List queryLandmarkByAreaId(Map<String, Object> paramMap) {
		return landmarkMasDAO.queryLandmarkByAreaId(paramMap);
	}

	@Override
	public void removeUnused(String paramString) {

		landmarkMasDAO.removeById(paramString);
		
	}

	@Override
	public LandmarkMas get(String id) {
		return landmarkMasDAO.get(id);
	}

	@Override
	public void saveOrUpdate(LandmarkMas paramT) {
		landmarkMasDAO.save(paramT);		
	}

	@Override
	public List<LandmarkMas> findBy(String[] propertyName, Object[] value) {
		return landmarkMasDAO.findBy(LandmarkMas.class, propertyName, value);
	}
	
	@Override
	public Page findLandMarkMasList(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){		
		if (null != paramMap && paramMap.containsKey("orderby")
				&& "".equals(paramMap.get("orderby").toString())) {
			paramMap.put("sord", "asc");
		}
		if (null != paramMap && paramMap.containsKey("orderby") && (!"".equals(paramMap.get("orderby").toString()))) {
			paramMap.put("orderby", "t."+paramMap.get("orderby").toString());
		}		
		Page type = landmarkMasDAO.findLandMarkMasList(paramMap,orderby);
		return type;
	}
	
	@Override
	public Msg delete(String id) {
		Msg msg = new Msg();
		LandmarkMas landmarkMas = landmarkMasDAO.get(id);
		LmShop lmShop = lmShopDAO.findUniqueBy(LmShop.class, "lmCode", landmarkMas.getCode());
		if(lmShop!=null){
			msg.setSuccess(true);
			msg.setCode("200");
			msg.setMsg("有店铺信息，删除失败！");
			return msg;
		}
		landmarkMasDAO.delete(id);
		msg.setCode("100");
		msg.setSuccess(true);
		msg.setMsg("删除成功！");
		return msg;
	}
	
	@Override
	public void editStatusFlgY(String[] ids) {
		LandmarkMas landmarkMas = null;
		LmShop lmShop = null;
		for (String id : ids) {
			landmarkMas = landmarkMasDAO.get(id);
			lmShop = lmShopDAO.findUniqueBy(LmShop.class, "lmCode", landmarkMas.getCode());
			if(lmShop==null){
				
			}else{
				lmShop.setStatusFlg("Y");
				lmShopDAO.save(lmShop);
			}
			landmarkMas.setStatusFlg("Y");
		}
		landmarkMasDAO.save(landmarkMas);
	}
	
	@Override
	public void editStatusFlgN(String[] ids) {
		LandmarkMas landmarkMas = null;
		LmShop lmShop = null;
		for (String id : ids) {
			landmarkMas = landmarkMasDAO.get(id);
			lmShop = lmShopDAO.findUniqueBy(LmShop.class, "lmCode", landmarkMas.getCode());
			if(lmShop==null){
				
			}else{
				lmShop.setStatusFlg("N");
				lmShopDAO.save(lmShop);
			}
			landmarkMas.setStatusFlg("N");
		}
		landmarkMasDAO.save(landmarkMas);
	}
	
	@Override
	public LandmarkMas getLandMarkMasByUUID(String id){
		return landmarkMasDAO.get(id);
	}
	
	@Override
	public List<Map<String, Object>> findShopByAreaId(Map<String, Object> params){
		return landmarkMasDAO.findShopByAreaId(params);
	}
	
	@Override
	public Page<Map<String, Object>> findLmMas(Map<String, Object> paramMap){
		return landmarkMasDAO.findLmMas(paramMap);
	}
	
	@Override
	public Page<Map<String, Object>> findLmShop(Map<String, Object> paramMap){
		return landmarkMasDAO.findLmShop(paramMap);
	}
	
	@Override
	public List<LandmarkMas> findByCode(String code){
		return landmarkMasDAO.findBy(LandmarkMas.class, "code", code);
	}

	@Override
	public List queryLandmarkByAreaIds(Map<String, Object> paramMap) {
		return landmarkMasDAO.queryLandmarkByAreaIds(paramMap);
	}
}
