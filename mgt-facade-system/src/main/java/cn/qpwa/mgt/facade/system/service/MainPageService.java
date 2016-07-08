package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.mgt.facade.system.entity.MainPage;

import java.math.BigDecimal;

/**
 * Service - 首页数据表
 * @author sy
 * @version 1.0
 */
public interface MainPageService {
	
	/**
	 * 首页记录实体查询
	 * @param pkNo 记录ID
	 * @return 首页实体
	 */
	MainPage findMainPageById(BigDecimal pkNo);

	/**
	 * 保存  MainPage 记录 
	 * @param mainPage 首页数据实体
	 */
    void save(MainPage mainPage);
}
