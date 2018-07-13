package org.sgpro.signalmaster;

import java.util.ArrayList;
import java.util.List;

class PcConfigIceServer {
	private String urls;
	private String credential;
	public String getUrls() {
		return urls;
	}
	public void setUrls(String url) {
		this.urls = url;
	}
	public String getCredential() {
		return credential;
	}
	public void setCredential(String credential) {
		this.credential = credential;
	}
	public PcConfigIceServer(String url, String credential) {
		super();
		this.urls = url;
		this.credential = credential;
	}
	
	public PcConfigIceServer() {
		// TODO Auto-generated constructor stub
	}
}

public class PcConfigIceServers {
	List<PcConfigIceServer> iceServers = new ArrayList<PcConfigIceServer>();

	public boolean add(PcConfigIceServer e) {
		return iceServers.add(e);
	}
}
