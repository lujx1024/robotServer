package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.HashSet;
import java.util.Set;

/**
 * EntHwSpec generated by hbm2java
 */
public class EntHwSpec implements java.io.Serializable {

	private long id;
	private String name;
	private boolean enabled;
	private String description;
	private Set entRobots = new HashSet(0);
	private Set tblCustomizedConfigForHwSpecs = new HashSet(0);

	public EntHwSpec() {
	}

	public EntHwSpec(long id, String name, boolean enabled, String description) {
		this.id = id;
		this.name = name;
		this.enabled = enabled;
		this.description = description;
	}

	public EntHwSpec(long id, String name, boolean enabled, String description,
			Set entRobots, Set tblCustomizedConfigForHwSpecs) {
		this.id = id;
		this.name = name;
		this.enabled = enabled;
		this.description = description;
		this.entRobots = entRobots;
		this.tblCustomizedConfigForHwSpecs = tblCustomizedConfigForHwSpecs;
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

	public boolean isEnabled() {
		return this.enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Set getEntRobots() {
		return this.entRobots;
	}

	public void setEntRobots(Set entRobots) {
		this.entRobots = entRobots;
	}

	public Set getTblCustomizedConfigForHwSpecs() {
		return this.tblCustomizedConfigForHwSpecs;
	}

	public void setTblCustomizedConfigForHwSpecs(
			Set tblCustomizedConfigForHwSpecs) {
		this.tblCustomizedConfigForHwSpecs = tblCustomizedConfigForHwSpecs;
	}

}