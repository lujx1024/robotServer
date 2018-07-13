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
 * Home object for domain model class ViewRobotLatestStatus.
 * @see org.sgpro.db.ViewRobotLatestStatus
 * @author Hibernate Tools
 */
public class ViewRobotLatestStatusHome {

	private static final Log log = LogFactory
			.getLog(ViewRobotLatestStatusHome.class);

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

	public void persist(ViewRobotLatestStatus transientInstance) {
		log.debug("persisting ViewRobotLatestStatus instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewRobotLatestStatus instance) {
		log.debug("attaching dirty ViewRobotLatestStatus instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewRobotLatestStatus instance) {
		log.debug("attaching clean ViewRobotLatestStatus instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewRobotLatestStatus persistentInstance) {
		log.debug("deleting ViewRobotLatestStatus instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewRobotLatestStatus merge(ViewRobotLatestStatus detachedInstance) {
		log.debug("merging ViewRobotLatestStatus instance");
		try {
			ViewRobotLatestStatus result = (ViewRobotLatestStatus) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewRobotLatestStatus findById(
			org.sgpro.db.ViewRobotLatestStatusId id) {
		log.debug("getting ViewRobotLatestStatus instance with id: " + id);
		try {
			ViewRobotLatestStatus instance = (ViewRobotLatestStatus) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewRobotLatestStatus", id);
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

	public List findByExample(ViewRobotLatestStatus instance) {
		log.debug("finding ViewRobotLatestStatus instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewRobotLatestStatus")
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
