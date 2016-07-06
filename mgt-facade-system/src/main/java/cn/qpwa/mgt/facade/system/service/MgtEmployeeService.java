package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.common.core.service.BaseService;
import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.facade.system.entity.MgtEmployee;
import cn.qpwa.mgt.facade.system.entity.User;
import net.sf.json.JSONObject;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户业务接口类
 * 
 */
@SuppressWarnings("rawtypes")
public interface MgtEmployeeService extends BaseService<MgtEmployee> {

    /**
     * 获取用户信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby);

    /**
     * 获取用户实体类
     * 
     * @param id
     *            用户ID
     * @return
     */
    public MgtEmployee findById(String id);

    /**
     * 删去用户
     * 
     * @param ids
     *            用户ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    /**
     * 保存用户角色关系
     * 
     * @param paramMap
     *            查询条件参数集合
     */
    public void saveEmployeeRole(Map<String, Object> paramMap);

    /**
     * 用户登陆密码验证
     * 
     * @param param
     *            用户实体
     * @return
     */
    public MgtEmployee getLoginEmployee(MgtEmployee param);

    /**
     * 根据用户名用户查询
     * 
     * @param param
     *            用户实体
     * @return
     */
    public MgtEmployee findLoginEmployee(MgtEmployee param);

    /**
     * 用户添加
     * 
     * @param Employee
     *            用户实体
     * @param
     *
     * @param citySelCode
     *            部门ID字符串，使用逗号分割
     *  * @param user
     *       系统登陆的用户
     */
    public MgtEmployee save(MgtEmployee Employee, String citySelCode, String[] roleIds, User user);

    /**
     * 用户修改
     * 
     * @param Employee
     *            用户实体
     * @param citySel
     *            部门ID
     * @param citySelCode
     *            部门ID字符串，使用逗号分割
     */
    public MgtEmployee update(MgtEmployee Employee, String citySel, String citySelCode);

    /**
     * 用户登陆授权
     * 
     * @param Employee
     *            用户实体
     * @return 返回用户角色列表roles,菜单列表menus
     */
    public Map<String, Object> findRoleResourceByEmployee(MgtEmployee Employee);

    /**
     * 验证用户账号是否存在
     * 
     * @param accountName
     *            用户账号
     * @return
     */
    public String exist(String accountName);

    /**
     * 修改密码
     * 
     * @param model
     *            用户实体
     * @param srcPwd
     *            密码
     * @return
     */
    public MgtEmployee editPassword(MgtEmployee model, String srcPwd);

    /**
     * 查询用户
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List<Map<String, Object>> findByList(Map<String, Object> paramMap);

    /**
     * 同步账号信息
     * @param user
     *            B2B用户实体
     */
    public void synchAccount(User user);
    /**
     * 编辑员工
     * @param entity
     * @param citySelCode
     */
    public void saveOrUpdate(MgtEmployee entity, String citySelCode);
    /**
     * 停用
     * @param ids
     */
    public void editStatus(String[] ids);
    /**
     * 查询所有
     * @return
     */
    public List getAll();
    /**
     * 修改员工所在部门
     * @param deptId
     * @param ids
     */
    public void editEmployeeDept(String deptId, String[] ids);
    public MgtEmployee findUniqueBy(String propertyName, Object value);
    /**
     * 根据用户参数查询数据库中的数据
     * @author:lj
     * @date 2015-7-1 下午5:05:48
     * @param param
     * @return
     */
    public MgtEmployee findEmployeeByParam(MgtEmployee param);
    /**
     * 启用停用
     * @param params
     */
    public void editStatus(JSONObject params);
    
    /**
     * 运营中心管理启用/停用
     * @author RJY
     * @data 2016年1月23日10:15:21
     * @param userNo
     */
    public void editFlg(JSONObject jobj, BigDecimal userNo);
    
    /**
     * 根据merchantCode查询
     * @param merchantCodes
     * @return
     * @author honghui
     * @date   2016-04-06
     */
    public List<MgtEmployee> findEmployeeByMerchantCode(List<BigDecimal> merchantCodes);

}
