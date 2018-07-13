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
 * Home object for domain model class ViewThirdPartyApiParamValue.
 * @see org.sgpro.db.ViewThirdPartyApiParamValue
 * @author Hibernate Tools
 */
public class ViewThirdPartyApiParamValueHome {

	private static final Log log = LogFactory
			.getLog(ViewThirdPartyApiParamValueHome.class);

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

	public void persist(ViewThirdPartyApiParamValue transientInstance) {
		log.debug("persisting ViewThirdPartyApiParamValue instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewThirdPartyApiParamValue instance) {
		log.debug("attaching dirty ViewThirdPartyApiParamValue instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewThirdPartyApiParamValue instance) {
		log.debug("attaching clean ViewThirdPartyApiParamValue instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewThirdPartyApiParamValue persistentInstance) {
		log.debug("deleting ViewThirdPartyApiParamValue instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewThirdPartyApiParamValue merge(
			ViewThirdPartyApiParamValue detachedInstance) {
		log.debug("merging ViewThirdPartyApiParamValue instance");
		try {
			ViewThirdPartyApiParamValue result = (ViewThirdPartyApiParamValue) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewThirdPartyApiParamValue findById(
			org.sgpro.db.ViewThirdPartyApiParamValueId id) {
		log.debug("getting ViewThirdPartyApiParamValue instance with id: " + id);
		try {
			ViewThirdPartyApiParamValue instance = (ViewThirdPartyApiParamValue) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewThirdPartyApiParamValue", id);
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

	public List findByExample(ViewThirdPartyApiParamValue instance) {
		log.debug("finding ViewThirdPartyApiParamValue instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewThirdPartyApiParamValue")
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
