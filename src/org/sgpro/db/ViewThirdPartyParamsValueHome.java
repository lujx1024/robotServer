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
 * Home object for domain model class ViewThirdPartyParamsValue.
 * @see org.sgpro.db.ViewThirdPartyParamsValue
 * @author Hibernate Tools
 */
public class ViewThirdPartyParamsValueHome {

	private static final Log log = LogFactory
			.getLog(ViewThirdPartyParamsValueHome.class);

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

	public void persist(ViewThirdPartyParamsValue transientInstance) {
		log.debug("persisting ViewThirdPartyParamsValue instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewThirdPartyParamsValue instance) {
		log.debug("attaching dirty ViewThirdPartyParamsValue instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewThirdPartyParamsValue instance) {
		log.debug("attaching clean ViewThirdPartyParamsValue instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewThirdPartyParamsValue persistentInstance) {
		log.debug("deleting ViewThirdPartyParamsValue instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewThirdPartyParamsValue merge(
			ViewThirdPartyParamsValue detachedInstance) {
		log.debug("merging ViewThirdPartyParamsValue instance");
		try {
			ViewThirdPartyParamsValue result = (ViewThirdPartyParamsValue) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewThirdPartyParamsValue findById(
			org.sgpro.db.ViewThirdPartyParamsValueId id) {
		log.debug("getting ViewThirdPartyParamsValue instance with id: " + id);
		try {
			ViewThirdPartyParamsValue instance = (ViewThirdPartyParamsValue) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewThirdPartyParamsValue", id);
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

	public List findByExample(ViewThirdPartyParamsValue instance) {
		log.debug("finding ViewThirdPartyParamsValue instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewThirdPartyParamsValue")
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
