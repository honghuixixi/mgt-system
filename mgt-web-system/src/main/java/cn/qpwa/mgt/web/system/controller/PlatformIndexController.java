package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.*;
import cn.qpwa.mgt.facade.system.entity.*;
import cn.qpwa.common.web.utils.WebUtils;
import cn.qpwa.common.utils.date.DateUtil;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
import cn.qpwa.common.page.Page;
import cn.qpwa.common.page.PageView;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Scope;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.util.*;

/**
 * 快报、公告信息维护Controller
 */
@Controller
@Scope("prototype")
@RequestMapping("/index")
@SuppressWarnings({ "unchecked" })
public class PlatformIndexController extends BaseController {

	@Autowired
	private IndexDataService indexDataService;
	@Autowired
	private AreaMasWebService areaMasWebService;
	@Autowired
	private ArticleService articleService;
	@Autowired
	private ArticleCategoryService articleCategoryService;
	@Autowired
	private StkCategoryService stkCategoryService;
	@Autowired
	private MainPageService mainPageService;
	@Autowired
	private MainPageBoxService mainPageBoxService;
	@Autowired
	private WebPromItem1Service webPromItem1Service;
	@Autowired
	private StkMasService stkMasService;
	@Autowired
	private UserService userService;
	@Autowired
	private ScuserAreaService scuserAreaService;
	@Autowired
	private StkMasImgService stkMasImgService;

	/**
	 * 跳转到平台首页内容列表页面
	 * @return
	 */
	@RequestMapping(value = "indexQuery")
	public ModelAndView infoQuery(ModelMap modelMap) {
		//一级区域列表
		List<AreaMasWeb> areaOptions = areaMasWebService.findRoots();
		String areaRoot="";
		User user = userService.findByUsername(WebUtils.getSessionUser().getAccountName());
		if(user==null || null==user.getAreaId()){
			areaRoot="-1";
		}else{
			Map<String, Object> areaTemp = areaMasWebService.findRootsByAreaId(user.getAreaId());
			areaRoot = areaTemp.get("AREA_ID").toString();
		}
		modelMap.addAttribute("areaOptions", areaOptions);
		modelMap.addAttribute("areaRoot", areaRoot);
		return super.toView(super.getUrl("mgt.indexquery"));
	}
		
	/**
	 * ajax获取平台首页内容列表
	 * @return PageView
	 */
	@RequestMapping(value = "indexContentList")
	@ResponseBody
	public Object info(final ModelMap modelMap) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = indexDataService.findAllType(jsonObject, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"),JSONTools.getInt(jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}

	/**
	 * ajax 修改显示、隐藏状态
	 * @return Msg
	 */
	@RequestMapping(value = "isShowFlg", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg isShowFlg(){
		Msg msg = new Msg();
		try {
			if (getJsonObject() != null && StringUtils.isNotBlank(getJsonObject().getString("id"))
					 && StringUtils.isNotBlank(getJsonObject().getString("showFlg"))) {
				BigDecimal pkNo = new BigDecimal(jsonObject.getString("id"));
				indexDataService.showFlgModify(pkNo,jsonObject.getString("showFlg").toString());
				msg.setCode("100");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("操作失败，请联系管理员！");
		}
		return msg;
	}	

	/**
	 * 跳转到各种类型的首页数据“编辑”页面
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "editDetails")
	public ModelAndView editDetails(final ModelMap modelMap,HttpServletRequest request) throws UnsupportedEncodingException {
		String url  = "";
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("type"))) {
			String type  = jsonObject.getString("type");
			jsonObject.put("masPkNo", jsonObject.getString("id"));
			List<StkCategory> cateList = stkCategoryService.findRoots();
			//“热销词”的数据维护
			if(type.equals("A")){
				url="mgt.indexTypeA";
			//“首页flash图片”的数据维护
			}else if(type.equals("B")){
				url="mgt.indexTypeB";
				jsonObject.put("boxType", "A");
				List<MainPageBox> list = indexDataService.findIndexDataById(jsonObject, null).getItems();
				modelMap.addAttribute("mainList",list);
				modelMap.addAttribute("cateList",cateList);
			//“每日特价、新品”的数据维护
			}else if(type.equals("D")){
				url="mgt.indexTypeD";
				List<MainPageBox> list = indexDataService.findIndexDataById(jsonObject, null).getItems();
				MainPage mp = mainPageService.findMainPageById(new BigDecimal(jsonObject.getString("id").toString()));
				String boxName = mp.getBoxName();
				modelMap.addAttribute("boxName", boxName);
			//“各楼层”的数据维护
			}else if(type.equals("E")){
				MainPage temp = mainPageService.findMainPageById(new BigDecimal(jsonObject.get("id").toString()));
				String boxName = temp.getBoxName();
				BigDecimal cateID = temp.getCatId();
				BigDecimal xuhao = temp.getSortNo();
				modelMap.addAttribute("boxName", boxName);
				modelMap.addAttribute("cateID", cateID);
				modelMap.addAttribute("xuhao", xuhao);
				//楼层Map封装数据
				Map<String, Object> floorArea = new HashMap<String, Object>();
				//楼层商品list
				List indexMasList = new ArrayList();
				int q = 0;
				//根据网站类别，决定每楼层的商品个数
				int w = 0;
				List<MainPageBox> list = indexDataService.findIndexDataById(jsonObject, null).getItems();
				for(int i=0;i<list.size();i++){
					if("T".equals(((Map)list.get(i)).get("BOX_TYPE"))){
						floorArea.put("titleImg", list.get(i));
					}else if("R".equals(((Map)list.get(i)).get("BOX_TYPE"))){
						q = q+1;
						indexMasList.add(list.get(i));
						
					}else if("L".equals(((Map)list.get(i)).get("BOX_TYPE"))){
						floorArea.put("leftImg", list.get(i));
					}
				}
				if("B2BWEB".equals(jsonObject.getString("prodType").toString())){
					w=8;
				}else if("B2BWAP".equals(jsonObject.getString("prodType").toString())){
					w=6;
				}else if("B2BAPP".equals(jsonObject.getString("prodType").toString())){
					w=4;
				}
				for(int j = q;j<w;j++){
					MainPageBox m = new MainPageBox();
					m.setMasPkNo(new BigDecimal((String)jsonObject.get("masPkNo")));
					m.setBoxType("R");
					m.setCreateDate(DateUtil.toTimestamp(new Date()));
					m.setSortNo(new BigDecimal(j+1) );
					mainPageBoxService.save(m);
					Map<String,Object> map = new HashMap<String, Object>();
					map.put("PK_NO", m.getPkNo());
					map.put("SORT_NO", m.getSortNo());
					indexMasList.add(map);
				}
				floorArea.put("indexMas", indexMasList);
				modelMap.addAttribute("cateList",cateList);
				modelMap.addAttribute("floorArea",floorArea);
				url="mgt.indexTypeE";
			}
		}
		modelMap.addAttribute("masPkNo", jsonObject.getString("id"));
		modelMap.addAttribute("areaId", jsonObject.getString("areaId"));
		modelMap.addAttribute("type", jsonObject.getString("type"));
		modelMap.addAttribute("prodType", jsonObject.getString("prodType"));
		return super.toView(super.getUrl(url));
	}	
	
	
	/**
	 * ajax获取“某”类型数据详细列表
	 * @return PageView
	 */
	@RequestMapping(value = "editIndexDataById")
	@ResponseBody
	public Object editIndexDataById(final ModelMap modelMap) {
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = indexDataService.findIndexDataById(jsonObject, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"),JSONTools.getInt(jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;
	}	

	/**
	 * ajax添加“A”类型数据
	 * @return Msg 信息
	 */
	@RequestMapping(value = "addItemA")
	@ResponseBody
	public Object addItemA(BigDecimal masPkNo,String items,final ModelMap modelMap) {
		Msg msg = new Msg();
		try {
			indexDataService.addItemA(masPkNo,items);
			msg.setCode("add-A-index");
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setSuccess(false);
			msg.setMsg("操作失败，请联系管理员！");
		}
		return msg;
	}	
	
	/**
	 * 批量删除记录
	 * @author SY
	 * @date 2016年1月4日
	 */
	@RequestMapping(value = "delMainPageBox", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg delMainPageBox() {
		Msg msg = new Msg();
		if (jsonObject != null & StringUtils.isNotBlank(jsonObject.getString("pkno"))) {
			try {
				String ids = jsonObject.getString("pkno");
				String[] idArray = StringUtils.split(ids, ",");
				BigDecimal[] bigs = new BigDecimal[idArray.length]; // 声明BigDecimal类型的数组
				for (int i = 0; i < idArray.length; i++) {
					String str = idArray[i];
					//所选元素的主键为空是，数组中去掉该元素，防止传入后台报错
					if("on".equals(str)){
						continue;
					}else{
						BigDecimal big = new BigDecimal(str);
						bigs[i] = big;
					}
				}
				if(null!=bigs){
					mainPageBoxService.delMainPageBox(bigs);
				}
				msg.setMsg("删除成功！");
				msg.setSuccess(true);
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("删除失败，请联系管理员！");
			}
		} else {
			msg.setMsg("删除失败，请联系管理员！");
		}
		return msg;
	}	
	
	/**
	 * ajax获取“每日特价”可添加的商品
	 * @return
	 */
	@RequestMapping(value = "editWebPromItem")
	@ResponseBody
	public Object editWebPromItem(final ModelMap modelMap) {
		JSONObject jobj = jsonObject;
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = webPromItem1Service.findWebItembyareaIdOldcode(jobj, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"),JSONTools.getInt(jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;		
	}	
	
	/**
	 * ajax单条添加“每日特价商品”
	 * 到的“添加特价的商品”列表
	 * （同步商品主表记录到，MainPageBox 表中）
	 * @return Msg
	 */
	@RequestMapping(value = "addPromItem", method = RequestMethod.POST)
	@ResponseBody
	public Msg addPromItem(BigDecimal pkNo,BigDecimal masPkNo) {
		Msg msg = new Msg();
		MainPageBox mainPageBox = new MainPageBox();
		try {
			if(!"".equals(pkNo.toString())){
				WebPromItem1 webPromItem1 = webPromItem1Service.findById(pkNo);
					mainPageBox.setMasPkNo(masPkNo);
					mainPageBox.setBoxType("A");
					mainPageBox.setBoxDesc("特价");
					mainPageBox.setShowType("T");
					mainPageBox.setStkC(webPromItem1.getStkC());
					mainPageBox.setStkName(webPromItem1.getStkName());
					mainPageBox.setCreateDate(DateUtil.toTimestamp(new Date()));
				mainPageBoxService.save(mainPageBox);
				msg.setSuccess(true);
				msg.setMsg("添加成功！");
				msg.setCode("001");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("添加失败！");
		}
		return msg;
	}
	
	/**
	 * ajax单条添加“新品”
	 * 到的“添加新品商品”列表
	 * （同步商品主表记录到，MainPageBox 表中）
	 * @return Msg
	 */
	@RequestMapping(value = "addStkMas", method = RequestMethod.POST)
	@ResponseBody
	public Msg addStkMas(String stkC,BigDecimal masPkNo) {
		Msg msg = new Msg();
		MainPageBox mainPageBox = new MainPageBox();
		try {
			if(!"".equals(stkC.toString())){
				StkMas stkMas = stkMasService.findStkMasById(stkC);
					mainPageBox.setMasPkNo(masPkNo);
					mainPageBox.setBoxType("A");
					mainPageBox.setBoxDesc("新品");
					mainPageBox.setShowType("T");
					mainPageBox.setStkC(stkC);
					mainPageBox.setStkName(stkMas.getName());
					mainPageBox.setCreateDate(DateUtil.toTimestamp(new Date()));
				mainPageBoxService.save(mainPageBox);
				msg.setSuccess(true);
				msg.setMsg("添加成功！");
				msg.setCode("001");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("添加失败！");
		}
		return msg;
	}
	
	/**
	 * ajax获取“楼层内”可添加的商品
	 * @return
	 */
	@RequestMapping(value = "editFloorItem")
	@ResponseBody
	public Object editFloorItem(final ModelMap modelMap) {
		JSONObject jobj = jsonObject;
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = stkMasService.findStkMasbyareaIdOldcode(jobj, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"),JSONTools.getInt(jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;		
	}	
	
	/**
	 * ajax单条添加“楼层商品”
	 * 替换“楼层的商品”
	 * （同步商品主表记录到，MainPageBox 表中）
	 * @return Msg
	 */
	@RequestMapping(value = "addFloorItem", method = RequestMethod.POST)
	@ResponseBody
	public Msg addFloorItem(String stkC,BigDecimal pkNo,BigDecimal masPkNo,BigDecimal sortNo) {
		Msg msg = new Msg();
		try {
			//修改
			if(!"".equals(stkC) && null!=pkNo){
				MainPageBox mpb = mainPageBoxService.findMainPageBoxById(pkNo);
				StkMas stkmas = stkMasService.findStkMasById(stkC);
//				List smis =  stkMasImgService.findStkMasImgByStkC(stkC, new BigDecimal(100));
//				String boxImg = ((StkMasImg)smis.get(0)).getServerUrl().toString()+((StkMasImg)smis.get(0)).getSourcePath().toString();
				mpb.setStkC(stkC);
				mpb.setStkName(stkmas.getName());
				mpb.setBoxImg(stkmas.getUrlAddr());
				mpb.setSortNo(sortNo);
				mpb.setModifyDate(DateUtil.toTimestamp(new Date()));
				mainPageBoxService.save(mpb);
				msg.setSuccess(true);
				msg.setMsg("操作成功！");
				msg.setCode("001");
			//添加
			}else if(!"".equals(stkC) && null==pkNo){
				MainPageBox mpb = new MainPageBox();
				StkMas stkmas = stkMasService.findStkMasById(stkC);
//				List smis =  stkMasImgService.findStkMasImgByStkC(stkC, new BigDecimal(100));
//				String boxImg = ((StkMasImg)smis.get(0)).getServerUrl().toString()+((StkMasImg)smis.get(0)).getSourcePath().toString();
				mpb.setMasPkNo(masPkNo);
				mpb.setBoxType("R");
				mpb.setBoxDesc("右侧商品");
				mpb.setBoxImg(stkmas.getUrlAddr());
				mpb.setSortNo(sortNo);
				mpb.setShowType("T");
				mpb.setStkC(stkC);
				mpb.setStkName(stkmas.getName());
				mpb.setCreateDate(DateUtil.toTimestamp(new Date()));
				mainPageBoxService.save(mpb);
				msg.setSuccess(true);
				msg.setMsg("操作成功！");
				msg.setCode("001");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("操作失败！");
		}
		return msg;
	}	
	
	/**
	 * ajax提交保存”楼层的“数据维护信息
	 * @return Msg
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "editFloor")
	@ResponseBody
	public Object editFloor(BigDecimal masPkNo,BigDecimal catId,String titImg,String leftImg,String tithref,String lefthref,final ModelMap modelMap) throws UnsupportedEncodingException {
	    Msg msg = new Msg();
		if(StringUtils.isNotBlank(masPkNo.toString())){
			MainPage mb = mainPageService.findMainPageById(masPkNo);
			if(StringUtils.isNotBlank((String)jsonObject.get("name"))){
				mb.setBoxName((String)jsonObject.get("name"));
			}else{
				mb.setBoxName(stkCategoryService.find(catId).getCatName());
			}
			if(StringUtils.isNotBlank((String)jsonObject.get("SortNo"))){
				mb.setSortNo(new BigDecimal((String)jsonObject.get("SortNo")));
			}
			mb.setCatId(catId);
			mb.setModifyDate(DateUtil.toTimestamp(new Date()));
			mainPageService.save(mb);
			
			//标题型图片+链接
			MainPageBox mpb = mainPageBoxService.findByMasPkNoBoxType(masPkNo, "T");
			if(mpb != null){
				mpb.setBoxImg(titImg);
				mpb.setHref(tithref);
				mpb.setModifyDate(DateUtil.toTimestamp(new Date()));
			}else{
				mpb = new MainPageBox();
				mpb.setMasPkNo(masPkNo);
				mpb.setBoxType("T");
				mpb.setCreateDate(DateUtil.toTimestamp(new Date()));
				mpb.setBoxImg(titImg);
				mpb.setHref(tithref);
			}
			mainPageBoxService.save(mpb);
		    //左侧图片+链接
			MainPageBox mpb1 = mainPageBoxService.findByMasPkNoBoxType(masPkNo, "L");
			if(mpb1 != null){
				mpb1.setBoxImg(leftImg);
				mpb1.setHref(lefthref);
				mpb1.setModifyDate(DateUtil.toTimestamp(new Date()));
			}else{
				mpb1 = new MainPageBox();
				mpb1.setMasPkNo(masPkNo);
				mpb1.setBoxType("L");
				mpb1.setCreateDate(DateUtil.toTimestamp(new Date()));
				mpb1.setBoxImg(leftImg);
				mpb1.setHref(lefthref);
			}
			mainPageBoxService.save(mpb1);
		    msg.setSuccess(true);
		    msg.setMsg("保存成功！");
		}else{
		    msg.setSuccess(false);
		    msg.setMsg("保存失败！");
		}    
		return msg;
	}	
	
	/**
	 * ajax提交保存“首页flash图片”数据维护信息
	 * @return Msg
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping(value = "saveTypeB")
	@ResponseBody
	public Object saveTypeB(BigDecimal masPkNo,String boxType,BigDecimal pkNo,String imgDiZhi,String sortNum,String descWord,String linkHref,final ModelMap modelMap) throws UnsupportedEncodingException {
	    Msg msg = new Msg();
	    try{
		if(null!=pkNo){
			MainPageBox mpb = mainPageBoxService.findMainPageBoxById(pkNo);
			mpb.setBoxImg(imgDiZhi);
			mpb.setSortNo(new BigDecimal(sortNum));
			mpb.setBoxDesc(descWord);
			mpb.setBoxType(boxType);
			mpb.setHref(linkHref);
			mpb.setModifyDate(DateUtil.toTimestamp(new Date()));
			mainPageBoxService.save(mpb);
			msg.setCode("save-B-index");
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		}else{
			MainPageBox mpb = new MainPageBox();
			mpb.setBoxImg(imgDiZhi);
			mpb.setSortNo(new BigDecimal(sortNum));
			mpb.setBoxDesc(descWord);
			mpb.setBoxType(boxType);
			mpb.setHref(linkHref);
			mpb.setMasPkNo(masPkNo);
			mpb.setShowType("T");
			mpb.setCreateDate(DateUtil.toTimestamp(new Date()));
			mainPageBoxService.save(mpb);
			msg.setCode("save-B-index");
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		}
		} catch (Exception e) {
			e.printStackTrace();
			msg.setSuccess(false);
			msg.setMsg("操作失败！");
		}
		return msg;
	}	

	/**
	 * 每日特价商品保存
	 * @author RJY
	 * @data 2016年1月20日17:42:21
	 * @param items
	 * @param modelMap
	 * @return
	 */
	@RequestMapping(value = "editDsave")
	@ResponseBody
	public Object editDsave(String items,final ModelMap modelMap) {
		mainPageBoxService.editDsave(items);
		Msg msg = new Msg();
		msg.setSuccess(true);
		msg.setCode("001");
		msg.setMsg("保存成功！");
		return msg;
	}
	
	/**
	 * ajax获取“新品”可添加的商品
	 * @return
	 */
	@RequestMapping(value = "editStkMas")
	@ResponseBody
	public Object editStkMas(final ModelMap modelMap) {
		JSONObject jobj = jsonObject;
		SystemContext.setPagesize(JSONTools.getInt(jsonObject, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jsonObject, "page"));
		Page page = stkMasService.findStkMasbyareaIdOldcode(jobj, null);
		PageView pageView = new PageView(JSONTools.getInt(jsonObject, "rows"),JSONTools.getInt(jsonObject, "page"));
		pageView.setTotalrecord(page.getTotal());
		pageView.setRecords(page.getItems());
		return pageView;	
	}

	/**
	 *首页数据维护（热门搜索重复检验）
	 * @author SY
	 * @data 2016年3月15日
	 * @param KeyWord
	 * @return MSg
	 */
	@RequestMapping(value = "checkTypeA")
	@ResponseBody
	public Object checkTypeA(BigDecimal masPkNo,String boxType ,String keyWord,final ModelMap modelMap) {
		MainPageBox mpb = mainPageBoxService.checkTypeByKeyWord(masPkNo, boxType,keyWord);
		Msg msg = new Msg();
		if(null!=mpb){
			msg.setCode("001");
		}else{
			msg.setCode("002");
		}
		return msg;
	}
}
