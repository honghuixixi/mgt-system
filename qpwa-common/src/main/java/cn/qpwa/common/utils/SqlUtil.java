package cn.qpwa.common.utils;

import java.util.List;

/**
 * 数据库sql工具类
 * 
 * @author honghui 2016-3-23
 */
@SuppressWarnings("rawtypes")
public class SqlUtil {

	/**
	 * 把超过1000的in条件集合拆分成数量splitNum的多组sql的in集合。
	 * 解决数据库的列表SQL限制，不能超过1000问题
	 * @param sqhList     In条件的List
	 * @param splitNum    拆分的间隔数目
	 * @param columnName  SQL中引用的字段名例
	 * @return
	 */
	public static String getSqlIn(List sqhList, int splitNum, String columnName) {
		if (splitNum > 1000) //因为数据库的列表sql限制，不能超过1000.
			return null;
		StringBuffer sql = new StringBuffer("");
		if (sqhList != null) {
			sql.append(" ").append(columnName).append(" IN ( ");
			for (int i = 0; i < sqhList.size(); i++) {
				sql.append("'").append(sqhList.get(i) + "',");
				if ((i + 1) % splitNum == 0 && (i + 1) < sqhList.size()) {
					sql.deleteCharAt(sql.length() - 1);
					sql.append(" ) OR ").append(columnName).append(" IN (");
				}
			}
			sql.deleteCharAt(sql.length() - 1);
			sql.append(" )");
		}
		return sql.toString();
	}

}
