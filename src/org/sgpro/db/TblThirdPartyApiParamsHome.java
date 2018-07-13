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
 * Home object for domain model class TblThirdPartyApiParams.
 * @see org.sgpro.db.TblThirdPartyApiParams
 * @author Hibernate Tools
 */
public class TblThirdPartyApiParamsHome {

	private static final Log log = LogFactory
			.getLog(TblThirdPartyApiParamsHome.class);

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

	public void persist(TblThirdPartyApiParams transientInstance) {
		log.debug("persisting TblThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(TblThirdPartyApiParams instance) {
		log.debug("attaching dirty TblThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(TblThirdPartyApiParams instance) {
		log.debug("attaching clean TblThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(TblThirdPartyApiParams persistentInstance) {
		log.debug("deleting TblThirdPartyApiParams instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public TblThirdPartyApiParams merge(TblThirdPartyApiParams detachedInstance) {
		log.debug("merging TblThirdPartyApiParams instance");
		try {
			TblThirdPartyApiParams result = (TblThirdPartyApiParams) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public TblThirdPartyApiParams findById(
			org.sgpro.db.TblThirdPartyApiParamsId id) {
		log.debug("getting TblThirdPartyApiParams instance with id: " + id);
		try {
			TblThirdPartyApiParams instance = (TblThirdPartyApiParams) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.TblThirdPartyApiParams", id);
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

	public List findByExample(TblThirdPartyApiParams instance) {
		log.debug("finding TblThirdPartyApiParams instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.TblThirdPartyApiParams")
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
