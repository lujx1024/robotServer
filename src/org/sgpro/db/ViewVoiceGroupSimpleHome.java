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
 * Home object for domain model class ViewVoiceGroupSimple.
 * @see org.sgpro.db.ViewVoiceGroupSimple
 * @author Hibernate Tools
 */
public class ViewVoiceGroupSimpleHome {

	private static final Log log = LogFactory
			.getLog(ViewVoiceGroupSimpleHome.class);

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

	public void persist(ViewVoiceGroupSimple transientInstance) {
		log.debug("persisting ViewVoiceGroupSimple instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewVoiceGroupSimple instance) {
		log.debug("attaching dirty ViewVoiceGroupSimple instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewVoiceGroupSimple instance) {
		log.debug("attaching clean ViewVoiceGroupSimple instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewVoiceGroupSimple persistentInstance) {
		log.debug("deleting ViewVoiceGroupSimple instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewVoiceGroupSimple merge(ViewVoiceGroupSimple detachedInstance) {
		log.debug("merging ViewVoiceGroupSimple instance");
		try {
			ViewVoiceGroupSimple result = (ViewVoiceGroupSimple) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewVoiceGroupSimple findById(org.sgpro.db.ViewVoiceGroupSimpleId id) {
		log.debug("getting ViewVoiceGroupSimple instance with id: " + id);
		try {
			ViewVoiceGroupSimple instance = (ViewVoiceGroupSimple) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewVoiceGroupSimple", id);
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

	public List findByExample(ViewVoiceGroupSimple instance) {
		log.debug("finding ViewVoiceGroupSimple instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewVoiceGroupSimple")
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
