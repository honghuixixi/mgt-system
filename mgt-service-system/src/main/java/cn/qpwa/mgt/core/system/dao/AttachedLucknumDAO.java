package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.AttachedLucknum;

public interface AttachedLucknumDAO extends EntityDao<AttachedLucknum>{
	
	public AttachedLucknum findAttachedLucknumByNum(String lucknum);
	
}
