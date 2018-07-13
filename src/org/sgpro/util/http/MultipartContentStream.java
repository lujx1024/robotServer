package org.sgpro.util.http;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.LinkedList;
import java.util.Queue;
import java.util.Set;


public class MultipartContentStream extends InputStream {
	public static final String BOUNDARY = "--SGPRO_JAVA_MULTIPART_UPLOAD_BOUNDARY";
	public static final String REQ_MULTIPART_FILE_FMT = "--%s\r\nContent-Disposition: form-data; name=\"%s\"; filename=\"%s\" \r\nContent-Type: %s\r\n\r\n";
	public static final String REQ_MULTIPART_PARA_FMT = "--%s\r\nContent-Disposition: form-data; name=\"%s\"\r\n\r\n%s\r\n";
	public static final String REQ_MULTIPART_TAIL_FMT =  "\r\n--%s--\r\n";
	
	protected Queue<InputStream> readQueue ; 
	InputStream currSubStream = null;
	private long contentLength;
	
	@Override
	public int read() throws IOException {
		// TODO Auto-generated method stub
		int ret = -1;
		
		if (currSubStream == null) {
			currSubStream = getNextInputStream();
		}
		
		if (currSubStream != null) {
			
			while ((ret = currSubStream.read()) == -1) {
				currSubStream.close();
				if ((currSubStream = getNextInputStream()) == null) {
					break;
				}
			}
		}
		
		
		return ret;
	}
	
	private InputStream getNextInputStream() {
		return 
				(readQueue != null && readQueue.peek() != null)? readQueue.poll() : null;
		
	}
		
	public MultipartContentStream(Set<MultipartDisposition> parameter) {
		
		try {
			contentLength = 0;
			byte[] data = null;
			if (parameter != null) {
				readQueue = new LinkedList<InputStream>();
				for (MultipartDisposition md : parameter) {
					if (md != null) {
						String item = null;
						String name = md.getName();
						if (!md.isFile()) {
							item = String.format(REQ_MULTIPART_PARA_FMT, BOUNDARY, name, md.getStringContent());
							data = item.getBytes();
							readQueue.offer(new ByteArrayInputStream(data));
							contentLength += data.length;
						} else {
							item = String.format( 
									REQ_MULTIPART_FILE_FMT,
									BOUNDARY,  name,  md.getStringContent(), md.getContentType());
							data = item.getBytes();
							readQueue.offer(new ByteArrayInputStream(data));
							contentLength += data.length;
							
							readQueue.offer(md.getValue());
							contentLength += md.getContentLength();
						}
					}
				} 
				data = String.format(REQ_MULTIPART_TAIL_FMT, BOUNDARY).getBytes();
				readQueue.offer(new ByteArrayInputStream(data));
				contentLength += data.length;
			}
		} catch (Throwable t) {
			throw new IllegalArgumentException(t.getMessage(), t);
		}
	}

	
	@Override
	public void close() throws IOException {
		// TODO Auto-generated method stub
		super.close();
		
		if (readQueue != null) {
			for (InputStream is : readQueue) {
				if (is != null) {
					is.close();
				}
			}
		}
	}

	public long getContentLength() {
		// TODO Auto-generated method stub
		return contentLength;
	}
}

	
