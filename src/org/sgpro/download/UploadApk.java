package org.sgpro.download;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.sgpro.util.Digest;

/**
 * Servlet implementation class UploadApk
 */
@WebServlet("/upload")
public class UploadApk extends HttpServlet {
	public static final String C_UPLOAD_APKS = "C:/upload/apks/";
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UploadApk() {
        super();
        // TODO Auto-generated constructor stub
    }
	protected List<FileItem>  parseRequest(HttpServletRequest req) throws Throwable {

		FileUpload fu = new FileUpload(new DiskFileItemFactory());
		
		 List<FileItem> l = fu.parseRequest(req);
		return l;
	}
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	
	HttpServletRequest context;
	HttpServletResponse response;
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		context  = request;
		// TODO Auto-generated method stub
		response.addHeader("Access-Control-Allow-Origin" , "*");
		request.setCharacterEncoding("utf-8");
		try {
			this.response = response;
			saveFiles(parseRequest(request));
		} catch (Throwable e) {
			// TODO Auto-generated catch block
			throw new IOException(e);
		}
	}
	
	protected boolean validateRequest(List<FileItem>  l) throws Throwable {
		 int uploadCount = 0;
		 for (FileItem fi : l) {
			 if (!fi.isFormField()) {
				 uploadCount++;
			 }
		 }
		 
		 if (uploadCount != 1) {
			 throw new Exception("upload object must be equal 1");
		 }
		 
		 return true;
	}
	
	
	private void saveFiles(List<FileItem> l) throws Throwable {
		// TODO Auto-generated method stub
		if (validateRequest(l)) {
			String objectName = null; 
			
			Map<String, String> description = new HashMap<String, String>();
			FileItem file = null;
			for (FileItem fi : l) {
				String key = fi.getFieldName();
				if (fi.isFormField()) {
					description.put(key, fi.getString("utf-8"));
				} else {
					file = fi;
				}
			}
			
			
//			objectName = Digest.getMD5(String.valueOf(System.currentTimeMillis())) 
//					+ "_" + file.getName();
			
			
			//update by lvdw;20171017;为了让中文名称和特殊字符命名的文件流也可以上传
			String objectType = file.getName().substring( file.getName().lastIndexOf("."));
			
			objectName = Digest.getMD5(String.valueOf(System.currentTimeMillis())+file.getName())+objectType;
			
			
			File dir = new File(C_UPLOAD_APKS);					
			if (file != null) {
				if (!dir.exists()) {
					dir.mkdirs();
				}
				
				if (dir.exists()) {
					file.write(new File(dir.getAbsoluteFile() + "/" + objectName));
				}
				
				String url = 
						
						String.format("%s://%s:%d%s/download?obj=%s", 
						  context.getScheme() 
						, context.getServerName() 
						, context.getServerPort() 
						, context.getContextPath()
						, objectName);
				
				String json = String.format("{\"url\" : \"%s\"}", url);
				response.getWriter().print(json);
			}
		}
	}

}
