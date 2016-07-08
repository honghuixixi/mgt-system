package cn.qpwa.mgt.web.system.controller;

import cn.qpwa.common.web.base.BaseController;
import cn.qpwa.mgt.facade.system.service.ArticleCategoryService;
import cn.qpwa.mgt.facade.system.service.ArticleService;
import cn.qpwa.mgt.facade.system.entity.SiteArticle;
import cn.qpwa.mgt.facade.system.entity.SiteArticleCategory;
import cn.qpwa.common.utils.Msg;
import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.utils.json.JSONTools;
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
import java.math.BigDecimal;
import java.util.*;

/**
 * 快报、公告信息维护Controller
 */
@Controller
@Scope("prototype")
@RequestMapping("/info")
@SuppressWarnings({ "unchecked" })
public class InfoController extends BaseController {

	@Autowired
	private ArticleService articleService;
	@Autowired
	private ArticleCategoryService articleCategoryService;

	/**
	 * 查询信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "infoQuery")
	public ModelAndView infoQuery() {
		return super.toView(super.getUrl("mgt.infoquery"));
	}

	/**
	 * ajax获取即时信息列表
	 * 
	 * @return
	 */
	@RequestMapping(value = "infoList")
	@ResponseBody
	public Object info(final ModelMap modelMap) {
		JSONObject jobj = jsonObject;
		SystemContext.setPagesize(JSONTools.getInt(jobj, "rows"));
		SystemContext.setOffset(JSONTools.getInt(jobj, "page"));
		PageView<SiteArticle> pageview = articleService.findArticlePage(jobj, null);
		return pageview;
	}

	/**
	 * 跳转文章添加界面
	 * 
	 * @return
	 */
	@RequestMapping(value = "addInfoUI")
	public String addInfoUI() {
		return super.getUrl("mgt.addInfoUI");
	}

	/**
	 * 保存文章信息
	 * 
	 * @return
	 */
	@RequestMapping(value = "add", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg add(final HttpServletRequest request) {
		Msg msg = new Msg();
		String acid = null;
		SiteArticle siteArticle = new SiteArticle();
		acid = jsonObject.getString("acId");
		siteArticle.setAcId(new BigDecimal(acid));
		siteArticle.setArtTitle(jsonObject.getString("artTitle"));
		siteArticle.setSeoDescription(jsonObject.getString("description"));
		siteArticle.setContent(jsonObject.getString("kindcontent"));
		siteArticle.setCreateDate(new Date());
		siteArticle.setModifyDate(new Date());
		siteArticle.setHits(new BigDecimal(0));
		siteArticle.setIsPublication(new BigDecimal(0));
		siteArticle.setIsTop(new BigDecimal(0));
		try {
			articleService.save(siteArticle);
			msg.setSuccess(true);
			msg.setMsg("保存成功！");
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("保存失败，请联系管理员！");
		}
		return msg;
	}

	/**
	 * 更新文章界面
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "editInfoUI")
	public String editInfoUI(BigDecimal id, ModelMap modelMap) throws Exception {
		SiteArticle article = articleService.findArticleById(id);
		modelMap.addAttribute("article", article);
		modelMap.addAttribute("artCate", articleCategoryService.find(article.getAcId()));
		return super.getUrl("mgt.editInfoUI");
	}

	/**
	 * 保存更新信息
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping(value = "edit", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg edit(final HttpServletRequest request) {
		Msg msg = new Msg();
		SiteArticle siteArticle = articleService.findArticleById(new BigDecimal(jsonObject.getString("id")));
		if (siteArticle != null) {
			siteArticle.setAcId(new BigDecimal(jsonObject.getString("acId")));
			siteArticle.setArtTitle(jsonObject.getString("artTitle"));
			siteArticle.setAuthor(jsonObject.getString("author"));
			siteArticle.setSeoDescription(jsonObject.getString("description"));
			siteArticle.setContent(jsonObject.getString("kindcontent"));
			siteArticle.setIsPublication(new BigDecimal(jsonObject.getString("isPublication")));
			siteArticle.setIsTop(new BigDecimal(jsonObject.getString("isTop")));
			siteArticle.setCreateDate(new Date());
			siteArticle.setModifyDate(new Date());
			try {
				articleService.save(siteArticle);
				msg.setSuccess(true);
				msg.setMsg("修改成功！");
			} catch (Exception e) {
				e.printStackTrace();
				msg.setMsg("修改失败，请联系管理员！");
			}
		}
		return msg;
	}

	/**
	 * 删去文章
	 * 
	 * @return
	 */
	@RequestMapping(value = "delete", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg delete() {
		Msg msg = new Msg();
		if (getJsonObject() != null & StringUtils.isNotBlank(getJsonObject().getString("id"))) {
			try {
				String ids = jsonObject.getString("id");
				String[] idArray = StringUtils.split(ids, ",");
				BigDecimal[] bigs = new BigDecimal[idArray.length]; // 声明BigDecimal类型的数组
				for (int i = 0; i < idArray.length; i++) {
					String str = idArray[i];
					BigDecimal big = new BigDecimal(str);
					bigs[i] = big;
				}
				articleService.delete(bigs);
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
	 * ajax 判断文章标题是否重复 查找文章
	 * 
	 * @param ART_TITLE
	 * @return
	 */
	@RequestMapping(value = "findByTitle", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg findByTitle(final String artTitle, BigDecimal artId) {
		Msg msg = new Msg();
		boolean flag = false;
		try {
			SiteArticle art = articleService.findByTitle(artTitle);
			if (art != null && artId != null) {
				SiteArticle art1 = articleService.findArticleById(artId);
				if (art1.getArtTitle().equals(artTitle)) {
					flag = true;
				}
				flag = false;
			} else if (art != null && artId == null) {
				flag = false;
			}
			flag = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		msg.setData(flag);
		return msg;
	}
	
	/**
	 * 文章类型
	 * 级联下拉列表 ajax
	 */
	@RequestMapping(value = "/artType", method = RequestMethod.GET)
	public @ResponseBody
	Map<BigDecimal, String> artType(BigDecimal parentId) {
		List<SiteArticleCategory> artCates = new ArrayList<SiteArticleCategory>();
		SiteArticleCategory parent = articleCategoryService.find(parentId);
		if (parent != null) {
			artCates = articleCategoryService.findChild(parent.getAcId());
		} else {
			artCates = articleCategoryService.findRoots();
		}
		Map<BigDecimal, String> options = new HashMap<BigDecimal, String>();
		for (SiteArticleCategory artType : artCates) {
			options.put(artType.getAcId(), artType.getName());
		}
		return options;
	}
	
	/**
	 * ajax 修改发布状态
	 * @return
	 */
	@RequestMapping(value = "isPublicationFlg", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg isPublicationFlg(){
		Msg msg = new Msg();
		try {
			if (getJsonObject() != null && StringUtils.isNotBlank(getJsonObject().getString("artId"))
					 && StringUtils.isNotBlank(getJsonObject().getString("isPublication"))) {
				BigDecimal artId = new BigDecimal(jsonObject.getString("artId"));
				BigDecimal isPublication = new BigDecimal(jsonObject.getString("isPublication"));
				articleService.isPublicationFlg(artId,isPublication);
				msg.setCode("100");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("删除失败，请联系管理员！");
		}
		return msg;
	}
	
	/**
	 * ajax 修改置顶状态
	 * @return
	 */
	@RequestMapping(value = "isTopFlg", method = { RequestMethod.POST, RequestMethod.GET })
	@ResponseBody
	public Msg isTopFlg(){
		Msg msg = new Msg();
		try {
			if (getJsonObject() != null && StringUtils.isNotBlank(getJsonObject().getString("artId"))
					 && StringUtils.isNotBlank(getJsonObject().getString("isTop"))) {
				BigDecimal artId = new BigDecimal(jsonObject.getString("artId"));
				BigDecimal isTop = new BigDecimal(jsonObject.getString("isTop"));
				articleService.isTopFlg(artId,isTop);
				msg.setCode("100");
			}
		} catch (Exception e) {
			e.printStackTrace();
			msg.setMsg("删除失败，请联系管理员！");
		}
		return msg;
	}
}
