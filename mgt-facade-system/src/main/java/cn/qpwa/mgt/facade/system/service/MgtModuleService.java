package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.mgt.facade.system.entity.MgtModule;

import java.util.List;

/**
 * Created by Administrator on 2016/7/8 0008.
 */
@SuppressWarnings("rawtypes")
public interface MgtModuleService extends BaseService<MgtModule> {

    List selectMgtModuleList();
}
