package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

/**
 * EntRequest generated by hbm2java
 */
public class EntRequest implements java.io.Serializable {

	private String id;
	private String path;
	private String input;
	private String lexer;
	private String sn;
	private String robotId;
	private String tag;
	private String randint;
	private String userAgent;
	private String start;
	private String timegreeting;
	private String clientIp;
	private String currentDate;
	private String HVersion;
	private String HLatitude;
	private String HLongtitude;
	private String HCity;
	private String HAddr;
	private String HCountry;
	private String HAddrdesc;
	private String HStreet;
	private Date datetime;
	private Date execStartDatetime;
	private Set tblRequestProperties = new HashSet(0);

	public EntRequest() {
	}

	public EntRequest(String id) {
		this.id = id;
	}

	public EntRequest(String id, String path, String input, String lexer,
			String sn, String robotId, String tag, String randint,
			String userAgent, String start, String timegreeting,
			String clientIp, String currentDate, String HVersion,
			String HLatitude, String HLongtitude, String HCity, String HAddr,
			String HCountry, String HAddrdesc, String HStreet, Date datetime,
			Date execStartDatetime, Set tblRequestProperties) {
		this.id = id;
		this.path = path;
		this.input = input;
		this.lexer = lexer;
		this.sn = sn;
		this.robotId = robotId;
		this.tag = tag;
		this.randint = randint;
		this.userAgent = userAgent;
		this.start = start;
		this.timegreeting = timegreeting;
		this.clientIp = clientIp;
		this.currentDate = currentDate;
		this.HVersion = HVersion;
		this.HLatitude = HLatitude;
		this.HLongtitude = HLongtitude;
		this.HCity = HCity;
		this.HAddr = HAddr;
		this.HCountry = HCountry;
		this.HAddrdesc = HAddrdesc;
		this.HStreet = HStreet;
		this.datetime = datetime;
		this.execStartDatetime = execStartDatetime;
		this.tblRequestProperties = tblRequestProperties;
	}

	public String getId() {
		return this.id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPath() {
		return this.path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getInput() {
		return this.input;
	}

	public void setInput(String input) {
		this.input = input;
	}

	public String getLexer() {
		return this.lexer;
	}

	public void setLexer(String lexer) {
		this.lexer = lexer;
	}

	public String getSn() {
		return this.sn;
	}

	public void setSn(String sn) {
		this.sn = sn;
	}

	public String getRobotId() {
		return this.robotId;
	}

	public void setRobotId(String robotId) {
		this.robotId = robotId;
	}

	public String getTag() {
		return this.tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public String getRandint() {
		return this.randint;
	}

	public void setRandint(String randint) {
		this.randint = randint;
	}

	public String getUserAgent() {
		return this.userAgent;
	}

	public void setUserAgent(String userAgent) {
		this.userAgent = userAgent;
	}

	public String getStart() {
		return this.start;
	}

	public void setStart(String start) {
		this.start = start;
	}

	public String getTimegreeting() {
		return this.timegreeting;
	}

	public void setTimegreeting(String timegreeting) {
		this.timegreeting = timegreeting;
	}

	public String getClientIp() {
		return this.clientIp;
	}

	public void setClientIp(String clientIp) {
		this.clientIp = clientIp;
	}

	public String getCurrentDate() {
		return this.currentDate;
	}

	public void setCurrentDate(String currentDate) {
		this.currentDate = currentDate;
	}

	public String getHVersion() {
		return this.HVersion;
	}

	public void setHVersion(String HVersion) {
		this.HVersion = HVersion;
	}

	public String getHLatitude() {
		return this.HLatitude;
	}

	public void setHLatitude(String HLatitude) {
		this.HLatitude = HLatitude;
	}

	public String getHLongtitude() {
		return this.HLongtitude;
	}

	public void setHLongtitude(String HLongtitude) {
		this.HLongtitude = HLongtitude;
	}

	public String getHCity() {
		return this.HCity;
	}

	public void setHCity(String HCity) {
		this.HCity = HCity;
	}

	public String getHAddr() {
		return this.HAddr;
	}

	public void setHAddr(String HAddr) {
		this.HAddr = HAddr;
	}

	public String getHCountry() {
		return this.HCountry;
	}

	public void setHCountry(String HCountry) {
		this.HCountry = HCountry;
	}

	public String getHAddrdesc() {
		return this.HAddrdesc;
	}

	public void setHAddrdesc(String HAddrdesc) {
		this.HAddrdesc = HAddrdesc;
	}

	public String getHStreet() {
		return this.HStreet;
	}

	public void setHStreet(String HStreet) {
		this.HStreet = HStreet;
	}

	public Date getDatetime() {
		return this.datetime;
	}

	public void setDatetime(Date datetime) {
		this.datetime = datetime;
	}

	public Date getExecStartDatetime() {
		return this.execStartDatetime;
	}

	public void setExecStartDatetime(Date execStartDatetime) {
		this.execStartDatetime = execStartDatetime;
	}

	public Set getTblRequestProperties() {
		return this.tblRequestProperties;
	}

	public void setTblRequestProperties(Set tblRequestProperties) {
		this.tblRequestProperties = tblRequestProperties;
	}

}
