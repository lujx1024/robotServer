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
 * Home object for domain model class TblCustomizedConfigForUserGroup.
 * @see org.sgpro.db.TblCustomizedConfigForUserGroup
 * @author Hibernate Tools
 */
public class TblCustomizedConfigForUserGroupHome {

	private static final Log log = LogFactory
			.getLog(TblCustomizedConfigForUserGroupHome.class);

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

	public void persist(TblCustomizedConfigForUserGroup transientInstance) {
		log.debug("persisting TblCustomizedConfigForUserGroup instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(TblCustomizedConfigForUserGroup instance) {
		log.debug("attaching dirty TblCustomizedConfigForUserGroup instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(TblCustomizedConfigForUserGroup instance) {
		log.debug("attaching clean TblCustomizedConfigForUserGroup instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(TblCustomizedConfigForUserGroup persistentInstance) {
		log.debug("deleting TblCustomizedConfigForUserGroup instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public TblCustomizedConfigForUserGroup merge(
			TblCustomizedConfigForUserGroup detachedInstance) {
		log.debug("merging TblCustomizedConfigForUserGroup instance");
		try {
			TblCustomizedConfigForUserGroup result = (TblCustomizedConfigForUserGroup) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public TblCustomizedConfigForUserGroup findById(
			org.sgpro.db.TblCustomizedConfigForUserGroupId id) {
		log.debug("getting TblCustomizedConfigForUserGroup instance with id: "
				+ id);
		try {
			TblCustomizedConfigForUserGroup instance = (TblCustomizedConfigForUserGroup) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.TblCustomizedConfigForUserGroup", id);
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

	public List findByExample(TblCustomizedConfigForUserGroup instance) {
		log.debug("finding TblCustomizedConfigForUserGroup instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria(
							"org.sgpro.db.TblCustomizedConfigForUserGroup")
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
