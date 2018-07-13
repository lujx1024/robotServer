package org.sgpro.util;

import java.util.LinkedList;
import java.util.Queue;
import java.util.Vector;

import org.sgpro.util.SafeThread.ResurrectionNotify;
import org.sgpro.util.SafeThread.SafeRunnable;


public class SyncObserverModel<MessageType extends SyncObserverModelMessageType> {

	public static interface Observer<MessageType> {
		void observe(MessageType m);
	}
	
	private Queue<MessageType> messageQueue = new LinkedList<MessageType>();
	
	private Vector<Observer<MessageType>> observers = new Vector<SyncObserverModel.Observer<MessageType>>();
	
	
	public void registerObserver(Observer<MessageType> obs) {
		if (obs != null) {
			observers.add(obs);
		}
	}
	
	public void unregisterObserver(Observer<MessageType> obs) {
		observers.remove(obs);
	}
	
	private enum Status {
		running,
		stop
	}
	
	protected Status status = Status.stop;
	protected String name;
	
	public SyncObserverModel() {
		// TODO Auto-generated constructor stub
		this("SyncObserverModel MessageQueue");
	}
	
	public SyncObserverModel(String name) {
		// TODO Auto-generated constructor stub
		this.name = name;
	}

	public  void  sendMessage(MessageType i) {
		synchronized (messageQueue) {
			messageQueue.add(i);
			messageQueue.notifyAll();
		}
	}
	
	public void messageLooper() throws Throwable {
		
		MessageType m = null;
		while (Status.running.equals(status)) {
			m = getTopMessage();
			if (m != null) {
				handler(m);
			}
		}
	}
	
	protected void handler(MessageType m) {
		// TODO Auto-generated method stub
		for (Observer<MessageType> ob : observers) {
			ob.observe(m);
		}
	}

	private MessageType getTopMessage() throws Throwable {
		MessageType ret = null;
		// TODO Auto-generated method stub
		synchronized (messageQueue) {
			if (!messageQueue.isEmpty()) {
				ret = messageQueue.poll();
			} else {
				messageQueue.wait();
			}
		}

		return ret;
	}

	private int count = 0;
	public void start() {
		// TODO Auto-generated method stub
		
		if (Status.stop.equals(status)) {
			status = Status.running;
			SafeThread st = new SafeThread(new SafeRunnable() {
				
				@Override
				public void safeRun() throws Throwable {
					// TODO Auto-generated method stub
					messageLooper();
				}
			});
			st.setName(name + " " + count);
			st.setPriority(Thread.MAX_PRIORITY);
			st.registerResurrection(new ResurrectionNotify() {
				
				@Override
				public void resurrection(SafeThread resurrectedThread) {
					// TODO Auto-generated method stub
					
				}
			});
			
			st.start();
			count++;
		} else {
			// already running ignor it.
		}
	}
	
	public void stop() {
		// TODO Auto-generated method stub
		status = Status.stop;
	}

}
