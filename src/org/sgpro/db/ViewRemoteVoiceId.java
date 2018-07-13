package org.sgpro.db;

/**
 * ADD BY LvDW
 * 2018-05-02
 * */

public class ViewRemoteVoiceId implements java.io.Serializable {
	private long voiceId;
	private String voiceType;
	private String voiceName;
	private String voicePath;
	private String voiceText;
	private String voiceCat;
	private String voiceDescripition;
	private String voiceCommand;
	private String voiceCommandParam;
	private String voiceThirdpardName;
	private String voiceThirdpardMethod;
	private String voiceThirdpartyapiHeaderparams;
	private String voiceThirdpartyapiUrl;
	private String voiceThirdpartyapiResulttype;
	private boolean voiceThirdpartyapiRunatserver;
	private String voiceIncprop;
	private String voiceExcerpt;
	private String voiceEmotion;
	private boolean voiceEnabled;
	private String remake1;
	private String remake2;
	private String robotSn;
	
	
	public ViewRemoteVoiceId() {
	}


	public ViewRemoteVoiceId(long voiceId, String voiceType, String voiceName, String voicePath, String voiceText,
			String voiceCat, String voiceDescripition, String voiceCommand, String voiceCommandParam,
			String voiceThirdpardName, String voiceThirdpardMethod, String voiceThirdpartyapiHeaderparams,
			String voiceThirdpartyapiUrl, String voiceThirdpartyapiResulttype, boolean voiceThirdpartyapiRunatserver,
			String voiceIncprop, String voiceExcerpt, String voiceEmotion, boolean voiceEnabled, String remake1,
			String remake2,String robotSn) {
		this.voiceId = voiceId;
		this.voiceType = voiceType;
		this.voiceName = voiceName;
		this.voicePath = voicePath;
		this.voiceText = voiceText;
		this.voiceCat = voiceCat;
		this.voiceDescripition = voiceDescripition;
		this.voiceCommand = voiceCommand;
		this.voiceCommandParam = voiceCommandParam;
		this.voiceThirdpardName = voiceThirdpardName;
		this.voiceThirdpardMethod = voiceThirdpardMethod;
		this.voiceThirdpartyapiHeaderparams = voiceThirdpartyapiHeaderparams;
		this.voiceThirdpartyapiUrl = voiceThirdpartyapiUrl;
		this.voiceThirdpartyapiResulttype = voiceThirdpartyapiResulttype;
		this.voiceThirdpartyapiRunatserver = voiceThirdpartyapiRunatserver;
		this.voiceIncprop = voiceIncprop;
		this.voiceExcerpt = voiceExcerpt;
		this.voiceEmotion = voiceEmotion;
		this.voiceEnabled = voiceEnabled;
		this.remake1 = remake1;
		this.remake2 = remake2;
		this.robotSn = robotSn;
	}
	
	
	


	public ViewRemoteVoiceId(long voiceId, String voiceType, String voiceName, String voicePath, String voiceText,
			String voiceCat, String voiceDescripition, String voiceCommand, String voiceCommandParam,
			String voiceThirdpardName, String voiceThirdpardMethod, String voiceThirdpartyapiHeaderparams,
			String voiceThirdpartyapiUrl, String voiceThirdpartyapiResulttype, boolean voiceThirdpartyapiRunatserver,
			String voiceIncprop, String voiceExcerpt, String voiceEmotion, boolean voiceEnabled, String robotSn) {
		super();
		this.voiceId = voiceId;
		this.voiceType = voiceType;
		this.voiceName = voiceName;
		this.voicePath = voicePath;
		this.voiceText = voiceText;
		this.voiceCat = voiceCat;
		this.voiceDescripition = voiceDescripition;
		this.voiceCommand = voiceCommand;
		this.voiceCommandParam = voiceCommandParam;
		this.voiceThirdpardName = voiceThirdpardName;
		this.voiceThirdpardMethod = voiceThirdpardMethod;
		this.voiceThirdpartyapiHeaderparams = voiceThirdpartyapiHeaderparams;
		this.voiceThirdpartyapiUrl = voiceThirdpartyapiUrl;
		this.voiceThirdpartyapiResulttype = voiceThirdpartyapiResulttype;
		this.voiceThirdpartyapiRunatserver = voiceThirdpartyapiRunatserver;
		this.voiceIncprop = voiceIncprop;
		this.voiceExcerpt = voiceExcerpt;
		this.voiceEmotion = voiceEmotion;
		this.voiceEnabled = voiceEnabled;
		this.robotSn = robotSn;
	}


	public long getVoiceId() {
		return voiceId;
	}


	public void setVoiceId(long voiceId) {
		this.voiceId = voiceId;
	}


	public String getVoiceType() {
		return voiceType;
	}


	public void setVoiceType(String voiceType) {
		this.voiceType = voiceType;
	}


	public String getVoiceName() {
		return voiceName;
	}


	public void setVoiceName(String voiceName) {
		this.voiceName = voiceName;
	}


	public String getVoicePath() {
		return voicePath;
	}


	public void setVoicePath(String voicePath) {
		this.voicePath = voicePath;
	}


	public String getVoiceText() {
		return voiceText;
	}


	public void setVoiceText(String voiceText) {
		this.voiceText = voiceText;
	}


	public String getVoiceCat() {
		return voiceCat;
	}


	public void setVoiceCat(String voiceCat) {
		this.voiceCat = voiceCat;
	}


	public String getVoiceDescripition() {
		return voiceDescripition;
	}


	public void setVoiceDescripition(String voiceDescripition) {
		this.voiceDescripition = voiceDescripition;
	}


	public String getVoiceCommand() {
		return voiceCommand;
	}


	public void setVoiceCommand(String voiceCommand) {
		this.voiceCommand = voiceCommand;
	}


	public String getVoiceCommandParam() {
		return voiceCommandParam;
	}


	public void setVoiceCommandParam(String voiceCommandParam) {
		this.voiceCommandParam = voiceCommandParam;
	}


	public String getVoiceThirdpardName() {
		return voiceThirdpardName;
	}


	public void setVoiceThirdpardName(String voiceThirdpardName) {
		this.voiceThirdpardName = voiceThirdpardName;
	}


	public String getVoiceThirdpardMethod() {
		return voiceThirdpardMethod;
	}


	public void setVoiceThirdpardMethod(String voiceThirdpardMethod) {
		this.voiceThirdpardMethod = voiceThirdpardMethod;
	}


	public String getVoiceThirdpartyapiHeaderparams() {
		return voiceThirdpartyapiHeaderparams;
	}


	public void setVoiceThirdpartyapiHeaderparams(String voiceThirdpartyapiHeaderparams) {
		this.voiceThirdpartyapiHeaderparams = voiceThirdpartyapiHeaderparams;
	}


	public String getVoiceThirdpartyapiUrl() {
		return voiceThirdpartyapiUrl;
	}


	public void setVoiceThirdpartyapiUrl(String voiceThirdpartyapiUrl) {
		this.voiceThirdpartyapiUrl = voiceThirdpartyapiUrl;
	}


	public String getVoiceThirdpartyapiResulttype() {
		return voiceThirdpartyapiResulttype;
	}


	public void setVoiceThirdpartyapiResulttype(String voiceThirdpartyapiResulttype) {
		this.voiceThirdpartyapiResulttype = voiceThirdpartyapiResulttype;
	}


	public boolean isVoiceThirdpartyapiRunatserver() {
		return voiceThirdpartyapiRunatserver;
	}


	public void setVoiceThirdpartyapiRunatserver(boolean voiceThirdpartyapiRunatserver) {
		this.voiceThirdpartyapiRunatserver = voiceThirdpartyapiRunatserver;
	}


	public String getVoiceIncprop() {
		return voiceIncprop;
	}


	public void setVoiceIncprop(String voiceIncprop) {
		this.voiceIncprop = voiceIncprop;
	}


	public String getVoiceExcerpt() {
		return voiceExcerpt;
	}


	public void setVoiceExcerpt(String voiceExcerpt) {
		this.voiceExcerpt = voiceExcerpt;
	}


	public String getVoiceEmotion() {
		return voiceEmotion;
	}


	public void setVoiceEmotion(String voiceEmotion) {
		this.voiceEmotion = voiceEmotion;
	}


	public boolean isVoiceEnabled() {
		return voiceEnabled;
	}


	public void setVoiceEnabled(boolean voiceEnabled) {
		this.voiceEnabled = voiceEnabled;
	}


	public String getRemake1() {
		return remake1;
	}


	public void setRemake1(String remake1) {
		this.remake1 = remake1;
	}


	public String getRemake2() {
		return remake2;
	}


	public void setRemake2(String remake2) {
		this.remake2 = remake2;
	}


	public String getRobotSn() {
		return robotSn;
	}


	public void setRobotSn(String robotSn) {
		this.robotSn = robotSn;
	}
}
