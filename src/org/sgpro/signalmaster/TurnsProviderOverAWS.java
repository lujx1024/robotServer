package org.sgpro.signalmaster;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;
import java.net.URLConnection;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CatchPkg
 */
public class TurnsProviderOverAWS extends HttpServlet {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static final String TURN_FORMAT = 
			"https://computeengineondemand.appspot.com/turn?username=%s&key=%s";
	private static final int BUFF_SIZE = 1024;

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
		String uid = req.getParameter("uid");
		String key = req.getParameter("key");
		

		InputStream is = null;
		InputStreamReader isr = null;
		
		try {
			String turn = 
					String.format(TURN_FORMAT, uid, key);
			URL url = new URL(turn);
			URLConnection conn = url.openConnection();
			conn.connect();
			
			is = conn.getInputStream();
			
			isr = new InputStreamReader(is);
			
			char[] buffer = new char[BUFF_SIZE];
			
			int readCount = 0;
			
			StringBuffer sb = new StringBuffer();
			while ((readCount  = isr.read(buffer, 0, BUFF_SIZE)) > 0) {
				sb.append(buffer, 0, readCount);
			}
			
			resp.getWriter().print(sb);
			
			isr.close();
			is.close();
			
			isr = null;
			is = null;
		} catch (Throwable t) {
			throw new IOException(t);
		} finally {
			if (isr != null) {
				isr.close();
			}
			if (is != null) {
				is.close();
			}
		}
	}
	
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(req, resp);
	}
}
