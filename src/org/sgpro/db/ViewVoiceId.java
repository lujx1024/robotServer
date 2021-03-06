package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewVoiceId generated by hbm2java
 */
public class ViewVoiceId implements java.io.Serializable {

	private long id;
	private String name;
	private String path;
	private String text;
	private String cat;
	private String description;
	private Long command;
	private String commandParam;
	private String thirdPartyApiName;
	private String thirdPartyApiMethod;
	private String thirdPartyApiHeaderParams;
	private String thirdPartyApiUrl;
	private String thirdPartyApiResultType;
	private Boolean thirdPartyApiRunAtServer;
	private String incProp;
	private String excProp;
	private String emotion;
	private boolean enabled;

	public ViewVoiceId() {
	}

	public ViewVoiceId(long id, String name, String cat, String description,
			boolean enabled) {
		this.id = id;
		this.name = name;
		this.cat = cat;
		this.description = description;
		this.enabled = enabled;
	}

	public ViewVoiceId(long id, String name, String path, String text,
			String cat, String description, Long command, String commandParam,
			String thirdPartyApiName, String thirdPartyApiMethod,
			String thirdPartyApiHeaderParams, String thirdPartyApiUrl,
			String thirdPartyApiResultType, Boolean thirdPartyApiRunAtServer,
			String incProp, String excProp, String emotion, boolean enabled) {
		this.id = id;
		this.name = name;
		this.path = path;
		this.text = text;
		this.cat = cat;
		this.description = description;
		this.command = command;
		this.commandParam = commandParam;
		this.thirdPartyApiName = thirdPartyApiName;
		this.thirdPartyApiMethod = thirdPartyApiMethod;
		this.thirdPartyApiHeaderParams = thirdPartyApiHeaderParams;
		this.thirdPartyApiUrl = thirdPartyApiUrl;
		this.thirdPartyApiResultType = thirdPartyApiResultType;
		this.thirdPartyApiRunAtServer = thirdPartyApiRunAtServer;
		this.incProp = incProp;
		this.excProp = excProp;
		this.emotion = emotion;
		this.enabled = enabled;
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

	public String getPath() {
		return this.path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getText() {
		return this.text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public String getCat() {
		return this.cat;
	}

	public void setCat(String cat) {
		this.cat = cat;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Long getCommand() {
		return this.command;
	}

	public void setCommand(Long command) {
		this.command = command;
	}

	public String getCommandParam() {
		return this.commandParam;
	}

	public void setCommandParam(String commandParam) {
		this.commandParam = commandParam;
	}

	public String getThirdPartyApiName() {
		return this.thirdPartyApiName;
	}

	public void setThirdPartyApiName(String thirdPartyApiName) {
		this.thirdPartyApiName = thirdPartyApiName;
	}

	public String getThirdPartyApiMethod() {
		return this.thirdPartyApiMethod;
	}

	public void setThirdPartyApiMethod(String thirdPartyApiMethod) {
		this.thirdPartyApiMethod = thirdPartyApiMethod;
	}

	public String getThirdPartyApiHeaderParams() {
		return this.thirdPartyApiHeaderParams;
	}

	public void setThirdPartyApiHeaderParams(String thirdPartyApiHeaderParams) {
		this.thirdPartyApiHeaderParams = thirdPartyApiHeaderParams;
	}

	public String getThirdPartyApiUrl() {
		return this.thirdPartyApiUrl;
	}

	public void setThirdPartyApiUrl(String thirdPartyApiUrl) {
		this.thirdPartyApiUrl = thirdPartyApiUrl;
	}

	public String getThirdPartyApiResultType() {
		return this.thirdPartyApiResultType;
	}

	public void setThirdPartyApiResultType(String thirdPartyApiResultType) {
		this.thirdPartyApiResultType = thirdPartyApiResultType;
	}

	public Boolean getThirdPartyApiRunAtServer() {
		return this.thirdPartyApiRunAtServer;
	}

	public void setThirdPartyApiRunAtServer(Boolean thirdPartyApiRunAtServer) {
		this.thirdPartyApiRunAtServer = thirdPartyApiRunAtServer;
	}

	public String getIncProp() {
		return this.incProp;
	}

	public void setIncProp(String incProp) {
		this.incProp = incProp;
	}

	public String getExcProp() {
		return this.excProp;
	}

	public void setExcProp(String excProp) {
		this.excProp = excProp;
	}

	public String getEmotion() {
		return this.emotion;
	}

	public void setEmotion(String emotion) {
		this.emotion = emotion;
	}

	public boolean isEnabled() {
		return this.enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewVoiceId))
			return false;
		ViewVoiceId castOther = (ViewVoiceId) other;

		return (this.getId() == castOther.getId())
				&& ((this.getName() == castOther.getName()) || (this.getName() != null
						&& castOther.getName() != null && this.getName()
						.equals(castOther.getName())))
				&& ((this.getPath() == castOther.getPath()) || (this.getPath() != null
						&& castOther.getPath() != null && this.getPath()
						.equals(castOther.getPath())))
				&& ((this.getText() == castOther.getText()) || (this.getText() != null
						&& castOther.getText() != null && this.getText()
						.equals(castOther.getText())))
				&& ((this.getCat() == castOther.getCat()) || (this.getCat() != null
						&& castOther.getCat() != null && this.getCat().equals(
						castOther.getCat())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())))
				&& ((this.getCommand() == castOther.getCommand()) || (this
						.getCommand() != null && castOther.getCommand() != null && this
						.getCommand().equals(castOther.getCommand())))
				&& ((this.getCommandParam() == castOther.getCommandParam()) || (this
						.getCommandParam() != null
						&& castOther.getCommandParam() != null && this
						.getCommandParam().equals(castOther.getCommandParam())))
				&& ((this.getThirdPartyApiName() == castOther
						.getThirdPartyApiName()) || (this
						.getThirdPartyApiName() != null
						&& castOther.getThirdPartyApiName() != null && this
						.getThirdPartyApiName().equals(
								castOther.getThirdPartyApiName())))
				&& ((this.getThirdPartyApiMethod() == castOther
						.getThirdPartyApiMethod()) || (this
						.getThirdPartyApiMethod() != null
						&& castOther.getThirdPartyApiMethod() != null && this
						.getThirdPartyApiMethod().equals(
								castOther.getThirdPartyApiMethod())))
				&& ((this.getThirdPartyApiHeaderParams() == castOther
						.getThirdPartyApiHeaderParams()) || (this
						.getThirdPartyApiHeaderParams() != null
						&& castOther.getThirdPartyApiHeaderParams() != null && this
						.getThirdPartyApiHeaderParams().equals(
								castOther.getThirdPartyApiHeaderParams())))
				&& ((this.getThirdPartyApiUrl() == castOther
						.getThirdPartyApiUrl()) || (this.getThirdPartyApiUrl() != null
						&& castOther.getThirdPartyApiUrl() != null && this
						.getThirdPartyApiUrl().equals(
								castOther.getThirdPartyApiUrl())))
				&& ((this.getThirdPartyApiResultType() == castOther
						.getThirdPartyApiResultType()) || (this
						.getThirdPartyApiResultType() != null
						&& castOther.getThirdPartyApiResultType() != null && this
						.getThirdPartyApiResultType().equals(
								castOther.getThirdPartyApiResultType())))
				&& ((this.getThirdPartyApiRunAtServer() == castOther
						.getThirdPartyApiRunAtServer()) || (this
						.getThirdPartyApiRunAtServer() != null
						&& castOther.getThirdPartyApiRunAtServer() != null && this
						.getThirdPartyApiRunAtServer().equals(
								castOther.getThirdPartyApiRunAtServer())))
				&& ((this.getIncProp() == castOther.getIncProp()) || (this
						.getIncProp() != null && castOther.getIncProp() != null && this
						.getIncProp().equals(castOther.getIncProp())))
				&& ((this.getExcProp() == castOther.getExcProp()) || (this
						.getExcProp() != null && castOther.getExcProp() != null && this
						.getExcProp().equals(castOther.getExcProp())))
				&& ((this.getEmotion() == castOther.getEmotion()) || (this
						.getEmotion() != null && castOther.getEmotion() != null && this
						.getEmotion().equals(castOther.getEmotion())))
				&& (this.isEnabled() == castOther.isEnabled());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		result = 37 * result
				+ (getPath() == null ? 0 : this.getPath().hashCode());
		result = 37 * result
				+ (getText() == null ? 0 : this.getText().hashCode());
		result = 37 * result
				+ (getCat() == null ? 0 : this.getCat().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		result = 37 * result
				+ (getCommand() == null ? 0 : this.getCommand().hashCode());
		result = 37
				* result
				+ (getCommandParam() == null ? 0 : this.getCommandParam()
						.hashCode());
		result = 37
				* result
				+ (getThirdPartyApiName() == null ? 0 : this
						.getThirdPartyApiName().hashCode());
		result = 37
				* result
				+ (getThirdPartyApiMethod() == null ? 0 : this
						.getThirdPartyApiMethod().hashCode());
		result = 37
				* result
				+ (getThirdPartyApiHeaderParams() == null ? 0 : this
						.getThirdPartyApiHeaderParams().hashCode());
		result = 37
				* result
				+ (getThirdPartyApiUrl() == null ? 0 : this
						.getThirdPartyApiUrl().hashCode());
		result = 37
				* result
				+ (getThirdPartyApiResultType() == null ? 0 : this
						.getThirdPartyApiResultType().hashCode());
		result = 37
				* result
				+ (getThirdPartyApiRunAtServer() == null ? 0 : this
						.getThirdPartyApiRunAtServer().hashCode());
		result = 37 * result
				+ (getIncProp() == null ? 0 : this.getIncProp().hashCode());
		result = 37 * result
				+ (getExcProp() == null ? 0 : this.getExcProp().hashCode());
		result = 37 * result
				+ (getEmotion() == null ? 0 : this.getEmotion().hashCode());
		result = 37 * result + (this.isEnabled() ? 1 : 0);
		return result;
	}

}
