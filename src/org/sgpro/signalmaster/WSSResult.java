package org.sgpro.signalmaster;

public class WSSResult extends Result {

	public WSSResult() {
		super();
		// TODO Auto-generated constructor stub
	}
	public WSSResult(String code, String message) {
		super(code, message);
		// TODO Auto-generated constructor stub
	}

	private String cmd;
	private String manualMode;
	
	
	public String getManualMode() {
		return manualMode;
	}
	public void setManualMode(String manualMode) {
		this.manualMode = manualMode;
	}
	public String getCmd() {
		return cmd;
	}
	public void setCmd(String cmd) {
		this.cmd = cmd;
	}
	 
	public static WSSResult success() {
		return new WSSResult("0", "OK");
	}
	
	public static WSSResult unknowException(Throwable t) {
		WSSResult ret = new WSSResult("99", t.getMessage());
		ret.setCmd("error");
		return ret;
	}

}
