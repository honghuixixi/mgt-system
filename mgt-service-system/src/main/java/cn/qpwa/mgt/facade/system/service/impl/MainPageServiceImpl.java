package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.facade.system.service.MainPageService;
import cn.qpwa.mgt.core.system.dao.MainPageDAO;
import cn.qpwa.mgt.facade.system.entity.MainPage;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service("mainPageService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class MainPageServiceImpl implements MainPageService{
	
    @Autowired
    MainPageDAO mainPageDAO;
    
    @Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MainPage findMainPageById(BigDecimal pkNo) {
    	MainPage mainPage = mainPageDAO.get(pkNo);
		return mainPage;
	}
    
 	@Override
 	public void save(MainPage mainPage) {		
     	mainPageDAO.save(mainPage);
 	}
}