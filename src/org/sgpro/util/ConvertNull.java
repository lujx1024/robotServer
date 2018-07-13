package org.sgpro.util;

public class ConvertNull {

	public static Object isNull(Object o, Object conv) {
		if (o == null) {
			return conv;
		} else {
			return o;
		}
	}

	public static Object isNullToEmpty(Object o) {
		return isNull(o, "");
	}
}
