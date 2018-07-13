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
 * Home object for domain model class EntHuaqin2016ProviderConfrenceCompany.
 * @see org.sgpro.db.EntHuaqin2016ProviderConfrenceCompany
 * @author Hibernate Tools
 */
public class EntHuaqin2016ProviderConfrenceCompanyHome {

	private static final Log log = LogFactory
			.getLog(EntHuaqin2016ProviderConfrenceCompanyHome.class);

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

	public void persist(EntHuaqin2016ProviderConfrenceCompany transientInstance) {
		log.debug("persisting EntHuaqin2016ProviderConfrenceCompany instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(EntHuaqin2016ProviderConfrenceCompany instance) {
		log.debug("attaching dirty EntHuaqin2016ProviderConfrenceCompany instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(EntHuaqin2016ProviderConfrenceCompany instance) {
		log.debug("attaching clean EntHuaqin2016ProviderConfrenceCompany instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(EntHuaqin2016ProviderConfrenceCompany persistentInstance) {
		log.debug("deleting EntHuaqin2016ProviderConfrenceCompany instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public EntHuaqin2016ProviderConfrenceCompany merge(
			EntHuaqin2016ProviderConfrenceCompany detachedInstance) {
		log.debug("merging EntHuaqin2016ProviderConfrenceCompany instance");
		try {
			EntHuaqin2016ProviderConfrenceCompany result = (EntHuaqin2016ProviderConfrenceCompany) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public EntHuaqin2016ProviderConfrenceCompany findById(long id) {
		log.debug("getting EntHuaqin2016ProviderConfrenceCompany instance with id: "
				+ id);
		try {
			EntHuaqin2016ProviderConfrenceCompany instance = (EntHuaqin2016ProviderConfrenceCompany) sessionFactory
					.getCurrentSession()
					.get("org.sgpro.db.EntHuaqin2016ProviderConfrenceCompany",
							id);
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

	public List findByExample(EntHuaqin2016ProviderConfrenceCompany instance) {
		log.debug("finding EntHuaqin2016ProviderConfrenceCompany instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria(
							"org.sgpro.db.EntHuaqin2016ProviderConfrenceCompany")
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
