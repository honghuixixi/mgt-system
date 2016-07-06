package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.mgt.core.system.dao.AttachedLucknumDAO;
import cn.qpwa.mgt.facade.system.entity.AttachedLucknum;
import org.springframework.stereotype.Repository;

@Repository("attachedLucknumDAO")
public class AttachedLucknumDAOImpl extends HibernateEntityDao<AttachedLucknum> implements AttachedLucknumDAO {

	public AttachedLucknum findAttachedLucknumByNum(String lucknum){
		if (lucknum == null) {
			return null;
		}
		return this.findUniqueBy("attachedAccount", lucknum);
	}


}
