package cn.qpwa.common.utils;

import java.util.Map;

public class AreaSetSqlUtil {
	public static void setSqlAndParam(StringBuilder sb, Map<String, Object> param, Object value) {
		sb.append(" and (ba.id1 in(SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:username)) "
				+ "or ba.id2 in(SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:username)) "
				+ "or ba.id3 in(SELECT area_id FROM AREA_MAS_WEB CONNECT BY PRIOR area_id =parent_id START WITH area_id in (SELECT area_id FROM SCUSER_AREA where user_name=:username)))");
		param.put("username", value);
	}
}
