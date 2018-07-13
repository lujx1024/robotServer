package org.sgpro.util.log;

import java.util.Set;

public interface LogOutput {

	public enum LOG_LEVEL {

		  DEBUG("d", 0x1 << bitsetOrder())
		, ERROR("e", 0x1 << bitsetOrder())
		, INFOR("i", 0x1 << bitsetOrder())
		, WARN("w", 0x1 << bitsetOrder());

		private static int bitsetOrderPnt = 0;

		private static int bitsetOrder() {
			return bitsetOrderPnt++;
		}

		public static LOG_LEVEL parse(String levelName) {
			LOG_LEVEL ret = null;

			if (LOG_LEVEL.values() != null && levelName != null) {
				for (LOG_LEVEL l : LOG_LEVEL.values()) {
					if (l != null && levelName.equals(l.levelName())) {
						ret = l;
						break;
					}
				}
			}

			return ret;
		}

		private int bitmarsk = 0;
		private String levelName;

		private LOG_LEVEL(String levelName, int bitmark) {
			this.bitmarsk = bitmark;
			this.levelName = levelName;
		}

		public int level() {
			return bitmarsk;
		}

		public String levelName() {
			return levelName;
		}
		
		@Override
		public String toString() {
			// TODO Auto-generated method stub
			return levelName;
		}
	};

	public void commonLog(String levelName, StringBuilder sender, int position, Throwable t, String format, Object...args);

	public void debug(String format, Object... args);

	public void err(String format, Object... args);

	public void err(Throwable t, String format, Object... args);

	public void info(String format, Object... args);
	

	public void debug(int position, String format, Object... args);

	public void err(int position, String format, Object... args);

	public void err(int position, Throwable t, String format, Object... args);

	public void info(int position, String format, Object... args);
	
	
	public void debug(StringBuilder sender, String format, Object... args);

	public void err(StringBuilder sender, String format, Object... args);

	public void err(StringBuilder sender, Throwable t, String format, Object... args);

	public void info(StringBuilder sender, String format, Object... args);
	
	
	public void debug(StringBuilder sender, int position, String format, Object... args);

	public void err(StringBuilder sender,int position,  String format, Object... args);

	public void err(StringBuilder sender, int position, Throwable t, String format, Object... args);

	public void info(StringBuilder sender, int position, String format, Object... args);

	
	public boolean isLogOn(LOG_LEVEL level);

	public Set<LOG_LEVEL> logOnSet();

	public void setLogOn(LOG_LEVEL level, boolean value);

	public void warn(String format, Object... args);
	
	// if sender name not set. use  stack trace 
	public void setDefaultSenderName(StringBuilder senderName);
}
