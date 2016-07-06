package cn.qpwa.common.message.dao;

import cn.qpwa.common.entity.Employee;
import cn.qpwa.common.core.dao.EntityDao;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 * 用户数据访问层接口，提供用户相关的CRUD操作
 */
public interface MgtEmployeeDao extends EntityDao<Employee> {
    /**
     * 查询用户list
     * @param paramMap
     *            查询条件参数集合
     * @return
     */
    public List<Map<String, Object>> findByList(Map<String, Object> paramMap);
    
    /**
	 * 查询配送员
	 * @param paramMap
	 */
	public List<Map<String, Object>> getLogisticUser(Map<String, Object> paramMap);
	
	/**
     * 根据merchantCode查询
     * @param merchantCodes
     * @return
     */
	public List<Employee> findEmployeeByMerchantCode(List<BigDecimal> merchantCodes);
	
}