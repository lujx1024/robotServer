package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewThirdPartySimpleId generated by hbm2java
 */
public class ViewThirdPartySimpleId implements java.io.Serializable {

	private long id;
	private String name;
	private String url;
	private String method;
	private String resultType;
	private boolean runAtServer;
	private boolean enable;
	private String description;

	public ViewThirdPartySimpleId() {
	}

	public ViewThirdPartySimpleId(long id, String name, String url,
			String method, String resultType, boolean runAtServer,
			boolean enable, String description) {
		this.id = id;
		this.name = name;
		this.url = url;
		this.method = method;
		this.resultType = resultType;
		this.runAtServer = runAtServer;
		this.enable = enable;
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

	public String getResultType() {
		return this.resultType;
	}

	public void setResultType(String resultType) {
		this.resultType = resultType;
	}

	public boolean isRunAtServer() {
		return this.runAtServer;
	}

	public void setRunAtServer(boolean runAtServer) {
		this.runAtServer = runAtServer;
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

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewThirdPartySimpleId))
			return false;
		ViewThirdPartySimpleId castOther = (ViewThirdPartySimpleId) other;

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
				&& ((this.getResultType() == castOther.getResultType()) || (this
						.getResultType() != null
						&& castOther.getResultType() != null && this
						.getResultType().equals(castOther.getResultType())))
				&& (this.isRunAtServer() == castOther.isRunAtServer())
				&& (this.isEnable() == castOther.isEnable())
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
		result = 37 * result
				+ (getUrl() == null ? 0 : this.getUrl().hashCode());
		result = 37 * result
				+ (getMethod() == null ? 0 : this.getMethod().hashCode());
		result = 37
				* result
				+ (getResultType() == null ? 0 : this.getResultType()
						.hashCode());
		result = 37 * result + (this.isRunAtServer() ? 1 : 0);
		result = 37 * result + (this.isEnable() ? 1 : 0);
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		return result;
	}

}
