package org.sgpro.db;

import java.util.Date;

public class ViewRemoteUserRobotBindListId implements java.io.Serializable{
	private long robotId;
	private String robotName;
	private String robotImei;
	private boolean robotManualMode;
	private Date robotActivateDatetime;
	private Date robotLatestStatusUpdateDatetime;
	private String robotLatestStatusWssSessionId;
	private Boolean robotLatestStatusOnline;
	private String robotLatestStatusExtraInfo;
	private long userId;
	private Boolean isActivateUser;
	private String userName;
	private String userPassword;
	private Date userLastestStatusUpdateDatetime;
	private String userLastestStatusWssSessionId;
	private Date updateDatetime;
	private Boolean userLastestStatusOnline;
	
    
	public ViewRemoteUserRobotBindListId(long robotId, String robotName, String robotImei, boolean robotManualMode,
			Date robotActivateDatetime, Date robotLatestStatusUpdateDatetime, String robotLatestStatusWssSessionId,
			Boolean robotLatestStatusOnline, String robotLatestStatusExtraInfo, long userId, Boolean isActivateUser,
			String userName, String userPassword, Date userLastestStatusUpdateDatetime,
			String userLastestStatusWssSessionId, Date updateDatetime, Boolean userLastestStatusOnline) {
		this.robotId = robotId;
		this.robotName = robotName;
		this.robotImei = robotImei;
		this.robotManualMode = robotManualMode;
		this.robotActivateDatetime = robotActivateDatetime;
		this.robotLatestStatusUpdateDatetime = robotLatestStatusUpdateDatetime;
		this.robotLatestStatusWssSessionId = robotLatestStatusWssSessionId;
		this.robotLatestStatusOnline = robotLatestStatusOnline;
		this.robotLatestStatusExtraInfo = robotLatestStatusExtraInfo;
		this.userId = userId;
		this.isActivateUser = isActivateUser;
		this.userName = userName;
		this.userPassword = userPassword;
		this.userLastestStatusUpdateDatetime = userLastestStatusUpdateDatetime;
		this.userLastestStatusWssSessionId = userLastestStatusWssSessionId;
		this.updateDatetime = updateDatetime;
		this.userLastestStatusOnline = userLastestStatusOnline;
	}

	
	
	public boolean isRobotManualMode() {
		return robotManualMode;
	}



	public void setRobotManualMode(boolean robotManualMode) {
		this.robotManualMode = robotManualMode;
	}



	public ViewRemoteUserRobotBindListId() {
	}

	public long getRobotId() {
		return robotId;
	}

	public void setRobotId(long robotId) {
		this.robotId = robotId;
	}

	public String getRobotName() {
		return robotName;
	}

	public void setRobotName(String robotName) {
		this.robotName = robotName;
	}

	public String getRobotImei() {
		return robotImei;
	}

	public void setRobotImei(String robotImei) {
		this.robotImei = robotImei;
	}

	public Date getRobotActivateDatetime() {
		return robotActivateDatetime;
	}

	public void setRobotActivateDatetime(Date robotActivateDatetime) {
		this.robotActivateDatetime = robotActivateDatetime;
	}

	public Date getRobotLatestStatusUpdateDatetime() {
		return robotLatestStatusUpdateDatetime;
	}

	public void setRobotLatestStatusUpdateDatetime(Date robotLatestStatusUpdateDatetime) {
		this.robotLatestStatusUpdateDatetime = robotLatestStatusUpdateDatetime;
	}

	public String getRobotLatestStatusWssSessionId() {
		return robotLatestStatusWssSessionId;
	}

	public void setRobotLatestStatusWssSessionId(String robotLatestStatusWssSessionId) {
		this.robotLatestStatusWssSessionId = robotLatestStatusWssSessionId;
	}

	public Boolean getRobotLatestStatusOnline() {
		return robotLatestStatusOnline;
	}

	public void setRobotLatestStatusOnline(Boolean robotLatestStatusOnline) {
		this.robotLatestStatusOnline = robotLatestStatusOnline;
	}

	public String getRobotLatestStatusExtraInfo() {
		return robotLatestStatusExtraInfo;
	}

	public void setRobotLatestStatusExtraInfo(String robotLatestStatusExtraInfo) {
		this.robotLatestStatusExtraInfo = robotLatestStatusExtraInfo;
	}

	public long getUserId() {
		return userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public Boolean getIsActivateUser() {
		return isActivateUser;
	}

	public void setIsActivateUser(Boolean isActivateUser) {
		this.isActivateUser = isActivateUser;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getUserPassword() {
		return userPassword;
	}

	public void setUserPassword(String userPassword) {
		this.userPassword = userPassword;
	}

	public Date getUserLastestStatusUpdateDatetime() {
		return userLastestStatusUpdateDatetime;
	}

	public void setUserLastestStatusUpdateDatetime(Date userLastestStatusUpdateDatetime) {
		this.userLastestStatusUpdateDatetime = userLastestStatusUpdateDatetime;
	}

	public String getUserLastestStatusWssSessionId() {
		return userLastestStatusWssSessionId;
	}

	public void setUserLastestStatusWssSessionId(String userLastestStatusWssSessionId) {
		this.userLastestStatusWssSessionId = userLastestStatusWssSessionId;
	}

	public Date getUpdateDatetime() {
		return updateDatetime;
	}

	public void setUpdateDatetime(Date updateDatetime) {
		this.updateDatetime = updateDatetime;
	}

	public Boolean getUserLastestStatusOnline() {
		return userLastestStatusOnline;
	}

	public void setUserLastestStatusOnline(Boolean userLastestStatusOnline) {
		this.userLastestStatusOnline = userLastestStatusOnline;
	}
	
	
	

}
