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
 * Home object for domain model class TblRtcSessionStatus.
 * @see org.sgpro.db.TblRtcSessionStatus
 * @author Hibernate Tools
 */
public class TblRtcSessionStatusHome {

	private static final Log log = LogFactory
			.getLog(TblRtcSessionStatusHome.class);

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

	public void persist(TblRtcSessionStatus transientInstance) {
		log.debug("persisting TblRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(TblRtcSessionStatus instance) {
		log.debug("attaching dirty TblRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(TblRtcSessionStatus instance) {
		log.debug("attaching clean TblRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(TblRtcSessionStatus persistentInstance) {
		log.debug("deleting TblRtcSessionStatus instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public TblRtcSessionStatus merge(TblRtcSessionStatus detachedInstance) {
		log.debug("merging TblRtcSessionStatus instance");
		try {
			TblRtcSessionStatus result = (TblRtcSessionStatus) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public TblRtcSessionStatus findById(org.sgpro.db.TblRtcSessionStatusId id) {
		log.debug("getting TblRtcSessionStatus instance with id: " + id);
		try {
			TblRtcSessionStatus instance = (TblRtcSessionStatus) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.TblRtcSessionStatus", id);
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

	public List findByExample(TblRtcSessionStatus instance) {
		log.debug("finding TblRtcSessionStatus instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.TblRtcSessionStatus")
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
