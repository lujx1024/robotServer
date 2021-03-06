package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * ViewRobotLatestStatusId generated by hbm2java
 */
public class ViewRobotLatestStatusId implements java.io.Serializable {

	private Long robotId;
	private Date updateDatetime;
	private String wssSessionId;
	private Boolean online;
	private String extraInfo;
	private String robotName;

	public ViewRobotLatestStatusId() {
	}

	public ViewRobotLatestStatusId(String wssSessionId, String extraInfo,
			String robotName) {
		this.wssSessionId = wssSessionId;
		this.extraInfo = extraInfo;
		this.robotName = robotName;
	}

	public ViewRobotLatestStatusId(Long robotId, Date updateDatetime,
			String wssSessionId, Boolean online, String extraInfo,
			String robotName) {
		this.robotId = robotId;
		this.updateDatetime = updateDatetime;
		this.wssSessionId = wssSessionId;
		this.online = online;
		this.extraInfo = extraInfo;
		this.robotName = robotName;
	}

	public Long getRobotId() {
		return this.robotId;
	}

	public void setRobotId(Long robotId) {
		this.robotId = robotId;
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

	public Boolean getOnline() {
		return this.online;
	}

	public void setOnline(Boolean online) {
		this.online = online;
	}

	public String getExtraInfo() {
		return this.extraInfo;
	}

	public void setExtraInfo(String extraInfo) {
		this.extraInfo = extraInfo;
	}

	public String getRobotName() {
		return this.robotName;
	}

	public void setRobotName(String robotName) {
		this.robotName = robotName;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewRobotLatestStatusId))
			return false;
		ViewRobotLatestStatusId castOther = (ViewRobotLatestStatusId) other;

		return ((this.getRobotId() == castOther.getRobotId()) || (this
				.getRobotId() != null && castOther.getRobotId() != null && this
				.getRobotId().equals(castOther.getRobotId())))
				&& ((this.getUpdateDatetime() == castOther.getUpdateDatetime()) || (this
						.getUpdateDatetime() != null
						&& castOther.getUpdateDatetime() != null && this
						.getUpdateDatetime().equals(
								castOther.getUpdateDatetime())))
				&& ((this.getWssSessionId() == castOther.getWssSessionId()) || (this
						.getWssSessionId() != null
						&& castOther.getWssSessionId() != null && this
						.getWssSessionId().equals(castOther.getWssSessionId())))
				&& ((this.getOnline() == castOther.getOnline()) || (this
						.getOnline() != null && castOther.getOnline() != null && this
						.getOnline().equals(castOther.getOnline())))
				&& ((this.getExtraInfo() == castOther.getExtraInfo()) || (this
						.getExtraInfo() != null
						&& castOther.getExtraInfo() != null && this
						.getExtraInfo().equals(castOther.getExtraInfo())))
				&& ((this.getRobotName() == castOther.getRobotName()) || (this
						.getRobotName() != null
						&& castOther.getRobotName() != null && this
						.getRobotName().equals(castOther.getRobotName())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getRobotId() == null ? 0 : this.getRobotId().hashCode());
		result = 37
				* result
				+ (getUpdateDatetime() == null ? 0 : this.getUpdateDatetime()
						.hashCode());
		result = 37
				* result
				+ (getWssSessionId() == null ? 0 : this.getWssSessionId()
						.hashCode());
		result = 37 * result
				+ (getOnline() == null ? 0 : this.getOnline().hashCode());
		result = 37 * result
				+ (getExtraInfo() == null ? 0 : this.getExtraInfo().hashCode());
		result = 37 * result
				+ (getRobotName() == null ? 0 : this.getRobotName().hashCode());
		return result;
	}

}
