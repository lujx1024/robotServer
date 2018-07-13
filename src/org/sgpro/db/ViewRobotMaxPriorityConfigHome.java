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
 * Home object for domain model class ViewRobotMaxPriorityConfig.
 * @see org.sgpro.db.ViewRobotMaxPriorityConfig
 * @author Hibernate Tools
 */
public class ViewRobotMaxPriorityConfigHome {

	private static final Log log = LogFactory
			.getLog(ViewRobotMaxPriorityConfigHome.class);

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

	public void persist(ViewRobotMaxPriorityConfig transientInstance) {
		log.debug("persisting ViewRobotMaxPriorityConfig instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewRobotMaxPriorityConfig instance) {
		log.debug("attaching dirty ViewRobotMaxPriorityConfig instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewRobotMaxPriorityConfig instance) {
		log.debug("attaching clean ViewRobotMaxPriorityConfig instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewRobotMaxPriorityConfig persistentInstance) {
		log.debug("deleting ViewRobotMaxPriorityConfig instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewRobotMaxPriorityConfig merge(
			ViewRobotMaxPriorityConfig detachedInstance) {
		log.debug("merging ViewRobotMaxPriorityConfig instance");
		try {
			ViewRobotMaxPriorityConfig result = (ViewRobotMaxPriorityConfig) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewRobotMaxPriorityConfig findById(
			org.sgpro.db.ViewRobotMaxPriorityConfigId id) {
		log.debug("getting ViewRobotMaxPriorityConfig instance with id: " + id);
		try {
			ViewRobotMaxPriorityConfig instance = (ViewRobotMaxPriorityConfig) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewRobotMaxPriorityConfig", id);
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

	public List findByExample(ViewRobotMaxPriorityConfig instance) {
		log.debug("finding ViewRobotMaxPriorityConfig instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewRobotMaxPriorityConfig")
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
