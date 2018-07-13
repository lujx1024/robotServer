package com.iflytek.util;
import java.text.SimpleDateFormat;

import org.apache.log4j.Logger;
import org.sgpro.signalmaster.Remote;

public class DebugLog {
	static Logger logger = Logger.getLogger(DebugLog.class.getName());
	private static SimpleDateFormat sDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss SSS"); 
	
	public static void Log(String tag,String log)
	{
		if(true)
		    logger.info(log);
	}
	
	public static void Log(String log)
	{
		String date=sDateFormat.format(new java.util.Date());
		if(true){
		    logger.info("<" + date + ">" + log);
		}
	}
}
