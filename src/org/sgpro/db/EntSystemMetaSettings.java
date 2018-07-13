package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * EntSystemMetaSettings generated by hbm2java
 */
public class EntSystemMetaSettings implements java.io.Serializable {

	private String name;
	private String value;
	private String description;

	public EntSystemMetaSettings() {
	}

	public EntSystemMetaSettings(String name) {
		this.name = name;
	}

	public EntSystemMetaSettings(String name, String value, String description) {
		this.name = name;
		this.value = value;
		this.description = description;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return this.value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

}