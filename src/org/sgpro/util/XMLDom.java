package org.sgpro.util;

import java.io.File;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.OutputKeys;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;


/**
 * 系统配置类
 *
 */
public class XMLDom {
	
	/**
	 * xml文档构建器
	 */
	private  DocumentBuilderFactory factory = null;
	
	/**
	 * xml文档构建
	 */
	private  DocumentBuilder builder = null;
	
	/**
	 * xml文档
	 */
	private  Document document = null;
	
	/**
	 * xml文档元素
	 */
	private  Element rootElement = null;

	private File file;
	
	/**
	 * 加载配置文件
	 * @param fileName 配置文件名
	 */
	public  boolean load(File f) {
		
		try { 
			factory = DocumentBuilderFactory.newInstance(); 
			builder = factory.newDocumentBuilder(); 
			document = builder.parse(f);
			rootElement = document.getDocumentElement();
			file  = f;
			return true;
		} catch (Exception e) { 
			throw new RuntimeException(e);
		} 
	}
	
	/**
	 * 
	 * @param text
	 * @return
	 */
	public  boolean load(String text) {
		
		try { 
			factory = DocumentBuilderFactory.newInstance(); 
			builder = factory.newDocumentBuilder(); 
			document = builder.parse(text);
			rootElement = document.getDocumentElement();
			return true;
		} catch (Exception e) { 
			throw new RuntimeException(e);
		} 
	}

	/**
	 * 读取缺省根配置
	 * @param key 键
	 * @return 值
	 */
	public  String get(String key) {
		String value = "";
		
		try {
			if (null != rootElement) {
				Node n = getNode(rootElement, key);
				if ( null != n) {
					n = n.getChildNodes().item(0);
					if (null != n) {						
						value = n.getNodeValue();
					}
				}
			}
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		
		return value;
	}
	
	/**
	 * 读取指定根下的配置节点
	 * @param root 文档根
	 * @param key 键
	 * @return 值
	 */
	public  Node getNode(Element root, String key) {
		//String value = "";
		Node node = null;
		try {
			if (null != root) {			
				NodeList list = root.getElementsByTagName(key);
				
				if ( null == list || 0 == list.getLength()) {
					throw new RuntimeException( key + " not found");
				} else {
					node = list.item(0);
				}
			} 
		} catch (RuntimeException e) {
			throw e;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		
		return node;
	}
	
	/**
	 * 
	 * @param root
	 * @param key
	 * @return
	 */
	public  NodeList getNodes(Element root, String key) {
		NodeList list = null;
		
		try {
			if (null != root) {			
				 list = root.getElementsByTagName(key);
				
				if ( null == list || 0 == list.getLength()) {
					throw new RuntimeException( key + " not found");
				}
			}
		} catch (RuntimeException e) {
			throw e;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		
		return list;
	}
	
	/**
	 * 读取文档根下的配置节点
	 * @param key 键
	 * @return 值
	 */	
	public  Node getNode(String key) {
		return getNode(rootElement, key);
	}
	
	/**
	 * 
	 * @param key
	 * @return
	 */
	public  NodeList getConfigNodes(String key) {
		return getNodes(rootElement, key);
	}	
	
	public  Node getNodeByPath(String path) {
		Element parentLevel = rootElement;

		try {	
			if (null != rootElement) {
				String[] pathSeq = path.split("/");
				int ind = 0;
				for (String p : pathSeq) {
					ind++;
					if (null != parentLevel) {
						parentLevel = (Element)getNode(parentLevel, p);
					} else {
						throw new RuntimeException(pathSeq[ind-2] + " not found");
					}
				}
				if (null == parentLevel) {
					throw new RuntimeException(pathSeq[ind-1] + " not found");
				} 
			}
		} catch (RuntimeException e) {
			throw e;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		
		return parentLevel;
	}
	/**
	 * 读取指定路径配置
	 * @param path 路径
	 * @return 值
	 */
	public  String getConfigByPath(String path) {
		String value = "";
		try {	
			Node res = getNodeByPath(path);
			if (null != res) {					
				Node n = res.getChildNodes().item(0);
				if (null != n) {						
					value = n.getNodeValue();
				}
			}
			else {
				throw new RuntimeException(path + "not found");
			}
		} catch (RuntimeException e) {
			throw e;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
		return value;
	}
	
	/**
	 * 设置配置信息
	 * @param path
	 * @param value
	 */
	public void setConfigByPath(String path, String value) {
		try {	
			Node res = getNodeByPath(path);
			if (null != res) {					
				// Node n = res.getChildNodes().item(0);
				if (null != res) {
					res.setTextContent(value);
				}
			}
			else {
				throw new RuntimeException(path + "not found");
			}
		} catch (RuntimeException e) {
			throw e;
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}
	

	/**
	 * 保存配置到指定文件
	 *
	 */
	public void restore(File conf) {
		try {
			TransformerFactory fac = TransformerFactory.newInstance();
			Transformer trans   = fac.newTransformer();
			StreamResult result = new StreamResult(conf);
			
			DOMSource source=new DOMSource(document);
			trans.setOutputProperty(OutputKeys.VERSION, document.getXmlVersion());
 			trans.setOutputProperty(OutputKeys.ENCODING, document.getXmlEncoding());
			trans.transform(source, result);
			
		} catch (Exception e) {
			throw new RuntimeException(e);
		}
	}

	
	/**
	 * 保存配置
	 *
	 */
	public void restoreConfig() {
		restore(file);
	}
}

