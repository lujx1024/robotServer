package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;

/**
 * EntDialog generated by hbm2java
 */
public class EntDialog implements java.io.Serializable {

	private long id;
	private String request;
	private String requestEpSn;
	private String requestModel;
	private String requestClientIp;
	private String requestClientVersion;
	private String requestAddr;
	private String response1;
	private String response2;
	private String response3;
	private String response4;
	private String response5;
	private String response6;
	private String response7;
	private String response8;
	private String response9;
	private String response10;
	private String response11;
	private String response12;
	private String response13;
	private String response14;
	private String response15;
	private String response16;
	private Long execMillsecs;
	private Date dateTime;

	public EntDialog() {
	}

	public EntDialog(long id, String request, Date dateTime) {
		this.id = id;
		this.request = request;
		this.dateTime = dateTime;
	}

	public EntDialog(long id, String request, String requestEpSn,
			String requestModel, String requestClientIp,
			String requestClientVersion, String requestAddr, String response1,
			String response2, String response3, String response4,
			String response5, String response6, String response7,
			String response8, String response9, String response10,
			String response11, String response12, String response13,
			String response14, String response15, String response16,
			Long execMillsecs, Date dateTime) {
		this.id = id;
		this.request = request;
		this.requestEpSn = requestEpSn;
		this.requestModel = requestModel;
		this.requestClientIp = requestClientIp;
		this.requestClientVersion = requestClientVersion;
		this.requestAddr = requestAddr;
		this.response1 = response1;
		this.response2 = response2;
		this.response3 = response3;
		this.response4 = response4;
		this.response5 = response5;
		this.response6 = response6;
		this.response7 = response7;
		this.response8 = response8;
		this.response9 = response9;
		this.response10 = response10;
		this.response11 = response11;
		this.response12 = response12;
		this.response13 = response13;
		this.response14 = response14;
		this.response15 = response15;
		this.response16 = response16;
		this.execMillsecs = execMillsecs;
		this.dateTime = dateTime;
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

	public String getRequestEpSn() {
		return this.requestEpSn;
	}

	public void setRequestEpSn(String requestEpSn) {
		this.requestEpSn = requestEpSn;
	}

	public String getRequestModel() {
		return this.requestModel;
	}

	public void setRequestModel(String requestModel) {
		this.requestModel = requestModel;
	}

	public String getRequestClientIp() {
		return this.requestClientIp;
	}

	public void setRequestClientIp(String requestClientIp) {
		this.requestClientIp = requestClientIp;
	}

	public String getRequestClientVersion() {
		return this.requestClientVersion;
	}

	public void setRequestClientVersion(String requestClientVersion) {
		this.requestClientVersion = requestClientVersion;
	}

	public String getRequestAddr() {
		return this.requestAddr;
	}

	public void setRequestAddr(String requestAddr) {
		this.requestAddr = requestAddr;
	}

	public String getResponse1() {
		return this.response1;
	}

	public void setResponse1(String response1) {
		this.response1 = response1;
	}

	public String getResponse2() {
		return this.response2;
	}

	public void setResponse2(String response2) {
		this.response2 = response2;
	}

	public String getResponse3() {
		return this.response3;
	}

	public void setResponse3(String response3) {
		this.response3 = response3;
	}

	public String getResponse4() {
		return this.response4;
	}

	public void setResponse4(String response4) {
		this.response4 = response4;
	}

	public String getResponse5() {
		return this.response5;
	}

	public void setResponse5(String response5) {
		this.response5 = response5;
	}

	public String getResponse6() {
		return this.response6;
	}

	public void setResponse6(String response6) {
		this.response6 = response6;
	}

	public String getResponse7() {
		return this.response7;
	}

	public void setResponse7(String response7) {
		this.response7 = response7;
	}

	public String getResponse8() {
		return this.response8;
	}

	public void setResponse8(String response8) {
		this.response8 = response8;
	}

	public String getResponse9() {
		return this.response9;
	}

	public void setResponse9(String response9) {
		this.response9 = response9;
	}

	public String getResponse10() {
		return this.response10;
	}

	public void setResponse10(String response10) {
		this.response10 = response10;
	}

	public String getResponse11() {
		return this.response11;
	}

	public void setResponse11(String response11) {
		this.response11 = response11;
	}

	public String getResponse12() {
		return this.response12;
	}

	public void setResponse12(String response12) {
		this.response12 = response12;
	}

	public String getResponse13() {
		return this.response13;
	}

	public void setResponse13(String response13) {
		this.response13 = response13;
	}

	public String getResponse14() {
		return this.response14;
	}

	public void setResponse14(String response14) {
		this.response14 = response14;
	}

	public String getResponse15() {
		return this.response15;
	}

	public void setResponse15(String response15) {
		this.response15 = response15;
	}

	public String getResponse16() {
		return this.response16;
	}

	public void setResponse16(String response16) {
		this.response16 = response16;
	}

	public Long getExecMillsecs() {
		return this.execMillsecs;
	}

	public void setExecMillsecs(Long execMillsecs) {
		this.execMillsecs = execMillsecs;
	}

	public Date getDateTime() {
		return this.dateTime;
	}

	public void setDateTime(Date dateTime) {
		this.dateTime = dateTime;
	}

}
