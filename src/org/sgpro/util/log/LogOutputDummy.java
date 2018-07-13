package org.sgpro.util.log;


public class LogOutputDummy extends LogOutputBase {

	public LogOutputDummy() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Override
	public void commonLog(String levelName, StringBuilder sender, int position,
			Throwable t, String format, Object... args) {
		// TODO Auto-generated method stub
		// do nothing.
	}
	
	@Override
	public void customLog(String tag, String position, String message,
			Throwable t) {
		// TODO Auto-generated method stub

	}
	
	@Override
	protected void systemLog(String levelName, String tag, String message,
			Throwable t) {
		// TODO Auto-generated method stub
	}

}
