package org.sgpro.db;

public class RemoteUserInfo implements java.io.Serializable{

	
	private long userId;
	private String userName;
	private String password;
	private String userLevel;
	private String status;
	private String logginSession;
	private String remake1;
	private String remake2;
	
	
	
	
	public RemoteUserInfo() {
	}
	
	
	
	public RemoteUserInfo(long userId, String userName, String password, String userLevel, String status,
			String logginSession) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.password = password;
		this.userLevel = userLevel;
		this.status = status;
		this.logginSession = logginSession;
	}
	
	






	public RemoteUserInfo(long userId, String userName, String password, String userLevel, String status,
			String logginSession, String remake1, String remake2) {
		super();
		this.userId = userId;
		this.userName = userName;
		this.password = password;
		this.userLevel = userLevel;
		this.status = status;
		this.logginSession = logginSession;
		this.remake1 = remake1;
		this.remake2 = remake2;
	}



	public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	public String getUserName() {
		return userName;
	}
	public void setUserName(String userName) {
		this.userName = userName;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getUserLevel() {
		return userLevel;
	}
	public void setUserLevel(String userLevel) {
		this.userLevel = userLevel;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	public String getLogginSession() {
		return logginSession;
	}
	public void setLogginSession(String logginSession) {
		this.logginSession = logginSession;
	}
	public String getRemake1() {
		return remake1;
	}
	public void setRemake1(String remake1) {
		this.remake1 = remake1;
	}
	public String getRemake2() {
		return remake2;
	}
	public void setRemake2(String remake2) {
		this.remake2 = remake2;
	}
	
	
}
