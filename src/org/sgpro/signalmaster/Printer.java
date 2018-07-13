package org.sgpro.signalmaster;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.print.Doc;
import javax.print.DocFlavor;
import javax.print.DocPrintJob;
import javax.print.PrintService;
import javax.print.PrintServiceLookup;
import javax.print.SimpleDoc;
import javax.print.attribute.Attribute;
import javax.print.attribute.AttributeSet;
import javax.print.attribute.HashPrintRequestAttributeSet;
import javax.print.attribute.PrintRequestAttributeSet;
import javax.print.attribute.standard.Copies;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.sgpro.db.HibSf;

import config.Log4jInit;

/**
 */
@Path("/print")
public class Printer extends HttpServlet {
	static Logger logger = Logger.getLogger(Printer.class.getName());

	public static final String ADMIN = "admin";
	public static final String ACCESS_KEY = "ACCESS_KEY";
	public static final String VERSION = "VERSION";

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Printer() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Context
	private HttpServletRequest request;
	@Context
	private HttpServletResponse response;

	@Path("/ex/{print_key}/{pic}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String print(
			@PathParam("print_key") String key
			,@PathParam("pic") String pic
			) {

		Result r = Result.success();

		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			FileInputStream psStream = null;
			psStream = new FileInputStream("D:\\mydoc\\MyPic\\" + pic);
			// 设置打印数据的格式，此处为图片gif格式
			DocFlavor psInFormat = DocFlavor.INPUT_STREAM.JPEG;
			// 创建打印数据
			Doc myDoc = new SimpleDoc(psStream, psInFormat, null);

			// 设置打印属性
			PrintRequestAttributeSet aset = new HashPrintRequestAttributeSet();
			// aset.add(new Copies(3));// 打印份数，3份

			// 查找所有打印服务
			PrintService[] services = PrintServiceLookup.lookupPrintServices(
					psInFormat, aset);

			PrintService myPrinter = getPS(Arrays.asList(services), key);

			assert(myPrinter != null);
			
			// dumpPrinterInfo(myPrinter);
			
			DocPrintJob job = myPrinter.createPrintJob();// 创建文档打印作业
			// job.print(myDoc, aset);// 打印文档
			logger.info("已远程打印:" + pic);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}

		return r.toString();
	}
	
	private void dumpPrinterInfo(PrintService myPrinter) {
		// TODO Auto-generated method stub
		// 可以输出打印机的各项属性
		AttributeSet att = myPrinter.getAttributes();

		for (Attribute a : att.toArray()) {

			String attributeName;
			String attributeValue;

			attributeName = a.getName();
			attributeValue = att.get(a.getClass()).toString();

			logger.info(attributeName + " : " + attributeValue);
		}
	}

	private PrintService getPS(List<PrintService> ps, String key) {
		PrintService p = null;
		if (ps != null) {
			for (int i = 0; i < ps.size(); i++) {  
				p = ps.get(i);
				logger.info("service found: " + p);  
				String svcName = p.toString();  
				if (svcName.toUpperCase().contains(key.toUpperCase()) 
						|| p.getName().toUpperCase().contains(key.toUpperCase())) {  
					//System.out.println("my printer found: " + svcName);  
					// System.out.println("my printer found: " + p);  
					break;  
				}  
			}  
		}
		
		return p;
	}

}
