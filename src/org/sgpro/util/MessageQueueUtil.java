package org.sgpro.util;

import java.util.LinkedList;
import java.util.Queue;

import org.sgpro.util.ReflectUtil.Invoker;
import org.sgpro.util.SafeThread.ResurrectionNotify;
import org.sgpro.util.SafeThread.SafeRunnable;

public class MessageQueueUtil {
	private Queue<Invoker> messageQueue = new LinkedList<ReflectUtil.Invoker>();
	
	private enum Status {
		running,
		stop
	}
	
	protected Status status = Status.stop;
	protected String name;
	
	public MessageQueueUtil() {
		// TODO Auto-generated constructor stub
		this("Anonymous MessageQueue");
	}
	
	public MessageQueueUtil(String name) {
		// TODO Auto-generated constructor stub
		this.name = name;
	}

	public  void  sendMessage(Invoker i) {
		synchronized (messageQueue) {
			messageQueue.add(i);
			messageQueue.notifyAll();
		}
	}
	
	public void messageLooper() throws Throwable {
		
		Invoker i = null;
		while (Status.running.equals(status)) {
			i = getTopMessage();
			if (i != null) {
				i.invok();
			}
		}
	}
	
	private Invoker getTopMessage() throws Throwable {
		Invoker ret = null;
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
