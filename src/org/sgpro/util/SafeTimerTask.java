package org.sgpro.util;

import java.io.Closeable;
import java.io.IOException;
import java.util.Timer;
import java.util.TimerTask;

import org.sgpro.util.SafeThread.SafeRunnable;

public class SafeTimerTask extends TimerTask implements Closeable {

	protected Timer tm;
	protected SafeRunnable sr;
	protected long delay;
	protected long period;
	
	public SafeTimerTask(String timerName, SafeRunnable runner, long delay, long period) {
		// TODO Auto-generated constructor stub
		tm = new Timer("SafeTimerTask " + timerName);
		sr = runner; 
		this.delay = delay;
		this.period = period;
		IOUtil.registerCloseAble(this);
		tm.schedule(this, delay, period);
	} 
	
	public SafeTimerTask(String timerName, SafeRunnable runner, long delay) {
		// TODO Auto-generated constructor stub
		tm = new Timer("SafeTimerTask " + timerName);
		sr = runner;
		this.delay = delay;
		IOUtil.registerCloseAble(this);
		tm.schedule(this, delay);
	}

	@Override
	public void run() {
		// TODO Auto-generated method stub
		if (sr != null) {
			sr.run();
		}
		
		if (period == 0) {
			cancel();
		}
	}

	@Override
	public void close() throws IOException {
		// TODO Auto-generated method stub
		cancel();
	}
	
	@Override
	public boolean cancel() {
		// TODO Auto-generated method stub
		boolean ret = super.cancel();
		
		if (ret) {
			tm.cancel();
			IOUtil.deRegistCloseAble(this);
		}
		return ret;
	}
}
