package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewFlowVoiceRuleId generated by hbm2java
 */
public class ViewFlowVoiceRuleId implements java.io.Serializable {

	private long id;
	private long flowId;
	private String flowName;
	private long voiceId;
	private String voiceName;
	private boolean enable;
	private String description;
	private boolean useFullyMatch;

	public ViewFlowVoiceRuleId() {
	}

	public ViewFlowVoiceRuleId(long id, long flowId, String flowName,
			long voiceId, String voiceName, boolean enable, String description,
			boolean useFullyMatch) {
		this.id = id;
		this.flowId = flowId;
		this.flowName = flowName;
		this.voiceId = voiceId;
		this.voiceName = voiceName;
		this.enable = enable;
		this.description = description;
		this.useFullyMatch = useFullyMatch;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getFlowId() {
		return this.flowId;
	}

	public void setFlowId(long flowId) {
		this.flowId = flowId;
	}

	public String getFlowName() {
		return this.flowName;
	}

	public void setFlowName(String flowName) {
		this.flowName = flowName;
	}

	public long getVoiceId() {
		return this.voiceId;
	}

	public void setVoiceId(long voiceId) {
		this.voiceId = voiceId;
	}

	public String getVoiceName() {
		return this.voiceName;
	}

	public void setVoiceName(String voiceName) {
		this.voiceName = voiceName;
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

	public boolean isUseFullyMatch() {
		return this.useFullyMatch;
	}

	public void setUseFullyMatch(boolean useFullyMatch) {
		this.useFullyMatch = useFullyMatch;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewFlowVoiceRuleId))
			return false;
		ViewFlowVoiceRuleId castOther = (ViewFlowVoiceRuleId) other;

		return (this.getId() == castOther.getId())
				&& (this.getFlowId() == castOther.getFlowId())
				&& ((this.getFlowName() == castOther.getFlowName()) || (this
						.getFlowName() != null
						&& castOther.getFlowName() != null && this
						.getFlowName().equals(castOther.getFlowName())))
				&& (this.getVoiceId() == castOther.getVoiceId())
				&& ((this.getVoiceName() == castOther.getVoiceName()) || (this
						.getVoiceName() != null
						&& castOther.getVoiceName() != null && this
						.getVoiceName().equals(castOther.getVoiceName())))
				&& (this.isEnable() == castOther.isEnable())
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())))
				&& (this.isUseFullyMatch() == castOther.isUseFullyMatch());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result + (int) this.getFlowId();
		result = 37 * result
				+ (getFlowName() == null ? 0 : this.getFlowName().hashCode());
		result = 37 * result + (int) this.getVoiceId();
		result = 37 * result
				+ (getVoiceName() == null ? 0 : this.getVoiceName().hashCode());
		result = 37 * result + (this.isEnable() ? 1 : 0);
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		result = 37 * result + (this.isUseFullyMatch() ? 1 : 0);
		return result;
	}

}
