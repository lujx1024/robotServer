package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * TblRobotOfferSessionId generated by hbm2java
 */
public class TblRobotOfferSessionId implements java.io.Serializable {

	private long id;
	private long offerRobotId;
	private long answerUserId;
	private Date offerDatetime;
	private Date connectedDatetime;
	private Date disconnectedDatetime;

	public TblRobotOfferSessionId() {
	}

	public TblRobotOfferSessionId(long id, long offerRobotId,
			long answerUserId, Date offerDatetime, Date connectedDatetime,
			Date disconnectedDatetime) {
		this.id = id;
		this.offerRobotId = offerRobotId;
		this.answerUserId = answerUserId;
		this.offerDatetime = offerDatetime;
		this.connectedDatetime = connectedDatetime;
		this.disconnectedDatetime = disconnectedDatetime;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public long getOfferRobotId() {
		return this.offerRobotId;
	}

	public void setOfferRobotId(long offerRobotId) {
		this.offerRobotId = offerRobotId;
	}

	public long getAnswerUserId() {
		return this.answerUserId;
	}

	public void setAnswerUserId(long answerUserId) {
		this.answerUserId = answerUserId;
	}

	public Date getOfferDatetime() {
		return this.offerDatetime;
	}

	public void setOfferDatetime(Date offerDatetime) {
		this.offerDatetime = offerDatetime;
	}

	public Date getConnectedDatetime() {
		return this.connectedDatetime;
	}

	public void setConnectedDatetime(Date connectedDatetime) {
		this.connectedDatetime = connectedDatetime;
	}

	public Date getDisconnectedDatetime() {
		return this.disconnectedDatetime;
	}

	public void setDisconnectedDatetime(Date disconnectedDatetime) {
		this.disconnectedDatetime = disconnectedDatetime;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TblRobotOfferSessionId))
			return false;
		TblRobotOfferSessionId castOther = (TblRobotOfferSessionId) other;

		return (this.getId() == castOther.getId())
				&& (this.getOfferRobotId() == castOther.getOfferRobotId())
				&& (this.getAnswerUserId() == castOther.getAnswerUserId())
				&& ((this.getOfferDatetime() == castOther.getOfferDatetime()) || (this
						.getOfferDatetime() != null
						&& castOther.getOfferDatetime() != null && this
						.getOfferDatetime()
						.equals(castOther.getOfferDatetime())))
				&& ((this.getConnectedDatetime() == castOther
						.getConnectedDatetime()) || (this
						.getConnectedDatetime() != null
						&& castOther.getConnectedDatetime() != null && this
						.getConnectedDatetime().equals(
								castOther.getConnectedDatetime())))
				&& ((this.getDisconnectedDatetime() == castOther
						.getDisconnectedDatetime()) || (this
						.getDisconnectedDatetime() != null
						&& castOther.getDisconnectedDatetime() != null && this
						.getDisconnectedDatetime().equals(
								castOther.getDisconnectedDatetime())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result + (int) this.getOfferRobotId();
		result = 37 * result + (int) this.getAnswerUserId();
		result = 37
				* result
				+ (getOfferDatetime() == null ? 0 : this.getOfferDatetime()
						.hashCode());
		result = 37
				* result
				+ (getConnectedDatetime() == null ? 0 : this
						.getConnectedDatetime().hashCode());
		result = 37
				* result
				+ (getDisconnectedDatetime() == null ? 0 : this
						.getDisconnectedDatetime().hashCode());
		return result;
	}

}
