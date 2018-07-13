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
 * Home object for domain model class TblWordGroupFlowToVoiceGroupRule.
 * @see org.sgpro.db.TblWordGroupFlowToVoiceGroupRule
 * @author Hibernate Tools
 */
public class TblWordGroupFlowToVoiceGroupRuleHome {

	private static final Log log = LogFactory
			.getLog(TblWordGroupFlowToVoiceGroupRuleHome.class);

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

	public void persist(TblWordGroupFlowToVoiceGroupRule transientInstance) {
		log.debug("persisting TblWordGroupFlowToVoiceGroupRule instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(TblWordGroupFlowToVoiceGroupRule instance) {
		log.debug("attaching dirty TblWordGroupFlowToVoiceGroupRule instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(TblWordGroupFlowToVoiceGroupRule instance) {
		log.debug("attaching clean TblWordGroupFlowToVoiceGroupRule instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(TblWordGroupFlowToVoiceGroupRule persistentInstance) {
		log.debug("deleting TblWordGroupFlowToVoiceGroupRule instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public TblWordGroupFlowToVoiceGroupRule merge(
			TblWordGroupFlowToVoiceGroupRule detachedInstance) {
		log.debug("merging TblWordGroupFlowToVoiceGroupRule instance");
		try {
			TblWordGroupFlowToVoiceGroupRule result = (TblWordGroupFlowToVoiceGroupRule) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public TblWordGroupFlowToVoiceGroupRule findById(
			org.sgpro.db.TblWordGroupFlowToVoiceGroupRuleId id) {
		log.debug("getting TblWordGroupFlowToVoiceGroupRule instance with id: "
				+ id);
		try {
			TblWordGroupFlowToVoiceGroupRule instance = (TblWordGroupFlowToVoiceGroupRule) sessionFactory
					.getCurrentSession()
					.get("org.sgpro.db.TblWordGroupFlowToVoiceGroupRule", id);
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

	public List findByExample(TblWordGroupFlowToVoiceGroupRule instance) {
		log.debug("finding TblWordGroupFlowToVoiceGroupRule instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria(
							"org.sgpro.db.TblWordGroupFlowToVoiceGroupRule")
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
