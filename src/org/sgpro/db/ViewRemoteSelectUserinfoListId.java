package org.sgpro.db;

public class ViewRemoteSelectUserinfoListId implements java.io.Serializable{

	private long userId;
	private String userName;
	private String password;
	private String userLevel;
	private String userRelateRobot;
	
	public ViewRemoteSelectUserinfoListId() {
	}
	
	public ViewRemoteSelectUserinfoListId(long userId, String userName, String password, String userLevel,
			String userRelateRobot) {
		this.userId = userId;
		this.userName = userName;
		this.password = password;
		this.userLevel = userLevel;
		this.userRelateRobot = userRelateRobot;
	}

	public ViewRemoteSelectUserinfoListId(long userId, String userName, String password, String userLevel) {
		this.userId = userId;
		this.userName = userName;
		this.password = password;
		this.userLevel = userLevel;
		this.userRelateRobot = "";
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

	public String getUserRelateRobot() {
		return userRelateRobot;
	}

	public void setUserRelateRobot(String userRelateRobot) {
		this.userRelateRobot = userRelateRobot;
	}

	
	
	
	
	
}
