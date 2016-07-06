package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.MgtRoleResource;

import java.util.List;
import java.util.Map;

/**
 * 资源角色关联数据访问层接口，提供相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtRoleResourceDao extends EntityDao<MgtRoleResource> {
    /**
     * 获取资源角色关联信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */

    public List findByList(Map<String, Object> paramMap);

    /**
     * 获取资源角色关联信息
     * 
     * @param resourceId
     *            资源ID
     * @return
     */
    public List findByResourceId(String resourceId);

    /**
     * 批量删去资源角色关联信息
     * 
     * @param roleId
     *            角色ID
     */
    public void deleteByRoleId(String roleId);

    /**
     * 批量删去资源角色关联信息
     * 
     * @param resourceId
     *            资源ID
     */
    public void deleteByResourceId(String resourceId);

    /**
     * 查询角色资源关联表
     * 
     * @param objects
     *            角色ID列表
     * @return
     */
    public List findRoleResourceByRoleId(List objects);

    /**
     * 查询角色下面的资源
     * 
     * @param roleId
     *            角色ID
     * @return
     */
    public List findResourceByRoleId(String roleId);
}