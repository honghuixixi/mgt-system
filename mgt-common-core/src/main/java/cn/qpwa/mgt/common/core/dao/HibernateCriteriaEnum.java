package cn.qpwa.mgt.common.core.dao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang.StringUtils;
import org.hibernate.Criteria;
import org.hibernate.criterion.Criterion;
import org.hibernate.criterion.Restrictions;

import cn.qpwa.mgt.common.page.Page;

public enum HibernateCriteriaEnum {

	NULL("null"), isnull("isnull") {
		public Criterion add(Object value, String key) {
			return Restrictions.isNotNull(key);
		}
	},
	eq("eq") {
		public Criterion add(Object value, String key) {
			return Restrictions.eq(key, value);
		}
	},
	isnotnull("isnotnull") {
		@Override
		public Criterion add(Object value, String key) {
			return Restrictions.isNotNull(key);
		}
	},
	ne("ne") {
		@Override
		public Criterion add(Object value, String key) {
			return Restrictions.ne(key, value);
		}
	},
	gte("gte") {
		@Override
		public Criterion add(Object value, String key) {
			return Restrictions.ge(key, value);
		}
	},
	gt("gt") {
		@Override
		public Criterion add(Object value, String key) {
			return Restrictions.gt(key, value);
		}
	},
	lte("lte") {
		@Override
		public Criterion add(Object value, String key) {
			return Restrictions.lt(key, value);
		}
	},
	le("le") {
		@Override
		public Criterion add(Object value, String key) {
			return Restrictions.le(key, value);
		}
	},
	like("like") {
		public Criterion add(Object value, String key) {
			return Restrictions.like(key, value);
		}
	};

	public Criterion add(Object value, String key) {
		return null;
	}

	private static Map<String, HibernateCriteriaEnum> conditionEnumMap;

	private String name;

	private HibernateCriteriaEnum(String name) {
		this.name = name;
	}

	static {
		HibernateCriteriaEnum[] cs = HibernateCriteriaEnum.values();
		if (cs != null) {
			conditionEnumMap = new HashMap<String, HibernateCriteriaEnum>(
					cs.length);
			for (HibernateCriteriaEnum condtionEnum : cs) {
				conditionEnumMap.put(condtionEnum.name, condtionEnum);
			}
			conditionEnumMap.put(null, NULL);
		} else {
			conditionEnumMap = new HashMap<String, HibernateCriteriaEnum>(0);
		}
	}

	public static HibernateCriteriaEnum getEnum(String key) {
		if (!conditionEnumMap.containsKey(key)) {
			return NULL;
		}

		return conditionEnumMap.get(key);
	}

	public static Criteria createCriteriaQuery(Criteria criteria,
			CriteriaModel criteriaModel) {
		if (criteriaModel != null && criteria != null) {

			Integer rows = criteriaModel.getRows();
			Integer page = criteriaModel.getPage();

			if (rows == null || rows == 0) {
				rows = Page.DEFAULT_PAGE_SIZE;
			}
			if (page == null || page == 0) {
				page = 1;
			}
			// 分页信息
			criteria.setFetchSize(rows);
			criteria.setFirstResult((page - 1) * rows);

			String sort = criteriaModel.getSort();
			String order = criteriaModel.getOrder();

			// 排序
			if (StringUtils.isNotBlank(sort) && StringUtils.isNotBlank(order)) {
				if (StringUtils.equalsIgnoreCase("desc", order)) {
					criteria.addOrder(org.hibernate.criterion.Order.desc(sort));
				} else {
					criteria.addOrder(org.hibernate.criterion.Order.asc(sort));
				}
			}

			List<ConditionModel> conditions = criteriaModel.getConditions();
			List<Criterion> list = new ArrayList<Criterion>();
			if (conditions != null && conditions.size() > 0) {
				for (ConditionModel conditionModel : conditions) {
					String opr = conditionModel.getOpr();
					Object value = conditionModel.getValue();
					String name = conditionModel.getName();

					if (value == null || StringUtils.isBlank(value.toString())) {
						continue;
					}

					if (StringUtils.isBlank(opr) || StringUtils.isBlank(name)) {
						continue;
					}

					HibernateCriteriaEnum cenum = HibernateCriteriaEnum
							.getEnum(opr);

					Criterion tmp = cenum.add(value, StringUtils.trim(name));
					if (tmp != null) {
						list.add(tmp);
					}
				}
			}
			if (list.size() > 0) {
				for (Criterion criterion : list) {
					criteria.add(criterion);
				}
			}
		}
		return criteria;
	}
}
