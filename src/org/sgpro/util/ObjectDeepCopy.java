package org.sgpro.util;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;


public class ObjectDeepCopy {

	@SuppressWarnings("unchecked")
	public static <T> T copyObject(T input) {
		
		T output = null;
		try {
			if (input != null) {
				ByteArrayOutputStream baos = new ByteArrayOutputStream();
				ObjectOutputStream byteOos = new ObjectOutputStream(baos);
				byteOos.writeObject(input);
				
				byte[] bs = baos.toByteArray();
				
				ObjectInputStream ois2 = new ObjectInputStream(new ByteArrayInputStream(bs));
				output = (T) ois2.readObject(); 
			}
		} catch (Throwable t) {
			throw new RuntimeException("ObjectDeepCopy error.", t);
		}
		
		return output;
	}
}
