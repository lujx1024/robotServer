package org.sgpro.util;

import java.lang.reflect.Modifier;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class JSONUtil {


	private static Gson gson = null;
	
	static {
		
		gson = new GsonBuilder()
		.excludeFieldsWithModifiers(
				  Modifier.TRANSIENT
				, Modifier.STATIC)
		.setDateFormat("yyyy-MM-dd HH:mm:ss")		
				.create();
	}
	
	public static Gson getGson() {
		return gson;
	}
	

}
