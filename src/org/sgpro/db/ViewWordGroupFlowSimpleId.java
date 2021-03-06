package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * ViewWordGroupFlowSimpleId generated by hbm2java
 */
public class ViewWordGroupFlowSimpleId implements java.io.Serializable {

	private long id;
	private String name;
	private String description;

	public ViewWordGroupFlowSimpleId() {
	}

	public ViewWordGroupFlowSimpleId(long id, String name, String description) {
		this.id = id;
		this.name = name;
		this.description = description;
	}

	public long getId() {
		return this.id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
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
		if (!(other instanceof ViewWordGroupFlowSimpleId))
			return false;
		ViewWordGroupFlowSimpleId castOther = (ViewWordGroupFlowSimpleId) other;

		return (this.getId() == castOther.getId())
				&& ((this.getName() == castOther.getName()) || (this.getName() != null
						&& castOther.getName() != null && this.getName()
						.equals(castOther.getName())))
				&& ((this.getDescription() == castOther.getDescription()) || (this
						.getDescription() != null
						&& castOther.getDescription() != null && this
						.getDescription().equals(castOther.getDescription())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getId();
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		result = 37
				* result
				+ (getDescription() == null ? 0 : this.getDescription()
						.hashCode());
		return result;
	}

}
