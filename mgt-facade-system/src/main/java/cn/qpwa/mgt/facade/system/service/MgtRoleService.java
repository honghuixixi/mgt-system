package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtEmployee;
import cn.qpwa.mgt.facade.system.entity.MgtRole;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 角色业务接口类
 * 
 */
@SuppressWarnings("rawtypes")
public interface MgtRoleService extends BaseService<MgtRole> {

    /**
     * 获取角色信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 获取角色实体类
     * 
     * @param id
     *            角色ID
     * @return
     */
    public MgtRole findById(String id);

    /**
     * 删去角色
     * 
     * @param ids
     *            角色ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 修改角色状态
     * 
     * @param role
     *            角色实体
     * @return
     */
    public void updateRoleStatus(MgtRole role);

    /**
     * 获取角色信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findByList(Map<String, Object> paramMap);

    /**
     * 角色资源配置
     * 
     * @param paramMap
     *            查询条件参数集合
     */
    public void saveRole(Map<String, Object> paramMap);

    /**
     * 查询用户角色
     * 
     * @param userId
     *            用户ID
     * @return
     */
    public List<Map<String, Object>> findEmployeeRoleByEmployeeId(String userId);

    /**
     * 查询角色下的用户
     * 
     * @param roleId
     *            角色ID
     * @return
     */
    public List<Map<String, Object>> findEmployeeRoleByRoleId(String roleId);

    /**
     * 用户角色配置
     * 
     * @param paramMap
     *            查询条件参数集合
     */
    public void saveEmployeeRole(Map<String, Object> paramMap);

    /**
     * 角色用户配置
     * 
     * @param paramMap
     *            查询条件参数集合
     */
    public void saveRoleEmployee(Map<String, Object> paramMap);

    /**
     * 测试数据，初始化管理员、角色、部门
     */
    public MgtEmployee saveEmployeeAllResource();

    /**
     * 查询角色是否存在
     * 
     * @param name
     *            角色名称
     * @return
     */
    public List findByName(String name);

    /**
     * 查询资源分配的角色
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findRoleResourceByList(Map<String, Object> paramMap);

    /**
     * 查询资源分配的角色
     * 
     * @param resourceId
     *            资源ID
     * @return
     */
    public List findByResourceId(String resourceId);
    /**
     * 根据用户id和商户code查询用户该商户下的角色
     * @author:lj
     * @date 2015-6-8 下午6:06:49
     * @param paramMap
     * @return
     */
    public List<MgtRole> findRoleListByMap(Map<String, Object> paramMap);
    /**
     * 修改角色的工作域属性
     * @author:lj
     * @date 2015-6-9 上午9:19:10
     * @param paramMap（RoleIds,scope）
     */
    public void modifyRoleScope(Map<String, Object> paramMap);
    /**
     * 删除用户和角色的配置关系
     * @author:lj
     * @date 2015-6-10 下午2:11:19
     * @param paramMap
     */
    public void deleteEmployeeRoleRelation(Map<String, Object> paramMap);
    /**
     * 查询企业下所有可见角色
     * @param paramMap
     * @return
     */
    public List findByAll(Map<String, Object> paramMap);
    
    /**
     * 查询商户入驻可见角色列表
     * zld
     * @date 2016-1-25
     * @param params
     * @return
     */
	public List<Map<String, Object>> findByPublc(Map<String, Object> params);
}
