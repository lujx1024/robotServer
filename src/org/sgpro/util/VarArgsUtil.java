package org.sgpro.util;

public class VarArgsUtil {


	public static boolean verifyArgCouns(int len, Object...objects) {
		return objects != null && objects.length >= len;
	}

	public static <T> T getArgument(int index, Class<T> clazz,  Object...objects) {
		T ret = null;
		
		if (objects != null 
				&& index < objects.length 
				&& clazz != null 
				&& clazz.isInstance(objects[index])) {
			ret =  clazz.cast(objects[index]);
		}
		return ret;
	}
	
	public static Class<?>[] getArgumentTypes(Object...objects) {

		Class<?>[] arrCls = null;
		int argCounts = objects == null? 0 : objects.length;
		
		if (argCounts > 0) {
			arrCls = new Class<?>[argCounts];
			
			for (int i = 0; i < argCounts; i++) {
				arrCls[i] = objects[i].getClass();
			}
		}
		
		return arrCls;
	}

	public static String dumpVarArgs(Object[] objects) {
		// TODO Auto-generated method stub
		String ret = null;
		
		if (objects != null) {
			StringBuffer fmtStr = new StringBuffer();
			
			for (int i = 0; i < objects.length; i++) {
				fmtStr.append("%s ");
			}
			ret = String.format(fmtStr.toString(), objects);
		}
		return ret;
	}
}
