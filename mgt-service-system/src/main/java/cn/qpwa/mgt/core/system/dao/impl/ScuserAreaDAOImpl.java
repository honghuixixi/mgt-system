package cn.qpwa.mgt.core.system.dao.impl;

import cn.qpwa.common.core.dao.HibernateEntityDao;
import cn.qpwa.mgt.core.system.dao.ScuserAreaDAO;
import cn.qpwa.mgt.facade.system.entity.ScuserArea;
import org.hibernate.Query;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository("ScuserAreaDAO")
@SuppressWarnings({"unchecked","deprecation"})
public class ScuserAreaDAOImpl extends HibernateEntityDao<ScuserArea> implements ScuserAreaDAO{
	
	@Override
	public List<Map<String, Object>> findByUserName(String userName){
		String sql = "SELECT amw.TREE_PATH,sa.* FROM SCUSER_AREA sa LEFT JOIN AREA_MAS_WEB amw ON sa.AREA_ID=amw.AREA_ID WHERE SA.USER_NAME=?";
		SQLQuery query = super.getSession().createSQLQuery(sql);
		return query.setResultTransformer(Transformers.ALIAS_TO_ENTITY_MAP).setString(0, userName).list();
	}
	
	@Override
	public void deleteByUserName(String userName) {
		Query query = super.getSession().createQuery("delete from ScuserArea sa where sa.id.userName =:userName");
		query.setParameter("userName", userName);
		query.executeUpdate();
	}

	@Override
	public List<Map<String, Object>> findAreaBy(Map<String, Object> map) {
		// TODO Auto-generated method stub
		return null;
	}

}
