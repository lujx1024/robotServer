package org.sgpro.util;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;



public class BeanValue  {

	Object json;
	public BeanValue(JSONObject jo) {
		json = jo;
	} 
	public BeanValue(JSONArray jo) {
		// TODO Auto-generated constructor stub
		json = jo;
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return json.toString();
	}
}
