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
 * Home object for domain model class ViewHuaqin2016ProivderConfrence.
 * @see org.sgpro.db.ViewHuaqin2016ProivderConfrence
 * @author Hibernate Tools
 */
public class ViewHuaqin2016ProivderConfrenceHome {

	private static final Log log = LogFactory
			.getLog(ViewHuaqin2016ProivderConfrenceHome.class);

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

	public void persist(ViewHuaqin2016ProivderConfrence transientInstance) {
		log.debug("persisting ViewHuaqin2016ProivderConfrence instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewHuaqin2016ProivderConfrence instance) {
		log.debug("attaching dirty ViewHuaqin2016ProivderConfrence instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewHuaqin2016ProivderConfrence instance) {
		log.debug("attaching clean ViewHuaqin2016ProivderConfrence instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewHuaqin2016ProivderConfrence persistentInstance) {
		log.debug("deleting ViewHuaqin2016ProivderConfrence instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewHuaqin2016ProivderConfrence merge(
			ViewHuaqin2016ProivderConfrence detachedInstance) {
		log.debug("merging ViewHuaqin2016ProivderConfrence instance");
		try {
			ViewHuaqin2016ProivderConfrence result = (ViewHuaqin2016ProivderConfrence) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewHuaqin2016ProivderConfrence findById(
			org.sgpro.db.ViewHuaqin2016ProivderConfrenceId id) {
		log.debug("getting ViewHuaqin2016ProivderConfrence instance with id: "
				+ id);
		try {
			ViewHuaqin2016ProivderConfrence instance = (ViewHuaqin2016ProivderConfrence) sessionFactory
					.getCurrentSession().get(
							"org.sgpro.db.ViewHuaqin2016ProivderConfrence", id);
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

	public List findByExample(ViewHuaqin2016ProivderConfrence instance) {
		log.debug("finding ViewHuaqin2016ProivderConfrence instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria(
							"org.sgpro.db.ViewHuaqin2016ProivderConfrence")
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
