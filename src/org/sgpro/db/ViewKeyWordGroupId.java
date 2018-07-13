package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewKeyWordGroupId generated by hbm2java
 */
public class ViewKeyWordGroupId implements java.io.Serializable {

	private long keyWordId;
	private long groupId;
	private String kw;
	private Long cat;
	private String description;

	public ViewKeyWordGroupId() {
	}

	public ViewKeyWordGroupId(long keyWordId, long groupId, String kw) {
		this.keyWordId = keyWordId;
		this.groupId = groupId;
		this.kw = kw;
	}

	public ViewKeyWordGroupId(long keyWordId, long groupId, String kw,
			Long cat, String description) {
		this.keyWordId = keyWordId;
		this.groupId = groupId;
		this.kw = kw;
		this.cat = cat;
		this.description = description;
	}

	public long getKeyWordId() {
		return this.keyWordId;
	}

	public void setKeyWordId(long keyWordId) {
		this.keyWordId = keyWordId;
	}

	public long getGroupId() {
		return this.groupId;
	}

	public void setGroupId(long groupId) {
		this.groupId = groupId;
	}

	public String getKw() {
		return this.kw;
	}

	public void setKw(String kw) {
		this.kw = kw;
	}

	public Long getCat() {
		return this.cat;
	}

	public void setCat(Long cat) {
		this.cat = cat;
	}

	public String getDescription() {
		return this.description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof ViewKeyWordGroupId))
			return false;
		ViewKeyWordGroupId castOther = (ViewKeyWordGroupId) other;

		return (this.getKeyWordId() == castOther.getKeyWordId())
				&& (this.getGroupId() == castOther.getGroupId())
				&& ((this.getKw() == castOther.getKw()) || (this.getKw() != null
						&& castOther.getKw() != null && this.getKw().equals(
						castOther.getKw())))
				&& ((this.getCat() == castOther.getCat()) || (this.getCat() != null
						&& castOther.getCat() != null && this.getCat().equals(
						castOther.getCat())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getKeyWordId();
		result = 37 * result + (int) this.getGroupId();
		result = 37 * result + (getKw() == null ? 0 : this.getKw().hashCode());
		result = 37 * result
				+ (getCat() == null ? 0 : this.getCat().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		return result;
	}

}