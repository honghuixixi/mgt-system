package cn.qpwa.common.entity;

import net.sf.json.JSONArray;

import java.io.Serializable;

public class DepartmentObject implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String departJsonArrayStr;

	public String getDepartJsonArrayStr() {
		return departJsonArrayStr;
	}

	public void setDepartJsonArrayStr(String departJsonArrayStr) {
		this.departJsonArrayStr = departJsonArrayStr;
	}

	public void setDepartJsonArray(JSONArray departJsonArray) {
		this.departJsonArrayStr = departJsonArray.toString();
	}

	public JSONArray getDepartJsonArray(){
		return JSONArray.fromObject(departJsonArrayStr);
	}
}
