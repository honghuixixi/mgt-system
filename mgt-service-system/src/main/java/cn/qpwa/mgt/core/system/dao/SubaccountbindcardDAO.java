package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.Subaccountbindcard;

import java.util.LinkedHashMap;
import java.util.Map;

public interface SubaccountbindcardDAO extends EntityDao<Subaccountbindcard> {
	
	/**
	 * 分页查询
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
	
	/**
	 * 银行卡信息分页查询
	 * @param paramMap
	 * @param orderby
	 * @return
	 */
	public Page queryBankCards(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
}
