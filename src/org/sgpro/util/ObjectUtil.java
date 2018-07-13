package org.sgpro.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;

public class ObjectUtil {

	
	static class  Calculator extends OutputStream {
		
		int byteCount = 0;
		
		@Override
		public void write(int arg0) throws IOException {
			// TODO Auto-generated method stub
			byteCount++;
		}
		
		public int getByteCount() {
			return byteCount;
		};
	}
	
	public static int calculateObjectLength(Object o) {
		int ret = 0;
		ObjectOutputStream oops = null;
		try {
			Calculator c = new Calculator();
			oops = new ObjectOutputStream(c);
			oops.writeObject(o);
			ret = c.getByteCount();
			
		} catch (Throwable t) {
			
		} finally {
			if (oops != null) {
				try {
					oops.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
				}
			}
		}
		
		return ret;
	}
	
	public static byte[] serialObjectToByteArray(Object o) {

		byte[] ret = null;
		ObjectOutputStream oops = null;
		ByteArrayOutputStream baos = null;
		
		try {
			
			if (o != null) {
				baos = new ByteArrayOutputStream();
				oops = new ObjectOutputStream(baos);
				
				oops.writeObject(o);
				oops.flush();
				baos.flush();
				
				ret = baos.toByteArray();
				
				oops.close();
				baos.close();
				
				oops = null;
				baos = null;
				
			}
			
		} catch (Throwable t) {
			throw new RuntimeException(t);
		} finally {
			if (oops != null) {
				try {
					oops.close();
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
			if (baos != null) {
				try {
					baos.close();
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
		}
		
		return ret;
	
	}
	
	public static Object deSerialObjectFromByteArray(byte[] in) {

		Object ret = null;
		ObjectInputStream ois = null;
		ByteArrayInputStream bais = null;
		
		try {
			
			if (in != null) {
				bais = new ByteArrayInputStream(in);
				ois = new ObjectInputStream(bais);
				
				ret = ois.readObject();
				ois.close();
				bais.close();
				
				
				ois = null;
				bais = null;
				
			}
			
		} catch (Throwable t) {
			throw new RuntimeException(t);
		} finally {
			if (ois != null) {
				try {
					ois.close();
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
			if (bais != null) {
				try {
					bais.close();
				} catch (IOException e) {
					throw new RuntimeException(e);
				}
			}
		}
		
		return ret;
	
	}
}
