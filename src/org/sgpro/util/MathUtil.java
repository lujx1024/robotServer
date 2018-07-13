package org.sgpro.util;

import java.util.Random;

public class MathUtil {

	static Random rd = new Random()
	;
	
	public static long Rand() {
		return rd.nextLong();
	}
	
	public static long Rand(long limit) {
		if (limit > 0) {
			return rd.nextLong() % limit;
		} else {
			throw new IllegalArgumentException("错误参数");
		}
	}
}
