/**
 * 
 */
package cn.qpwa.common.message.dao;

import cn.qpwa.common.entity.MsgTemplet;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.core.dao.HibernateEntityDao;
import org.apache.commons.lang.StringUtils;
import org.hibernate.Query;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

/**
 * @author wlw-62
 * 2016年5月18日
 */
@Repository("msgTempletDAO")
@SuppressWarnings("rawtypes")
public class MsgTempletDAOImpl extends HibernateEntityDao<MsgTemplet>  implements MsgTempletDAO {

	@Override
	public Page findMessagePage(Map<String, Object> paramMap) {
		StringBuilder sql = new StringBuilder("SELECT * from MSG_TEMPLET m where 1=1 ");
		Map<String, Object> param = new HashMap<String, Object>();
		
		if (paramMap != null) {
			if (paramMap.containsKey("busiCode") && StringUtils.isNotBlank(paramMap.get("busiCode").toString())) {
				sql.append(" and m.BUSI_CODE =:busiCode ");
				param.put("busiCode", paramMap.get("busiCode"));
			}
			if (paramMap.containsKey("busiName") && StringUtils.isNotBlank(paramMap.get("busiName").toString())) {
				sql.append(" and m.BUSI_NAME like :busiName ");
				param.put("busiName", "%"+paramMap.get("busiName")+"%");
			}
			if (paramMap.containsKey("tempName") && StringUtils.isNotBlank(paramMap.get("tempName").toString())) {
				sql.append(" and m.TEMP_NAME like :tempName ");
				param.put("tempName", "%"+paramMap.get("tempName")+"%");
			}
		}
		sql.append(" order by m.BUSI_CODE desc");
		return super.sqlqueryForpage(sql.toString(), param, null);
	}

	@Override
	public void deleteMsgTemplet(Collection<Integer> pkNos) {
		Query query = getSessionFactory().getCurrentSession().createQuery(
				"update MsgTemplet m set m.tempFlag=:tempFlag where m.pkNo in(:pkNos)");
		query.setParameterList("pkNos", pkNos);
		query.setParameter("tempFlag", "N");
		query.executeUpdate();
	}

	@Override
	public void delMsgTemplet(Collection<Integer> pkNos) {
		Query query = getSessionFactory().getCurrentSession().createQuery(
				"delete from MsgTemplet m where m.pkNo in(:pkNos)");
		query.setParameterList("pkNos", pkNos);
		query.executeUpdate();
		
	}

	@Override
	public void editMsgTempletFlag(MsgTemplet msgTemplet) {
		Query query = getSessionFactory().getCurrentSession().createQuery(
				"update MsgTemplet m set m.tempFlag=:tempFlag where m.pkNo =:pkNo");
		query.setParameter("pkNo", msgTemplet.getPkNo());
		query.setParameter("tempFlag", msgTemplet.getTempFlag());
		query.executeUpdate();
	}
	

	@Override
	public MsgTemplet findMsgTempletByBusiCode(String busiCode) {
		MsgTemplet msgTemplet = super.findUniqueBy(MsgTemplet.class, new String[]{"busiCode","tempFlag"},
				new Object[]{busiCode,"Y"});
		return msgTemplet;
	}


}
