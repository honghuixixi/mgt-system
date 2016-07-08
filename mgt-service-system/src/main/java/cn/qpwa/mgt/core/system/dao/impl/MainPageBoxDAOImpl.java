package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.mgt.core.system.dao.MainPageBoxDAO;
import cn.qpwa.mgt.facade.system.entity.MainPageBox;
import cn.qpwa.common.core.dao.HibernateEntityDao;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import java.math.BigDecimal;

/**
 * 首页数据访问接口实现，提供店铺类别的CRUD操作
 * @author sy
 */
@Repository("mainPageBoxDAO")
public class MainPageBoxDAOImpl extends HibernateEntityDao<MainPageBox> implements MainPageBoxDAO {
	
	@Override
	public void updateMainPageBox(BigDecimal masPkNo,String boxType,String boxImg,String href) {
		String sql="update MAIN_PAGE_BOX t set t.BOX_IMG=?,t.HREF=? ,t.MODIFY_DATE= sysdate where t.MAS_PK_NO=? and t.BOX_TYPE=?";
		this.getSession().createSQLQuery(sql).setString(0, boxImg).setString(1, href)
		.setBigDecimal(2, masPkNo).setString(3, boxType).executeUpdate();
	}
	
	@Override
	public void delMainPageBox(BigDecimal [] ids) {
		if (ids != null && ids.length > 0) {
			Query query = getSession().createQuery("delete from MainPageBox mpb where mpb.pkNo in (:ids)");
			query.setParameterList("ids", ids);
			query.executeUpdate();
		}
	}
}