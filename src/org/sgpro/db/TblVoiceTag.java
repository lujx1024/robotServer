package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblVoiceTag generated by hbm2java
 */
public class TblVoiceTag implements java.io.Serializable {

	private TblVoiceTagId id;
	private EntVoice entVoice;

	public TblVoiceTag() {
	}

	public TblVoiceTag(TblVoiceTagId id, EntVoice entVoice) {
		this.id = id;
		this.entVoice = entVoice;
	}

	public TblVoiceTagId getId() {
		return this.id;
	}

	public void setId(TblVoiceTagId id) {
		this.id = id;
	}

	public EntVoice getEntVoice() {
		return this.entVoice;
	}

	public void setEntVoice(EntVoice entVoice) {
		this.entVoice = entVoice;
	}

}
