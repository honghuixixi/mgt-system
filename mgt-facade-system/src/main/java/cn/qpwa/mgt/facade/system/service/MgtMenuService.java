package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtMenu;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * 菜单业务接口类
 * 
 */
@SuppressWarnings("rawtypes")
public interface MgtMenuService extends BaseService<MgtMenu> {

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
     * 获取菜单实体类
     * 
     * @param id
     *            菜单ID
     * @return
     */
    public MgtMenu findById(String id);

    /**
     * 删去菜单
     * 
     * @param ids
     *            菜单ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 修改菜单状态
     * 
     * @param menu
     *            菜单实体
     * @return
     */
    public void updateMenuStatus(MgtMenu menu);

    /**
     * 获取菜单信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findByList(Map<String, Object> paramMap);

    /**
     * 查询菜单
     * 
     * @param ids
     *            菜单ID集合
     */
    public List<MgtMenu> findByMenuIds(Set<String> ids);

    /**
     * 查询菜单通过parentId
     * 
     * @param parentId 父类菜单ID
     * 
     * @param visible
     *            是否可见
     */
    public List<Map<String, Object>> findByParentId(String parentId, String visible);

    /**
     * 查询所有菜单
     * 
     */
    public List findAll();

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
	 * 根据父菜单pid查找对应的菜单
	 * @param pid
	 * 			所对应的父菜单id
	 * @return
	 *			菜单集合
	 */
	public List<MgtMenu> fingMgtMenuByPid(String pid);
}












