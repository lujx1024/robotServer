package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblVoiceTagId generated by hbm2java
 */
public class TblVoiceTagId implements java.io.Serializable {

	private long voiceId;
	private String tag;

	public TblVoiceTagId() {
	}

	public TblVoiceTagId(long voiceId, String tag) {
		this.voiceId = voiceId;
		this.tag = tag;
	}

	public long getVoiceId() {
		return this.voiceId;
	}

	public void setVoiceId(long voiceId) {
		this.voiceId = voiceId;
	}

	public String getTag() {
		return this.tag;
	}

	public void setTag(String tag) {
		this.tag = tag;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TblVoiceTagId))
			return false;
		TblVoiceTagId castOther = (TblVoiceTagId) other;

		return (this.getVoiceId() == castOther.getVoiceId())
				&& ((this.getTag() == castOther.getTag()) || (this.getTag() != null
						&& castOther.getTag() != null && this.getTag().equals(
						castOther.getTag())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getVoiceId();
		result = 37 * result
				+ (getTag() == null ? 0 : this.getTag().hashCode());
		return result;
	}

}
