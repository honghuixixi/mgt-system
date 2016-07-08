package cn.qpwa.mgt.facade.system.service;

import cn.qpwa.mgt.facade.system.entity.MainPageBox;

import java.math.BigDecimal;

/**
 * Service - 首页数据表
 * @author sy
 * @version 1.0
 */
public interface MainPageBoxService {
	/**
	 * 首页记录实体查询
	 * @param pkNo 记录ID
	 * @return 首页实体
	 */
	MainPageBox findMainPageBoxById(BigDecimal pkNo);
	
	/** 修改网站首页楼层图片数据
	  * @author sy
	  * @param masPkNo 外键
	  * @param boxType 类型
	  * @param boxImg 图片地址
	  * @param href 超链接
	*/
	void updateMainPageBox(BigDecimal masPkNo, String boxType, String boxImg, String href);
	
	/** 根据楼层ID和类型查询
	  * @author sy
	  * @param masPkNo 外键
	  * @param boxType 类型
	*/
	MainPageBox findByMasPkNoBoxType(BigDecimal masPkNo, String boxType);
	
	/** 根据楼层ID和类型查询
	 * @author sy
	 * @param masPkNo 外键
	 * @param boxType 类型
	 * @param keyWord 关键字
	 */
	MainPageBox checkTypeByKeyWord(BigDecimal masPkNo, String boxType, String keyWord);


	/**
	 * 添加  MainPageBox 记录 
	 * @param mainPageBox 首页数据实体
	 */
    void save(MainPageBox mainPageBox);
	
	/**
	 * 批量删除首页数据记录
	 * @author SY
	 * @date 2016年1月4日
	 */
	void delMainPageBox(BigDecimal[] ids);
	
    /**
     * 每日特价商品保存
     * @author RJY
     * @data 2016年1月20日17:37:52
     * @param items
     */
    void editDsave(String items);
}
