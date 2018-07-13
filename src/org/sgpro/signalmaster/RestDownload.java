package org.sgpro.signalmaster;

import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.sgpro.download.UploadApk;

/**
 * Servlet implementation class Download
 */
@Path("/d")
public class RestDownload extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RestDownload() {
        super();
        // TODO Auto-generated constructor stub
    }

    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    @Path("/{objectName}")
    @GET
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    public String download(
    		@PathParam("objectName")
    		String objectName
    		) throws IOException {
    	if (objectName != null) {
			FileInputStream f = new FileInputStream(UploadApk.C_UPLOAD_APKS + "/" + objectName);
			
			response.setHeader("Content-Disposition", "attachment; filename=\""  
					+ objectName + "\"");
			response.setContentLength(f.available());

			ServletOutputStream os = response.getOutputStream();
			byte[] buff = new byte[Short.MAX_VALUE];
			while (f.available() > 0) {
				int realSize = f.read(buff , 0 , Short.MAX_VALUE);
				os.write(buff, 0, realSize);
			}
			
			f.close();
			os.close();
		}
    	return null;
    }
}
