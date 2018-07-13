package org.sgpro.signalmaster;
/**
 * @author lvdw
 * @data 2018-06-30
 * 获取AccessToken的服务
 * */

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;

import org.apache.log4j.Logger;

public class RemoteSetAccessTokenServlet extends HttpServlet{
	static Logger logger = Logger.getLogger(RemoteSetAccessTokenServlet.class.getName());
	
	
	/**
	 * 启动AT服务端口线程
	 */
	public void init() throws ServletException {
		try{
//			Runnable ra = new RemoteSetAccessTokenThread();
//			Thread t = new Thread(ra);
//			t.start();
		} catch (Exception e) {
			logger.error("【RemoteSetAccessTokenServlet】 AT服务启动",e);
		}
	}
	


}
