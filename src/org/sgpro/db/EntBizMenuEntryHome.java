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
 * Home object for domain model class EntBizMenuEntry.
 * @see org.sgpro.db.EntBizMenuEntry
 * @author Hibernate Tools
 */
public class EntBizMenuEntryHome {

	private static final Log log = LogFactory.getLog(EntBizMenuEntryHome.class);

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

	public void persist(EntBizMenuEntry transientInstance) {
		log.debug("persisting EntBizMenuEntry instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(EntBizMenuEntry instance) {
		log.debug("attaching dirty EntBizMenuEntry instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(EntBizMenuEntry instance) {
		log.debug("attaching clean EntBizMenuEntry instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(EntBizMenuEntry persistentInstance) {
		log.debug("deleting EntBizMenuEntry instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public EntBizMenuEntry merge(EntBizMenuEntry detachedInstance) {
		log.debug("merging EntBizMenuEntry instance");
		try {
			EntBizMenuEntry result = (EntBizMenuEntry) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public EntBizMenuEntry findById(java.lang.String id) {
		log.debug("getting EntBizMenuEntry instance with id: " + id);
		try {
			EntBizMenuEntry instance = (EntBizMenuEntry) sessionFactory
					.getCurrentSession()
					.get("org.sgpro.db.EntBizMenuEntry", id);
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

	public List findByExample(EntBizMenuEntry instance) {
		log.debug("finding EntBizMenuEntry instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.EntBizMenuEntry")
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
