package cn.qpwa.common.page;

import java.io.Serializable;
import java.util.List;

/**
 * Page is not a domain object but is used to store and fetch page information.
 * 
 */
@SuppressWarnings({ "rawtypes", "unchecked" })
public class Page<T> implements Serializable {

	public final static int DEFAULT_PAGE_SIZE = 20;

	private int total;
	private List<T> items; // 分页集合

	private int pageIndex;
	private int pageSize;
	private int pageCount;
	
	private List catList;
	
	public List getCatList() {
		return catList;
	}

	public void setCatList(List catList) {
		this.catList = catList;
	}

	public Page(int pageIndex, int pageSize) {
		// check:
		if (pageIndex < 1)
			pageIndex = 1;
		if (pageSize < 1)
			pageSize = 1;
		this.pageIndex = pageIndex;
		this.pageSize = pageSize;
	}

	public Page(List items, int totalCount, int pageSize, int pageIndex) {
		if (pageIndex < 1)
			pageIndex = 1;
		if (pageSize < 1)
			pageSize = 1;
		this.total = totalCount;
		this.pageIndex = pageIndex;
		this.pageSize = pageSize;
		this.items = items;
	}

	public Page(int pageIndex) {
		this(pageIndex, DEFAULT_PAGE_SIZE);
	}

	public int getPageIndex() {
		return pageIndex;
	}

	public int getPageSize() {
		return pageSize;
	}

	public int getPageCount() {
		return pageCount;
	}

	public int getTotalCount() {
		return total;
	}

	public int getFirstResult() {
		return (pageIndex - 1) * pageSize;
	}

	public boolean getHasPrevious() {
		return pageIndex > 1;
	}

	public boolean getHasNext() {
		return pageIndex < pageCount;
	}

	public void setTotalCount(int total) {
		this.total = total;
		pageCount = total / pageSize + (total % pageSize == 0 ? 0 : 1);
		if (total == 0) {
			if (pageIndex != 1)
				throw new IndexOutOfBoundsException("Page index out of range.");
		} else {
			if (pageIndex > pageCount)
				throw new IndexOutOfBoundsException("Page index out of range.");
		}
	}

	public boolean isEmpty() {
		return total == 0;
	}

	public List<T> getItems() {
		return items;
	}

	public void setItems(List<T> items) {
		this.items = items;
	}

	public int getTotal() {

		return total;
	}

	public void setTotal(int total) {

		this.total = total;
	}

	public Page() {
	}

	@Override
	public String toString() {
		return "Page [total=" + total + ", items=" + items + ", pageIndex="
				+ pageIndex + ", pageSize=" + pageSize + ", pageCount="
				+ pageCount + ", catList=" + catList + "]";
	}
	
	
}
