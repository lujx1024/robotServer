package org.sgpro.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;

import config.Log4jInit;
class StreamDrainer implements Runnable {
	
	static Logger logger = Logger.getLogger(StreamDrainer.class.getName());
    private InputStream ins;

    public StreamDrainer(InputStream ins) {
        this.ins = ins;
    }

    public void run() {
        try {
            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(ins));
            String line = null;
            while ((line = reader.readLine()) != null) {
            	logger.info(line);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
public class RuntimeUtil {

	
	
	public static void windowsCommand(String cmdLine) {
		        String[] cmd = new String[] { "cmd.exe", "/C", cmdLine };
		        try {
		            Process process = Runtime.getRuntime().exec(cmd);
		            
		            new Thread(new StreamDrainer(process.getInputStream())).start();
		            new Thread(new StreamDrainer(process.getErrorStream())).start();
		            
		            process.getOutputStream().close();
		        } catch (Exception e) {
		            e.printStackTrace();
		        }
	}
}
