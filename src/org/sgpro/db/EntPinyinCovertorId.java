package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * EntPinyinCovertorId generated by hbm2java
 */
public class EntPinyinCovertorId implements java.io.Serializable {

	private String source;
	private String destination;
	private boolean enabled;

	public EntPinyinCovertorId() {
	}

	public EntPinyinCovertorId(String source, String destination,
			boolean enabled) {
		this.source = source;
		this.destination = destination;
		this.enabled = enabled;
	}

	public String getSource() {
		return this.source;
	}

	public void setSource(String source) {
		this.source = source;
	}

	public String getDestination() {
		return this.destination;
	}

	public void setDestination(String destination) {
		this.destination = destination;
	}

	public boolean isEnabled() {
		return this.enabled;
	}

	public void setEnabled(boolean enabled) {
		this.enabled = enabled;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof EntPinyinCovertorId))
			return false;
		EntPinyinCovertorId castOther = (EntPinyinCovertorId) other;

		return ((this.getSource() == castOther.getSource()) || (this
				.getSource() != null && castOther.getSource() != null && this
				.getSource().equals(castOther.getSource())))
				&& ((this.getDestination() == castOther.getDestination()) || (this
						.getDestination() != null
						&& castOther.getDestination() != null && this
						.getDestination().equals(castOther.getDestination())))
				&& (this.isEnabled() == castOther.isEnabled());
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result
				+ (getSource() == null ? 0 : this.getSource().hashCode());
		result = 37
				* result
				+ (getDestination() == null ? 0 : this.getDestination()
						.hashCode());
		result = 37 * result + (this.isEnabled() ? 1 : 0);
		return result;
	}

}
