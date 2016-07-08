package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.excel.OutputExcelUtil;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.mgt.core.system.dao.*;
import cn.qpwa.mgt.facade.system.service.OperatorCenterService;
import cn.qpwa.mgt.facade.system.service.ScuserAreaService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.io.OutputStream;
import java.math.BigDecimal;
import java.util.List;
import java.util.Map;
import java.util.Set;


/**
 * 运营中心相关查询
 * 
 * @author HeWei
 *
 */
@Service
@SuppressWarnings({ "rawtypes", "unchecked" })
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class OperatorCenterServiceImpl implements OperatorCenterService {
	protected static final Logger logger = LoggerFactory.getLogger(OperatorCenterServiceImpl.class);

	@Autowired
	OrderMasDAO orderMasDAO;
	@Autowired
	UserDao userDao;
	@Autowired
	ScuserAreaService scuserAreaService;

	@Override
	public Page getOrderForOperator(Map<String, Object> paramMap, String userName) {
		return this.orderMasDAO.getOrderCountForOperator(paramMap, userName);
	}

	@Override
	public Page getVendorForOperator(Map<String, Object> paramMap, String userName) {
		return this.userDao.getSupplyCountByOperator(paramMap, userName);
	}

	@Override
	public Page getCustomerForOperator(Map<String, Object> paramMap, String userName) {
		return this.userDao.getCustomerCountByOperator(paramMap, userName);
	}

	@Override
	public Page getStkForOperator(Map<String, Object> paramMap, String userName) {
		return this.userDao.getStkMasCountForOperator(paramMap, userName);
	}

	@Override
	public void exportExcelForOperator(Map<String, Object> paramMap, String fileName, OutputStream out, String userName) {
		Page page = this.orderMasDAO.getOrderCountForOperator(paramMap, userName);
		if (null != page) {
			OutputExcelUtil.exportDataToExcel(fileName, out, new String[] { "一级区域", "二级区域", "三级区域", "订单数量", "销售金额" },
					new String[] { "A1", "A2", "A3", "COUNT", "AMT" }, page.getItems());
		}
	}

	@Override
	public void exportExcelVendorForOperator(Map<String, Object> paramMap, String fileName, OutputStream out,String userName) {
		Page page = this.userDao.getSupplyCountByOperator(paramMap, userName);
		if (null != page) {
			OutputExcelUtil.exportDataToExcel(fileName, out, new String[] { "一级区域", "二级区域", "三级区域", "供应商","订单数量","销售金额" },
					new String[] { "A1", "A2", "A3", "NAME","COUNT","AMOUNT" }, page.getItems());
		}
	}

	@Override
	public void exportExcelCustomerForOperator(Map<String, Object> paramMap, String fileName, OutputStream out,
			String userName) {
		Page page = this.userDao.getCustomerCountByOperator(paramMap, userName);
		if (null != page) {
			OutputExcelUtil.exportDataToExcel(fileName, out, new String[] { "一级区域", "二级区域", "三级区域", "客户", "订单数量",
					"销售金额" }, new String[] { "A1", "A2", "A3", "NAME", "COUNT", "AMOUNT" }, page.getItems());
		}
	}

	@Override
	public void exportExcelStkForOperator(Map<String, Object> paramMap, String fileName, OutputStream out,
			String userName) {
		Page page = this.userDao.getStkMasCountForOperator(paramMap, userName);
		OutputExcelUtil.exportDataToExcel(fileName, out, new String[] { "一级区域", "二级区域", "三级区域", "商品", "销售数量", "销售金额" },
				new String[] { "A1", "A2", "A3", "NAME", "COUNT", "AMOUNT" }, page.getItems());
	}


	@Override
	public Page getUserCountDataForOperations(Map<String, Object> paramMap, String userName) {
		return this.userDao.getCountDataByOperations(paramMap, userName);
	}
	
	@Override
	public void exportExcelMapDataForOperator(Map<String, Object> paramMap, String fileName, OutputStream out, String userName) {
		Page page = this.userDao.getCountDataByOperations(paramMap, userName);
			OutputExcelUtil.exportDataToExcel(fileName, out,
					new String[] { "一级区域", "二级区域", "三级区域", "店铺","供应商","物流商","O2O店铺","消费者" }, new String[] { "A1", "A2", "A3",
							"PUR_QTY", "CUS_QTY","LGS_QTY","O2O_QTY","C_QTY" }, page.getItems());
	}

	@Override
	public Object getSumCountDataForOperations(Map<String, Object> paramMap, String userName) {
		SystemContext.setPagesize(1);
		SystemContext.setOffset(1);
		Object object = this.userDao.getSumCountDataByOperations(paramMap, userName);
		return object;
	}

	@Override
	public List<Map<String, Object>> getUserCountMapTudeDataForOperations(Map<String, Object> paramMap, String userName, BigDecimal areaId) {
		Set<BigDecimal> areaIds = scuserAreaService.getAreaByUserName(userName);
		boolean exist = false;
		for(BigDecimal b:areaIds){
			if(b.longValue() == areaId.longValue()){
				exist = true;
				break;
			}
		}
		if (exist) {
			return this.userDao.getCountMapTudeDataByOperations(paramMap, areaId);
		} else {
			logger.error("areaId:"+areaId+" is not in user:" + userName + "'s area!");
			return null;
		}
	}

}
