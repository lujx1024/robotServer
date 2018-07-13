package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.HashSet;
import java.util.Set;

/**
 * EntRobotApp generated by hbm2java
 */
public class EntRobotApp implements java.io.Serializable {

	private long id;
	private String packageName;
	private String appName;
	private boolean exclusive;
	private boolean enable;
	private String description;
	private Set entUserGroups = new HashSet(0);
	private Set entUserGroups_1 = new HashSet(0);
	private Set tblRobotAppVersions = new HashSet(0);

	public EntRobotApp() {
	}

	public EntRobotApp(long id, String packageName, String appName,
			boolean exclusive, boolean enable, String description) {
		this.id = id;
		this.packageName = packageName;
		this.appName = appName;
		this.exclusive = exclusive;
		this.enable = enable;
		this.description = description;
	}

	public EntRobotApp(long id, String packageName, String appName,
			boolean exclusive, boolean enable, String description,
			Set entUserGroups, Set entUserGroups_1, Set tblRobotAppVersions) {
		this.id = id;
		this.packageName = packageName;
		this.appName = appName;
		this.exclusive = exclusive;
		this.enable = enable;
		this.description = description;
		this.entUserGroups = entUserGroups;
		this.entUserGroups_1 = entUserGroups_1;
		this.tblRobotAppVersions = tblRobotAppVersions;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getPackageName() {
		return this.packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getAppName() {
		return this.appName;
	}

	public void setAppName(String appName) {
		this.appName = appName;
	}

	public boolean isExclusive() {
		return this.exclusive;
	}

	public void setExclusive(boolean exclusive) {
		this.exclusive = exclusive;
	}

	public boolean isEnable() {
		return this.enable;
	}

	public void setEnable(boolean enable) {
		this.enable = enable;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Set getEntUserGroups() {
		return this.entUserGroups;
	}

	public void setEntUserGroups(Set entUserGroups) {
		this.entUserGroups = entUserGroups;
	}

	public Set getEntUserGroups_1() {
		return this.entUserGroups_1;
	}

	public void setEntUserGroups_1(Set entUserGroups_1) {
		this.entUserGroups_1 = entUserGroups_1;
	}

	public Set getTblRobotAppVersions() {
		return this.tblRobotAppVersions;
	}

	public void setTblRobotAppVersions(Set tblRobotAppVersions) {
		this.tblRobotAppVersions = tblRobotAppVersions;
	}

}
