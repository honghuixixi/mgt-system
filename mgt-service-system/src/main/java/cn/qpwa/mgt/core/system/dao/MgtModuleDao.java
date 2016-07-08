package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.MgtModule;

import java.util.List;

/**
 * Created by Administrator on 2016/7/8 0008.
 */
@SuppressWarnings("rawtypes")
public interface MgtModuleDao extends EntityDao<MgtModule> {


    List selectMgtModuleList();

}
