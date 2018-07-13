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
 * Home object for domain model class TblRequestPropertyBackup.
 * @see org.sgpro.db.TblRequestPropertyBackup
 * @author Hibernate Tools
 */
public class TblRequestPropertyBackupHome {

	private static final Log log = LogFactory
			.getLog(TblRequestPropertyBackupHome.class);

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

	public void persist(TblRequestPropertyBackup transientInstance) {
		log.debug("persisting TblRequestPropertyBackup instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(TblRequestPropertyBackup instance) {
		log.debug("attaching dirty TblRequestPropertyBackup instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(TblRequestPropertyBackup instance) {
		log.debug("attaching clean TblRequestPropertyBackup instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(TblRequestPropertyBackup persistentInstance) {
		log.debug("deleting TblRequestPropertyBackup instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public TblRequestPropertyBackup merge(
			TblRequestPropertyBackup detachedInstance) {
		log.debug("merging TblRequestPropertyBackup instance");
		try {
			TblRequestPropertyBackup result = (TblRequestPropertyBackup) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public TblRequestPropertyBackup findById(
			org.sgpro.db.TblRequestPropertyBackupId id) {
		log.debug("getting TblRequestPropertyBackup instance with id: " + id);
		try {
			TblRequestPropertyBackup instance = (TblRequestPropertyBackup) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.TblRequestPropertyBackup", id);
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

	public List findByExample(TblRequestPropertyBackup instance) {
		log.debug("finding TblRequestPropertyBackup instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.TblRequestPropertyBackup")
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
