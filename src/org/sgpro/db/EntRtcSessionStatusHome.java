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
 * Home object for domain model class EntRtcSessionStatus.
 * @see org.sgpro.db.EntRtcSessionStatus
 * @author Hibernate Tools
 */
public class EntRtcSessionStatusHome {

	private static final Log log = LogFactory
			.getLog(EntRtcSessionStatusHome.class);

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

	public void persist(EntRtcSessionStatus transientInstance) {
		log.debug("persisting EntRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(EntRtcSessionStatus instance) {
		log.debug("attaching dirty EntRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(EntRtcSessionStatus instance) {
		log.debug("attaching clean EntRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(EntRtcSessionStatus persistentInstance) {
		log.debug("deleting EntRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public EntRtcSessionStatus merge(EntRtcSessionStatus detachedInstance) {
		log.debug("merging EntRtcSessionStatus instance");
		try {
			EntRtcSessionStatus result = (EntRtcSessionStatus) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public EntRtcSessionStatus findById(long id) {
		log.debug("getting EntRtcSessionStatus instance with id: " + id);
		try {
			EntRtcSessionStatus instance = (EntRtcSessionStatus) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.EntRtcSessionStatus", id);
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

	public List findByExample(EntRtcSessionStatus instance) {
		log.debug("finding EntRtcSessionStatus instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.EntRtcSessionStatus")
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
