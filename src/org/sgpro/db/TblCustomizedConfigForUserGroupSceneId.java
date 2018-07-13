package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblCustomizedConfigForUserGroupSceneId generated by hbm2java
 */
public class TblCustomizedConfigForUserGroupSceneId implements
		java.io.Serializable {

	private long userGroupSceneId;
	private String name;

	public TblCustomizedConfigForUserGroupSceneId() {
	}

	public TblCustomizedConfigForUserGroupSceneId(long userGroupSceneId,
			String name) {
		this.userGroupSceneId = userGroupSceneId;
		this.name = name;
	}

	public long getUserGroupSceneId() {
		return this.userGroupSceneId;
	}

	public void setUserGroupSceneId(long userGroupSceneId) {
		this.userGroupSceneId = userGroupSceneId;
	}

	public String getName() {
		return this.name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public boolean equals(Object other) {
		if ((this == other))
			return true;
		if ((other == null))
			return false;
		if (!(other instanceof TblCustomizedConfigForUserGroupSceneId))
			return false;
		TblCustomizedConfigForUserGroupSceneId castOther = (TblCustomizedConfigForUserGroupSceneId) other;

		return (this.getUserGroupSceneId() == castOther.getUserGroupSceneId())
				&& ((this.getName() == castOther.getName()) || (this.getName() != null
						&& castOther.getName() != null && this.getName()
						.equals(castOther.getName())));
	}

	public int hashCode() {
		int result = 17;

		result = 37 * result + (int) this.getUserGroupSceneId();
		result = 37 * result
				+ (getName() == null ? 0 : this.getName().hashCode());
		return result;
	}

}