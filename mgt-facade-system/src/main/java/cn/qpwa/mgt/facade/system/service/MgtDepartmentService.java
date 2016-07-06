package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.entity.DepartmentObject;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import cn.qpwa.mgt.facade.system.entity.MgtDepartment;
import cn.qpwa.mgt.facade.system.entity.MgtDepartmentUser;
import net.sf.json.JSONArray;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 部门业务接口类
 * 
 */
@SuppressWarnings("rawtypes")
public interface MgtDepartmentService extends BaseService<MgtDepartment> {

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
     * 获取部门实体类
     * 
     * @param id
     *            部门ID
     * @return
     */
    public MgtDepartment findById(String id);

    /**
     * 删去部门
     * 
     * @param ids
     *            部门ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 获取部门信息
     * 
     * @param parentId
     *            父类部门ID
     * @return
     */
    public List<MgtDepartment> findByParentId(String parentId);

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
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public DepartmentObject queryForList(Map<String, Object> paramMap,
                                         LinkedHashMap<String, String> orderby);

    /**
     * 获取部门信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public List queryForLists(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 查询用户部门
     * 
     * @param userId
     *            用户ID
     * @return
     */
    public List<MgtDepartmentUser> findByUserId(String userId);

    /**
     * 删去部门及其子部门
     * 
     * @param code
     *            部门code
     * @throws Exception
     */
    public void deleteDept(String code) throws Exception;

    /**
     * 保存部门
     * 
     * @param entity
     *            部门实体
     * @throws Exception
     */
    public void saveDep(MgtDepartment entity) throws Exception;

    /**
     * 修改部门
     * 
     * @param entity
     *            部门实体
     */
    public void updateDep(MgtDepartment entity);

    /**
     * 查询部门编号是否存在
     * 
     * @param code
     *            部门code
     */
    public String exist(String code);

    /**
     * 获取所有的父部门
     * 
     * @param pid
     *            部门ID
     * @param depts
     *            部门列表
     * @return
     */
    public List<MgtDepartment> getParentDepts(String pid, List<MgtDepartment> depts);

    /**
     * 查询部门下是否还存在人员
     * 
     * @param depId
     *            部门ID
     * @return
     */
    public String findExistBySeq(String depId);
    /**
     * 根据分页和查询条件查询部门列表
     * @author:lj
     * @date 2015-6-5 下午1:44:30
     * @param paramMap
     * @param
     * @return
     */
    public PageView queryDepartmentListByPage(Map<String, Object> paramMap, LinkedHashMap<String, String> orderBy);
    
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
    
    /**
     * 根据用户查询部门
     * @return
     */
    public List<MgtDepartment> findDepartmentByEmployeeId(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

}
