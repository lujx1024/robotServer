package org.sgpro.util;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.sgpro.util.http.Request;
import org.sgpro.util.http.Response;


public interface ChineseGramaLex {

	public class LexItem {
		String property;
		String value;
		
		public String getProperty() {
			return property;
		}

		public void setProperty(String property) {
			this.property = property;
		}

		public String getValue() {
			return value;
		}

		public void setValue(String value) {
			this.value = value;
		}

		public LexItem() {
			// TODO Auto-generated constructor stub
		}

		public LexItem(String property, String value) {
			super();
			this.property = property;
			this.value = value;
		}
		
		
	}
	
	List<LexItem> analyze(String input);
	

	class BsonNLP implements ChineseGramaLex {

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
					
					parameter.put("Content-Type", "application/json");
					parameter.put("Accept", "application/json");
					parameter.put("X-Token", "r4L80RDI.6393.vQy-Uj48m07y");
					
					
					req.setParameter(parameter);
					
					
					Response rsp = req.getResponse("http://api.bosonnlp.com/tag/analysis?space_mode=0&oov_level=3&t2s=0&&special_char_conv=0"
							, "\""  + input + "\"");
					
					JSONArray ja = rsp.asJSONArray();
					
					JSONObject jo;
					if (ja.length() > 0 && (jo = ja.getJSONObject(0)) != null) {
						JSONArray jat = jo.getJSONArray("tag");
						JSONArray jaw = jo.getJSONArray("word");
						
						ret = new ArrayList<>();
						for (int i = 0; i < jat.length(); i++) {
							LexItem item = new LexItem(jat.getString(i), jaw.getString(i));
							ret.add(item);
						}
					} 
					System.out.println(ja.toString());				
				}
			} catch (Throwable t) {
				throw new RuntimeException("bson分词错误" , t);
			}
			
			return ret;
		}
	}
}
