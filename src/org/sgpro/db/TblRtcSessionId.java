package org.sgpro.db;



// Generated 2016-4-5 17:47:06 by Hibernate Tools 4.0.0

/**
 * TblRtcSessionId generated by hbm2java
 */
public class TblRtcSessionId implements java.io.Serializable {

	private long id;
	private long robotId;
	private long userId;
	private boolean robotInitiate;

	public TblRtcSessionId() {
	}

	public TblRtcSessionId(long id, long robotId, long userId,
			boolean robotInitiate) {
		this.id = id;
		this.robotId = robotId;
		this.userId = userId;
		this.robotInitiate = robotInitiate;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getRobotId() {
		return this.robotId;
	}

	public void setRobotId(long robotId) {
		this.robotId = robotId;
	}

	public long getUserId() {
		return this.userId;
	}

	public void setUserId(long userId) {
		this.userId = userId;
	}

	public boolean isRobotInitiate() {
		return this.robotInitiate;
	}

	public void setRobotInitiate(boolean robotInitiate) {
		this.robotInitiate = robotInitiate;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TblRtcSessionId))
			return false;
		TblRtcSessionId castOther = (TblRtcSessionId) other;

		return (this.getId() == castOther.getId())
				&& (this.getRobotId() == castOther.getRobotId())
				&& (this.getUserId() == castOther.getUserId())
				&& (this.isRobotInitiate() == castOther.isRobotInitiate());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result + (int) this.getRobotId();
		result = 37 * result + (int) this.getUserId();
		result = 37 * result + (this.isRobotInitiate() ? 1 : 0);
		return result;
	}

}
