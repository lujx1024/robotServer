package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewRobotConfigWithOwnerId generated by hbm2java
 */
public class ViewRobotConfigWithOwnerId implements java.io.Serializable {

	private int priority;
	private long ownerId;
	private String ownerName;
	private long robotId;
	private String robotImei;
	private String name;
	private String value;
	private String description;

	public ViewRobotConfigWithOwnerId() {
	}

	public ViewRobotConfigWithOwnerId(int priority, long ownerId,
			String ownerName, long robotId, String robotImei, String name,
			String value, String description) {
		this.priority = priority;
		this.ownerId = ownerId;
		this.ownerName = ownerName;
		this.robotId = robotId;
		this.robotImei = robotImei;
		this.name = name;
		this.value = value;
		this.description = description;
	}

	public int getPriority() {
		return this.priority;
	}

	public void setPriority(int priority) {
		this.priority = priority;
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
		if (!(other instanceof ViewRobotConfigWithOwnerId))
			return false;
		ViewRobotConfigWithOwnerId castOther = (ViewRobotConfigWithOwnerId) other;

		return (this.getPriority() == castOther.getPriority())
				&& (this.getOwnerId() == castOther.getOwnerId())
				&& ((this.getOwnerName() == castOther.getOwnerName()) || (this
						.getOwnerName() != null
						&& castOther.getOwnerName() != null && this
						.getOwnerName().equals(castOther.getOwnerName())))
				&& (this.getRobotId() == castOther.getRobotId())
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
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + this.getPriority();
		result = 37 * result + (int) this.getOwnerId();
		result = 37 * result
				+ (getOwnerName() == null ? 0 : this.getOwnerName().hashCode());
		result = 37 * result + (int) this.getRobotId();
		result = 37 * result
				+ (getRobotImei() == null ? 0 : this.getRobotImei().hashCode());
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		result = 37 * result
				+ (getValue() == null ? 0 : this.getValue().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		return result;
	}

}
