package cn.qpwa.common.web.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import cn.qpwa.common.utils.SystemContext;
import cn.qpwa.common.page.Page;

public class PagerFilter implements Filter {
	public static final String PAGE_SIZE_NAME = "ps";
	private static String ROOT_PATH = "";

	public void destroy() {

	}

	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest httpRequest = (HttpServletRequest) request;
		SystemContext.setOffset(getOffset(httpRequest));
		SystemContext.setPagesize(getPagesize(httpRequest));
		try {
			chain.doFilter(request, response);
		} finally {
			SystemContext.removeOffset();
			SystemContext.removePagesize();
		}
	}

	private int getOffset(HttpServletRequest request) {
		int offset = 0;
		try {
			offset = Integer.parseInt(request.getParameter("offset"));
		} catch (Exception ignore) {
		}
		return offset;
	}

	private int getPagesize(HttpServletRequest httpRequest) {
		String psvalue = httpRequest.getParameter(PAGE_SIZE_NAME);
		if (psvalue != null && !psvalue.trim().equals("")) {
			Integer ps = 0;
			try {
				ps = Integer.parseInt(psvalue);
			} catch (Exception e) {
			}
			if (ps != 0) {
				httpRequest.getSession().setAttribute(PAGE_SIZE_NAME, ps);
			}
		}

		Integer pagesize = (Integer) httpRequest.getSession().getAttribute(PAGE_SIZE_NAME);
		httpRequest.getSession().setAttribute(PAGE_SIZE_NAME, Page.DEFAULT_PAGE_SIZE);
		if (pagesize == null) {
			return Page.DEFAULT_PAGE_SIZE;
		}

		return pagesize;
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		String rootPath = arg0.getServletContext().getServletContextName();
		if (rootPath == null) {
			rootPath = "/";
		}
		ROOT_PATH = rootPath;
	}

	public static String getRootPath() {
		return ROOT_PATH;
	}
}
