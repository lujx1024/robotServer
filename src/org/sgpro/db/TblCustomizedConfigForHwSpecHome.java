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
 * Home object for domain model class TblCustomizedConfigForHwSpec.
 * @see org.sgpro.db.TblCustomizedConfigForHwSpec
 * @author Hibernate Tools
 */
public class TblCustomizedConfigForHwSpecHome {

	private static final Log log = LogFactory
			.getLog(TblCustomizedConfigForHwSpecHome.class);

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

	public void persist(TblCustomizedConfigForHwSpec transientInstance) {
		log.debug("persisting TblCustomizedConfigForHwSpec instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(TblCustomizedConfigForHwSpec instance) {
		log.debug("attaching dirty TblCustomizedConfigForHwSpec instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(TblCustomizedConfigForHwSpec instance) {
		log.debug("attaching clean TblCustomizedConfigForHwSpec instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(TblCustomizedConfigForHwSpec persistentInstance) {
		log.debug("deleting TblCustomizedConfigForHwSpec instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public TblCustomizedConfigForHwSpec merge(
			TblCustomizedConfigForHwSpec detachedInstance) {
		log.debug("merging TblCustomizedConfigForHwSpec instance");
		try {
			TblCustomizedConfigForHwSpec result = (TblCustomizedConfigForHwSpec) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public TblCustomizedConfigForHwSpec findById(
			org.sgpro.db.TblCustomizedConfigForHwSpecId id) {
		log.debug("getting TblCustomizedConfigForHwSpec instance with id: "
				+ id);
		try {
			TblCustomizedConfigForHwSpec instance = (TblCustomizedConfigForHwSpec) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.TblCustomizedConfigForHwSpec", id);
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

	public List findByExample(TblCustomizedConfigForHwSpec instance) {
		log.debug("finding TblCustomizedConfigForHwSpec instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria("org.sgpro.db.TblCustomizedConfigForHwSpec")
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
