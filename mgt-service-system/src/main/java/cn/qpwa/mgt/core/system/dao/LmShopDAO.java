package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.LmShop;

import java.util.LinkedHashMap;
import java.util.Map;

public interface LmShopDAO extends EntityDao<LmShop> {
	
	/**
	 * 查询地标列表
	 * @return
	 */
	public LmShop findByUserName(String userName);
	
	 /**
     * 获取地标申请信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);
}