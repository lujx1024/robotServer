package org.sgpro.signalmaster;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public interface DataTreeNode {
	
	public class XMLNodeList extends DataTreeNodeList {

		private List<Node> arr;

		public XMLNodeList(List<Node> array) {
			// TODO Auto-generated constructor stub
			this.setArr(array);
		}

		public List<Node> getArr() {
			return arr;
		}

		public void setArr(List<Node> arr) {
			this.arr = arr;
		}
	}

	boolean has(String key);

	DataTreeNode optNode(String key);
	DataTreeNodeList optNodeList(String key);
	DataTreeNode getNode(String key);
	DataTreeNodeList getNodeList(String key);
	Object getData(String key);
	
	abstract class DataTreeNodeList {
		protected List<DataTreeNode> list;
		
		DataTreeNode get(int index) {
			return list != null && list.size() > index? list.get(index) : null;
		}
		
		int length() {
			return list != null ? list.size() : 0;
		}
	}
	
	class JSONNodeList extends DataTreeNodeList {

		public JSONNodeList(JSONArray ja) {
			// TODO Auto-generated constructor stub
			try {
				if (ja != null) {
					list = new ArrayList<>();
					
					for (int i = 0; i < ja.length(); i++) {
						ja.get(i);
					}
					
				}
			} catch (Throwable t) {
				
			}
		}
		
//		@Override
//		public DataTreeNode get(int index) {
//			// TODO Auto-generated method stub
//			try {
//				return  ja == null ? null : new JSONNode(ja.getJSONObject(index));
//			} catch (JSONException e) {
//				// TODO Auto-generated catch block
//				return null;
//			}
//		}

//		@Override
//		public int length() {
//			// TODO Auto-generated method stub
//			return ja == null?  0 : ja.length();
//		}
//		
//		public Object getObject(int index) {
//			try {
//				return ja == null ? null : ja.get(index);
//			} catch (JSONException e) {
//				// TODO Auto-generated catch block
//				return null;
//			}
//		}
		
	}
	
	class JSONNode implements DataTreeNode {

		JSONObject jo;
		public JSONNode(JSONObject jo) {
			// TODO Auto-generated constructor stub
			this.jo = jo;
		}
		
		@Override
		public boolean has(String key) {
			// TODO Auto-generated method stub
			return jo == null? false : jo.has(key);
		}

		@Override
		public DataTreeNode optNode(String key) {
			// TODO Auto-generated method stub
			return jo == null? null : new JSONNode(jo.optJSONObject(key));
		}

		@Override
		public DataTreeNodeList optNodeList(String key) {
			// TODO Auto-generated method stub
				return jo == null?  null : new JSONNodeList(jo.optJSONArray(key));
		}

		@Override
		public DataTreeNode getNode(String key) {
			// TODO Auto-generated method stub
			try {
				return jo == null? null : new JSONNode(jo.getJSONObject(key));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				return null;
			}
		}

		@Override
		public DataTreeNodeList getNodeList(String key) {
			// TODO Auto-generated method stub
			try {
				return jo == null?  null : new JSONNodeList(jo.getJSONArray(key));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				return null;
			}
		}

		@Override
		public Object getData(String key) {
			// TODO Auto-generated method stub
			try {
				return jo == null? null : jo.get(key);
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				return null;
			}
		}
 	}
	
	class XMLNode implements DataTreeNode {
		Element elem;
		
		@Override
		public boolean has(String key) { 
			// TODO Auto-generated method stub
			NodeList list = elem.getElementsByTagName(key);
  			return elem == null || list == null || list.getLength() == 0;
		}

		@Override
		public DataTreeNode optNode(String key) {
			// TODO Auto-generated method stub
			return getNode(key);
		}

		@Override
		public DataTreeNodeList optNodeList(String key) {
			// TODO Auto-generated method stub
			NodeList list = elem.getChildNodes();
			List<Node> array = null;
			
			if (list != null && key != null) {
				array = new ArrayList<>();
				for (int i = 0; i < list.getLength(); i++) {
					Node item = list.item(i);
					if (key.equals(item.getNodeName())) {
						array.add(item);
						 break;
					}
				}
			}
			
			return array == null || array.size() == 0? null :
				new XMLNodeList(array);

		}

		@Override
		public DataTreeNode getNode(String key) {
			// TODO Auto-generated method stub
			DataTreeNodeList l = optNodeList(key);
			return l == null || l.length() == 0? null : l.get(0);
		}

		@Override
		public DataTreeNodeList getNodeList(String key) {
			// TODO Auto-generated method stub
			return optNodeList(key);
		}

		@Override
		public Object getData(String key) {
			// TODO Auto-generated method stub
			
			DataTreeNode n = getNode(key);
			String text = n == null ? elem.getTextContent() : null;
			Object o = text;
			
			try {
				o = Long.parseLong(text);
				o = Double.parseDouble(text);
				o = Boolean.parseBoolean(text);
			} catch (Throwable t) {
			}
			
			return o;
		}		
	}

}
