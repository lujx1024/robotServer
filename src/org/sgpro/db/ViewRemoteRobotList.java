package org.sgpro.db;

/**
 * ADD by LvDW
 * 2018-04-28
 * */

public class ViewRemoteRobotList implements java.io.Serializable{
	
	
	private ViewRemoteRobotListId id;

	public ViewRemoteRobotList(ViewRemoteRobotListId id) {
		this.id = id;
	}

	public ViewRemoteRobotList() {
	}

	public ViewRemoteRobotListId getId() {
		return id;
	}

	public void setId(ViewRemoteRobotListId id) {
		this.id = id;
	}
	
	
	
	

}
