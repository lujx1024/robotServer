package org.sgpro.util;

import java.util.ArrayList;
import java.util.List;
import java.util.TreeSet;

import org.sgpro.util.SafeThread.SafeRunnable;

/**
 * 
 * @author yinshengge
 *
 * @param <ObjectType>
 */
public class RecycableObjectPool<ObjectType> {

	/**
	 * define finder .
	 * 
	 * eg pool.new Finder()
	 * @author yinshengge
	 *
	 */
	public  abstract class Finder {
		public abstract boolean isTarget(ObjectType object);
	}

	/**
	 * 
	 */

	private int lifeCycleTimeMillsec = 1000 * 2;
	private String name;
	private SafeThread recyleTask = null;
	
	private TreeSet<Recorder<ObjectType>> innerSet =
			new TreeSet<RecycableObjectPool.Recorder<ObjectType>>(new Comparator());
	
	class Comparator implements java.util.Comparator< Recorder<ObjectType>> {

		@Override
		public int compare(Recorder<ObjectType> lhs, Recorder<ObjectType> rhs) {
			// TODO Auto-generated method stub
			
			return lhs != null && rhs != null ?  -(int)(lhs.lastAccessTime - rhs.lastAccessTime) : 0;
		}
		
	}
	
	private static class Recorder<ObjectType> {
		protected ObjectType object;
		protected Long  lastAccessTime;
	}
	
	class RecycleTask extends SafeRunnable {

		
		@Override
		public void safeRun() throws Throwable {
			// TODO Auto-generated method stub
			while (true) {
				Thread.sleep(60 * 1000);
				synchronized (innerSet) {
					while (!innerSet.isEmpty() 
							&& System.currentTimeMillis() - innerSet.last().lastAccessTime > lifeCycleTimeMillsec) {
						innerSet.pollLast();
					} 
				}
			}
		}
	}
	
	public RecycableObjectPool(String name, int lifeCycleTimeMillsec) {
		// TODO Auto-generated constructor stub
		this.name = name;
		this.lifeCycleTimeMillsec = lifeCycleTimeMillsec;
		this.recyleTask = new SafeThread(new RecycleTask(), this.name);
		this.recyleTask.setPriority(Thread.MIN_PRIORITY);
		this.recyleTask.registerResurrection();
		this.recyleTask.start();
	}
	
	public void add(ObjectType obj) {
		boolean has = false;
		
		// since compare so set inner anti duplicate data by object compare can not 
		// be use here. by another way. object equals
		for (Recorder<ObjectType> rec : innerSet) {
			if (rec.object != null && rec.equals(obj)) {
				has = true;
				break;
			}
		}
		
		if (!has) {
			Recorder<ObjectType> newRecord = new Recorder<ObjectType>();
			newRecord.object = obj;
			updateAccessTime(newRecord);
			synchronized (innerSet) {
				innerSet.add(newRecord);
			}
		}
	}
	
	private void updateAccessTime(Recorder<ObjectType> rec) {
		if (rec != null) {
			rec.lastAccessTime = System.currentTimeMillis();
		}
	}
	
	public List<ObjectType> gets(Finder f) {
		List<ObjectType> ret = null;
		if (f != null) {
			ret = new ArrayList<ObjectType>();
			synchronized (innerSet) {
				for (Recorder<ObjectType> rec : innerSet) {
					if (f.isTarget(rec.object)) {
						updateAccessTime(rec);
						ret.add(rec.object);
						break;
					}
				}
			}
		}

		
		return ret;
	}
	
	public ObjectType get(Finder f) {
		return CollectionUtil.getFirstElemFromCollection(gets(f));
	}
	
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return  " Recycle pool: " + this.name + " size = " + innerSet.size();  
	}
}
