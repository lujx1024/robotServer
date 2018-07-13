package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * ViewUserLastestStatusId generated by hbm2java
 */
public class ViewUserLastestStatusId implements java.io.Serializable {

	private long userId;
	private Date updateDatetime;
	private String wssSessionId;
	private boolean online;
	private String extraInfo;
	private long userGroupId;
	private String userGroupName;
	private String userName;

	public ViewUserLastestStatusId() {
	}

	public ViewUserLastestStatusId(long userId, Date updateDatetime,
			String wssSessionId, boolean online, String extraInfo,
			long userGroupId, String userGroupName, String userName) {
		this.userId = userId;
		this.updateDatetime = updateDatetime;
		this.wssSessionId = wssSessionId;
		this.online = online;
		this.extraInfo = extraInfo;
		this.userGroupId = userGroupId;
		this.userGroupName = userGroupName;
		this.userName = userName;
	}

	public long getUserId() {
		return this.userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public Date getUpdateDatetime() {
		return this.updateDatetime;
	}

	public void setUpdateDatetime(Date updateDatetime) {
		this.updateDatetime = updateDatetime;
	}

	public String getWssSessionId() {
		return this.wssSessionId;
	}

	public void setWssSessionId(String wssSessionId) {
		this.wssSessionId = wssSessionId;
	}

	public boolean isOnline() {
		return this.online;
	}

	public void setOnline(boolean online) {
		this.online = online;
	}

	public String getExtraInfo() {
		return this.extraInfo;
	}

	public void setExtraInfo(String extraInfo) {
		this.extraInfo = extraInfo;
	}

	public long getUserGroupId() {
		return this.userGroupId;
	}

	public void setUserGroupId(long userGroupId) {
		this.userGroupId = userGroupId;
	}

	public String getUserGroupName() {
		return this.userGroupName;
	}

	public void setUserGroupName(String userGroupName) {
		this.userGroupName = userGroupName;
	}

	public String getUserName() {
		return this.userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewUserLastestStatusId))
			return false;
		ViewUserLastestStatusId castOther = (ViewUserLastestStatusId) other;

		return (this.getUserId() == castOther.getUserId())
				&& ((this.getUpdateDatetime() == castOther.getUpdateDatetime()) || (this
						.getUpdateDatetime() != null
						&& castOther.getUpdateDatetime() != null && this
						.getUpdateDatetime().equals(
								castOther.getUpdateDatetime())))
				&& ((this.getWssSessionId() == castOther.getWssSessionId()) || (this
						.getWssSessionId() != null
						&& castOther.getWssSessionId() != null && this
						.getWssSessionId().equals(castOther.getWssSessionId())))
				&& (this.isOnline() == castOther.isOnline())
				&& ((this.getExtraInfo() == castOther.getExtraInfo()) || (this
						.getExtraInfo() != null
						&& castOther.getExtraInfo() != null && this
						.getExtraInfo().equals(castOther.getExtraInfo())))
				&& (this.getUserGroupId() == castOther.getUserGroupId())
				&& ((this.getUserGroupName() == castOther.getUserGroupName()) || (this
						.getUserGroupName() != null
						&& castOther.getUserGroupName() != null && this
						.getUserGroupName()
						.equals(castOther.getUserGroupName())))
				&& ((this.getUserName() == castOther.getUserName()) || (this
						.getUserName() != null
						&& castOther.getUserName() != null && this
						.getUserName().equals(castOther.getUserName())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getUserId();
		result = 37
				* result
				+ (getUpdateDatetime() == null ? 0 : this.getUpdateDatetime()
						.hashCode());
		result = 37
				* result
				+ (getWssSessionId() == null ? 0 : this.getWssSessionId()
						.hashCode());
		result = 37 * result + (this.isOnline() ? 1 : 0);
		result = 37 * result
				+ (getExtraInfo() == null ? 0 : this.getExtraInfo().hashCode());
		result = 37 * result + (int) this.getUserGroupId();
		result = 37
				* result
				+ (getUserGroupName() == null ? 0 : this.getUserGroupName()
						.hashCode());
		result = 37 * result
				+ (getUserName() == null ? 0 : this.getUserName().hashCode());
		return result;
	}

}