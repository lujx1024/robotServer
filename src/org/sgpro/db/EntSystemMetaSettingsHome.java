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
 * Home object for domain model class EntSystemMetaSettings.
 * @see org.sgpro.db.EntSystemMetaSettings
 * @author Hibernate Tools
 */
public class EntSystemMetaSettingsHome {

	private static final Log log = LogFactory
			.getLog(EntSystemMetaSettingsHome.class);

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

	public void persist(EntSystemMetaSettings transientInstance) {
		log.debug("persisting EntSystemMetaSettings instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(EntSystemMetaSettings instance) {
		log.debug("attaching dirty EntSystemMetaSettings instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(EntSystemMetaSettings instance) {
		log.debug("attaching clean EntSystemMetaSettings instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(EntSystemMetaSettings persistentInstance) {
		log.debug("deleting EntSystemMetaSettings instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public EntSystemMetaSettings merge(EntSystemMetaSettings detachedInstance) {
		log.debug("merging EntSystemMetaSettings instance");
		try {
			EntSystemMetaSettings result = (EntSystemMetaSettings) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public EntSystemMetaSettings findById(java.lang.String id) {
		log.debug("getting EntSystemMetaSettings instance with id: " + id);
		try {
			EntSystemMetaSettings instance = (EntSystemMetaSettings) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.EntSystemMetaSettings", id);
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

	public List findByExample(EntSystemMetaSettings instance) {
		log.debug("finding EntSystemMetaSettings instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.EntSystemMetaSettings")
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
