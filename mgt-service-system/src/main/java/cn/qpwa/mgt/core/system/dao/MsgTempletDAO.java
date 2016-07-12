/**
 * 
 */
package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MsgTemplet;

import java.util.Collection;
import java.util.Map;

/**
 * @author wlw-62
 * 2016年5月18日
 */
@SuppressWarnings("rawtypes")
public interface MsgTempletDAO extends EntityDao<MsgTemplet>{

	Page findMessagePage(Map<String, Object> paramMap);
	
	void deleteMsgTemplet(Collection<Integer> pkNos);
	
	void delMsgTemplet(Collection<Integer> pkNos);
	
	void editMsgTempletFlag(MsgTemplet msgTemplet);
	
	MsgTemplet findMsgTempletByBusiCode(String busiCode);
}
