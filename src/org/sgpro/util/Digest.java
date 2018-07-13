package org.sgpro.util;

import java.security.MessageDigest;

public class Digest {

	
	/**
	 * MD5 加密
	 * @return
	 */
	public static String getMD5(String src) {
        final char hexDigits[] = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 
                'a', 'b', 'c', 'd', 'e', 'f' }; 
        String  ret = "";
        try {
        	MessageDigest MD= MessageDigest.getInstance("MD5");	
        	MD.update(src.getBytes());
        	byte [] md = MD.digest();
        	
        	int  length = md.length; 
        	char res[] = new char[length * 2]; 
        	
        	int pnt = 0; 
        	for (int i = 0; i < length; i++) { 
        		byte b = md[i]; 
        		res[pnt++] = hexDigits[b >>> 4 & 0xf]; 
        		res[pnt++] = hexDigits[b & 0xf]; 
        	} 		
        	ret = String.valueOf(res);
        	
        } catch (Exception ex) {
        	
        }
        
		return ret;
	}
}
