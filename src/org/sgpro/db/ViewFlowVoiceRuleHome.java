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
 * Home object for domain model class ViewFlowVoiceRule.
 * @see org.sgpro.db.ViewFlowVoiceRule
 * @author Hibernate Tools
 */
public class ViewFlowVoiceRuleHome {

	private static final Log log = LogFactory
			.getLog(ViewFlowVoiceRuleHome.class);

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

	public void persist(ViewFlowVoiceRule transientInstance) {
		log.debug("persisting ViewFlowVoiceRule instance");
		try {
			sessionFactory.getCurrentSession().persist(transientInstance);
			log.debug("persist successful");
		} catch (RuntimeException re) {
			log.error("persist failed", re);
			throw re;
		}
	}

	public void attachDirty(ViewFlowVoiceRule instance) {
		log.debug("attaching dirty ViewFlowVoiceRule instance");
		try {
			sessionFactory.getCurrentSession().saveOrUpdate(instance);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void attachClean(ViewFlowVoiceRule instance) {
		log.debug("attaching clean ViewFlowVoiceRule instance");
		try {
			sessionFactory.getCurrentSession().lock(instance, LockMode.NONE);
			log.debug("attach successful");
		} catch (RuntimeException re) {
			log.error("attach failed", re);
			throw re;
		}
	}

	public void delete(ViewFlowVoiceRule persistentInstance) {
		log.debug("deleting ViewFlowVoiceRule instance");
		try {
			sessionFactory.getCurrentSession().delete(persistentInstance);
			log.debug("delete successful");
		} catch (RuntimeException re) {
			log.error("delete failed", re);
			throw re;
		}
	}

	public ViewFlowVoiceRule merge(ViewFlowVoiceRule detachedInstance) {
		log.debug("merging ViewFlowVoiceRule instance");
		try {
			ViewFlowVoiceRule result = (ViewFlowVoiceRule) sessionFactory
					.getCurrentSession().merge(detachedInstance);
			log.debug("merge successful");
			return result;
		} catch (RuntimeException re) {
			log.error("merge failed", re);
			throw re;
		}
	}

	public ViewFlowVoiceRule findById(org.sgpro.db.ViewFlowVoiceRuleId id) {
		log.debug("getting ViewFlowVoiceRule instance with id: " + id);
		try {
			ViewFlowVoiceRule instance = (ViewFlowVoiceRule) sessionFactory
					.getCurrentSession().get("org.sgpro.db.ViewFlowVoiceRule",
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

	public List findByExample(ViewFlowVoiceRule instance) {
		log.debug("finding ViewFlowVoiceRule instance by example");
		try {
			List results = sessionFactory.getCurrentSession()
					.createCriteria("org.sgpro.db.ViewFlowVoiceRule")
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
