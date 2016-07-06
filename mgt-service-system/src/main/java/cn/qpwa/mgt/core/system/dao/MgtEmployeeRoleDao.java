package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.mgt.facade.system.entity.MgtEmployeeRole;

import java.util.List;
import java.util.Map;

/**
 * 用户角色关联数据访问层接口实现类，提供相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtEmployeeRoleDao extends EntityDao<MgtEmployeeRole> {
    /**
     * 获取用户角色关联信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findEmployeeRoleByEmployeeId(Map<String, Object> paramMap);

    /**
     * 获取用户角色关联信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */

    public List findEmployeeRoleByRoleId(Map<String, Object> paramMap);

    /**
     * 获取用户角色关联信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public Map<String, Object> findByEmployeeRole(Map<String, Object> paramMap);

    /**
     * 批量用户角色
     * 
     * @param employeeId
     *            用户ID
     */
    public void deleteByUser(String employeeId);

    /**
     * 批量用户角色
     * 
     * @param roleId
     *            角色ID
     */
    public void deleteByRoleId(String roleId);
    /**
     * 删除用户和角色的配置关系
     * @author:lj
     * @date 2015-6-10 下午2:11:19
     * @param paramMap
     */
    public void deleteEmployeeRoleRelation(Map<String, Object> paramMap);
}