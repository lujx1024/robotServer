package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewThirdPartyParamSimpleId generated by hbm2java
 */
public class ViewThirdPartyParamSimpleId implements java.io.Serializable {

	private long id;
	private String name;
	private boolean header0Body1;
	private boolean optional;
	private String defaultValue;
	private String description;

	public ViewThirdPartyParamSimpleId() {
	}

	public ViewThirdPartyParamSimpleId(long id, String name,
			boolean header0Body1, boolean optional, String defaultValue,
			String description) {
		this.id = id;
		this.name = name;
		this.header0Body1 = header0Body1;
		this.optional = optional;
		this.defaultValue = defaultValue;
		this.description = description;
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

	public boolean isHeader0Body1() {
		return this.header0Body1;
	}

	public void setHeader0Body1(boolean header0Body1) {
		this.header0Body1 = header0Body1;
	}

	public boolean isOptional() {
		return this.optional;
	}

	public void setOptional(boolean optional) {
		this.optional = optional;
	}

	public String getDefaultValue() {
		return this.defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewThirdPartyParamSimpleId))
			return false;
		ViewThirdPartyParamSimpleId castOther = (ViewThirdPartyParamSimpleId) other;

		return (this.getId() == castOther.getId())
				&& ((this.getName() == castOther.getName()) || (this.getName() != null
						&& castOther.getName() != null && this.getName()
						.equals(castOther.getName())))
				&& (this.isHeader0Body1() == castOther.isHeader0Body1())
				&& (this.isOptional() == castOther.isOptional())
				&& ((this.getDefaultValue() == castOther.getDefaultValue()) || (this
						.getDefaultValue() != null
						&& castOther.getDefaultValue() != null && this
						.getDefaultValue().equals(castOther.getDefaultValue())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		result = 37 * result + (this.isHeader0Body1() ? 1 : 0);
		result = 37 * result + (this.isOptional() ? 1 : 0);
		result = 37
				* result
				+ (getDefaultValue() == null ? 0 : this.getDefaultValue()
						.hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		return result;
	}

}
