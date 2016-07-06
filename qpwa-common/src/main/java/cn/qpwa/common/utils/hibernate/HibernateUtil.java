package cn.qpwa.common.utils.hibernate;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {
	/**
	 * SessionFactory是单例
	 */
	private static SessionFactory factory = null;
	static {
		factory = new Configuration().configure().buildSessionFactory();
	}

	public static Session openSession() {
		return factory.openSession();
	}
}
