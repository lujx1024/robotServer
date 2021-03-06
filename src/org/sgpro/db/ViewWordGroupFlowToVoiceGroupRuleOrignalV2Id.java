package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * ViewWordGroupFlowToVoiceGroupRuleOrignalV2Id generated by hbm2java
 */
public class ViewWordGroupFlowToVoiceGroupRuleOrignalV2Id implements
		java.io.Serializable {

	private String request;
	private long createUserId;
	private long updateUserId;
	private Date createDatetime;
	private Date updateDatetime;
	private long genWordGroupFlowId;
	private Date genDatetime;
	private String name;
	private String path;
	private String emotion;
	private String text;
	private long command;
	private String commandParam;
	private long thirdPartyApiId;
	private long thirdPartyApiParamsValueId;
	private String incProp;
	private String cat;
	private String description;
	private long voiceId;
	private boolean voiceEnabled;
	private long orignalRuleId;

	public ViewWordGroupFlowToVoiceGroupRuleOrignalV2Id() {
	}

	public ViewWordGroupFlowToVoiceGroupRuleOrignalV2Id(String request,
			long createUserId, long updateUserId, Date createDatetime,
			Date updateDatetime, long genWordGroupFlowId, Date genDatetime,
			String name, String path, String emotion, String text,
			long command, String commandParam, long thirdPartyApiId,
			long thirdPartyApiParamsValueId, String incProp, String cat,
			String description, long voiceId, boolean voiceEnabled,
			long orignalRuleId) {
		this.request = request;
		this.createUserId = createUserId;
		this.updateUserId = updateUserId;
		this.createDatetime = createDatetime;
		this.updateDatetime = updateDatetime;
		this.genWordGroupFlowId = genWordGroupFlowId;
		this.genDatetime = genDatetime;
		this.name = name;
		this.path = path;
		this.emotion = emotion;
		this.text = text;
		this.command = command;
		this.commandParam = commandParam;
		this.thirdPartyApiId = thirdPartyApiId;
		this.thirdPartyApiParamsValueId = thirdPartyApiParamsValueId;
		this.incProp = incProp;
		this.cat = cat;
		this.description = description;
		this.voiceId = voiceId;
		this.voiceEnabled = voiceEnabled;
		this.orignalRuleId = orignalRuleId;
	}

	public String getRequest() {
		return this.request;
	}

	public void setRequest(String request) {
		this.request = request;
	}

	public long getCreateUserId() {
		return this.createUserId;
	}

	public void setCreateUserId(long createUserId) {
		this.createUserId = createUserId;
	}

	public long getUpdateUserId() {
		return this.updateUserId;
	}

	public void setUpdateUserId(long updateUserId) {
		this.updateUserId = updateUserId;
	}

	public Date getCreateDatetime() {
		return this.createDatetime;
	}

	public void setCreateDatetime(Date createDatetime) {
		this.createDatetime = createDatetime;
	}

	public Date getUpdateDatetime() {
		return this.updateDatetime;
	}

	public void setUpdateDatetime(Date updateDatetime) {
		this.updateDatetime = updateDatetime;
	}

	public long getGenWordGroupFlowId() {
		return this.genWordGroupFlowId;
	}

	public void setGenWordGroupFlowId(long genWordGroupFlowId) {
		this.genWordGroupFlowId = genWordGroupFlowId;
	}

	public Date getGenDatetime() {
		return this.genDatetime;
	}

	public void setGenDatetime(Date genDatetime) {
		this.genDatetime = genDatetime;
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

	public String getEmotion() {
		return this.emotion;
	}

	public void setEmotion(String emotion) {
		this.emotion = emotion;
	}

	public String getText() {
		return this.text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public long getCommand() {
		return this.command;
	}

	public void setCommand(long command) {
		this.command = command;
	}

	public String getCommandParam() {
		return this.commandParam;
	}

	public void setCommandParam(String commandParam) {
		this.commandParam = commandParam;
	}

	public long getThirdPartyApiId() {
		return this.thirdPartyApiId;
	}

	public void setThirdPartyApiId(long thirdPartyApiId) {
		this.thirdPartyApiId = thirdPartyApiId;
	}

	public long getThirdPartyApiParamsValueId() {
		return this.thirdPartyApiParamsValueId;
	}

	public void setThirdPartyApiParamsValueId(long thirdPartyApiParamsValueId) {
		this.thirdPartyApiParamsValueId = thirdPartyApiParamsValueId;
	}

	public String getIncProp() {
		return this.incProp;
	}

	public void setIncProp(String incProp) {
		this.incProp = incProp;
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

	public long getVoiceId() {
		return this.voiceId;
	}

	public void setVoiceId(long voiceId) {
		this.voiceId = voiceId;
	}

	public boolean isVoiceEnabled() {
		return this.voiceEnabled;
	}

	public void setVoiceEnabled(boolean voiceEnabled) {
		this.voiceEnabled = voiceEnabled;
	}

	public long getOrignalRuleId() {
		return this.orignalRuleId;
	}

	public void setOrignalRuleId(long orignalRuleId) {
		this.orignalRuleId = orignalRuleId;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewWordGroupFlowToVoiceGroupRuleOrignalV2Id))
			return false;
		ViewWordGroupFlowToVoiceGroupRuleOrignalV2Id castOther = (ViewWordGroupFlowToVoiceGroupRuleOrignalV2Id) other;

		return ((this.getRequest() == castOther.getRequest()) || (this
				.getRequest() != null && castOther.getRequest() != null && this
				.getRequest().equals(castOther.getRequest())))
				&& (this.getCreateUserId() == castOther.getCreateUserId())
				&& (this.getUpdateUserId() == castOther.getUpdateUserId())
				&& ((this.getCreateDatetime() == castOther.getCreateDatetime()) || (this
						.getCreateDatetime() != null
						&& castOther.getCreateDatetime() != null && this
						.getCreateDatetime().equals(
								castOther.getCreateDatetime())))
				&& ((this.getUpdateDatetime() == castOther.getUpdateDatetime()) || (this
						.getUpdateDatetime() != null
						&& castOther.getUpdateDatetime() != null && this
						.getUpdateDatetime().equals(
								castOther.getUpdateDatetime())))
				&& (this.getGenWordGroupFlowId() == castOther
						.getGenWordGroupFlowId())
				&& ((this.getGenDatetime() == castOther.getGenDatetime()) || (this
						.getGenDatetime() != null
						&& castOther.getGenDatetime() != null && this
						.getGenDatetime().equals(castOther.getGenDatetime())))
				&& ((this.getName() == castOther.getName()) || (this.getName() != null
						&& castOther.getName() != null && this.getName()
						.equals(castOther.getName())))
				&& ((this.getPath() == castOther.getPath()) || (this.getPath() != null
						&& castOther.getPath() != null && this.getPath()
						.equals(castOther.getPath())))
				&& ((this.getEmotion() == castOther.getEmotion()) || (this
						.getEmotion() != null && castOther.getEmotion() != null && this
						.getEmotion().equals(castOther.getEmotion())))
				&& ((this.getText() == castOther.getText()) || (this.getText() != null
						&& castOther.getText() != null && this.getText()
						.equals(castOther.getText())))
				&& (this.getCommand() == castOther.getCommand())
				&& ((this.getCommandParam() == castOther.getCommandParam()) || (this
						.getCommandParam() != null
						&& castOther.getCommandParam() != null && this
						.getCommandParam().equals(castOther.getCommandParam())))
				&& (this.getThirdPartyApiId() == castOther.getThirdPartyApiId())
				&& (this.getThirdPartyApiParamsValueId() == castOther
						.getThirdPartyApiParamsValueId())
				&& ((this.getIncProp() == castOther.getIncProp()) || (this
						.getIncProp() != null && castOther.getIncProp() != null && this
						.getIncProp().equals(castOther.getIncProp())))
				&& ((this.getCat() == castOther.getCat()) || (this.getCat() != null
						&& castOther.getCat() != null && this.getCat().equals(
						castOther.getCat())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())))
				&& (this.getVoiceId() == castOther.getVoiceId())
				&& (this.isVoiceEnabled() == castOther.isVoiceEnabled())
				&& (this.getOrignalRuleId() == castOther.getOrignalRuleId());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getRequest() == null ? 0 : this.getRequest().hashCode());
		result = 37 * result + (int) this.getCreateUserId();
		result = 37 * result + (int) this.getUpdateUserId();
		result = 37
				* result
				+ (getCreateDatetime() == null ? 0 : this.getCreateDatetime()
						.hashCode());
		result = 37
				* result
				+ (getUpdateDatetime() == null ? 0 : this.getUpdateDatetime()
						.hashCode());
		result = 37 * result + (int) this.getGenWordGroupFlowId();
		result = 37
				* result
				+ (getGenDatetime() == null ? 0 : this.getGenDatetime()
						.hashCode());
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		result = 37 * result
				+ (getPath() == null ? 0 : this.getPath().hashCode());
		result = 37 * result
				+ (getEmotion() == null ? 0 : this.getEmotion().hashCode());
		result = 37 * result
				+ (getText() == null ? 0 : this.getText().hashCode());
		result = 37 * result + (int) this.getCommand();
		result = 37
				* result
				+ (getCommandParam() == null ? 0 : this.getCommandParam()
						.hashCode());
		result = 37 * result + (int) this.getThirdPartyApiId();
		result = 37 * result + (int) this.getThirdPartyApiParamsValueId();
		result = 37 * result
				+ (getIncProp() == null ? 0 : this.getIncProp().hashCode());
		result = 37 * result
				+ (getCat() == null ? 0 : this.getCat().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		result = 37 * result + (int) this.getVoiceId();
		result = 37 * result + (this.isVoiceEnabled() ? 1 : 0);
		result = 37 * result + (int) this.getOrignalRuleId();
		return result;
	}

}
