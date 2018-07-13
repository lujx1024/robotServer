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
 * Home object for domain model class ViewThirdPartySimple.
 * @see org.sgpro.db.ViewThirdPartySimple
 * @author Hibernate Tools
 */
public class ViewThirdPartySimpleHome {

	private static final Log log = LogFactory
			.getLog(ViewThirdPartySimpleHome.class);

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

	public void persist(ViewThirdPartySimple transientInstance) {
		log.debug("persisting ViewThirdPartySimple instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewThirdPartySimple instance) {
		log.debug("attaching dirty ViewThirdPartySimple instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewThirdPartySimple instance) {
		log.debug("attaching clean ViewThirdPartySimple instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewThirdPartySimple persistentInstance) {
		log.debug("deleting ViewThirdPartySimple instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewThirdPartySimple merge(ViewThirdPartySimple detachedInstance) {
		log.debug("merging ViewThirdPartySimple instance");
		try {
			ViewThirdPartySimple result = (ViewThirdPartySimple) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewThirdPartySimple findById(org.sgpro.db.ViewThirdPartySimpleId id) {
		log.debug("getting ViewThirdPartySimple instance with id: " + id);
		try {
			ViewThirdPartySimple instance = (ViewThirdPartySimple) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewThirdPartySimple", id);
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

	public List findByExample(ViewThirdPartySimple instance) {
		log.debug("finding ViewThirdPartySimple instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewThirdPartySimple")
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
