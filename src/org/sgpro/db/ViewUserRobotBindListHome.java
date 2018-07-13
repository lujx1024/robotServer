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
 * Home object for domain model class ViewUserRobotBindList.
 * @see org.sgpro.db.ViewUserRobotBindList
 * @author Hibernate Tools
 */
public class ViewUserRobotBindListHome {

	private static final Log log = LogFactory
			.getLog(ViewUserRobotBindListHome.class);

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

	public void persist(ViewUserRobotBindList transientInstance) {
		log.debug("persisting ViewUserRobotBindList instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewUserRobotBindList instance) {
		log.debug("attaching dirty ViewUserRobotBindList instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewUserRobotBindList instance) {
		log.debug("attaching clean ViewUserRobotBindList instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewUserRobotBindList persistentInstance) {
		log.debug("deleting ViewUserRobotBindList instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewUserRobotBindList merge(ViewUserRobotBindList detachedInstance) {
		log.debug("merging ViewUserRobotBindList instance");
		try {
			ViewUserRobotBindList result = (ViewUserRobotBindList) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewUserRobotBindList findById(
			org.sgpro.db.ViewUserRobotBindListId id) {
		log.debug("getting ViewUserRobotBindList instance with id: " + id);
		try {
			ViewUserRobotBindList instance = (ViewUserRobotBindList) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewUserRobotBindList", id);
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

	public List findByExample(ViewUserRobotBindList instance) {
		log.debug("finding ViewUserRobotBindList instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewUserRobotBindList")
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
