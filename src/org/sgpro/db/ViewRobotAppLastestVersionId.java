package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * ViewRobotAppLastestVersionId generated by hbm2java
 */
public class ViewRobotAppLastestVersionId implements java.io.Serializable {

	private long robotAppId;
	private String appName;
	private String packageName;
	private String description;
	private long lastestVersionCode;
	private String versionName;
	private String downloadUrl;
	private String releaseNote;
	private Date publishDatetime;
	private boolean enable;

	public ViewRobotAppLastestVersionId() {
	}

	public ViewRobotAppLastestVersionId(long robotAppId, String appName,
			String packageName, String description, long lastestVersionCode,
			String versionName, String downloadUrl, String releaseNote,
			Date publishDatetime, boolean enable) {
		this.robotAppId = robotAppId;
		this.appName = appName;
		this.packageName = packageName;
		this.description = description;
		this.lastestVersionCode = lastestVersionCode;
		this.versionName = versionName;
		this.downloadUrl = downloadUrl;
		this.releaseNote = releaseNote;
		this.publishDatetime = publishDatetime;
		this.enable = enable;
	}

	public long getRobotAppId() {
		return this.robotAppId;
	}

	public void setRobotAppId(long robotAppId) {
		this.robotAppId = robotAppId;
	}

	public String getAppName() {
		return this.appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	public String getPackageName() {
		return this.packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public long getLastestVersionCode() {
		return this.lastestVersionCode;
	}

	public void setLastestVersionCode(long lastestVersionCode) {
		this.lastestVersionCode = lastestVersionCode;
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

	public boolean isEnable() {
		return this.enable;
	}

	public void setEnable(boolean enable) {
		this.enable = enable;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewRobotAppLastestVersionId))
			return false;
		ViewRobotAppLastestVersionId castOther = (ViewRobotAppLastestVersionId) other;

		return (this.getRobotAppId() == castOther.getRobotAppId())
				&& ((this.getAppName() == castOther.getAppName()) || (this
						.getAppName() != null && castOther.getAppName() != null && this
						.getAppName().equals(castOther.getAppName())))
				&& ((this.getPackageName() == castOther.getPackageName()) || (this
						.getPackageName() != null
						&& castOther.getPackageName() != null && this
						.getPackageName().equals(castOther.getPackageName())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())))
				&& (this.getLastestVersionCode() == castOther
						.getLastestVersionCode())
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
				&& (this.isEnable() == castOther.isEnable());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getRobotAppId();
		result = 37 * result
				+ (getAppName() == null ? 0 : this.getAppName().hashCode());
		result = 37
				* result
				+ (getPackageName() == null ? 0 : this.getPackageName()
						.hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		result = 37 * result + (int) this.getLastestVersionCode();
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
		result = 37 * result + (this.isEnable() ? 1 : 0);
		return result;
	}

}