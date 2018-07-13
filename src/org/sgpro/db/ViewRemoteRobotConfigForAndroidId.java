package org.sgpro.db;

public class ViewRemoteRobotConfigForAndroidId implements java.io.Serializable{
	
//	private String robotSn;
	private String appKey;
	private String secret;
	private String accessToken;
	private String voideUrl;
	private String controlUrl;
	private String deviceSerial;
	private String deviceName;
	private int cameraNo;
	
	public ViewRemoteRobotConfigForAndroidId() {
	}
	
//	public ViewRemoteRobotConfigForAndroidId(String robotSn, String appKey, String secret, String accessToken,
//			String voideUrl, String controlUrl) {
//		this.robotSn = robotSn;
//		this.appKey = appKey;
//		this.secret = secret;
//		this.accessToken = accessToken;
//		this.voideUrl = voideUrl;
//		this.controlUrl = controlUrl;
//	}


//	public String getRobotSn() {
//		return robotSn;
//	}
//
//	public void setRobotSn(String robotSn) {
//		this.robotSn = robotSn;
//	}

	public String getAppKey() {
		return appKey;
	}

	public ViewRemoteRobotConfigForAndroidId(String appKey, String secret, String accessToken, String voideUrl,
		String controlUrl, String deviceSerial, String deviceName, int cameraNo) {
	super();
	this.appKey = appKey;
	this.secret = secret;
	this.accessToken = accessToken;
	this.voideUrl = voideUrl;
	this.controlUrl = controlUrl;
	this.deviceSerial = deviceSerial;
	this.deviceName = deviceName;
	this.cameraNo = cameraNo;
}
	
	

	public String getDeviceSerial() {
		return deviceSerial;
	}

	public void setDeviceSerial(String deviceSerial) {
		this.deviceSerial = deviceSerial;
	}

	public String getDeviceName() {
		return deviceName;
	}

	public void setDeviceName(String deviceName) {
		this.deviceName = deviceName;
	}

	public int getCameraNo() {
		return cameraNo;
	}

	public void setCameraNo(int cameraNo) {
		this.cameraNo = cameraNo;
	}

	public void setAppKey(String appKey) {
		this.appKey = appKey;
	}

	public String getSecret() {
		return secret;
	}

	public void setSecret(String secret) {
		this.secret = secret;
	}

	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	public String getVoideUrl() {
		return voideUrl;
	}

	public void setVoideUrl(String voideUrl) {
		this.voideUrl = voideUrl;
	}

	public String getControlUrl() {
		return controlUrl;
	}

	public void setControlUrl(String controlUrl) {
		this.controlUrl = controlUrl;
	}
	
	
	

}
