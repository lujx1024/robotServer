package org.sgpro.util.http;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

public class MultipartDisposition {
	private String name;
	private byte[] data;
	private File   file;
	private String contentType;
	private InputStream is;
	private boolean isFile;
	private String  stringContent;
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	public InputStream getValue() {
		return is;
	}
	
	public void setData(String string)  throws Throwable  {
		setData(string, "utf-8");
	}
	
	public void setData(String string, String charsetName)  throws Throwable  {
		stringContent = string;
		setData(string.getBytes(charsetName));
	}
	
	public void setData(byte[] d)  throws Throwable  {
		data = d;
		if (data != null) {
			close();
			is = new ByteArrayInputStream(data);
			isFile = false;
		}
	}

	public void setFile(File f) throws Throwable {
		file = f;
		if (file != null && file.isFile() && file.exists() && file.canRead()) {
			close();
			is = new FileInputStream(file);
			String url = "file://" + file.getAbsolutePath();
			contentType = 
				"TODO" + url;
			stringContent = file.getName();
			isFile = true;
		}
	}
	public String getContentType() {
		return contentType;
	}

	public MultipartDisposition() {
		// TODO Auto-generated constructor stub
	}
	public MultipartDisposition(String name, Object value) throws Throwable {
		if (File.class.isInstance(value)) {
			setFile((File)value);
		} else {
			setData(value.toString());
		}
		setName(name);
	}
	
	public void close() throws Throwable {
		if (is != null) {
			is.close();
		}
	}
	public boolean isFile() {
		return isFile;
	}
	public String getStringContent() {
		return stringContent;
	}
	public long getContentLength() {
		// TODO Auto-generated method stub
		long ret = 0;
		if (isFile) {
			if (file != null) {
				ret = file.length();
			}
		} else {
			if (data != null) {
				ret = data.length;
			}
		}
		
		return ret;
	}
	
	
	
}
