package org.sgpro.signalmaster;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class SessionFactoryListener implements ServletContextListener {

	private SessionFactory mSessionFactory;

	public void contextDestroyed(ServletContextEvent event) {

		if (mSessionFactory != null && !mSessionFactory.isClosed()) {
			mSessionFactory.close();
		}

	}

	public void contextInitialized(ServletContextEvent event) {
		InitialContext initialContext = null;
		try {

			initialContext = new InitialContext();

		} catch (NamingException e) {
			throw new RuntimeException("Unable to create InitalContext", e);
		}

		try {
			mSessionFactory = (SessionFactory) initialContext
					.lookup("SessionFactory");
		} catch (NamingException e) {
			Configuration cfg;
			cfg = new Configuration();
			cfg.configure();
			mSessionFactory = cfg.buildSessionFactory();

			try {
				initialContext.rebind("SessionFactory", mSessionFactory);
			} catch (NamingException e1) {
				throw new RuntimeException(
						"Unable to bind the SessionFactory to the Inital Context");
			}
		}
		
	}
}
