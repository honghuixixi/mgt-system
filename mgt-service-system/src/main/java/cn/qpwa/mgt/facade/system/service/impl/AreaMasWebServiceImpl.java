package cn.qpwa.mgt.facade.system.service.impl;


import cn.qpwa.mgt.core.system.dao.AreaMasWebDAO;
import cn.qpwa.mgt.facade.system.entity.AreaMasWeb;
import cn.qpwa.mgt.facade.system.service.AreaMasWebService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

@Service("areaMasWebService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class AreaMasWebServiceImpl implements AreaMasWebService {

	@Autowired
	AreaMasWebDAO areaMasWebDAO;

	@Override
	public List<AreaMasWeb> findRoots() {
		return areaMasWebDAO.findRoots();
	}

	@Override
	public List<AreaMasWeb> findChild(BigDecimal areaId) {
		return areaMasWebDAO.findChilds(areaId);
	}

	@Override
	public AreaMasWeb find(BigDecimal areaId) {
		if(areaId == null){
			return null;
		}
		return areaMasWebDAO.get(areaId);
	}

	@Override
	public AreaMasWeb getArea(String areaName) {
		return areaMasWebDAO.findUniqueBy(AreaMasWeb.class, "areaName", areaName);
	}
	
	@Override
	public Map<String, Object> findAll(BigDecimal areaId) {
		Map<String, Object> map = areaMasWebDAO.findAll(areaId);
		return map;
	}

	@Override
	public List<AreaMasWeb> findAll() {
		/**
		 * 更新 2016-02-01 zy
		 * 查询语句修改 增加开通状态
		 */
		return areaMasWebDAO.getAll();
	}
	
	@Override
	public List<AreaMasWeb> findAllCity() {
		return areaMasWebDAO.findBy(AreaMasWeb.class, "grade", new BigDecimal(2));
	}

	@Override
	public List<AreaMasWeb> findAllCounty() {
		return areaMasWebDAO.findBy(AreaMasWeb.class, "grade", new BigDecimal(3));
	}

	@Override
	public Map<String, Object> findFullName(BigDecimal areaId) {
		return areaMasWebDAO.findFullName(areaId);
	}

	@Override
	public Map<String, Object> findAllParntIdByAreaId(BigDecimal areaId) {
		return areaMasWebDAO.findAllParntIdByAreaId(areaId);
	}

	@Override
	public Map<String, Object> findRootsByAreaId(BigDecimal areaId) {
		
		return areaMasWebDAO.findRootsByAreaId(areaId);
	}

	@Override
	public Map<String, Object> findChildByRootAreaId(BigDecimal rootAreaId) {
		return areaMasWebDAO.findChildByRootAreaId(rootAreaId);
	}
	
	@Override
	public List<Map<String, Object>> findAllAreaId(Map<String, Object> param) {
		return areaMasWebDAO.findAllAreaId(param);
	}
	
	@Override
	public List<Map<String, Object>> findAllAreaId(String[] areaIdS){
		return areaMasWebDAO.findAllAreaId(areaIdS);
	}

	@Override
	public List<AreaMasWeb> findAllParentArea() {
		return areaMasWebDAO.findAllParentArea();
	}

	@Override
	public List<Map<String, Object>> findCityAreaId(Map<String, Object> param) {
		 return areaMasWebDAO.findCityAreaId(param);
	}
	
	@Override
	public List<Map<String, Object>> findWLCityAreaId(Map<String, Object> param) {
		return areaMasWebDAO.findWLCityAreaId(param);
	}
	
	@Override
	public List<Map<String, Object>> findDistAreaId(Map<String, Object> param) {
		return areaMasWebDAO.findDistAreaId(param);
	}
	
	@Override
	public List<Map<String, Object>> findWLDistAreaId(Map<String, Object> param) {
		return areaMasWebDAO.findWLDistAreaId(param);
	}
	
	@Override
	public List<AreaMasWeb> findAllAreaId(BigDecimal areaId) {
		/**
		 * 更新 2016-02-01 zy
		 * 查询语句修改 增加开通状态
		 */
		return areaMasWebDAO.findAllAreaId(areaId);
	}
	
	@Override
	public String findGradeByAreaId(BigDecimal areaId) {
		return areaMasWebDAO.findGradeByAreaId(areaId);
	}
	
	@Override
	public Map<String, Object> findChildByRootAreaId(String areaName, BigDecimal grade) {
		return areaMasWebDAO.findChildByRootAreaId(areaName, grade);
	}
	
	@Override
	public List<Map<String, Object>> findBelongAreaId(BigDecimal areaId){
		return areaMasWebDAO.findBelongAreaId(areaId);
	}

}