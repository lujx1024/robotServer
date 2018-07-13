package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.HashSet;
import java.util.Set;

/**
 * EntHuaqin2016ProviderConfrenceCompany generated by hbm2java
 */
public class EntHuaqin2016ProviderConfrenceCompany implements
		java.io.Serializable {

	private long id;
	private String name;
	private String cname;
	private String fullName;
	private boolean enabled;
	private Set tblHuaqin2016ProviderConfrencePaticipantses = new HashSet(0);

	public EntHuaqin2016ProviderConfrenceCompany() {
	}

	public EntHuaqin2016ProviderConfrenceCompany(long id, String name,
			String fullName, boolean enabled) {
		this.id = id;
		this.name = name;
		this.fullName = fullName;
		this.enabled = enabled;
	}

	public EntHuaqin2016ProviderConfrenceCompany(long id, String name,
			String cname, String fullName, boolean enabled,
			Set tblHuaqin2016ProviderConfrencePaticipantses) {
		this.id = id;
		this.name = name;
		this.cname = cname;
		this.fullName = fullName;
		this.enabled = enabled;
		this.tblHuaqin2016ProviderConfrencePaticipantses = tblHuaqin2016ProviderConfrencePaticipantses;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getCname() {
		return this.cname;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}

	public String getFullName() {
		return this.fullName;
	}

	public void setFullName(String fullName) {
		this.fullName = fullName;
	}

	public boolean isEnabled() {
		return this.enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public Set getTblHuaqin2016ProviderConfrencePaticipantses() {
		return this.tblHuaqin2016ProviderConfrencePaticipantses;
	}

	public void setTblHuaqin2016ProviderConfrencePaticipantses(
			Set tblHuaqin2016ProviderConfrencePaticipantses) {
		this.tblHuaqin2016ProviderConfrencePaticipantses = tblHuaqin2016ProviderConfrencePaticipantses;
	}

}