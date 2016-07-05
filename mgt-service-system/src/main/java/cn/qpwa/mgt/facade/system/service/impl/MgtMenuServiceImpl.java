package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.page.Page;
import cn.qpwa.mgt.core.system.dao.MgtMenuDao;
import cn.qpwa.mgt.core.system.dao.MgtResourceDao;
import cn.qpwa.mgt.core.system.dao.MgtRoleResourceDao;
import cn.qpwa.mgt.facade.system.entity.MgtMenu;
import cn.qpwa.mgt.facade.system.service.MgtMenuService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * 菜单接口实现类
 * 
 */
@Service("mgtMenuService")
@Transactional
@SuppressWarnings({ "rawtypes" })
public class MgtMenuServiceImpl implements MgtMenuService {

	@Autowired
	private MgtMenuDao mgtMenuDao;
	@Autowired
	private MgtResourceDao mgtResourceDao;
	@Autowired
	private MgtRoleResourceDao mgtRoleResourceDao;

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtMenu get(String id) {
		return mgtMenuDao.get(id);
	}

	@Override
	public void removeUnused(String id) {
		mgtMenuDao.removeById(id);
	}

	@Override
	public void saveOrUpdate(MgtMenu entity) {
		mgtMenuDao.save(entity);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public Page querys(Map<String, Object> paramMap, LinkedHashMap<String, String> orderby) {
		return mgtMenuDao.querys(paramMap, orderby);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public MgtMenu findById(String id) {
		return mgtMenuDao.get(id);
	}

	@Override
	public void delete(String[] ids) {
		for (String menuId : ids) {
			List<Map<String, Object>> resourceList = mgtResourceDao.findResourceByMenuId(menuId);
			for (Map<String, Object> resource : resourceList) {
				mgtRoleResourceDao.deleteByResourceId(resource.get("ID").toString());
			}
		}
		mgtResourceDao.deleteByMenuIds(ids);
		mgtMenuDao.delete(ids);
	}

	@Override
	public void updateMenuStatus(MgtMenu menu) {
		MgtMenu menus = mgtMenuDao.get(menu.getId());
		menus.setVisible(menu.getVisible());
		mgtMenuDao.save(menus);
	}

	@Override
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List findByList(Map<String, Object> paramMap) {
		return mgtMenuDao.findByList(paramMap);
	}

	@Override
	public List<MgtMenu> findByMenuIds(Set<String> ids) {
		return mgtMenuDao.findByMenuIds(ids);
	}

	@Override
	public List<Map<String, Object>> findByParentId(String parentId, String visible) {
		List<Map<String, Object>> menuList = mgtMenuDao.findByParentId(parentId, visible);
		for (Map<String, Object> menu : menuList) {
			List<Map<String, Object>> menuItems = new ArrayList<Map<String, Object>>();
			menuItems = mgtMenuDao.findByParentId(menu.get("ID").toString(), visible);
			for (int i = (menuItems.size() - 1); i >= 0; i--) {
				Map<String, Object> menuItem = menuItems.get(i);
				List<Map<String, Object>> resourceItems = mgtResourceDao.findResourceByMenuId(menuItem.get("ID")
						.toString());
				if (null != resourceItems && resourceItems.size() > 0) {
					menuItem.put("resourceItems", resourceItems);
				} else {
					menuItems.remove(i);
				}
			}
			menu.put("menuItems", menuItems);
		}
		return menuList;
	}

	@Override
	public List findAll() {
		return mgtMenuDao.getAll();
	}

	@Override
	public int countMneuBySortby(Integer sortby) {
		return mgtMenuDao.countMneuBySortby(sortby);
	}
	 /**
     * 根据角色id列表查询角色对应的菜单
     * @author:lj
     * @date 2015-6-9 下午1:50:54
     * @param paramMap
     * @return
     */
	@Override
    public List queryMenuListByRoleIds(Map<String, Object> paramMap){
    	return mgtMenuDao.queryMenuListByRoleIds(paramMap);
    }

	@Override
	public List<MgtMenu> fingMgtMenuByPid(String pid) {
		return mgtMenuDao.fingMgtMenuByPid(pid);
	}
	
	
}
