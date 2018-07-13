package org.sgpro.util.log;

import java.lang.reflect.Method;

import org.apache.log4j.Logger;

import sun.rmi.runtime.Log;

public class LogOutputBase extends AbsLogOutput {

	static Logger logger = Logger.getLogger(LogOutputBase.class.getName());
	public LogOutputBase( ) {
	}

	@Override
	public void customLog(String tag, String logPosition, String message, Throwable t) {
		// TODO Auto-generated method stub
		logger.info(message);
		if (t != null) {
			logger.error(t.getMessage());
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		}
	}

	@Override
	protected void systemLog(String levelName, String tag, String message, Throwable t) {
		// TODO Auto-generated method stub
		try {
			Method m = Log.class.getMethod(levelName, String.class, String.class, Throwable.class);
			m.invoke(Log.class, tag, message, t);
		} catch (Throwable ex) {
			throw new RuntimeException(ex);
		}
	} 

}
