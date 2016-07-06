package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.mgt.core.system.dao.SubaccountOperDAO;
import cn.qpwa.mgt.facade.system.entity.SubaccountOper;
import org.springframework.stereotype.Repository;

@Repository("subaccountOperDAO")
public class SubaccountOperDAOImpl extends HibernateEntityDao<SubaccountOper> implements SubaccountOperDAO{}
