package org.sgpro.db;

// Generated 2017-6-21 11:12:45 by Hibernate Tools 4.0.0

/**
 * TblRobotTags generated by hbm2java
 */
public class TblRobotTags implements java.io.Serializable {

	private TblRobotTagsId id;
	private EntRobot entRobot;
	private String tagStr;

	public TblRobotTags() {
	}

	public TblRobotTags(TblRobotTagsId id, EntRobot entRobot, String tagStr) {
		this.id = id;
		this.entRobot = entRobot;
		this.tagStr = tagStr;
	}

	public TblRobotTagsId getId() {
		return this.id;
	}

	public void setId(TblRobotTagsId id) {
		this.id = id;
	}

	public EntRobot getEntRobot() {
		return this.entRobot;
	}

	public void setEntRobot(EntRobot entRobot) {
		this.entRobot = entRobot;
	}

	public String getTagStr() {
		return this.tagStr;
	}

	public void setTagStr(String tagStr) {
		this.tagStr = tagStr;
	}

}
