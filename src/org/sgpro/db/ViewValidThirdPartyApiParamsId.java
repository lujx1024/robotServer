package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewValidThirdPartyApiParamsId generated by hbm2java
 */
public class ViewValidThirdPartyApiParamsId implements java.io.Serializable {

	private long id;
	private String name;
	private String url;
	private String method;
	private String description;
	private String paramName;
	private boolean header0Body1;
	private String defaultValue;
	private boolean optional;
	private boolean runAtServer;
	private String resultType;

	public ViewValidThirdPartyApiParamsId() {
	}

	public ViewValidThirdPartyApiParamsId(long id, String name, String url,
			String method, String paramName, boolean header0Body1,
			boolean optional, boolean runAtServer) {
		this.id = id;
		this.name = name;
		this.url = url;
		this.method = method;
		this.paramName = paramName;
		this.header0Body1 = header0Body1;
		this.optional = optional;
		this.runAtServer = runAtServer;
	}

	public ViewValidThirdPartyApiParamsId(long id, String name, String url,
			String method, String description, String paramName,
			boolean header0Body1, String defaultValue, boolean optional,
			boolean runAtServer, String resultType) {
		this.id = id;
		this.name = name;
		this.url = url;
		this.method = method;
		this.description = description;
		this.paramName = paramName;
		this.header0Body1 = header0Body1;
		this.defaultValue = defaultValue;
		this.optional = optional;
		this.runAtServer = runAtServer;
		this.resultType = resultType;
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

	public String getUrl() {
		return this.url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getMethod() {
		return this.method;
	}

	public void setMethod(String method) {
		this.method = method;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getParamName() {
		return this.paramName;
	}

	public void setParamName(String paramName) {
		this.paramName = paramName;
	}

	public boolean isHeader0Body1() {
		return this.header0Body1;
	}

	public void setHeader0Body1(boolean header0Body1) {
		this.header0Body1 = header0Body1;
	}

	public String getDefaultValue() {
		return this.defaultValue;
	}

	public void setDefaultValue(String defaultValue) {
		this.defaultValue = defaultValue;
	}

	public boolean isOptional() {
		return this.optional;
	}

	public void setOptional(boolean optional) {
		this.optional = optional;
	}

	public boolean isRunAtServer() {
		return this.runAtServer;
	}

	public void setRunAtServer(boolean runAtServer) {
		this.runAtServer = runAtServer;
	}

	public String getResultType() {
		return this.resultType;
	}

	public void setResultType(String resultType) {
		this.resultType = resultType;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewValidThirdPartyApiParamsId))
			return false;
		ViewValidThirdPartyApiParamsId castOther = (ViewValidThirdPartyApiParamsId) other;

		return (this.getId() == castOther.getId())
				&& ((this.getName() == castOther.getName()) || (this.getName() != null
						&& castOther.getName() != null && this.getName()
						.equals(castOther.getName())))
				&& ((this.getUrl() == castOther.getUrl()) || (this.getUrl() != null
						&& castOther.getUrl() != null && this.getUrl().equals(
						castOther.getUrl())))
				&& ((this.getMethod() == castOther.getMethod()) || (this
						.getMethod() != null && castOther.getMethod() != null && this
						.getMethod().equals(castOther.getMethod())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())))
				&& ((this.getParamName() == castOther.getParamName()) || (this
						.getParamName() != null
						&& castOther.getParamName() != null && this
						.getParamName().equals(castOther.getParamName())))
				&& (this.isHeader0Body1() == castOther.isHeader0Body1())
				&& ((this.getDefaultValue() == castOther.getDefaultValue()) || (this
						.getDefaultValue() != null
						&& castOther.getDefaultValue() != null && this
						.getDefaultValue().equals(castOther.getDefaultValue())))
				&& (this.isOptional() == castOther.isOptional())
				&& (this.isRunAtServer() == castOther.isRunAtServer())
				&& ((this.getResultType() == castOther.getResultType()) || (this
						.getResultType() != null
						&& castOther.getResultType() != null && this
						.getResultType().equals(castOther.getResultType())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		result = 37 * result
				+ (getUrl() == null ? 0 : this.getUrl().hashCode());
		result = 37 * result
				+ (getMethod() == null ? 0 : this.getMethod().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		result = 37 * result
				+ (getParamName() == null ? 0 : this.getParamName().hashCode());
		result = 37 * result + (this.isHeader0Body1() ? 1 : 0);
		result = 37
				* result
				+ (getDefaultValue() == null ? 0 : this.getDefaultValue()
						.hashCode());
		result = 37 * result + (this.isOptional() ? 1 : 0);
		result = 37 * result + (this.isRunAtServer() ? 1 : 0);
		result = 37
				* result
				+ (getResultType() == null ? 0 : this.getResultType()
						.hashCode());
		return result;
	}

}
