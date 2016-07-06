package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtResource;
import cn.qpwa.mgt.facade.system.entity.MgtRoleResource;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 资源业务接口类
 * 
 */
@SuppressWarnings("rawtypes")
public interface MgtResourceService extends BaseService<MgtResource> {

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
     * 获取资源实体类
     * 
     * @param id
     *            资源ID
     * @return
     */
    public MgtResource findById(String id);

    /**
     * 删去资源
     * 
     * @param ids
     *            资源ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 修改资源状态
     * 
     * @param resource
     *            资源实体
     * @return
     */
    public void updateResourceStatus(MgtResource resource);

    /**
     * 获取资源信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findByList(Map<String, Object> paramMap);

    /**
     * 查询角色资源关联表
     * 
     * @param roleIds
     *            角色ID列表
     * @return
     */
    public List<MgtRoleResource> findRoleResourceByRoleId(List roleIds);

    /**
     * 查询角色下面的资源
     * 
     * @param roleId
     *            角色ID
     * @return
     */
    public List findResourceByRoleId(String roleId);

    /**
     * 查询菜单下资源
     * 
     * @param menuId
     *            菜单ID
     * @return
     */
    public List<Map<String, Object>> findResourceByMenuId(String menuId);

    /**
     * 角色授权
     * 
     * @param paramMap
     *            查询条件参数集合
     */
    public void saveRoleResource(Map<String, Object> paramMap);

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
     * @param paramMap
     * @return
     */
    public List queryResourceListByRoleIds(Map<String, Object> paramMap);
}
