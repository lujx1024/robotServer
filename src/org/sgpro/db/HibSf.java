package org.sgpro.db;

import java.sql.Connection;
import java.sql.SQLException;

import javax.naming.InitialContext;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.engine.spi.SessionFactoryImplementor;

public class HibSf {
	private static SessionFactory sf = null;
	

	public synchronized static SessionFactory getSessionFactory() {
		try {
			if (sf == null) {
				try {
					return (SessionFactory) new InitialContext()
							.lookup("SessionFactory");
				} catch (Exception e) {
					throw new IllegalStateException(
							"Could not locate SessionFactory in JNDI");
				}
			}
		} catch (Exception e) {
			// log.error("Could not locate SessionFactory in JNDI", e);
			throw new IllegalStateException(
					"Could not locate SessionFactory in JNDI", e);
		}
		return sf;
	}
	
	public static Session getSession() {
		return getSessionFactory().getCurrentSession();
	}
	
	public static Connection getConnection() {
			try {
				return ((SessionFactoryImplementor)getSessionFactory()).getConnectionProvider().getConnection();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				throw new RuntimeException(e);
			}
	}


}
