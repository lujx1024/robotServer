package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * TblUserOfferSessionId generated by hbm2java
 */
public class TblUserOfferSessionId implements java.io.Serializable {

	private long id;
	private long offerUserId;
	private long answerUserId;
	private Date offerDatetime;
	private Date connectedDatetime;
	private Date disconnectedDatetime;

	public TblUserOfferSessionId() {
	}

	public TblUserOfferSessionId(long id, long offerUserId, long answerUserId,
			Date offerDatetime, Date connectedDatetime,
			Date disconnectedDatetime) {
		this.id = id;
		this.offerUserId = offerUserId;
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

	public long getOfferUserId() {
		return this.offerUserId;
	}

	public void setOfferUserId(long offerUserId) {
		this.offerUserId = offerUserId;
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
		if (!(other instanceof TblUserOfferSessionId))
			return false;
		TblUserOfferSessionId castOther = (TblUserOfferSessionId) other;

		return (this.getId() == castOther.getId())
				&& (this.getOfferUserId() == castOther.getOfferUserId())
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
		result = 37 * result + (int) this.getOfferUserId();
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
