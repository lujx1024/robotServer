package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * EntPinyin2Id generated by hbm2java
 */
public class EntPinyin2Id implements java.io.Serializable {

	private Character chr;
	private String py;

	public EntPinyin2Id() {
	}

	public EntPinyin2Id(Character chr, String py) {
		this.chr = chr;
		this.py = py;
	}

	public Character getChr() {
		return this.chr;
	}

	public void setChr(Character chr) {
		this.chr = chr;
	}

	public String getPy() {
		return this.py;
	}

	public void setPy(String py) {
		this.py = py;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof EntPinyin2Id))
			return false;
		EntPinyin2Id castOther = (EntPinyin2Id) other;

		return ((this.getChr() == castOther.getChr()) || (this.getChr() != null
				&& castOther.getChr() != null && this.getChr().equals(
				castOther.getChr())))
				&& ((this.getPy() == castOther.getPy()) || (this.getPy() != null
						&& castOther.getPy() != null && this.getPy().equals(
						castOther.getPy())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getChr() == null ? 0 : this.getChr().hashCode());
		result = 37 * result + (getPy() == null ? 0 : this.getPy().hashCode());
		return result;
	}

}
