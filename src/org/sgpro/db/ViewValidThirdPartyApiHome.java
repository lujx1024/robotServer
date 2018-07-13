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
 * Home object for domain model class ViewValidThirdPartyApi.
 * @see org.sgpro.db.ViewValidThirdPartyApi
 * @author Hibernate Tools
 */
public class ViewValidThirdPartyApiHome {

	private static final Log log = LogFactory
			.getLog(ViewValidThirdPartyApiHome.class);

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

	public void persist(ViewValidThirdPartyApi transientInstance) {
		log.debug("persisting ViewValidThirdPartyApi instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewValidThirdPartyApi instance) {
		log.debug("attaching dirty ViewValidThirdPartyApi instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewValidThirdPartyApi instance) {
		log.debug("attaching clean ViewValidThirdPartyApi instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewValidThirdPartyApi persistentInstance) {
		log.debug("deleting ViewValidThirdPartyApi instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewValidThirdPartyApi merge(ViewValidThirdPartyApi detachedInstance) {
		log.debug("merging ViewValidThirdPartyApi instance");
		try {
			ViewValidThirdPartyApi result = (ViewValidThirdPartyApi) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewValidThirdPartyApi findById(
			org.sgpro.db.ViewValidThirdPartyApiId id) {
		log.debug("getting ViewValidThirdPartyApi instance with id: " + id);
		try {
			ViewValidThirdPartyApi instance = (ViewValidThirdPartyApi) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewValidThirdPartyApi", id);
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

	public List findByExample(ViewValidThirdPartyApi instance) {
		log.debug("finding ViewValidThirdPartyApi instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewValidThirdPartyApi")
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
