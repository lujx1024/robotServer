package org.sgpro.signalmaster;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Queue;
import java.util.Set;

import org.apache.log4j.Logger;
import org.sgpro.signalmaster.Message.GAECandidate;
import org.sgpro.util.DateUtil;

import config.Log4jInit;

public class Roomes {
	static Logger logger = Logger.getLogger(Roomes.class.getName());
	public class Client {
		String id;
		Map<String, String> sdp = new HashMap<String, String>();
		List<GAECandidate> ice = new ArrayList<GAECandidate>();
		
		public String getId() {
			return id;
		}
		
		public Map<String, String> getSdp() {
			return sdp;
		}
		public void setSdp(String type, String sdp) {
			this.sdp.put(type, sdp);
		}
		public List<GAECandidate> getIce() {
			return ice;
		}

		public boolean addIce(GAECandidate arg0) {
			return ice.add(arg0);
		}

		public Client() {
			super();
			id = String.valueOf(System.currentTimeMillis());
		}

		
		List<String> messageOriginal = new ArrayList<String>();
		public void addMessageOriginal(String data) {
			// TODO Auto-generated method stub
			messageOriginal.add(data);
		}
		public List<String> getMessageOriginal() {
			return messageOriginal;
		}

	}
    public class Room {
    	private Date createDateTime;
    	private Queue<Client> clients;
		public Room() {
			super();
			// TODO Auto-generated constructor stub
			createDateTime = DateUtil.getNow();
			clients = new LinkedList<Client>();
		}
		public boolean join(Client arg0) {
			return clients.add(arg0);
		}
		public boolean has(Object arg0) {
			return clients.contains(arg0);
		}
		public boolean isEmpty() {
			return clients.isEmpty();
		}
		public boolean leave(Client client) {
			return clients.remove(client);
		}
		
		public boolean leave(String clientId) {
			return leave(getClient(clientId));
		}
		
		public int count() {
			return clients.size();
		}
		public Date getCreateDateTime() {
			return createDateTime;
		}
    	
		public Client getClient(String clientId) {
			Client ret = null;
			for (Client c : clients) {
				if (c.getId().equals(clientId)) {
					ret  = c;
					break;
				}
			}
			return ret;
		}
		
		public Queue<Client> getClients() {
			return clients;
		}
	}

	private Map<String, Room> rooms = new HashMap<String, Room>();
	private static Roomes globalRoomes;

    public boolean isRoomExsists(String roomId) {
    	return rooms.containsKey(roomId);
    }
    
    private void newRoom(String roomId) {
    	if (!isRoomExsists(roomId)) {
    		rooms.put(roomId, new Room());
    	}
    }
    
	public Room getRoom(String roomId) {
		return rooms.get(roomId);
	}
	
	
    public Client joinRoom(Room r) {
    	Client client = new Client();
    	r.join(client);
    	return client;
    }
	
    public Client joinRoom(String roomId) {
    	Room r = getRoom(roomId);
    	if (r == null) {
    		newRoom(roomId);
    		r = getRoom(roomId);
    	}
    	
    	return joinRoom(r);
    }
    
    public void leaveRoom(String roomId, String clientId) {
    	if (isRoomExsists(roomId)) {
    		Room r = getRoom(roomId);
    		r.leave(clientId);
    		logger.info("Roomes.leaveRoom "+ clientId + " leave from " + roomId);    			
    		
    		if (r.count() == 0) {
    			rooms.remove(roomId);
    			logger.info("room " + roomId + " is empty. so remove it!");    			
    		}
    		
    		if (rooms.isEmpty()) {
    			logger.info("all roomes be removed.");
    		}
    	}
    }
    
    
     static {
    	 globalRoomes = new Roomes();
    }
    public static Roomes getGlobalRoomes() {
    	return globalRoomes;
    }
}
