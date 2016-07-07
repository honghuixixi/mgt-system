package cn.qpwa.mgt.facade.system.service.impl;

import cn.qpwa.common.page.Page;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.mgt.core.system.dao.IndexDataDAO;
import cn.qpwa.mgt.core.system.dao.StkCategoryDAO;
import cn.qpwa.mgt.facade.system.entity.MainPage;
import cn.qpwa.mgt.facade.system.entity.MainPageBox;
import cn.qpwa.mgt.facade.system.service.IndexDataService;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.*;

/**
 * 首页接口实现类，提供相关业务逻辑操作
 * @author TheDragonLord
 */
@Service("IndexDataService")
@Transactional(readOnly = false, propagation = Propagation.REQUIRED, rollbackFor = Exception.class)
@SuppressWarnings({ "rawtypes", "unchecked" })
public class IndexDataServiceImpl implements IndexDataService {
	
    @Autowired
	IndexDataDAO indexDataDAO;
    @Autowired
	StkCategoryDAO stkCategoryDAO;
  
	@Override
	public List findHotSearch(String type,BigDecimal areaId,String netType){		
		List hotsearch = indexDataDAO.findHotSearch(type,areaId,netType);
		return hotsearch;
	}
	
	@Override
	public List findTJcate(String boxType){		
		List TJcate = indexDataDAO.findTJcate(boxType);
		return TJcate;
	}

	@Override
	public List findADs(String type,BigDecimal areaId,String netType){		
		List ADs = indexDataDAO.findADs(type,areaId,netType);
		return ADs;
	}
	
	@Override
	public List findADs(String type){		
		List ADs = indexDataDAO.findADs(type);
		return ADs;
	}
		
	/**
	 * 特别推荐
	 * @param type 类型
	 * @return list
	 */
	public List findSpecialRec(String type){		
		List specialRec = indexDataDAO.findSpecialRec(type);
		return specialRec;
	}

	@Override
	public List findDailyspecial(String type,BigDecimal areaId,String netType){		
		List dailyspecial = indexDataDAO.findDailyspecial(type,areaId,netType);
		return dailyspecial;
	}
	
	@Override
	public List findNewPro(String type,BigDecimal areaId,String netType){		
		List newPro = indexDataDAO.findNewPro(type,areaId,netType);
		return newPro;
	}
	
	@Override
	public JSONObject findRecmendCombo(BigDecimal areaId){
		JSONObject result = null;
		//获取套餐列表
		List RecmendCombo = indexDataDAO.findRecmendCombo(areaId);
		if (RecmendCombo != null && RecmendCombo.size() > 0) {
			result = new JSONObject();
			result.put("success", "true");
			result.put("msg", "成功");
			JSONArray jarray = new JSONArray();
			for (int i = 0; i < RecmendCombo.size(); i++) {
				JSONObject content = new JSONObject();
				Map<String, Object> comboMas = (Map<String, Object>) RecmendCombo.get(i);
				String comboCode = comboMas.get("COMBO_CODE").toString();
				BigDecimal orgNo = (BigDecimal)comboMas.get("ORG_NO");
				List comboItem = indexDataDAO.findComboItem(comboCode,orgNo);
				comboMas.put("comboItem", JSONTools.toJson(comboItem));
				content.put("comboMas", JSONTools.toJson(comboMas));
				jarray.add(content);
			}
			result.put("content", jarray);
		}else{
			return result;
		}
		return result;
	}
	
	@Override
	public List findPromotiontitle(String type,BigDecimal areaId,String netType){		
		List promotiontitle = indexDataDAO.findPromotiontitle(type,areaId,netType);
		return promotiontitle;
	}

	@Override
	public JSONObject findCateArea(BigDecimal areaId,String netType) {
		JSONObject result = null;
		// 获取大类
		List cate = indexDataDAO.findCate("E",areaId,netType);
		if (cate != null && cate.size() > 0) {
			result = new JSONObject();
			result.put("success", "true");
			result.put("msg", "成功");
			Map<String, Object> map = new HashMap<String, Object>();
			JSONArray jarray = new JSONArray();
			for (int i = 0; i < cate.size(); i++) {
				JSONObject content = new JSONObject();
				Map<String, Object> catMap = (Map<String, Object>) cate.get(i);
				BigDecimal cateID = (BigDecimal) catMap.get("PK_NO");
				//分类信息
				content.put("cate", JSONTools.toJson(cate.get(i)));
				// 获取各大类下商品
				map.put("type", "R");
				map.put("cateID", cateID);
				List product = indexDataDAO.findMainPageBox(map);
				content.put("product", JSONTools.toJson(product));
				if(product != null && product.size() > 0){
					content.put("show", "true");
				}
				// 获取大类的小标签
				map.put("type", "H");
				List title = indexDataDAO.findMainPageBox(map);
				content.put("title", JSONTools.toJson(title));
				// 获取各品牌及其促销标题list
				map.put("type", "E");
				List brand = indexDataDAO.findMainPageBox(map);
				content.put("brand", JSONTools.toJson(brand));
				// 获取大类对应左侧广告图片
				map.put("type", "L");
				map.put("cateID", cateID);
				List L_image = indexDataDAO.findMainPageBox(map);
				content.put("L_image", JSONTools.toJson(L_image));
				// 获取标题广告图片
				map.put("type", "T");
				List titleADs = indexDataDAO.findMainPageBox(map);
				content.put("titleADs", JSONTools.toJson(titleADs));
				jarray.add(content);
			}
			result.put("content", jarray);
		}
		return result;
	}
	
	@Override
	public JSONObject findAppCateArea(BigDecimal areaId,String netType) {
		JSONObject result = null;
		// 获取大类
		List cate = indexDataDAO.findCate("E",areaId,netType);
		if (cate != null && cate.size() > 0) {
			result = new JSONObject();
			/*result.put("success", "true");
			result.put("msg", "成功");*/
			Map<String, Object> map = new HashMap<String, Object>();
			ArrayList list = new ArrayList();
			JSONArray jarray = new JSONArray();
			for (int i = 0; i < cate.size(); i++) {
				Map<String, Object> catMap = (Map<String, Object>) cate.get(i);
				BigDecimal cateID = (BigDecimal) catMap.get("PK_NO");
				//分类信息
				//content.put("cate", JSONTools.toJson(cate.get(i)));
				// 获取各大类下商品
				map.put("type", "RT");
				map.put("cateID", cateID);
				List product = indexDataDAO.findMainPageBox(map);
				list.addAll(product);
				//content.put("product1", JSONTools.toJson(product));
				/*if(product != null && product.size() > 0){
					content.put("show", "true");
				}*/
				/*// 获取大类的小标签
				map.put("type", "H");
				List title = indexDataDAO.findMainPageBox(map);
				content.put("title", JSONTools.toJson(title));
				// 获取各品牌及其促销标题list
				map.put("type", "E");
				List brand = indexDataDAO.findMainPageBox(map);
				content.put("brand", JSONTools.toJson(brand));
				// 获取大类对应左侧广告图片
				map.put("type", "L");
				map.put("cateID", cateID);
				List L_image = indexDataDAO.findMainPageBox(map);
				content.put("L_image", JSONTools.toJson(L_image));
				// 获取标题广告图片
				map.put("type", "T");
				List titleADs = indexDataDAO.findMainPageBox(map);
				content.put("titleADs", JSONTools.toJson(titleADs));*/
				
				//jarray.add(content);
			}
			result.put("content", JSONTools.toJson(list));
		}

		return result;
	}
	
	@Override
	public List findCateAreaCatId(String type,BigDecimal masPkNo){		
		List catId = indexDataDAO.findCateAreaCatId(type,masPkNo);
		return catId;
	}
	
	@Override
	public Page findAllType(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){		
		if (null != paramMap && paramMap.containsKey("orderby")
				&& "".equals(paramMap.get("orderby").toString())) {
			paramMap.put("sord", "desc");
		}		
		Page type = indexDataDAO.findAllType(paramMap,orderby);
		return type;
	}
	
	@Override
	public void showFlgModify(BigDecimal pkNo,String showFlg){		
		indexDataDAO.showFlgModify(pkNo,showFlg);
	}
	
	@Override
	public Page findIndexDataById(Map<String, Object> paramMap,LinkedHashMap<String, String> orderby){		
		if (null != paramMap && paramMap.containsKey("orderby")
				&& "".equals(paramMap.get("orderby").toString())) {
			paramMap.put("sord", "desc");
		}		
		Page type = indexDataDAO.findIndexDataById(paramMap,orderby);
		return type;
	}
	
	@Override
	public void addItemA(BigDecimal masPkNo,String items) {
		//处理item,保存发货数量
		if(StringUtils.isNotBlank(items)){
			String[] itemArr = items.split(";");
			MainPageBox mpb = null;
			for(int i=0; i<itemArr.length; i++) {
				if(StringUtils.isNotBlank(itemArr[i])){
					String[] itemArra = itemArr[i].split(",");
					if(!"".equals(itemArra[0].toString())){
						mpb = indexDataDAO.findUniqueBy(MainPageBox.class, new String[]{"pkNo"},new Object[]{itemArra[0]});
						if(mpb != null){
							mpb.setBoxType(itemArra[1]);
							mpb.setBoxDesc(itemArra[2]);
							mpb.setSortNo(new BigDecimal(itemArra[3]));
							mpb.setHref(itemArra[4]);
							mpb.setModifyDate(DateUtil.toTimestamp(new Date()));
						}
					}else{
						mpb = new MainPageBox();
						mpb.setBoxType(itemArra[1]);
						mpb.setBoxDesc(itemArra[2]);
						mpb.setSortNo(new BigDecimal(itemArra[3]));
						mpb.setHref(itemArra[4]);
						mpb.setMasPkNo(masPkNo);
						mpb.setCreateDate(DateUtil.toTimestamp(new Date()));
						mpb.setShowType("T");
					}
				}
				indexDataDAO.save(mpb);
			  }
	    }
    }

	@Override
	public List findIndexListByAreaId(String type, String rootAreaId) {
		return indexDataDAO.findBy(MainPage.class, new String[]{"prodType","areaId"},new Object[]{type,rootAreaId});
	}
}
