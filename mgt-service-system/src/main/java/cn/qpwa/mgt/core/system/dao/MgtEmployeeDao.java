package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.mgt.facade.system.entity.MgtEmployee;
import cn.qpwa.common.core.dao.EntityDao;
import cn.qpwa.common.page.Page;

import java.math.BigDecimal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 用户数据访问层接口，提供用户相关的CRUD操作
 */
@SuppressWarnings("rawtypes")
public interface MgtEmployeeDao extends EntityDao<MgtEmployee> {

    /**
     * 获取用户信息
     * 
     * @param paramMap
     *            查询条件参数集合
     * @param orderby
     *            排序条件
     * @param relist
     *            部门ID列表
     * @return
     */
    public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby,
                       List relist);

    /**
     * 批量删去用户信息
     * 
     * @param ids
     *            用户ID字符串，使用逗号分割
     */
    public void delete(String[] ids);

    public MgtEmployee getLoginEmployee(MgtEmployee param);

    public MgtEmployee findLoginEmployee(MgtEmployee param);

    /**
     * 验证用户账户是否存在
     * 
     * @param accountName
     *            用户账户
     * @return
     */
    public String exist(String accountName);

    /**
     * 验证用户账户是否存在
     * 
     * @param accountName
     *            用户账户
     * @return
     */
    public MgtEmployee findByAccountName(String accountName);

    /**
     * 获取人员信息
     * 
     * @param employeeId
     *            用户ID
     */
    public MgtEmployee findById(String employeeId);

    /**
     * 查询用户list
     * 
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List<Map<String, Object>> findByList(Map<String, Object> paramMap);
    
    /**
     * 根据用户参数查询数据库中的数据
     * @author:lj
     * @date 2015-7-1 下午5:05:48
     * @param param
     * @return
     */
    public MgtEmployee findEmployeeByParam(MgtEmployee param);

    /**
	 * 查询配送员
	 * @param params
	 */
	public List<Map<String, Object>> getLogisticUser(Map<String, Object> params);
	
	/**
     * 根据merchantCode查询
     * @param merchantCodes
     * @return
     * @author honghui
     * @date   2016-04-06
     */
	public List<MgtEmployee> findEmployeeByMerchantCode(List<BigDecimal> merchantCodes);
	
}