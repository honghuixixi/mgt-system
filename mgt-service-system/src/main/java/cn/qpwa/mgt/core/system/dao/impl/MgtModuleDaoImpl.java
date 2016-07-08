package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.mgt.core.system.dao.MgtModuleDao;
import cn.qpwa.mgt.facade.system.entity.MgtModule;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Created by Administrator on 2016/7/8 0008.
 */
@Repository("mgtModuleDao")
@SuppressWarnings({ "unchecked", "rawtypes", "deprecation" })
public class MgtModuleDaoImpl extends HibernateEntityDao<MgtModule> implements MgtModuleDao{

    @Override
    public List selectMgtModuleList() {
        String sql = "SELECT mo.* FROM MGT_MODULE mo";
        return super.getSession().createSQLQuery(sql).setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).list();

    }
}
