package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.mgt.facade.system.service.MgtDepartmentUserService;
import cn.qpwa.mgt.core.system.dao.MgtDepartmentUserDao;
import cn.qpwa.mgt.facade.system.entity.MgtDepartmentUser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service("mgtDepartmentUserService")
@Transactional
public class MgtDepartmentUserServiceImpl implements MgtDepartmentUserService {

	@Autowired
	private MgtDepartmentUserDao mgtDepartmentUserDao;

	@Override
	public MgtDepartmentUser get(String id) {
		return mgtDepartmentUserDao.get(id);
	}

	@Override
	public void removeUnused(String id) {
		mgtDepartmentUserDao.removeById(id);

	}

	@Override
	public void saveOrUpdate(MgtDepartmentUser model) {
		mgtDepartmentUserDao.save(model);

	}
	/**
	 * 根据用户id查询用户所在公司id
	 * @author:lj
	 * @date 2015-6-12 上午11:45:58
	 * @param userId
	 * @return
	 */
	@Override
	public String findDepartmentIdByUserId(String userId){
		return mgtDepartmentUserDao.findDepartmentIdByUserId(userId);
	}

	@Override
	public List<MgtDepartmentUser> findByUserId(String userId) {
		return mgtDepartmentUserDao.findByUserId(userId);
	}

}
