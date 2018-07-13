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
 * Home object for domain model class ViewRobotLatestStatusDrop.
 * @see org.sgpro.db.ViewRobotLatestStatusDrop
 * @author Hibernate Tools
 */
public class ViewRobotLatestStatusDropHome {

	private static final Log log = LogFactory
			.getLog(ViewRobotLatestStatusDropHome.class);

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

	public void persist(ViewRobotLatestStatusDrop transientInstance) {
		log.debug("persisting ViewRobotLatestStatusDrop instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewRobotLatestStatusDrop instance) {
		log.debug("attaching dirty ViewRobotLatestStatusDrop instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewRobotLatestStatusDrop instance) {
		log.debug("attaching clean ViewRobotLatestStatusDrop instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewRobotLatestStatusDrop persistentInstance) {
		log.debug("deleting ViewRobotLatestStatusDrop instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewRobotLatestStatusDrop merge(
			ViewRobotLatestStatusDrop detachedInstance) {
		log.debug("merging ViewRobotLatestStatusDrop instance");
		try {
			ViewRobotLatestStatusDrop result = (ViewRobotLatestStatusDrop) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewRobotLatestStatusDrop findById(
			org.sgpro.db.ViewRobotLatestStatusDropId id) {
		log.debug("getting ViewRobotLatestStatusDrop instance with id: " + id);
		try {
			ViewRobotLatestStatusDrop instance = (ViewRobotLatestStatusDrop) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewRobotLatestStatusDrop", id);
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

	public List findByExample(ViewRobotLatestStatusDrop instance) {
		log.debug("finding ViewRobotLatestStatusDrop instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewRobotLatestStatusDrop")
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
