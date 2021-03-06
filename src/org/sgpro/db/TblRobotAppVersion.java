package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * TblRobotAppVersion generated by hbm2java
 */
public class TblRobotAppVersion implements java.io.Serializable {

	private TblRobotAppVersionId id;
	private EntRobotApp entRobotApp;
	private String versionName;
	private String downloadUrl;
	private String releaseNote;
	private Date publishDatetime;
	private boolean enabled;
	private Set tblRobotAppVersionRequireds = new HashSet(0);

	public TblRobotAppVersion() {
	}

	public TblRobotAppVersion(TblRobotAppVersionId id, EntRobotApp entRobotApp,
			String versionName, String downloadUrl, String releaseNote,
			Date publishDatetime, boolean enabled) {
		this.id = id;
		this.entRobotApp = entRobotApp;
		this.versionName = versionName;
		this.downloadUrl = downloadUrl;
		this.releaseNote = releaseNote;
		this.publishDatetime = publishDatetime;
		this.enabled = enabled;
	}

	public TblRobotAppVersion(TblRobotAppVersionId id, EntRobotApp entRobotApp,
			String versionName, String downloadUrl, String releaseNote,
			Date publishDatetime, boolean enabled,
			Set tblRobotAppVersionRequireds) {
		this.id = id;
		this.entRobotApp = entRobotApp;
		this.versionName = versionName;
		this.downloadUrl = downloadUrl;
		this.releaseNote = releaseNote;
		this.publishDatetime = publishDatetime;
		this.enabled = enabled;
		this.tblRobotAppVersionRequireds = tblRobotAppVersionRequireds;
	}

	public TblRobotAppVersionId getId() {
		return this.id;
	}

	public void setId(TblRobotAppVersionId id) {
		this.id = id;
	}

	public EntRobotApp getEntRobotApp() {
		return this.entRobotApp;
	}

	public void setEntRobotApp(EntRobotApp entRobotApp) {
		this.entRobotApp = entRobotApp;
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

	public Set getTblRobotAppVersionRequireds() {
		return this.tblRobotAppVersionRequireds;
	}

	public void setTblRobotAppVersionRequireds(Set tblRobotAppVersionRequireds) {
		this.tblRobotAppVersionRequireds = tblRobotAppVersionRequireds;
	}

}
