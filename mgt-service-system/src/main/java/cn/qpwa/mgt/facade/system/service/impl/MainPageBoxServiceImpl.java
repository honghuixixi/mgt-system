package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.facade.system.service.MainPageBoxService;
import cn.qpwa.mgt.core.system.dao.MainPageBoxDAO;
import cn.qpwa.mgt.core.system.dao.MainPageDAO;
import cn.qpwa.mgt.facade.system.entity.MainPageBox;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

@Service("mainPageBoxService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
public class MainPageBoxServiceImpl implements MainPageBoxService{
	
    @Autowired
    MainPageBoxDAO mainPageBoxDAO;
    @Autowired
    MainPageDAO mainPageDAO;
    
    @Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MainPageBox findMainPageBoxById(BigDecimal pkNo) {
    	MainPageBox mainPageBox = mainPageBoxDAO.get(pkNo);
		return mainPageBox;
	}
	
    @Override
    public void updateMainPageBox(BigDecimal masPkNo,String boxType,String boxImg,String href){
    	mainPageBoxDAO.updateMainPageBox(masPkNo,boxType,boxImg,href);
    }
   
	@Override
	public void save(MainPageBox mainPageBox) {		
    	mainPageBoxDAO.save(mainPageBox);
	}
	
	@Override
	public void delMainPageBox(BigDecimal[] ids){
		mainPageBoxDAO.delMainPageBox(ids);
	}
	
	@Override
	public void editDsave(String items){
		if(StringUtils.isNotBlank(items)){
			String[] itemArr = items.split(";");
			for(int i=0; i<itemArr.length; i++) {
				if(StringUtils.isNotBlank(itemArr[i])){
					String[] itemArra = itemArr[i].split(",");
					MainPageBox mainPageBox = mainPageBoxDAO.findUniqueBy(MainPageBox.class, "pkNo", new BigDecimal(itemArra[0]));
					if(!itemArra[1].equals("")){
						mainPageBox.setSortNo(new BigDecimal(itemArra[1]));
					}
					mainPageBox.setBoxImg(itemArra[2]);
					mainPageBoxDAO.save(mainPageBox);
				}
			}
		}
	}

	@Override
	public MainPageBox findByMasPkNoBoxType(BigDecimal masPkNo, String boxType) {
		String[] propertyName ={"masPkNo","boxType"};
		Object[] value ={masPkNo,boxType};
		return mainPageBoxDAO.findUniqueBy(MainPageBox.class, propertyName, value);
	}
	
	@Override
	public MainPageBox checkTypeByKeyWord(BigDecimal masPkNo, String boxType,String keyWord) {
		String[] propertyName ={"masPkNo","boxType","boxDesc"};
		Object[] value ={masPkNo,boxType,keyWord};
		return mainPageBoxDAO.findUniqueBy(MainPageBox.class, propertyName, value);
	}
}
