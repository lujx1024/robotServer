package org.sgpro.util;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;

public class CollectionUtil {

	public static boolean isCollectionEmpty(Collection<?> c) {
		return c == null || c.size() == 0;
	}
	
	public static <T> T getFirstElemFromCollection(Collection<T> c) {
		T ret = null;
		if (!isCollectionEmpty(c)) {
			if (c instanceof List) {
				ret  = ((List<T>) c).get(0);
			} else {
				Iterator<T> it = c.iterator();
				if (it.hasNext()) {
					ret =it.next();
				}
			}
		}
		return ret;
	}
	
	public static <T>  List<T> enumeration(Enumeration<T> enumEr) {
		List<T> ret = null;
		if (enumEr != null) {
			ret = new ArrayList<T>();
			while (enumEr.hasMoreElements()) {
				ret.add(enumEr.nextElement());
			}
		}
		return ret;
	}
	
	public static <T> List<T> asList(T[] arg) {
		
		List<T> t = null;
		
		if (arg != null) {
			t = new ArrayList<T>();
			
			for (T o : arg) {
				t.add(o);
			}
		}
		return t;
	}
}


