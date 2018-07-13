package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.HashSet;
import java.util.Set;

/**
 * EntUserGroup generated by hbm2java
 */
public class EntUserGroup implements java.io.Serializable {

	private long id;
	private EntIndustry entIndustry;
	private String name;
	private String tag;
	private Set entRobotApps = new HashSet(0);
	private Set tblInheritConfigForUserGroups = new HashSet(0);
	private Set tblCustomizedConfigForUserGroups = new HashSet(0);
	private Set entRobotApps_1 = new HashSet(0);
	private Set tblUserGroupScenes = new HashSet(0);
	private Set entUsers = new HashSet(0);

	public EntUserGroup() {
	}

	public EntUserGroup(long id, String name, String tag) {
		this.id = id;
		this.name = name;
		this.tag = tag;
	}

	public EntUserGroup(long id, EntIndustry entIndustry, String name,
			String tag, Set entRobotApps, Set tblInheritConfigForUserGroups,
			Set tblCustomizedConfigForUserGroups, Set entRobotApps_1,
			Set tblUserGroupScenes, Set entUsers) {
		this.id = id;
		this.entIndustry = entIndustry;
		this.name = name;
		this.tag = tag;
		this.entRobotApps = entRobotApps;
		this.tblInheritConfigForUserGroups = tblInheritConfigForUserGroups;
		this.tblCustomizedConfigForUserGroups = tblCustomizedConfigForUserGroups;
		this.entRobotApps_1 = entRobotApps_1;
		this.tblUserGroupScenes = tblUserGroupScenes;
		this.entUsers = entUsers;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public EntIndustry getEntIndustry() {
		return this.entIndustry;
	}

	public void setEntIndustry(EntIndustry entIndustry) {
		this.entIndustry = entIndustry;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getTag() {
		return this.tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public Set getEntRobotApps() {
		return this.entRobotApps;
	}

	public void setEntRobotApps(Set entRobotApps) {
		this.entRobotApps = entRobotApps;
	}

	public Set getTblInheritConfigForUserGroups() {
		return this.tblInheritConfigForUserGroups;
	}

	public void setTblInheritConfigForUserGroups(
			Set tblInheritConfigForUserGroups) {
		this.tblInheritConfigForUserGroups = tblInheritConfigForUserGroups;
	}

	public Set getTblCustomizedConfigForUserGroups() {
		return this.tblCustomizedConfigForUserGroups;
	}

	public void setTblCustomizedConfigForUserGroups(
			Set tblCustomizedConfigForUserGroups) {
		this.tblCustomizedConfigForUserGroups = tblCustomizedConfigForUserGroups;
	}

	public Set getEntRobotApps_1() {
		return this.entRobotApps_1;
	}

	public void setEntRobotApps_1(Set entRobotApps_1) {
		this.entRobotApps_1 = entRobotApps_1;
	}

	public Set getTblUserGroupScenes() {
		return this.tblUserGroupScenes;
	}

	public void setTblUserGroupScenes(Set tblUserGroupScenes) {
		this.tblUserGroupScenes = tblUserGroupScenes;
	}

	public Set getEntUsers() {
		return this.entUsers;
	}

	public void setEntUsers(Set entUsers) {
		this.entUsers = entUsers;
	}

}
