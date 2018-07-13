package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * ViewRtcSessionStatusId generated by hbm2java
 */
public class ViewRtcSessionStatusId implements java.io.Serializable {

	private long rtcSessionId;
	private long robotId;
	private long userId;
	private boolean robotInitiate;
	private Date createDatetime;
	private Date latestUpdateDatetime;
	private String status;

	public ViewRtcSessionStatusId() {
	}

	public ViewRtcSessionStatusId(long rtcSessionId, long robotId, long userId,
			boolean robotInitiate, Date createDatetime,
			Date latestUpdateDatetime) {
		this.rtcSessionId = rtcSessionId;
		this.robotId = robotId;
		this.userId = userId;
		this.robotInitiate = robotInitiate;
		this.createDatetime = createDatetime;
		this.latestUpdateDatetime = latestUpdateDatetime;
	}

	public ViewRtcSessionStatusId(long rtcSessionId, long robotId, long userId,
			boolean robotInitiate, Date createDatetime,
			Date latestUpdateDatetime, String status) {
		this.rtcSessionId = rtcSessionId;
		this.robotId = robotId;
		this.userId = userId;
		this.robotInitiate = robotInitiate;
		this.createDatetime = createDatetime;
		this.latestUpdateDatetime = latestUpdateDatetime;
		this.status = status;
	}

	public long getRtcSessionId() {
		return this.rtcSessionId;
	}

	public void setRtcSessionId(long rtcSessionId) {
		this.rtcSessionId = rtcSessionId;
	}

	public long getRobotId() {
		return this.robotId;
	}

	public void setRobotId(long robotId) {
		this.robotId = robotId;
	}

	public long getUserId() {
		return this.userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public boolean isRobotInitiate() {
		return this.robotInitiate;
	}

	public void setRobotInitiate(boolean robotInitiate) {
		this.robotInitiate = robotInitiate;
	}

	public Date getCreateDatetime() {
		return this.createDatetime;
	}

	public void setCreateDatetime(Date createDatetime) {
		this.createDatetime = createDatetime;
	}

	public Date getLatestUpdateDatetime() {
		return this.latestUpdateDatetime;
	}

	public void setLatestUpdateDatetime(Date latestUpdateDatetime) {
		this.latestUpdateDatetime = latestUpdateDatetime;
	}

	public String getStatus() {
		return this.status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewRtcSessionStatusId))
			return false;
		ViewRtcSessionStatusId castOther = (ViewRtcSessionStatusId) other;

		return (this.getRtcSessionId() == castOther.getRtcSessionId())
				&& (this.getRobotId() == castOther.getRobotId())
				&& (this.getUserId() == castOther.getUserId())
				&& (this.isRobotInitiate() == castOther.isRobotInitiate())
				&& ((this.getCreateDatetime() == castOther.getCreateDatetime()) || (this
						.getCreateDatetime() != null
						&& castOther.getCreateDatetime() != null && this
						.getCreateDatetime().equals(
								castOther.getCreateDatetime())))
				&& ((this.getLatestUpdateDatetime() == castOther
						.getLatestUpdateDatetime()) || (this
						.getLatestUpdateDatetime() != null
						&& castOther.getLatestUpdateDatetime() != null && this
						.getLatestUpdateDatetime().equals(
								castOther.getLatestUpdateDatetime())))
				&& ((this.getStatus() == castOther.getStatus()) || (this
						.getStatus() != null && castOther.getStatus() != null && this
						.getStatus().equals(castOther.getStatus())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getRtcSessionId();
		result = 37 * result + (int) this.getRobotId();
		result = 37 * result + (int) this.getUserId();
		result = 37 * result + (this.isRobotInitiate() ? 1 : 0);
		result = 37
				* result
				+ (getCreateDatetime() == null ? 0 : this.getCreateDatetime()
						.hashCode());
		result = 37
				* result
				+ (getLatestUpdateDatetime() == null ? 0 : this
						.getLatestUpdateDatetime().hashCode());
		result = 37 * result
				+ (getStatus() == null ? 0 : this.getStatus().hashCode());
		return result;
	}

}
