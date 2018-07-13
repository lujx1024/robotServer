package org.sgpro.util.log;

import java.util.HashSet;
import java.util.Set;

import org.apache.log4j.Logger;
import org.sgpro.util.ExceptionUtil;

import config.Log4jInit;

public abstract class AbsLogOutput implements LogOutput {
	static Logger logger = Logger.getLogger(AbsLogOutput.class.getName());
	public AbsLogOutput() {
		// TODO Auto-generated constructor stub
	}
	
	public abstract void customLog(String tag, String position, String message, Throwable t) ;

	private long bitset = 
			  LOG_LEVEL.ERROR.level() 
			| LOG_LEVEL.DEBUG.level() 
			| LOG_LEVEL.INFOR.level()
			| LOG_LEVEL.WARN.level();
	
	/**
	 * 不输出 commonLog 自己产生的log，否则陷入死递归
	 */
	public void commonLog(String levelName, StringBuilder sender, int position, Throwable t, String format, Object...args) {
		
		
		try {
			
			String stackTrace = ExceptionUtil.getExcetpionTrace(t);
			String strPosition = ExceptionUtil.dumapStackTrace(Thread.currentThread().getStackTrace()[position]);
			String tag = sender == null? strPosition : sender.toString();
			
			String DONT_SAVE_OWNER_LOG = this.getClass().getName() + "." + "commonLog";
			if (stackTrace != null && stackTrace.contains(DONT_SAVE_OWNER_LOG)) {
				throw new Exception("Dead recusive....");
			}
			
			String message = String.format(format, args);
			message = String.format("(%s) %s", Thread.currentThread().getName(), message) ;
			
			
			if (isLogOn(LOG_LEVEL.parse(levelName))) {
				systemLog(levelName, tag, message, t);
				customLog(tag, strPosition, message, t);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			// System.err.println("AbsWOTPLogOutput", "Fata error", e);
			logger.error(e.getMessage());
		}
	}

	protected abstract void systemLog(String levelName, String tag, String message, Throwable t) ;	
	

	// with postion and sender.
	public void err(StringBuilder sender, int position, String format, Object...args) {
		commonLog("e", sender, position, null, format, args);
	}
	
	public void err(StringBuilder sender, int position, Throwable t, String format, Object...args) {
		commonLog("e", sender, position, t, format, args);
	}
	
	public void debug(StringBuilder sender, int position, String format, Object...args) {
		commonLog("d", sender, position, null, format, args);
	}
	
	public void warn(StringBuilder sender, int position, String format, Object...args) {
		commonLog("w", sender, position, null, format, args);
	}
	
	public void info(StringBuilder sender, int position, String format, Object...args) {
		commonLog("i", sender, position, null, format, args);
	}
	

	// with sender no position
	// use default position.
	public void err(StringBuilder sender, String format, Object...args) {
		err(sender, 5, format, args);
	}
	
	public void err(StringBuilder sender, Throwable t, String format, Object...args) {
		err(sender, 5, t, format, args);
	}
	
	public void debug(StringBuilder sender, String format, Object...args) {
		debug(sender, 5, format, args);
	}
	
	public void warn(StringBuilder sender, String format, Object...args) {
		warn(sender, 5, format, args);
	}
	
	public void info(StringBuilder sender, String format, Object...args) {
		info(sender, 5, format, args);
	}
	
	// no sender with position
	// use default sender.
	public void err(int position, String format, Object...args) {
		err(senderName, position, format, args);
	}
	
	public void err(int position, Throwable t, String format, Object...args) {
		err(senderName, position, t, format, args);
	}
	
	public void debug(int position, String format, Object...args) {
		debug(senderName, position, format, args);
	}
	
	public void warn(int position, String format, Object...args) {
		warn(senderName, position, format, args);
	}
	
	public void info(int position, String format, Object...args) {
		info(senderName, position, format, args);
	}
	
	
	// no sender no position.
	// default position.
	// default sender.
	public void err(String format, Object...args) {
		err(senderName, 5, format, args);
	}
	
	public void err(Throwable t, String format, Object...args) {
		err(senderName, 5, t, format, args);
	}
	
	public void debug(String format, Object...args) {
		debug(senderName, 5, format, args);
	}
	
	public void warn(String format, Object...args) {
		warn(senderName, 5, format, args);
	}
	
	public void info(String format, Object...args) {
		info(senderName, 5, format, args);
	}

	@Override
	public void setLogOn(LOG_LEVEL level, boolean value) {
		// TODO Auto-generated method stub
		if (level != null) {
			bitset = value? (bitset | level.level()) : (bitset & ~level.level());
		}
	}

	@Override
	public boolean isLogOn(LOG_LEVEL level) {
		// TODO Auto-generated method stub
		return level == null? false : (bitset & level.level()) != 0;  
	}

	@Override
	public Set<LOG_LEVEL> logOnSet() {
		// TODO Auto-generated method stub
		 Set<LOG_LEVEL> ret = new HashSet<LogOutput.LOG_LEVEL>();
		 for (LOG_LEVEL l : LOG_LEVEL.values()) {
			 if (isLogOn(l)) {
				 ret.add(l);
			 }
		 }
		return ret;
	}

	private StringBuilder senderName  = null;
	
	// 
	@Override
	public void setDefaultSenderName(StringBuilder senderName) {
		// TODO Auto-generated method stub
		this.senderName   = senderName;
	}
}
