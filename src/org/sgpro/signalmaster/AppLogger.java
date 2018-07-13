package org.sgpro.signalmaster;

import org.sgpro.util.log.AbsLogOutput;
import org.sgpro.util.log.LogOutput.LOG_LEVEL;
import org.sgpro.util.log.LogOutputBase;

public class AppLogger {

	private static AbsLogOutput logger = null;
	
	static {
		logger = new LogOutputBase();
		logger.setLogOn(LOG_LEVEL.DEBUG, true);
		logger.setLogOn(LOG_LEVEL.ERROR, true);
		logger.setLogOn(LOG_LEVEL.INFOR, true);
		logger.setLogOn(LOG_LEVEL.WARN,  true);
	}
	
	public static AbsLogOutput getLogger() {
		return logger;
	}
}
