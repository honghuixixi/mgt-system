package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.mgt.core.system.dao.MainPageDAO;
import cn.qpwa.mgt.facade.system.entity.MainPage;
import cn.qpwa.common.core.dao.HibernateEntityDao;
import org.springframework.stereotype.Repository;

/**
 * 首页数据访问接口实现，提供店铺类别的CRUD操作
 * @author sy
 */
@Repository("mainPageDAO")
public class MainPageDAOImpl extends HibernateEntityDao<MainPage> implements MainPageDAO {
}