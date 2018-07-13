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
 * Home object for domain model class ViewThirdPartyParamValueSimple.
 * @see org.sgpro.db.ViewThirdPartyParamValueSimple
 * @author Hibernate Tools
 */
public class ViewThirdPartyParamValueSimpleHome {

	private static final Log log = LogFactory
			.getLog(ViewThirdPartyParamValueSimpleHome.class);

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

	public void persist(ViewThirdPartyParamValueSimple transientInstance) {
		log.debug("persisting ViewThirdPartyParamValueSimple instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewThirdPartyParamValueSimple instance) {
		log.debug("attaching dirty ViewThirdPartyParamValueSimple instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewThirdPartyParamValueSimple instance) {
		log.debug("attaching clean ViewThirdPartyParamValueSimple instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewThirdPartyParamValueSimple persistentInstance) {
		log.debug("deleting ViewThirdPartyParamValueSimple instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewThirdPartyParamValueSimple merge(
			ViewThirdPartyParamValueSimple detachedInstance) {
		log.debug("merging ViewThirdPartyParamValueSimple instance");
		try {
			ViewThirdPartyParamValueSimple result = (ViewThirdPartyParamValueSimple) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewThirdPartyParamValueSimple findById(
			org.sgpro.db.ViewThirdPartyParamValueSimpleId id) {
		log.debug("getting ViewThirdPartyParamValueSimple instance with id: "
				+ id);
		try {
			ViewThirdPartyParamValueSimple instance = (ViewThirdPartyParamValueSimple) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewThirdPartyParamValueSimple", id);
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

	public List findByExample(ViewThirdPartyParamValueSimple instance) {
		log.debug("finding ViewThirdPartyParamValueSimple instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria(
							"org.sgpro.db.ViewThirdPartyParamValueSimple")
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
