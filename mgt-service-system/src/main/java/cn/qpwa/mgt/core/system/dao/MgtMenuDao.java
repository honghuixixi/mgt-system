package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtMenu;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 菜单数据访问层接口，提供菜单相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtMenuDao extends EntityDao<MgtMenu> {
    /**
     * 获取菜单信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 获取菜单信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findByList(Map<String, Object> paramMap);

    /**
     * 批量删去菜单信息
     * 
     * @param ids
     *            菜单ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 查询菜单通过parentId
     * 
     * @param pId
     *            父类菜单ID
     * @param visible
     *            是否可见
     * 
     */
    public List<Map<String, Object>> findByParentId(String pId, String visible);

    /**
     * 查询菜单
     * 
     * @param ids
     *            菜单ID集合
     */
    public List<MgtMenu> findByMenuIds(Set<String> ids);

    /**
     * 查询排序号是否存在
     * 
     * @param sortby
     *            排序号
     * @return
     */
    public int countMneuBySortby(Integer sortby);
    /**
     * 根据角色id列表查询角色对应的菜单
     * @author:lj
     * @date 2015-6-9 下午1:50:54
     * @param paramMap
     * @return
     */
    public List queryMenuListByRoleIds(Map<String, Object> paramMap);

	/**
	 * 根据父菜单id查找对应的子菜单集合
	 * @param pid
	 * 		父菜单id
	 * @return
	 * 		子菜单集合
	 * 		
	 */
	public List<MgtMenu> fingMgtMenuByPid(String pid);
}











