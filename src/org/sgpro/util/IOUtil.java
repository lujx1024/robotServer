package org.sgpro.util;

import java.io.Closeable;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashSet;
import java.util.Set;

public class IOUtil {
	public static final int STREAM_COPY_TEMP_BUFF_SIZE_KB = 63;
	public static final int STREAM_COPY_TEMP_BUFF_SIZE = STREAM_COPY_TEMP_BUFF_SIZE_KB * 1024;
	
	private static byte[] STREAM_COPY_TEMP_BUFF = new byte[STREAM_COPY_TEMP_BUFF_SIZE];
	public static void streamCopy(InputStream is, OutputStream os) throws Throwable {
		if (is != null && os != null) {
			int readCount = 0;
			while ((readCount = is.read(STREAM_COPY_TEMP_BUFF)) != -1) {
				os.write(STREAM_COPY_TEMP_BUFF, 0, readCount);
			}
		}
	}
	
	private static Set<Closeable> closeableManager = null;
	
	public  synchronized static void registerCloseAble(Closeable c) {
		if (closeableManager == null) {
			closeableManager = new HashSet<Closeable>();
		}
		
		if (c != null) {
			synchronized (closeableManager) {
				closeableManager.add(c);
			}
		}
	}
	
	public synchronized  static void deRegistCloseAble(Closeable c) {
		if (c != null && closeableManager != null) {
			synchronized (closeableManager) {
				closeableManager.remove(c);
			}
		}
	}
	
	public synchronized static void finalizeCloseable() throws IOException {
		if (closeableManager != null) {
			
			synchronized (closeableManager) {
				
				for (Closeable c : closeableManager) {
					if (c != null) {
						try {c.close(); } catch (Throwable t) {}
					}
				}
				closeableManager.clear();
			}
		}
	}
}
