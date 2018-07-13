package org.sgpro.signalmaster;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;
import org.sgpro.util.ChineseGramaLex;
import org.sgpro.util.http.Request;
import org.sgpro.util.http.Response;

import config.Log4jInit;

public class SCWS implements ChineseGramaLex {
	static Logger logger = Logger.getLogger(Log4jInit.class.getName());
	@Override
	public List<LexItem> analyze(String input) {
		// TODO Auto-generated method stub
		List<LexItem> ret = null;
		try {
			if (input != null) {
				
				// TODO Auto-generated method stub
				Request req = new Request();
				
				Map<String, String> parameter = new HashMap<String, String>();
				parameter.put(Request.HTTP_PARAM_KEY_METHOD, "POST");
				
				req.setParameter(parameter);
				
				StringBuffer postData = new StringBuffer();
				
				postData.append("data=");
				postData.append(input);
				postData.append("&respond=json");
				postData.append("&duality=true");
				postData.append("&multi=3");

				Response rsp = req.getResponse("http://www.xunsearch.com/scws/api.php"
						, postData.toString()
						);
				
				JSONArray ja = rsp.asJSONObject().getJSONArray("words");
				
				JSONObject jo;
				if (ja != null && ja.length() > 0) {
					
					ret = new ArrayList<>();
					for (int i = 0; i < ja.length(); i++) {
						jo = ja.getJSONObject(i);
						LexItem item = new LexItem(jo.getString("attr"), jo.getString("word"));
						ret.add(item);
					}
				} 
				logger.info(ja.toString());				
			}
		} catch (Throwable t) {
			throw new RuntimeException("SCWS分词错误" , t);
		}
		
		return ret;
	}

}
