package org.sgpro.signalmaster;

public enum RTCWssCommandEnum {

	/**
	 * 登录
	 */
	login,
	
	/**
	 * 发起会话sdp
	 */
	offer,
	
	/**
	 * 应答 sdp
	 */
	answer,
	
	/**
	 * ice candidate 
	 */
	candidate, 
	
	
	logout,
	
	endpoint_status_changed,
	close,
	manual_mode_switch, // 手动模式切换
	connection_state_changed
	, manual_talk,
	status_remind,
	running_talk,
	stop_talk,
	custom_talk,
	ping, remote_video_status_changed, get_bind_list
	
}
