package org.sgpro.signalmaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;

import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.sgpro.db.HibSf;

/**
 * @author philo
 *
 */
public class ViewUtils {
	
	/**
	 * 
	 * @param t
	 * @return
	 * @throws Throwable
	 */
	public static List<Object> getViewDataList(List t) throws Throwable  {
		List<Object> ret = null ;
		if (t != null && t.size() > 0) {
			ret = new ArrayList<>();
			for (Object v : t) {
				if (v != null) {
					Object item = v.getClass().getMethod("getId").invoke(v);
					
					if (item != null) {
						ret.add(item);
					}
				}
			}
		}
		return ret;
	}
	
	/**
	 * 
	 * @param t
	 * @return
	 * @throws Throwable
	 */
	public static  <T>  T getViewDataFirstIndex(List<T> t) throws Throwable {
		T ret = null ;
		if (t != null && t.size() > 0) {
			ret = t.get(0);
		}
		return ret;
	}
	
	/**
	 * 
	 * @param t
	 * @return
	 * @throws Throwable
	 */
	public static  Object getViewData(List t) throws Throwable {
		Object ret = null ;
		if (t != null && t.size() > 0) {
			Object v = t.get(0);
			if (v != null) {
				ret = v.getClass().getMethod("getId").invoke(v);
			}
		}
		return ret;
	}
	
	public enum DBMethod {
		SELECT,
		CALL
	}
	
	/**
	 * @param func
	 * @param objects
	 * @return
	 */
	public static Object dbFunc(String func, Object...objects) {
		// TODO Auto-generated method stub
		Session s = HibSf.getSession();
		StringBuffer sb = new StringBuffer();
		
		for (Object o : objects) {
			if (sb.length() > 0) {
				sb.append(",");
			}
			sb.append("?");
		}
		
		SQLQuery q1 = s.createSQLQuery(
				String.format("SELECT %s (%s)", func, sb.toString()));
		int index = 0;
		
		for (Object o : objects) {
			q1.setParameter(index++, o);
		}
		
		List l = q1.list();
		
		return  l == null || l.size() == 0? null : l.get(0);
		
	}
	
	public static Object dbFunc1(String func, Object...objects) {
		// TODO Auto-generated method stub
		Session s = HibSf.getSession();
		
		SQLQuery q1 = s.createSQLQuery(
				String.format("%s", func ));
		int index = 0;
		
		for (Object o : objects) {
			q1.setParameter(index++, o);
		}
		
		List l = q1.list();
		
		return  l == null || l.size() == 0? null : l.get(0);
		
	}
	
	/**
	 * @param proc
	 * @param objects
	 * @return
	 */
	public static int dbProc(String proc, Object...objects) {
		// TODO Auto-generated method stub
		Session s = org.sgpro.db.HibSf.getSession();
		
		StringBuffer sb = new StringBuffer();
		
		for (Object o : objects) {
			if (sb.length() > 0) {
				sb.append(",");
			}
			sb.append("?");
		}
		
		SQLQuery q1 = s.createSQLQuery(
				String.format("exec %s %s", proc, sb.toString()));
		int index = 0;
		
		for (Object o : objects) {
			q1.setParameter(index++, o);
		}
		return 
				q1.executeUpdate();
	}
	
	
	/**
	 * ADD by LvDW  可以使用sql语句
	 * */
	public static int dbSql(String proc,Object...objects) {
		// TODO Auto-generated method stub
		Session s = org.sgpro.db.HibSf.getSession();
		
		SQLQuery q1 = s.createSQLQuery(
				String.format("%s", proc));
		int index = 0;
		
		for (Object o : objects) {
			q1.setParameter(index++, o);
		}
		return 
				q1.executeUpdate();
	}

	public static class ProcParam {
		public Object i;
		public Object o;
		public boolean out;
		int    type;
		
		public ProcParam(Object i, Object o, boolean out, int outType) {
			super();
			this.i = i;
			this.o = o;
			this.out = out;
			this.type = outType;
		}
		
		public static ProcParam genOutputParam(Object input, int outType) {
			return new ProcParam(input, null, true, outType);
		}
		public static ProcParam genParam(Object input) {
			return new ProcParam(input, null, false, 0);
		}
	}
	/**
	 * @param proc
	 * @param objects
	 * @return
	 */
	public static boolean dbProcWithOutput(String proc
			, ProcParam...parms
			) {
		// TODO Auto-generated method stub
		boolean ret = false;
		try {
			Connection c = HibSf.getConnection();
			
			StringBuffer sb = new StringBuffer();
			
			for (ProcParam o : parms) {
				if (sb.length() > 0) {
					sb.append(",");
				}
				sb.append("?");
			}
			
			CallableStatement call =
					c.prepareCall(
					String.format("exec %s %s", proc, sb.toString()));
			
			ProcParam o = null;
			for (int index = 1; index <= parms.length; index++) {
				o = parms[index-1];
				
				call.setObject(index, o.i);
				
				if (o.out) {
					call.registerOutParameter(index,  o.type);
				}
			}
			ret = call.execute();
			
			for (int index = 1; index <= parms.length; index++) {
				o = parms[index-1];
				if (o.out) {
					o.o = call.getObject(index);
				}
			}
		} catch (Throwable t) {
			throw new RuntimeException(t);
		}
		
		return ret;
	}
	
	/**
	 * @param proc
	 * @param objects
	 * @return
	 */
	public static int sqlNonQuery(String query, Object...objects) {
		// TODO Auto-generated method stub
		Session s = org.sgpro.db.HibSf.getSession();
		
				
		SQLQuery q1 = s.createSQLQuery(query);
		int index = 0;
		
		for (Object o : objects) {
			q1.setParameter(index++, o);
		}
		
		return 
				q1.executeUpdate();
	}
	
	/**
	 * @param proc
	 * @param objects
	 * @return
	 */
	public static <T> List<T> sqlQuery(String query, Class<T> retClass, Object...objects) {
		// TODO Auto-generated method stub
		Session s = org.sgpro.db.HibSf.getSession();
		
				
		SQLQuery q1 = s.createSQLQuery(query).addEntity(retClass);
		int index = 0;
		
		for (Object o : objects) {
			q1.setParameter(index++, o);
		}
		return 
				q1.list();
	}
	
	/**
	 * @param proc
	 * @param objects
	 * @return
	 */
	public static <T> List<T>  dbProcQuery(Class<T> entityClass, String proc, Object...objects) {
		// TODO Auto-generated method stub
		Session s = org.sgpro.db.HibSf.getSession();
		
		StringBuffer sb = new StringBuffer();
		
		for (Object o : objects) {
			if (sb.length() > 0) {
				sb.append(",");
			}
			sb.append("?");
		}
		
		SQLQuery q1 = s.createSQLQuery(
				String.format("exec %s %s", proc, sb.toString()));
		int index = 0;
		
		for (Object o : objects) {
			q1.setParameter(index++, o);
		}
		q1.addEntity(entityClass);
		return q1.list();
	}
	
	public static <T> List<T>  dbProcQuery1(Class<T> entityClass, String proc) {
		// TODO Auto-generated method stub
		Session s = org.sgpro.db.HibSf.getSession();
		
		StringBuffer sb = new StringBuffer();
		
		
		SQLQuery q1 = s.createSQLQuery(
				String.format("%s", proc));
		
		q1.addEntity(entityClass);
		return q1.list();
	}
	
	/**
	 * @return
	 */
	public static int firstResult(Integer pageCount, Integer pageNo) {

		pageCount = pageCount(pageCount);
		return  pageNo == null || pageCount == null
				|| pageNo <= 0 ? 0 : (pageNo - 1) * pageCount;
	}
	
	/**
	 * @return
	 */
	public static int pageCount(Integer pageCount) {
		return (pageCount == null) ?
			10 : pageCount ;
		
		
	}
	
}
