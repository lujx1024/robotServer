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
 * Home object for domain model class TblInheritConfigForRobot.
 * @see org.sgpro.db.TblInheritConfigForRobot
 * @author Hibernate Tools
 */
public class TblInheritConfigForRobotHome {

	private static final Log log = LogFactory
			.getLog(TblInheritConfigForRobotHome.class);

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

	public void persist(TblInheritConfigForRobot transientInstance) {
		log.debug("persisting TblInheritConfigForRobot instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(TblInheritConfigForRobot instance) {
		log.debug("attaching dirty TblInheritConfigForRobot instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(TblInheritConfigForRobot instance) {
		log.debug("attaching clean TblInheritConfigForRobot instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(TblInheritConfigForRobot persistentInstance) {
		log.debug("deleting TblInheritConfigForRobot instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public TblInheritConfigForRobot merge(
			TblInheritConfigForRobot detachedInstance) {
		log.debug("merging TblInheritConfigForRobot instance");
		try {
			TblInheritConfigForRobot result = (TblInheritConfigForRobot) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public TblInheritConfigForRobot findById(
			org.sgpro.db.TblInheritConfigForRobotId id) {
		log.debug("getting TblInheritConfigForRobot instance with id: " + id);
		try {
			TblInheritConfigForRobot instance = (TblInheritConfigForRobot) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.TblInheritConfigForRobot", id);
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

	public List findByExample(TblInheritConfigForRobot instance) {
		log.debug("finding TblInheritConfigForRobot instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.TblInheritConfigForRobot")
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
