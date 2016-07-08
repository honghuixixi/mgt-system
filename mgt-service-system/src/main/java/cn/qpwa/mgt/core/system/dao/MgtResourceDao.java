package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtResource;


import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 资源信息数据访问层接口，提供资源信息相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtResourceDao extends EntityDao<MgtResource> {
    /**
     * 获取资源信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 批量删去资源信息
     * 
     * @param ids
     *            资源ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 通过menuIDs批量删去资源信息
     * 
     * @param menuIds
     *            菜单ID字符串，使用逗号分割
     */
    public void deleteByMenuIds(String[] menuIds);

    /**
     * 获取资源信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findByList(Map<String, Object> paramMap);

    /**
     * 查询菜单下资源
     * 
     * @param menuId
     *            菜单ID
     * @return
     */
    public List<Map<String, Object>> findResourceByMenuId(String menuId);

    /**
     * 查询资源
     * 
     * @param ids
     *            资源ID字符串，使用逗号分割
     * @param status
     *            资源状态
     * @return
     */
    public List<Map<String, Object>> findResourceByIds(String[] ids, String status);

    /**
     * 查询资源地址是否存在
     * 
     * @param url
     *            资源URL
     * @return
     */
    public int findResourceByUrl(String url);
    /**
     * 根据角色id数组查询资源列表
     * @author:lj
     * @date 2015-6-9 上午11:39:00
     * @return
     */
    public List queryResourceListByRoleIds(Map<String, Object> paramMap);
    
    /**
     * 查询所有
     * @return
     */
    public List findAll();
}