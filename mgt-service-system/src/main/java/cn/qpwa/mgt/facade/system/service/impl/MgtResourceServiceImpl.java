package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtResourceDao;
import cn.qpwa.mgt.core.system.dao.MgtRoleResourceDao;
import cn.qpwa.mgt.facade.system.entity.MgtResource;
import cn.qpwa.mgt.facade.system.entity.MgtRoleResource;
import cn.qpwa.mgt.facade.system.service.MgtResourceService;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 资源接口实现类
 * 
 */
@Service("mgtResourceService")
@Transactional
@SuppressWarnings({ "rawtypes", "unchecked" })
public class MgtResourceServiceImpl implements MgtResourceService {

	@Autowired
	private MgtResourceDao mgtResourceDao;
	@Autowired
	private MgtRoleResourceDao mgtRoleResourceDao;

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtResource get(String id) {
		return mgtResourceDao.get(id);
	}

	@Override
	public void removeUnused(String id) {
		mgtResourceDao.removeById(id);
	}

	@Override
	public void saveOrUpdate(MgtResource entity) {
		mgtResourceDao.save(entity);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		return mgtResourceDao.querys(paramMap, orderby);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtResource findById(String id) {
		return mgtResourceDao.get(id);
	}

	@Override
	public void delete(String[] ids) {
		for (String resourceId : ids) {
			mgtRoleResourceDao.deleteByResourceId(resourceId);
		}
		mgtResourceDao.delete(ids);
	}

	@Override
	public void updateResourceStatus(MgtResource resource) {
		MgtResource resources = mgtResourceDao.get(resource.getId());
		resources.setStatus(resource.getStatus());
		mgtResourceDao.save(resources);
	}

	@Override
	public List findByList(Map<String, Object> paramMap) {
		return mgtResourceDao.findByList(paramMap);
	}

	@Override
	public List<MgtRoleResource> findRoleResourceByRoleId(List roleIds) {

		return mgtRoleResourceDao.findRoleResourceByRoleId(roleIds);
	}

	@Override
	public List findResourceByRoleId(String roleId) {
		return mgtRoleResourceDao.findResourceByRoleId(roleId);
	}

	@Override
	public List<Map<String, Object>> findResourceByMenuId(String menuId) {
		return mgtResourceDao.findResourceByMenuId(menuId);
	}

	@Override
	public void saveRoleResource(Map<String, Object> paramMap) {
		String roleId = paramMap.get("roleId").toString();
		mgtRoleResourceDao.removeById(roleId);
		if (null != paramMap.get("resourceIds") && StringUtils.isNotBlank(paramMap.get("resourceIds").toString())) {
			String[] resourceIds = StringUtils.split(paramMap.get("resourceIds").toString(), ",");

			for (String resourceId : resourceIds) {
				MgtRoleResource roleResource = new MgtRoleResource();
				roleResource.setRoleId(roleId);
				roleResource.setResourceId(resourceId);
				mgtRoleResourceDao.save(roleResource);
			}
		}

	}

	@Override
	public int findResourceByUrl(String url) {
		return mgtResourceDao.findResourceByUrl(url);
	}
	/**
     * 根据角色id数组查询资源列表
     * @author:lj
     * @date 2015-6-9 上午11:39:00
     * @param paramMap
     * @return
     */
    public List queryResourceListByRoleIds(Map<String, Object> paramMap){
    	return mgtResourceDao.queryResourceListByRoleIds(paramMap);
    }
}
