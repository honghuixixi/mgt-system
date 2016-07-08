package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.core.system.dao.MgtModuleDao;
import cn.qpwa.mgt.facade.system.entity.MgtModule;
import cn.qpwa.mgt.facade.system.service.MgtModuleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Created by Administrator on 2016/7/8 0008.
 */
@Service("mgtModuleService")
@Transactional
@SuppressWarnings({ "rawtypes" })
public class MgtModuleServiceImpl implements MgtModuleService{

    @Autowired
    MgtModuleDao mgtModuleDao;

    @Override
    public void removeUnused(String paramString) {
        mgtModuleDao.removeById(paramString);
    }

    @Override
    public MgtModule get(String paramString) {
        return mgtModuleDao.get(paramString);
    }

    @Override
    public void saveOrUpdate(MgtModule paramT) {
        mgtModuleDao.save(paramT);
    }

    @Override
    public List selectMgtModuleList() {
        return mgtModuleDao.selectMgtModuleList();
    }
}
