package cn.qpwa.mgt.common.utils;

@SuppressWarnings({ "unchecked", "rawtypes" })
public class SystemContext {
	private static ThreadLocal offset = new ThreadLocal();
	private static ThreadLocal pagesize = new ThreadLocal();

	public static void setOffset(Integer _offset) {
		offset.set(_offset);
	}

	public static Integer getOffset() {
		Integer os = (Integer) offset.get();
		if (os == null) {
			return 0;
		}
		return os;
	}

	public static void removeOffset() {
		offset.remove();
	}

	public static void setPagesize(Integer _pagesize) {
		pagesize.set(_pagesize);
	}

	public static Integer getPagesize() {
		Integer ps = (Integer) pagesize.get();
		if (ps == null) {
			return Integer.MAX_VALUE;
		}
		return ps;
	}

	public static void removePagesize() {
		pagesize.remove();
	}
}
