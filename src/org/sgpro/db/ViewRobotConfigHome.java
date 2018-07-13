package org.sgpro.db;

// Generated 2017-6-21 11:12:48 by Hibernate Tools 4.0.0

import java.util.List;
import javax.naming.InitialContext;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.LockMode;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Example;

/**
 * Home object for domain model class ViewRobotConfig.
 * @see org.sgpro.db.ViewRobotConfig
 * @author Hibernate Tools
 */
public class ViewRobotConfigHome {

	private static final Log log = LogFactory.getLog(ViewRobotConfigHome.class);

	private final SessionFactory sessionFactory = getSessionFactory();

	protected SessionFactory getSessionFactory() {
		try {
			return (SessionFactory) new InitialContext()
					.lookup("SessionFactory");
		} catch (Exception e) {
			log.error("Could not locate SessionFactory in JNDI", e);
			throw new IllegalStateException(
					"Could not locate SessionFactory in JNDI");
		}
	}

	public void persist(ViewRobotConfig transientInstance) {
		log.debug("persisting ViewRobotConfig instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewRobotConfig instance) {
		log.debug("attaching dirty ViewRobotConfig instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewRobotConfig instance) {
		log.debug("attaching clean ViewRobotConfig instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewRobotConfig persistentInstance) {
		log.debug("deleting ViewRobotConfig instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewRobotConfig merge(ViewRobotConfig detachedInstance) {
		log.debug("merging ViewRobotConfig instance");
		try {
			ViewRobotConfig result = (ViewRobotConfig) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewRobotConfig findById(org.sgpro.db.ViewRobotConfigId id) {
		log.debug("getting ViewRobotConfig instance with id: " + id);
		try {
			ViewRobotConfig instance = (ViewRobotConfig) sessionFactory
					.getCurrentSession()
					.get("org.sgpro.db.ViewRobotConfig", id);
			if (instance == null) {
				log.debug("get successful, no instance found");
			} else {
				log.debug("get successful, instance found");
			}
			return instance;
		} catch (RuntimeException re) {
			log.error("get failed", re);
			throw re;
		}
	}

	public List findByExample(ViewRobotConfig instance) {
		log.debug("finding ViewRobotConfig instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewRobotConfig")
					.add(Example.create(instance)).list();
			log.debug("find by example successful, result size: "
					+ results.size());
			return results;
		} catch (RuntimeException re) {
			log.error("find by example failed", re);
			throw re;
		}
	}
}
