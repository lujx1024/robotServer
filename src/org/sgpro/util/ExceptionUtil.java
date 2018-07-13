package org.sgpro.util;

import java.io.PrintWriter;
import java.io.StringWriter;
import java.lang.Thread.UncaughtExceptionHandler;
import java.sql.SQLException;

import org.apache.log4j.Logger;

import config.Log4jInit;

public class ExceptionUtil {

	static Logger logger = Logger.getLogger(ExceptionUtil.class.getName());
	public static String getExcetpionTrace(Throwable t) {
		String stackTrace = "";
		try {
			if (t != null) {
				StringWriter sw = new StringWriter();
				PrintWriter pw = new PrintWriter(sw);
				t.printStackTrace(pw);
				stackTrace = sw.toString();
			}
		} catch (Exception ex) {
			// 错误处理的错误， 简易处理之，以免发生死递归
			ex.printStackTrace();
		}
		return stackTrace;
	}
	
	public static String getCurrentStackString() {
		
		Exception ex = new Exception();
		try {
			
			StackTraceElement[] ste = ex.getStackTrace();
			StackTraceElement[] ignorFirstElem = new StackTraceElement[ste.length - 1];
			
			for (int i = 0; i < ignorFirstElem.length; i++) {
				ignorFirstElem[i] = ste[i+1];
			}
			ex.setStackTrace(ignorFirstElem);
		} catch (Throwable t) {
			// 错误处理的错误， 简易处理之，以免发生死递归
			t.printStackTrace();
		}
		
		return getExcetpionTrace(ex);
	}

	
	public static StackTraceElement getElement(Throwable t, int index) {
		StackTraceElement se = null;
				
		if (t != null && index >= 0 && index < t.getStackTrace().length ) {
			se = t.getStackTrace()[index];
		}
		
		return se;
	}
	
	public static String dumapStackTrace(StackTraceElement se) {
		return se == null? null : se.toString();
	}
	
	public static String currentMethodName() {
		return Thread.currentThread().getStackTrace()[3].getMethodName();
	}
	
	public static String classMethod() {
		String methodName = Thread.currentThread().getStackTrace()[3].getMethodName();
		String className = Thread.currentThread().getStackTrace()[3].getClassName();
		return String.format("%s.%s", className, methodName);
	}
	
	public static void registerExceptionHandler() {
		registerExceptionHandler(null);
	}
	public static void registerExceptionHandler(UncaughtExceptionHandler handler) {
		UncaughtExceptionHandler h = null;
		
		if (handler == null) {
			h = new UncaughtExceptionHandler() {
				
				@Override
				public void uncaughtException(Thread thread, Throwable ex) {
					// TODO Auto-a("uncaught exception occured." + thread.toString());
					logger.error(ex.getMessage());
				}
			};
		} else {
			h = handler;
		}
		Thread.currentThread().setUncaughtExceptionHandler(h);
	}

	public static <T extends Throwable>  T getRoot(Throwable t, Class<T> cls) {
		// TODO Auto-generated method stub
		T ret = null;
		if (cls != null && t != null) {
			do {
				if (cls.isInstance(t)) {
					ret = (T)t;
					break;
				} 
			}while (!t.equals(t.getCause()) && (t = t.getCause()) != null);
		}
		
		return ret;
	}
}
