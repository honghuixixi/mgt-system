package cn.qpwa.mgt.core.system.dao;

import cn.qpwa.mgt.facade.system.entity.MainPageBox;
import cn.qpwa.common.core.dao.EntityDao;

import java.math.BigDecimal;

/**
 * 首页数据访问接口，提供店铺类别的CRUD操作
 * @author 孙洋
 */
public interface MainPageBoxDAO extends EntityDao<MainPageBox> {
	
	/** 修改网站首页楼层图片数据
	  * @author sy
	  * @param masPkNo 外键
	  * @param boxType 类型
	  * @param boxImg 图片地址
	  * @param href 超链接
	*/
	void updateMainPageBox(BigDecimal masPkNo, String boxType, String boxImg, String href);
    
	/**
	 * 批量删除首页数据记录
	 * @author SY
	 * @date 2016年1月4日
	 */
	void delMainPageBox(BigDecimal[] ids);
}