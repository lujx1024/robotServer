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
 * Home object for domain model class ViewConfigModuleBitMask.
 * @see org.sgpro.db.ViewConfigModuleBitMask
 * @author Hibernate Tools
 */
public class ViewConfigModuleBitMaskHome {

	private static final Log log = LogFactory
			.getLog(ViewConfigModuleBitMaskHome.class);

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

	public void persist(ViewConfigModuleBitMask transientInstance) {
		log.debug("persisting ViewConfigModuleBitMask instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewConfigModuleBitMask instance) {
		log.debug("attaching dirty ViewConfigModuleBitMask instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewConfigModuleBitMask instance) {
		log.debug("attaching clean ViewConfigModuleBitMask instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewConfigModuleBitMask persistentInstance) {
		log.debug("deleting ViewConfigModuleBitMask instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewConfigModuleBitMask merge(
			ViewConfigModuleBitMask detachedInstance) {
		log.debug("merging ViewConfigModuleBitMask instance");
		try {
			ViewConfigModuleBitMask result = (ViewConfigModuleBitMask) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewConfigModuleBitMask findById(
			org.sgpro.db.ViewConfigModuleBitMaskId id) {
		log.debug("getting ViewConfigModuleBitMask instance with id: " + id);
		try {
			ViewConfigModuleBitMask instance = (ViewConfigModuleBitMask) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewConfigModuleBitMask", id);
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

	public List findByExample(ViewConfigModuleBitMask instance) {
		log.debug("finding ViewConfigModuleBitMask instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewConfigModuleBitMask")
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
