package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * ViewRobotAppVersionId generated by hbm2java
 */
public class ViewRobotAppVersionId implements java.io.Serializable {

	private String appName;
	private long versionCode;
	private String versionName;
	private String downloadUrl;
	private String releaseNote;
	private Date publishDatetime;
	private boolean enabled;
	private long robotAppId;

	public ViewRobotAppVersionId() {
	}

	public ViewRobotAppVersionId(String appName, long versionCode,
			String versionName, String downloadUrl, String releaseNote,
			Date publishDatetime, boolean enabled, long robotAppId) {
		this.appName = appName;
		this.versionCode = versionCode;
		this.versionName = versionName;
		this.downloadUrl = downloadUrl;
		this.releaseNote = releaseNote;
		this.publishDatetime = publishDatetime;
		this.enabled = enabled;
		this.robotAppId = robotAppId;
	}

	public String getAppName() {
		return this.appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	public long getVersionCode() {
		return this.versionCode;
	}

	public void setVersionCode(long versionCode) {
		this.versionCode = versionCode;
	}

	public String getVersionName() {
		return this.versionName;
	}

	public void setVersionName(String versionName) {
		this.versionName = versionName;
	}

	public String getDownloadUrl() {
		return this.downloadUrl;
	}

	public void setDownloadUrl(String downloadUrl) {
		this.downloadUrl = downloadUrl;
	}

	public String getReleaseNote() {
		return this.releaseNote;
	}

	public void setReleaseNote(String releaseNote) {
		this.releaseNote = releaseNote;
	}

	public Date getPublishDatetime() {
		return this.publishDatetime;
	}

	public void setPublishDatetime(Date publishDatetime) {
		this.publishDatetime = publishDatetime;
	}

	public boolean isEnabled() {
		return this.enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public long getRobotAppId() {
		return this.robotAppId;
	}

	public void setRobotAppId(long robotAppId) {
		this.robotAppId = robotAppId;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewRobotAppVersionId))
			return false;
		ViewRobotAppVersionId castOther = (ViewRobotAppVersionId) other;

		return ((this.getAppName() == castOther.getAppName()) || (this
				.getAppName() != null && castOther.getAppName() != null && this
				.getAppName().equals(castOther.getAppName())))
				&& (this.getVersionCode() == castOther.getVersionCode())
				&& ((this.getVersionName() == castOther.getVersionName()) || (this
						.getVersionName() != null
						&& castOther.getVersionName() != null && this
						.getVersionName().equals(castOther.getVersionName())))
				&& ((this.getDownloadUrl() == castOther.getDownloadUrl()) || (this
						.getDownloadUrl() != null
						&& castOther.getDownloadUrl() != null && this
						.getDownloadUrl().equals(castOther.getDownloadUrl())))
				&& ((this.getReleaseNote() == castOther.getReleaseNote()) || (this
						.getReleaseNote() != null
						&& castOther.getReleaseNote() != null && this
						.getReleaseNote().equals(castOther.getReleaseNote())))
				&& ((this.getPublishDatetime() == castOther
						.getPublishDatetime()) || (this.getPublishDatetime() != null
						&& castOther.getPublishDatetime() != null && this
						.getPublishDatetime().equals(
								castOther.getPublishDatetime())))
				&& (this.isEnabled() == castOther.isEnabled())
				&& (this.getRobotAppId() == castOther.getRobotAppId());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getAppName() == null ? 0 : this.getAppName().hashCode());
		result = 37 * result + (int) this.getVersionCode();
		result = 37
				* result
				+ (getVersionName() == null ? 0 : this.getVersionName()
						.hashCode());
		result = 37
				* result
				+ (getDownloadUrl() == null ? 0 : this.getDownloadUrl()
						.hashCode());
		result = 37
				* result
				+ (getReleaseNote() == null ? 0 : this.getReleaseNote()
						.hashCode());
		result = 37
				* result
				+ (getPublishDatetime() == null ? 0 : this.getPublishDatetime()
						.hashCode());
		result = 37 * result + (this.isEnabled() ? 1 : 0);
		result = 37 * result + (int) this.getRobotAppId();
		return result;
	}

}
