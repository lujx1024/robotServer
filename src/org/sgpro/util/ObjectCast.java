package org.sgpro.util;

import java.lang.reflect.Field;
import java.lang.reflect.Type;
import java.math.BigDecimal;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Collection;


	/**
	 * 对象转换工具
	 * @author yinshengge
	 *
	 */
	public class ObjectCast {

		public static void updateObject(Object ori , Object upd, Class<?> t) throws Exception {
			if (ori != null && upd != null && t != null) {
				// Class<?> c = ori.getClass();
				
				Field[] fs = t.getDeclaredFields();
				
				if (fs == null || fs.length == 0) {
					fs = t.getSuperclass().getDeclaredFields();
				}
				
				if (fs != null) {
					for (Field f : fs) {					
						if (f != null) {
							f.setAccessible(true);
							
							if ( f.get(upd) != null) {
								f.set(ori, f.get(upd));
							}
						}
					}
					
				}
			}
		}
		
		public static Long castNumberToLong(Object o) {
			Long ret = 0L;
			
			if (  o instanceof Long ) {
				ret = (Long)o;
			} else if (  o instanceof Integer ) {
				ret = ((Integer) o).longValue();
			} else if (  o instanceof Short ) {
				ret = ((Short) o).longValue();
			} else  if (  o instanceof BigInteger ) {
				ret = ((BigInteger) o).longValue();
			} else  if (  o instanceof BigDecimal ) {
				ret = ((BigDecimal) o).longValue();
			}  else if (  o instanceof Double ) {
				ret = ((Double) o).longValue();
			} else if (  o instanceof Float ) {
				ret = ((Float) o).longValue();
			} 
			
			return ret;
		}
		@SuppressWarnings("deprecation")
		public static <T> T castStringToObject(Class<T> type, String strValue, Object fmt) {
			Object value = null;
			
			if (type != null && StringUtil.isNotNullAndEmpy(strValue)) {
				 if (type.equals(Integer.class) || type.equals(int.class)) {
					 value = Integer.parseInt(strValue);
				 } else if (type.equals(Long.class) || type.equals(long.class)) {
					 value = Long.parseLong(strValue);
				 } else if (type.equals(Boolean.class) || type.equals(boolean.class)) {
					 value = Boolean.parseBoolean(strValue);
				 } else if (type.equals(Float.class) || type.equals(float.class)) {
					 value = Float.parseFloat(strValue);
				 } else if (type.equals(Double.class) || type.equals(double.class)) {
					 value = Double.parseDouble(strValue);
				 } else if (type.equals(Byte.class) || type.equals(byte.class)) {
					 value = Byte.parseByte(strValue);
				 } else if (type.equals(Short.class) || type.equals(short.class)) {
					 value = Short.parseShort(strValue);
				 } else if (type.equals(Character.class) || type.equals(char.class)) {
					 value = strValue.charAt(0);
				 }	else if (type.equals(java.sql.Date.class)) {
					 value = java.sql.Date.parse(strValue);
				 }	else if (type.equals(java.util.Date.class)) {
					  SimpleDateFormat formatter = (SimpleDateFormat)fmt;
					  if (formatter != null) {
						  try {value = formatter.parse(strValue);} catch(Throwable t){};
					  }

				 }	else if (type.equals(Timestamp.class)) {
					 value = Timestamp.parse(strValue);
				 }	else {
					 value = strValue;
				 }
			}
			return  type.cast(value);
		}
		
		public static boolean isCollection(Class<?> type) {
			boolean ret = false;
			
			if (type != null && !Object.class.equals(type)) {
				if (type.equals(Collection.class)) {
					ret = true;
				} else if (type.getSuperclass() != null) {
					ret = isCollection(type.getSuperclass());
				} else if (type.getGenericSuperclass() != null) {
					ret = isCollection(type.getGenericSuperclass().getClass());
				} else if (type.getGenericInterfaces() != null) {
					Type[] ts = type.getGenericInterfaces();
					 
					for (Type t : ts) {
						if (t != null) {
							ret = isCollection(t.getClass());
							if (ret) {
								break;
							}
						}
					}
				}
			}
			
			return ret;
		}
	}

