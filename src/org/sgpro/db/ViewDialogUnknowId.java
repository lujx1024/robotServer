package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * ViewDialogUnknowId generated by hbm2java
 */
public class ViewDialogUnknowId implements java.io.Serializable {

	private long id;
	private String request;
	private String requestModel;
	private Date datetime;

	public ViewDialogUnknowId() {
	}

	public ViewDialogUnknowId(long id, String request, Date datetime) {
		this.id = id;
		this.request = request;
		this.datetime = datetime;
	}

	public ViewDialogUnknowId(long id, String request, String requestModel,
			Date datetime) {
		this.id = id;
		this.request = request;
		this.requestModel = requestModel;
		this.datetime = datetime;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getRequest() {
		return this.request;
	}

	public void setRequest(String request) {
		this.request = request;
	}

	public String getRequestModel() {
		return this.requestModel;
	}

	public void setRequestModel(String requestModel) {
		this.requestModel = requestModel;
	}

	public Date getDatetime() {
		return this.datetime;
	}

	public void setDatetime(Date datetime) {
		this.datetime = datetime;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewDialogUnknowId))
			return false;
		ViewDialogUnknowId castOther = (ViewDialogUnknowId) other;

		return (this.getId() == castOther.getId())
				&& ((this.getRequest() == castOther.getRequest()) || (this
						.getRequest() != null && castOther.getRequest() != null && this
						.getRequest().equals(castOther.getRequest())))
				&& ((this.getRequestModel() == castOther.getRequestModel()) || (this
						.getRequestModel() != null
						&& castOther.getRequestModel() != null && this
						.getRequestModel().equals(castOther.getRequestModel())))
				&& ((this.getDatetime() == castOther.getDatetime()) || (this
						.getDatetime() != null
						&& castOther.getDatetime() != null && this
						.getDatetime().equals(castOther.getDatetime())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result
				+ (getRequest() == null ? 0 : this.getRequest().hashCode());
		result = 37
				* result
				+ (getRequestModel() == null ? 0 : this.getRequestModel()
						.hashCode());
		result = 37 * result
				+ (getDatetime() == null ? 0 : this.getDatetime().hashCode());
		return result;
	}

}
