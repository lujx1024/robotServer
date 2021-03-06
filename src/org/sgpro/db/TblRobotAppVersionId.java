package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblRobotAppVersionId generated by hbm2java
 */
public class TblRobotAppVersionId implements java.io.Serializable {

	private long robotAppId;
	private long versionCode;

	public TblRobotAppVersionId() {
	}

	public TblRobotAppVersionId(long robotAppId, long versionCode) {
		this.robotAppId = robotAppId;
		this.versionCode = versionCode;
	}

	public long getRobotAppId() {
		return this.robotAppId;
	}

	public void setRobotAppId(long robotAppId) {
		this.robotAppId = robotAppId;
	}

	public long getVersionCode() {
		return this.versionCode;
	}

	public void setVersionCode(long versionCode) {
		this.versionCode = versionCode;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TblRobotAppVersionId))
			return false;
		TblRobotAppVersionId castOther = (TblRobotAppVersionId) other;

		return (this.getRobotAppId() == castOther.getRobotAppId())
				&& (this.getVersionCode() == castOther.getVersionCode());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getRobotAppId();
		result = 37 * result + (int) this.getVersionCode();
		return result;
	}

}
