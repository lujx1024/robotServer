package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblThirdPartyApiParamValueId generated by hbm2java
 */
public class TblThirdPartyApiParamValueId implements java.io.Serializable {

	private long thirdPartyApiParamValueId;
	private long thirdPartyApiParamId;

	public TblThirdPartyApiParamValueId() {
	}

	public TblThirdPartyApiParamValueId(long thirdPartyApiParamValueId,
			long thirdPartyApiParamId) {
		this.thirdPartyApiParamValueId = thirdPartyApiParamValueId;
		this.thirdPartyApiParamId = thirdPartyApiParamId;
	}

	public long getThirdPartyApiParamValueId() {
		return this.thirdPartyApiParamValueId;
	}

	public void setThirdPartyApiParamValueId(long thirdPartyApiParamValueId) {
		this.thirdPartyApiParamValueId = thirdPartyApiParamValueId;
	}

	public long getThirdPartyApiParamId() {
		return this.thirdPartyApiParamId;
	}

	public void setThirdPartyApiParamId(long thirdPartyApiParamId) {
		this.thirdPartyApiParamId = thirdPartyApiParamId;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TblThirdPartyApiParamValueId))
			return false;
		TblThirdPartyApiParamValueId castOther = (TblThirdPartyApiParamValueId) other;

		return (this.getThirdPartyApiParamValueId() == castOther
				.getThirdPartyApiParamValueId())
				&& (this.getThirdPartyApiParamId() == castOther
						.getThirdPartyApiParamId());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getThirdPartyApiParamValueId();
		result = 37 * result + (int) this.getThirdPartyApiParamId();
		return result;
	}

}
