package cn.qpwa.common.core.dao;

public class ConditionModel {

	private String name;
	private String opr;
	private Object value;

	public ConditionModel() {
		super();
	}

	public ConditionModel(String name, String opr, Object value) {
		this.name = name;
		this.opr = opr;
		this.value = value;
	}

	public ConditionModel(String name, Object value) {
		this.name = name;
		this.value = value;
		this.opr = HibernateCriteriaEnum.eq.name();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getOpr() {
		return opr;
	}

	public void setOpr(String opr) {
		this.opr = opr;
	}

	public Object getValue() {
		return value;
	}

	public void setValue(Object value) {
		this.value = value;
	}
}
