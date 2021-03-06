package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblRobotAppVersionRequired generated by hbm2java
 */
public class TblRobotAppVersionRequired implements java.io.Serializable {

	private TblRobotAppVersionRequiredId id;
	private EntDbVersion entDbVersion;
	private TblRobotAppVersion tblRobotAppVersion;
	private String extra;

	public TblRobotAppVersionRequired() {
	}

	public TblRobotAppVersionRequired(TblRobotAppVersionRequiredId id,
			EntDbVersion entDbVersion, TblRobotAppVersion tblRobotAppVersion) {
		this.id = id;
		this.entDbVersion = entDbVersion;
		this.tblRobotAppVersion = tblRobotAppVersion;
	}

	public TblRobotAppVersionRequired(TblRobotAppVersionRequiredId id,
			EntDbVersion entDbVersion, TblRobotAppVersion tblRobotAppVersion,
			String extra) {
		this.id = id;
		this.entDbVersion = entDbVersion;
		this.tblRobotAppVersion = tblRobotAppVersion;
		this.extra = extra;
	}

	public TblRobotAppVersionRequiredId getId() {
		return this.id;
	}

	public void setId(TblRobotAppVersionRequiredId id) {
		this.id = id;
	}

	public EntDbVersion getEntDbVersion() {
		return this.entDbVersion;
	}

	public void setEntDbVersion(EntDbVersion entDbVersion) {
		this.entDbVersion = entDbVersion;
	}

	public TblRobotAppVersion getTblRobotAppVersion() {
		return this.tblRobotAppVersion;
	}

	public void setTblRobotAppVersion(TblRobotAppVersion tblRobotAppVersion) {
		this.tblRobotAppVersion = tblRobotAppVersion;
	}

	public String getExtra() {
		return this.extra;
	}

	public void setExtra(String extra) {
		this.extra = extra;
	}

}
