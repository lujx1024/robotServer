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
 * Home object for domain model class ViewValidThirdPartyApiParams.
 * @see org.sgpro.db.ViewValidThirdPartyApiParams
 * @author Hibernate Tools
 */
public class ViewValidThirdPartyApiParamsHome {

	private static final Log log = LogFactory
			.getLog(ViewValidThirdPartyApiParamsHome.class);

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

	public void persist(ViewValidThirdPartyApiParams transientInstance) {
		log.debug("persisting ViewValidThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewValidThirdPartyApiParams instance) {
		log.debug("attaching dirty ViewValidThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewValidThirdPartyApiParams instance) {
		log.debug("attaching clean ViewValidThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewValidThirdPartyApiParams persistentInstance) {
		log.debug("deleting ViewValidThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewValidThirdPartyApiParams merge(
			ViewValidThirdPartyApiParams detachedInstance) {
		log.debug("merging ViewValidThirdPartyApiParams instance");
		try {
			ViewValidThirdPartyApiParams result = (ViewValidThirdPartyApiParams) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewValidThirdPartyApiParams findById(
			org.sgpro.db.ViewValidThirdPartyApiParamsId id) {
		log.debug("getting ViewValidThirdPartyApiParams instance with id: "
				+ id);
		try {
			ViewValidThirdPartyApiParams instance = (ViewValidThirdPartyApiParams) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewValidThirdPartyApiParams", id);
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

	public List findByExample(ViewValidThirdPartyApiParams instance) {
		log.debug("finding ViewValidThirdPartyApiParams instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewValidThirdPartyApiParams")
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
