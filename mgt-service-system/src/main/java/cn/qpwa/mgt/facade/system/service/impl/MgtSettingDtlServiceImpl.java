package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.facade.system.service.MgtSettingDtlService;
import cn.qpwa.mgt.core.system.dao.MgtSettingDtlDAO;
import cn.qpwa.mgt.facade.system.entity.MgtSettingDtl;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

/**
 * 商户系统参数配置
 * @author lj
 *
 */
@Service("mgtSettingDtlService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MgtSettingDtlServiceImpl implements MgtSettingDtlService {

	@Autowired
	private MgtSettingDtlDAO mgtSettingDtlDAO;
	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<Map<String, Object>> queryMgtSettingDtlList(
			Map<String, Object> param) {
		return mgtSettingDtlDAO.queryMgtSettingDtlList(param);
	}

	@Override
	public void addMgtSettingDtl(MgtSettingDtl mgtSettingDtl) {
		//2015-12-17 lj增加，如果数据库中存在该数据。修改。没有的话新增
		MgtSettingDtl dtl = mgtSettingDtlDAO.findUniqueBy(
				MgtSettingDtl.class, 
				new String []{"employeeId","itemNo"}, 
				new Object[]{mgtSettingDtl.getEmployeeId(),mgtSettingDtl.getItemNo()});
		if(dtl!=null){
			dtl.setDefFlg(mgtSettingDtl.getDefFlg());
			dtl.setDefValue(mgtSettingDtl.getDefValue());
		}else{
			dtl = mgtSettingDtl;
		}
		mgtSettingDtlDAO.save(dtl);
	}

	@Override
	public void deleteMgtSettingDtl(String itemNo, String merchantCode) {
		//根据参数查询用户参数这条数据。
		MgtSettingDtl mgtSettingDtl = mgtSettingDtlDAO.findMgtSettingByItemNoAndCode(itemNo, merchantCode);
		if(mgtSettingDtl != null){
			mgtSettingDtlDAO.removeById(mgtSettingDtl.getUuid());
		}
	}

	@Override
	public void removeUnused(String paramString) {
		mgtSettingDtlDAO.removeById(paramString);
	}

	@Override
	public MgtSettingDtl get(String paramString) {
		return mgtSettingDtlDAO.get(paramString);
	}

	@Override
	public void saveOrUpdate(MgtSettingDtl paramT) {
		mgtSettingDtlDAO.save(paramT);
	}

}
