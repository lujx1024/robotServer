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
 * Home object for domain model class ViewUserGroupBindRobotSn.
 * @see org.sgpro.db.ViewUserGroupBindRobotSn
 * @author Hibernate Tools
 */
public class ViewUserGroupBindRobotSnHome {

	private static final Log log = LogFactory
			.getLog(ViewUserGroupBindRobotSnHome.class);

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

	public void persist(ViewUserGroupBindRobotSn transientInstance) {
		log.debug("persisting ViewUserGroupBindRobotSn instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewUserGroupBindRobotSn instance) {
		log.debug("attaching dirty ViewUserGroupBindRobotSn instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewUserGroupBindRobotSn instance) {
		log.debug("attaching clean ViewUserGroupBindRobotSn instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewUserGroupBindRobotSn persistentInstance) {
		log.debug("deleting ViewUserGroupBindRobotSn instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewUserGroupBindRobotSn merge(
			ViewUserGroupBindRobotSn detachedInstance) {
		log.debug("merging ViewUserGroupBindRobotSn instance");
		try {
			ViewUserGroupBindRobotSn result = (ViewUserGroupBindRobotSn) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewUserGroupBindRobotSn findById(
			org.sgpro.db.ViewUserGroupBindRobotSnId id) {
		log.debug("getting ViewUserGroupBindRobotSn instance with id: " + id);
		try {
			ViewUserGroupBindRobotSn instance = (ViewUserGroupBindRobotSn) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewUserGroupBindRobotSn", id);
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

	public List findByExample(ViewUserGroupBindRobotSn instance) {
		log.debug("finding ViewUserGroupBindRobotSn instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewUserGroupBindRobotSn")
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
