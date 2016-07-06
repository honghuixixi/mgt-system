package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtDepartment;
import net.sf.json.JSONArray;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门数据访问层接口，提供部门相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtDepartmentDao extends EntityDao<MgtDepartment> {
    /**
     * 获取部门信息
     * 
     * @param parentId
     *            父类部门ID
     * @return
     */
    public List<MgtDepartment> findByParentId(String parentId);

    /**
     * 查询Department
     * 
     * @param code
     *            部门code
     * @return
     */
    public List<MgtDepartment> findByCode(String code);

    /**
     * 获取部门信息
     * 
     * @param depId
     *            类部门ID
     * @return
     */
    public MgtDepartment findbyId(String depId);

    /**
     * 批量删去部门信息
     * 
     * @param ids
     *            部门ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 获取部门信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 获取部门信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public List queryForList(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 批量部门及子部门信息
     * 
     * @param code
     *            部门code
     */
    public void deleteDept(String code);

    /**
     * 查询部门编号是否存在
     * 
     * @param departCode
     *            部门code
     */
    public String findExist(String departCode);

    /**
     * 查询部门是否存在人员
     * 
     * @param jsonArray
     *            查询条件
     */
    public String findExistBySeq(JSONArray jsonArray);

    /**
     * 获取部门信息
     * 
     * @param list
     *            pId列表
     * @return
     */
    public JSONArray findByParentMap(List list);

    /**
     * 获取部门信息
     * 
     * @param list
     *            pId列表
     * @return 部门信息列表
     */
    public List findDeptByPids(List list);
    /**
     * 根据分页和查询条件查询部门列表
     * @author:lj
     * @date 2015-6-5 下午1:44:30
     * @param paramMap
     * @param orderby
     * @return
     */
    public Page queryDepartmentListByPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderBy);
    /**
     * 根据商家编号上级部门
     * @author:lj
     * @date 2015-6-8 上午10:31:33
     * @param merchantCode
     * @return
     */
    public String findParentIdByMerchantCode(String merchantCode);
    /**
     * 根据主键id删除部门
     * @author:lj
     * @date 2015-6-8 下午2:06:34
     * @param id
     */
    public void deleteDepartmentById(String id);

}