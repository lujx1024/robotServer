package org.sgpro.download;

import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Download
 */
@WebServlet("/download")
public class Download extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Download() {
        super();
        // TODO Auto-generated constructor stub
    }

    public void download(HttpServletRequest request, HttpServletResponse response, String objectName) throws IOException {
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
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String objName =  request.getParameter("obj"); 
		download(request, response, objName);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
