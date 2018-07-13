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
 * Home object for domain model class ViewWordGroupFlowToVoiceGroupRuleOrignal.
 * @see org.sgpro.db.ViewWordGroupFlowToVoiceGroupRuleOrignal
 * @author Hibernate Tools
 */
public class ViewWordGroupFlowToVoiceGroupRuleOrignalHome {

	private static final Log log = LogFactory
			.getLog(ViewWordGroupFlowToVoiceGroupRuleOrignalHome.class);

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

	public void persist(
			ViewWordGroupFlowToVoiceGroupRuleOrignal transientInstance) {
		log.debug("persisting ViewWordGroupFlowToVoiceGroupRuleOrignal instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewWordGroupFlowToVoiceGroupRuleOrignal instance) {
		log.debug("attaching dirty ViewWordGroupFlowToVoiceGroupRuleOrignal instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewWordGroupFlowToVoiceGroupRuleOrignal instance) {
		log.debug("attaching clean ViewWordGroupFlowToVoiceGroupRuleOrignal instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(
			ViewWordGroupFlowToVoiceGroupRuleOrignal persistentInstance) {
		log.debug("deleting ViewWordGroupFlowToVoiceGroupRuleOrignal instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewWordGroupFlowToVoiceGroupRuleOrignal merge(
			ViewWordGroupFlowToVoiceGroupRuleOrignal detachedInstance) {
		log.debug("merging ViewWordGroupFlowToVoiceGroupRuleOrignal instance");
		try {
			ViewWordGroupFlowToVoiceGroupRuleOrignal result = (ViewWordGroupFlowToVoiceGroupRuleOrignal) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewWordGroupFlowToVoiceGroupRuleOrignal findById(
			org.sgpro.db.ViewWordGroupFlowToVoiceGroupRuleOrignalId id) {
		log.debug("getting ViewWordGroupFlowToVoiceGroupRuleOrignal instance with id: "
				+ id);
		try {
			ViewWordGroupFlowToVoiceGroupRuleOrignal instance = (ViewWordGroupFlowToVoiceGroupRuleOrignal) sessionFactory
					.getCurrentSession()
					.get("org.sgpro.db.ViewWordGroupFlowToVoiceGroupRuleOrignal",
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

	public List findByExample(ViewWordGroupFlowToVoiceGroupRuleOrignal instance) {
		log.debug("finding ViewWordGroupFlowToVoiceGroupRuleOrignal instance by example");
		try {
			List results = sessionFactory
					.getCurrentSession()
					.createCriteria(
							"org.sgpro.db.ViewWordGroupFlowToVoiceGroupRuleOrignal")
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
