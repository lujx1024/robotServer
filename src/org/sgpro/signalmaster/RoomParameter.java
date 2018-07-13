package org.sgpro.signalmaster;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


class Constraints {
	
}

public class RoomParameter implements HttpResultData {

	private boolean is_initiator = false;
	private String room_link = null;
	private  List<String> messages = new ArrayList<String>();
	private String [] error_messages = new String[0];
	private String client_id = "";
	private boolean bypass_join_confirmation = false;
	private Map<String, Boolean> media_constraints = new HashMap<String, Boolean>();
	private String include_loopback_js = "";
	private String turn_url ="";
	private boolean is_loopback = false;
	private String wss_url ="";
	private Map<String, String[]> pc_constraints = new HashMap<String, String[]>();
	private PcConfigIceServers pc_config = null;
	private String wss_post_url ="";
	private String room_id = "";
	private String turn_transports ="";
	private Map<String, String[]> offer_constraints = new HashMap<String, String[]>();
	
	public boolean isIs_initiator() {
		return is_initiator;
	}
	public void setIs_initiator(boolean is_initiator) {
		this.is_initiator = is_initiator;
	}
	public String getRoom_link() {
		return room_link;
	}
	public void setRoom_link(String room_link) {
		this.room_link = room_link;
	}
	public List<String> getMessages() {
		return messages;
	}
	public void setMessages(List<String> messages) {
		this.messages = messages;
	}
	public String[] getError_messages() {
		return error_messages;
	}
	public void setError_messages(String[] error_messages) {
		this.error_messages = error_messages;
	}
	public String getClient_id() {
		return client_id;
	}
	public void setClient_id(String client_id) {
		this.client_id = client_id;
	}
	public boolean isBypass_join_confirmation() {
		return bypass_join_confirmation;
	}
	public void setBypass_join_confirmation(boolean bypass_join_confirmation) {
		this.bypass_join_confirmation = bypass_join_confirmation;
	}
	public Map<String, Boolean> getMedia_constraints() {
		return media_constraints;
	}
	public void setMedia_constraints(Map<String, Boolean> media_constraints) {
		this.media_constraints = media_constraints;
	}
	public String getInclude_loopback_js() {
		return include_loopback_js;
	}
	public void setInclude_loopback_js(String include_loopback_js) {
		this.include_loopback_js = include_loopback_js;
	}
	public String getTurn_url() {
		return turn_url;
	}
	public void setTurn_url(String turn_url) {
		this.turn_url = turn_url;
	}
	public boolean isIs_loopback() {
		return is_loopback;
	}
	public void setIs_loopback(boolean is_loopback) {
		this.is_loopback = is_loopback;
	}
	public String getWss_url() {
		return wss_url;
	}
	public void setWss_url(String wss_url) {
		this.wss_url = wss_url;
	}
	public Map<String, String[]> getPc_constraints() {
		return pc_constraints;
	}
	public void setPc_constraints(Map<String, String[]> pc_constraints) {
		this.pc_constraints = pc_constraints;
	}
	public PcConfigIceServers getPc_config() {
		return pc_config;
	}
	public void setPc_config(PcConfigIceServers servers) {
		this.pc_config = servers;
	}
	public String getWss_post_url() {
		return wss_post_url;
	}
	public void setWss_post_url(String wss_post_url) {
		this.wss_post_url = wss_post_url;
	}
	public String getRoom_id() {
		return room_id;
	}
	public void setRoom_id(String room_id) {
		this.room_id = room_id;
	}
	public String getTurn_transports() {
		return turn_transports;
	}
	public void setTurn_transports(String turn_transports) {
		this.turn_transports = turn_transports;
	}
	public Map<String, String[]> getOffer_constraints() {
		return offer_constraints;
	}
	public void setOffer_constraints(Map<String, String[]> offer_constraints) {
		this.offer_constraints = offer_constraints;
	}
	public RoomParameter(boolean is_initiator, String room_link,
			List<String> messages, String[] error_messages, String client_id,
			boolean bypass_join_confirmation,
			Map<String, Boolean> media_constraints, String include_loopback_js,
			String turn_url, boolean is_loopback, String wss_url,
			Map<String, String[]> pc_constraints,
			PcConfigIceServers pc_config, String wss_post_url,
			String room_id, String turn_transports,
			Map<String, String[]> offer_constraints) {
		super();
		this.is_initiator = is_initiator;
		this.room_link = room_link;
		this.messages = messages;
		this.error_messages = error_messages;
		this.client_id = client_id;
		this.bypass_join_confirmation = bypass_join_confirmation;
		this.media_constraints = media_constraints;
		this.include_loopback_js = include_loopback_js;
		this.turn_url = turn_url;
		this.is_loopback = is_loopback;
		this.wss_url = wss_url;
		this.pc_constraints = pc_constraints;
		this.pc_config = pc_config;
		this.wss_post_url = wss_post_url;
		this.room_id = room_id;
		this.turn_transports = turn_transports;
		this.offer_constraints = offer_constraints;
	}
	public RoomParameter() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	
}
