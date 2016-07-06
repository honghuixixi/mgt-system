package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtRole;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 角色信息数据访问层接口，提供角色信息相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtRoleDao extends EntityDao<MgtRole> {

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
     * 获取角色信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List findByList(Map<String, Object> paramMap);

    /**
     * 批量删去角色信息
     * 
     * @param ids
     *            角色ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 查询角色是否存在
     * 
     * @param name
     *            角色名称
     * @return
     */
    public List findByName(String name);
    
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