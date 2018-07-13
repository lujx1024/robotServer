package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * TblRuntimeDataBackupId generated by hbm2java
 */
public class TblRuntimeDataBackupId implements java.io.Serializable {

	private long id;
	private String robotId;
	private String app;
	private String type;
	private String msg;
	private String details;
	private Date dateTime;

	public TblRuntimeDataBackupId() {
	}

	public TblRuntimeDataBackupId(long id, String robotId, String app,
			String type, String msg, String details, Date dateTime) {
		this.id = id;
		this.robotId = robotId;
		this.app = app;
		this.type = type;
		this.msg = msg;
		this.details = details;
		this.dateTime = dateTime;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getRobotId() {
		return this.robotId;
	}

	public void setRobotId(String robotId) {
		this.robotId = robotId;
	}

	public String getApp() {
		return this.app;
	}

	public void setApp(String app) {
		this.app = app;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getMsg() {
		return this.msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getDetails() {
		return this.details;
	}

	public void setDetails(String details) {
		this.details = details;
	}

	public Date getDateTime() {
		return this.dateTime;
	}

	public void setDateTime(Date dateTime) {
		this.dateTime = dateTime;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TblRuntimeDataBackupId))
			return false;
		TblRuntimeDataBackupId castOther = (TblRuntimeDataBackupId) other;

		return (this.getId() == castOther.getId())
				&& ((this.getRobotId() == castOther.getRobotId()) || (this
						.getRobotId() != null && castOther.getRobotId() != null && this
						.getRobotId().equals(castOther.getRobotId())))
				&& ((this.getApp() == castOther.getApp()) || (this.getApp() != null
						&& castOther.getApp() != null && this.getApp().equals(
						castOther.getApp())))
				&& ((this.getType() == castOther.getType()) || (this.getType() != null
						&& castOther.getType() != null && this.getType()
						.equals(castOther.getType())))
				&& ((this.getMsg() == castOther.getMsg()) || (this.getMsg() != null
						&& castOther.getMsg() != null && this.getMsg().equals(
						castOther.getMsg())))
				&& ((this.getDetails() == castOther.getDetails()) || (this
						.getDetails() != null && castOther.getDetails() != null && this
						.getDetails().equals(castOther.getDetails())))
				&& ((this.getDateTime() == castOther.getDateTime()) || (this
						.getDateTime() != null
						&& castOther.getDateTime() != null && this
						.getDateTime().equals(castOther.getDateTime())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result
				+ (getRobotId() == null ? 0 : this.getRobotId().hashCode());
		result = 37 * result
				+ (getApp() == null ? 0 : this.getApp().hashCode());
		result = 37 * result
				+ (getType() == null ? 0 : this.getType().hashCode());
		result = 37 * result
				+ (getMsg() == null ? 0 : this.getMsg().hashCode());
		result = 37 * result
				+ (getDetails() == null ? 0 : this.getDetails().hashCode());
		result = 37 * result
				+ (getDateTime() == null ? 0 : this.getDateTime().hashCode());
		return result;
	}

}
