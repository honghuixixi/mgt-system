package cn.qpwa.mgt.common.page;

import java.util.List;

@SuppressWarnings({ "rawtypes", "unchecked" })
public class PageView<T> {
	/** 分页数据 **/
	private List<T> records;
	/** 页码开始索引和结束索引 **/
	private PageIndex pageindex;
	/** 总页数 **/
	private long totalpage = 1;
	/** 每页显示记录数 **/
	private int maxresult = Page.DEFAULT_PAGE_SIZE;
	/** 当前页 **/
	private int currentpage = 1;
	/** 总记录数 **/
	private long totalrecord;
	/** 页码数量 **/
	private int pagecode = 10;

	private int begin = 0;

	private int end = 0;
	/**
	 * 分页时调用的js方法名.
	 */
	private String jsMethod;
	/** 对象所属类别 **/
	private List catList;
	
	public List getCatList() {
		return catList;
	}

	public void setCatList(List catList) {
		this.catList = catList;
	}

	/** 要获取记录的开始索引 **/
	public int getFirstResult() {
		return (this.currentpage - 1) * this.maxresult;
	}

	public int getPagecode() {
		return pagecode;
	}

	public void setPagecode(int pagecode) {
		this.pagecode = pagecode;
	}
	
	public PageView(Integer maxresult, Integer currentpage) {
		if (maxresult == null || maxresult < 1) {
			maxresult = Page.DEFAULT_PAGE_SIZE;
		}
		if (currentpage == null || currentpage < 1) {
			currentpage = 1;
		}
		this.currentpage = currentpage;
		this.maxresult = maxresult;
	}

	public void setQueryResult(Page qr) {
		setTotalrecord(qr.getTotal());
		setRecords(qr.getItems());
	}

	public long getTotalrecord() {
		return totalrecord;
	}

	public void setTotalrecord(long totalrecord) {
		this.totalrecord = totalrecord;
		setTotalpage(this.totalrecord % this.maxresult == 0 &&  this.totalrecord!=0 ? this.totalrecord
				/ this.maxresult : this.totalrecord / this.maxresult + 1);
	}

	public List<T> getRecords() {
		return records;
	}

	public void setRecords(List<T> records) {
		this.records = records;
	}

	public PageIndex getPageindex() {
		return pageindex;
	}

	public long getTotalpage() {
		return totalpage;
	}

	public void setTotalpage(long totalpage) {
		this.totalpage = totalpage;
		this.pageindex = PageIndex.getPageIndex(pagecode, currentpage,
				totalpage);
	}

	public int getMaxresult() {
		return maxresult;
	}

	public int getCurrentpage() {
		return currentpage;
	}

	public int getBegin() {
		begin = (currentpage - 1) * maxresult;
		return begin;
	}

	public void setBegin(int begin) {
		this.begin = begin;
	}

	public int getEnd() {
		end = (currentpage) * maxresult - 1;
		return end;
	}

	public void setEnd(int end) {
		this.end = end;
	}

	/**
	 * @return the jsMethod
	 */
	public String getJsMethod() {
		return jsMethod;
	}

	/**
	 * @param jsMethod
	 *            the jsMethod to set
	 */
	public void setJsMethod(String jsMethod) {
		this.jsMethod = jsMethod;
	}
}
