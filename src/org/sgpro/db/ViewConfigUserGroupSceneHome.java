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
 * Home object for domain model class ViewConfigUserGroupScene.
 * @see org.sgpro.db.ViewConfigUserGroupScene
 * @author Hibernate Tools
 */
public class ViewConfigUserGroupSceneHome {

	private static final Log log = LogFactory
			.getLog(ViewConfigUserGroupSceneHome.class);

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

	public void persist(ViewConfigUserGroupScene transientInstance) {
		log.debug("persisting ViewConfigUserGroupScene instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewConfigUserGroupScene instance) {
		log.debug("attaching dirty ViewConfigUserGroupScene instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewConfigUserGroupScene instance) {
		log.debug("attaching clean ViewConfigUserGroupScene instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewConfigUserGroupScene persistentInstance) {
		log.debug("deleting ViewConfigUserGroupScene instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewConfigUserGroupScene merge(
			ViewConfigUserGroupScene detachedInstance) {
		log.debug("merging ViewConfigUserGroupScene instance");
		try {
			ViewConfigUserGroupScene result = (ViewConfigUserGroupScene) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewConfigUserGroupScene findById(
			org.sgpro.db.ViewConfigUserGroupSceneId id) {
		log.debug("getting ViewConfigUserGroupScene instance with id: " + id);
		try {
			ViewConfigUserGroupScene instance = (ViewConfigUserGroupScene) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewConfigUserGroupScene", id);
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

	public List findByExample(ViewConfigUserGroupScene instance) {
		log.debug("finding ViewConfigUserGroupScene instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewConfigUserGroupScene")
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
