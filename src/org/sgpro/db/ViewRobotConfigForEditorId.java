package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewRobotConfigForEditorId generated by hbm2java
 */
public class ViewRobotConfigForEditorId implements java.io.Serializable {

	private int priority;
	private String robotImei;
	private String name;
	private String value;
	private long ownerId;
	private String ownerName;
	private long robotId;
	private String candidate;
	private String description;
	private long level;
	private String limitH;
	private String limitL;
	private String pattern;
	private String type;

	public ViewRobotConfigForEditorId() {
	}

	public ViewRobotConfigForEditorId(int priority, String robotImei,
			String name, String value, long ownerId, String ownerName,
			long robotId, String candidate, String description, long level,
			String limitH, String limitL, String pattern, String type) {
		this.priority = priority;
		this.robotImei = robotImei;
		this.name = name;
		this.value = value;
		this.ownerId = ownerId;
		this.ownerName = ownerName;
		this.robotId = robotId;
		this.candidate = candidate;
		this.description = description;
		this.level = level;
		this.limitH = limitH;
		this.limitL = limitL;
		this.pattern = pattern;
		this.type = type;
	}

	public int getPriority() {
		return this.priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
	}

	public String getRobotImei() {
		return this.robotImei;
	}

	public void setRobotImei(String robotImei) {
		this.robotImei = robotImei;
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

	public long getOwnerId() {
		return this.ownerId;
	}

	public void setOwnerId(long ownerId) {
		this.ownerId = ownerId;
	}

	public String getOwnerName() {
		return this.ownerName;
	}

	public void setOwnerName(String ownerName) {
		this.ownerName = ownerName;
	}

	public long getRobotId() {
		return this.robotId;
	}

	public void setRobotId(long robotId) {
		this.robotId = robotId;
	}

	public String getCandidate() {
		return this.candidate;
	}

	public void setCandidate(String candidate) {
		this.candidate = candidate;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public long getLevel() {
		return this.level;
	}

	public void setLevel(long level) {
		this.level = level;
	}

	public String getLimitH() {
		return this.limitH;
	}

	public void setLimitH(String limitH) {
		this.limitH = limitH;
	}

	public String getLimitL() {
		return this.limitL;
	}

	public void setLimitL(String limitL) {
		this.limitL = limitL;
	}

	public String getPattern() {
		return this.pattern;
	}

	public void setPattern(String pattern) {
		this.pattern = pattern;
	}

	public String getType() {
		return this.type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewRobotConfigForEditorId))
			return false;
		ViewRobotConfigForEditorId castOther = (ViewRobotConfigForEditorId) other;

		return (this.getPriority() == castOther.getPriority())
				&& ((this.getRobotImei() == castOther.getRobotImei()) || (this
						.getRobotImei() != null
						&& castOther.getRobotImei() != null && this
						.getRobotImei().equals(castOther.getRobotImei())))
				&& ((this.getName() == castOther.getName()) || (this.getName() != null
						&& castOther.getName() != null && this.getName()
						.equals(castOther.getName())))
				&& ((this.getValue() == castOther.getValue()) || (this
						.getValue() != null && castOther.getValue() != null && this
						.getValue().equals(castOther.getValue())))
				&& (this.getOwnerId() == castOther.getOwnerId())
				&& ((this.getOwnerName() == castOther.getOwnerName()) || (this
						.getOwnerName() != null
						&& castOther.getOwnerName() != null && this
						.getOwnerName().equals(castOther.getOwnerName())))
				&& (this.getRobotId() == castOther.getRobotId())
				&& ((this.getCandidate() == castOther.getCandidate()) || (this
						.getCandidate() != null
						&& castOther.getCandidate() != null && this
						.getCandidate().equals(castOther.getCandidate())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())))
				&& (this.getLevel() == castOther.getLevel())
				&& ((this.getLimitH() == castOther.getLimitH()) || (this
						.getLimitH() != null && castOther.getLimitH() != null && this
						.getLimitH().equals(castOther.getLimitH())))
				&& ((this.getLimitL() == castOther.getLimitL()) || (this
						.getLimitL() != null && castOther.getLimitL() != null && this
						.getLimitL().equals(castOther.getLimitL())))
				&& ((this.getPattern() == castOther.getPattern()) || (this
						.getPattern() != null && castOther.getPattern() != null && this
						.getPattern().equals(castOther.getPattern())))
				&& ((this.getType() == castOther.getType()) || (this.getType() != null
						&& castOther.getType() != null && this.getType()
						.equals(castOther.getType())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + this.getPriority();
		result = 37 * result
				+ (getRobotImei() == null ? 0 : this.getRobotImei().hashCode());
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		result = 37 * result
				+ (getValue() == null ? 0 : this.getValue().hashCode());
		result = 37 * result + (int) this.getOwnerId();
		result = 37 * result
				+ (getOwnerName() == null ? 0 : this.getOwnerName().hashCode());
		result = 37 * result + (int) this.getRobotId();
		result = 37 * result
				+ (getCandidate() == null ? 0 : this.getCandidate().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		result = 37 * result + (int) this.getLevel();
		result = 37 * result
				+ (getLimitH() == null ? 0 : this.getLimitH().hashCode());
		result = 37 * result
				+ (getLimitL() == null ? 0 : this.getLimitL().hashCode());
		result = 37 * result
				+ (getPattern() == null ? 0 : this.getPattern().hashCode());
		result = 37 * result
				+ (getType() == null ? 0 : this.getType().hashCode());
		return result;
	}

}
