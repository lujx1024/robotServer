package org.sgpro.db;
/**
 * ADD by LvDW
 * 2018-04-28
 * */
public class ViewRemoteRobotListId implements java.io.Serializable{
	
	private long userId;
	private long robotId;
	private String robotImei;
	private String name;
	private String robotStatus;
	private String sessionId;
	private String robotName;
	private String robotSite;
	private String statusOnline;
	
	
	
	
	public ViewRemoteRobotListId(long userId, long robotId, String robotImei, String name, String robotStatus,
			String sessionId, String robotName, String robotSite, String statusOnline) {
		super();
		this.userId = userId;
		this.robotId = robotId;
		this.robotImei = robotImei;
		this.name = name;
		this.robotStatus = robotStatus;
		this.sessionId = sessionId;
		this.robotName = robotName;
		this.robotSite = robotSite;
		this.statusOnline = statusOnline;
	}




	
	public String getStatusOnline() {
		return statusOnline;
	}





	public void setStatusOnline(String statusOnline) {
		this.statusOnline = statusOnline;
	}





	public String getRobotName() {
		return robotName;
	}




	public void setRobotName(String robotName) {
		this.robotName = robotName;
	}




	public String getRobotSite() {
		return robotSite;
	}




	public void setRobotSite(String robotSite) {
		this.robotSite = robotSite;
	}




	public String getSessionId() {
		return sessionId;
	}


	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}


	public ViewRemoteRobotListId() {
	}
	public long getUserId() {
		return userId;
	}
	public void setUserId(long userId) {
		this.userId = userId;
	}
	
	
	public String getRobotImei() {
		return robotImei;
	}
	public void setRobotImei(String robotImei) {
		this.robotImei = robotImei;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getRobotStatus() {
		return robotStatus;
	}
	public void setRobotStatus(String robotStatus) {
		this.robotStatus = robotStatus;
	}
	public long getRobotId() {
		return robotId;
	}
	public void setRobotId(long robotId) {
		this.robotId = robotId;
	}
	
	
	

//	private long userId;
//	private String robotImei;
//	private String robotName;
//	private String robotStatus;
//	
//	public ViewRemoteRobotListId() {
//	}
//	
//	public ViewRemoteRobotListId(long userId, String robotImei, String robotName, String robotStatus) {
//		this.userId = userId;
//		this.robotImei = robotImei;
//		this.robotName = robotName;
//		this.robotStatus = robotStatus;
//	}
//	
//	public long getUserId() {
//		return userId;
//	}
//	public void setUserId(long userId) {
//		this.userId = userId;
//	}
//	public String getRobotImei() {
//		return robotImei;
//	}
//	public void setRobotImei(String robotImei) {
//		this.robotImei = robotImei;
//	}
//	public String getRobotName() {
//		return robotName;
//	}
//	public void setRobotName(String robotName) {
//		this.robotName = robotName;
//	}
//	public String getRobotStatus() {
//		return robotStatus;
//	}
//	public void setRobotStatus(String robotStatus) {
//		this.robotStatus = robotStatus;
//	}
}
