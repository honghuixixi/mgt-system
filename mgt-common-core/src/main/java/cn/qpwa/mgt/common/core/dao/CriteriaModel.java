package cn.qpwa.mgt.common.core.dao;

import java.util.List;

public class CriteriaModel {

	private Integer rows;
	private Integer page;

	private String sort;
	private String order;

	public CriteriaModel() {
		super();
	}

	public CriteriaModel(Integer rows, Integer page) {
		this.rows = rows;
		this.page = page;
	}

	/**
	 * 查询条件
	 */
	private List<ConditionModel> conditions;

	public Integer getRows() {
		return rows;
	}

	public void setRows(Integer rows) {
		this.rows = rows;
	}

	public Integer getPage() {
		return page;
	}

	public void setPage(Integer page) {
		this.page = page;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public List<ConditionModel> getConditions() {
		return conditions;
	}

	public void setConditions(List<ConditionModel> conditions) {
		this.conditions = conditions;
	}
}
