package org.sgpro.signalmaster;
/**
 * @author lvdw
 * 2018-07-01
 * 获取AccessToken的线程，初始化获取一次，以后每次到期后自己获取，未到期则每日获取一次
 * */




import java.util.HashMap;
import java.util.Map;


import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.json.JSONObject;
import org.sgpro.db.HibSf;
import org.sgpro.util.http.Request;
import org.sgpro.util.http.Response;

public class RemoteSetAccessTokenThread implements Runnable{
	static Logger logger = Logger.getLogger(RemoteSetAccessTokenThread.class.getName());
	
	private static long expireTime = 0;
	
	private static long nowTime = 0;
	
	@Override
	public void run() {
		// TODO Auto-generated method stub
		Map<String,Object> map = new HashMap<String,Object>();
		
		logger.info("线程刚启动，需要第一次获取");
		map = getAc();
		logger.info("获取到的值为："+map.toString());
		if(!map.isEmpty()){
			expireTime = Long.valueOf((String)map.get("expireTime"));
			nowTime = System.currentTimeMillis();
		}
		while(true){
			if(System.currentTimeMillis() > expireTime){
				logger.info("已经达到上一个AccessToken的过期时间了，需要重新获取");
				map = getAc();
				logger.info("获取到的值为："+map.toString());
				if(!map.isEmpty()){
					expireTime = Long.valueOf((String)map.get("expireTime"));
					nowTime = System.currentTimeMillis();
				}
			}else if(System.currentTimeMillis() - nowTime > 1000*60*60*24){
				logger.info("虽然AccessToken还没有过期，但是离上次已经过了一天了，重新获取一次");
				map = getAc();
				logger.info("获取到的值为："+map.toString());
				if(!map.isEmpty()){
					expireTime = Long.valueOf((String)map.get("expireTime"));
					nowTime = System.currentTimeMillis();
				}
			}
			
			try {
				Thread.sleep(1000*60*60);
			} catch (InterruptedException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}
	
	private void setAc(String accessToken) {
		// TODO Auto-generated method stub
		logger.info("将获取到的AccessToken存入数据库中");
		Transaction trans = null;
		try{
			trans = HibSf.getSession().beginTransaction();
			
			ViewUtils.dbProc("UPDATE REMOTE_CAMERAINFO SET ACCESS_TOKEN = ?",accessToken );
			
			trans.commit();
		}catch(Throwable e){
			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				t.printStackTrace();
			}
		}
		
	}

	@SuppressWarnings("finally")
	private Map<String,Object> getAc(){
		Request req = new Request();  
		String date = null;
		String url = "https://open.ys7.com/api/lapp/token/get?appKey=47944ece9e834bb7bfae0947ed21f655&appSecret=54bd4dcabb45f5f4f28475de624f33ce";
		Response rsp = null;
		String ret = null;
		Map<String,Object> map = new HashMap<String,Object>();
		try {
			rsp = req.getResponse(url,date);
			ret = rsp.asString();
			JSONObject jo = new JSONObject(ret);
			String code = jo.optString("code");
			String msg = jo.optString("msg");
			String data = "";
			if("200".equals(code)){
				data = jo.optString("data");
				JSONObject jo1 = new JSONObject(data);
				map.put("accessTolen", jo1.optString("accessToken"));
				map.put("expireTime", jo1.optString("expireTime"));
				logger.info("获取到正确的AccessToken为："+jo1.optString("accessToken")+",获取到正确的expireTime为："+jo1.optString("expireTime"));
				setAc(jo1.optString("accessToken"));
			}
			logger.info("获取AccessToken的结果为："+msg);
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			logger.info("获取AccessToken出现异常！");
		}finally{
			return map;
		}
	}
}


