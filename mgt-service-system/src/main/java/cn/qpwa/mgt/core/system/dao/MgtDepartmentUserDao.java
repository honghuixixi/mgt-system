package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtDepartmentUser;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门用户关联数据访问层接口，提供相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtDepartmentUserDao extends EntityDao<MgtDepartmentUser> {

    /**
     * 获取部门关联信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 批量删去部门关联信息
     * 
     * @param userId
     *            用户ID
     */
    public void deleteByUserId(String userId);

    /**
     * 查询用户部门
     * 
     * @param userId
     *            用户ID
     * @return
     */
    public List<MgtDepartmentUser> findByUserId(String userId);
    
    /**
	 * 根据用户id查询用户所在公司id
	 * @author:lj
	 * @date 2015-6-12 上午11:45:58
	 * @param userId
	 * @return
	 */
	public String findDepartmentIdByUserId(String userId);
}