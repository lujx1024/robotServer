package org.sgpro.download;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUpload;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.Expression;
import org.hibernate.criterion.Order;
import org.sgpro.db.EntThirdPartyApi;
import org.sgpro.db.EntVoiceCommand;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewEndpointLatestStatusId;
import org.sgpro.db.ViewWordGroupFlowToVoiceGroupRuleOrignalV2;
import org.sgpro.signalmaster.DBFunctionUtils;
import org.sgpro.signalmaster.Remote;
import org.sgpro.signalmaster.Result;
import org.sgpro.signalmaster.ViewUtils;
import org.sgpro.util.ObjectCast;
import org.sgpro.util.StringUtil;


import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 * Servlet implementation class UploadApk
 */
@WebServlet("/upload_voice_table")
public class UploadOrignalVoiceTable extends HttpServlet {
	static Logger logger = Logger.getLogger(UploadOrignalVoiceTable.class.getName());
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public UploadOrignalVoiceTable() {
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
	private ViewEndpointLatestStatusId userEp;
	private List<EntThirdPartyApi>  _3rdList;
	private List<EntVoiceCommand> cmdlist;
	
	public long get3RdIdByName(String name) {
		long ret = 0;
		
		if (_3rdList != null) {
			for (EntThirdPartyApi c : _3rdList) {
				if (c != null && c.getName() != null && c.getDescription().equals(name)) {
					ret = c.getId();
					break;
				}
			}
		}
		return ret;
	}
	
	public long getCmdIdByName(String name) {
		long ret = 0;
		
		if (cmdlist != null) {
			for (EntVoiceCommand c : cmdlist) {
				if (c != null && c.getName() != null && c.getName().equals(name)) {
					ret = c.getId();
					break;
				}
			}
		}
		return ret;
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		context  = request;
		// TODO Auto-generated method stub
		response.addHeader("Access-Control-Allow-Origin" , "*");
		request.setCharacterEncoding("utf-8");
		Result rs = Result.success();
		Transaction trans = null; 
		try {
			Session s = HibSf.getSession();
			trans = s.beginTransaction();

			userEp = DBFunctionUtils.getEndPointBySessionId(request
					.getSession().getId());

			if (userEp == null) {
				throw new Exception("用户未登录");
			}
			
			DBFunctionUtils.validateLoginSession(request);
			this.response = response;
			
			// 命令列表
			// 第三方列表
			_3rdList = s
			.createCriteria(EntThirdPartyApi.class)
			.add(Expression.eq("enable", true))
			.addOrder(Order.asc("name"))
			.list();
			
			cmdlist = s
					.createCriteria(EntVoiceCommand.class)
					.addOrder(Order.asc("name"))
					.list();
			saveFiles(parseRequest(request));

			trans.commit();

		} catch (Throwable e) {
			// TODO Auto-generated catch block
			if (trans != null) {
				trans.rollback();
			}
			rs = Result.unknowException(e);
		}
		response.setCharacterEncoding("utf-8");
		response.getWriter().print(rs.toString());
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
	
	
	enum VoiceColumnName {
		  /**
		   * 序号
		   */
		   SEQ(ColumnIndex())
		   /**
		    * 名字
		    */
		  , Name(ColumnIndex())
		  /**
		   * 提问方式
		   */
		  , Request(ColumnIndex())
		  /**
		   * 回答方式
		   */
		  , Text(ColumnIndex())
		  /**
		   * 音频路径
		   */
		  , Path(ColumnIndex())
		  /**
		   * 表情
		   */
		  , Emotion(ColumnIndex())
		  /**
		   * 命令
		   */
		  , Command(ColumnIndex())
		  /**
		   * 命令参数
		   */
		  , CommandParam(ColumnIndex())
		  /**
		   * 第三方
		   */
		  , ThirdPartyApi(ColumnIndex())
		  /**
		   * 第三方参数
		   */
		  , ThirdPartyApiParamsValueId(ColumnIndex())
		  /**
		   * TAG
		   */
		  , IncProp(ColumnIndex()), 
		  /**
		   * 用户id
		   */
		  UserId(ColumnIndex()),
		  ;

		VoiceColumnName(int cIndex) {
			this.columnIndex = cIndex;
		}
		
		public int index() {
			return columnIndex;
		}
		
		private  int columnIndex = 0;

		private static int ColumnIndex = 0;

		private static int ColumnIndex() {
			return ColumnIndex++;
		}
	}
	
	public  <T> T getCellValue(Row row, VoiceColumnName col, Class<T> type) {
		Object ret = null;
		if (Number.class.equals(type.getSuperclass())) {
			Double d = row.getCell(col.index()).getNumericCellValue();
			
			if (Long.class.equals(type)) {
				ret =  d.longValue();
			}
			
			if (Double.class.equals(type)) {
				ret =  d.doubleValue();
			}
			
			if (Integer.class.equals(type)) {
				ret =  d.intValue();
			}
			
			if (Short.class.equals(type)) {
				ret =  d.shortValue();
			}
			
			if (Float.class.equals(type)) {
				ret =  d.floatValue();
			}
		}
		
		return (T)ret;
	}
	
	public  String getCellValue(Row row, VoiceColumnName col) {
		return ObjectCast.castStringToObject(String.class, row.getCell(col.index()).toString(), null);
	}

	long getCurrentUserId() {
		return userEp == null ? 1476294385117L : userEp
				.getEndPointId();
	}
	public void readXls(InputStream is) throws IOException {
			
			Workbook wb = new XSSFWorkbook(is);
			// 循环工作表Sheet
			if (wb.getNumberOfSheets() > 0) {
				Sheet sheet = wb.getSheetAt(0);
				if (sheet != null) {
					
					// 循环行Row
					handleSheet(sheet);
				}
				
			}
			
			
	}

	
	private void handleSheet(Sheet sheet) {
		// TODO Auto-generated method stub
		if (sheet != null) {
			for (int rowNum = 1; rowNum <= sheet.getLastRowNum(); rowNum++) {
				Row row = sheet.getRow(rowNum);
				if (row != null 
						&& StringUtil.isNotNullAndEmpy(getCellValue(row, VoiceColumnName.Name))
						&& StringUtil.isNotNullAndEmpy(getCellValue(row, VoiceColumnName.Request))
						) {
					
					logger.info("上传：" + getCellValue(row, VoiceColumnName.Name) 
							+ " - " +  getCellValue(row, VoiceColumnName.Request));
					
					ViewUtils.dbProcQuery(ViewWordGroupFlowToVoiceGroupRuleOrignalV2.class,
							"SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2",
							null, // @ORGINAL_RULE_ID
							null, // @VOICE_ID
							getCellValue(row, VoiceColumnName.Name), // @NAME
							getCellValue(row, VoiceColumnName.Path),// @PATH
							getCellValue(row, VoiceColumnName.Emotion),// @EMOTION
							getCellValue(row, VoiceColumnName.Text),// @TEXT
							
							getCmdIdByName(getCellValue(row, VoiceColumnName.Command)),
							getCellValue(row, VoiceColumnName.CommandParam), //@COMMAND_PARAM
							get3RdIdByName(getCellValue(row, VoiceColumnName.ThirdPartyApi)),
							
							getCellValue(row,
									VoiceColumnName.ThirdPartyApiParamsValueId, //@THIRD_PARTY_API_PARAMS_VALUE_ID
									Long.class),
							// getCellValue(row, VoiceColumnName.IncProp), // @INC_PROP
							null,		
							"4", // @CAT 用户提交
							getCellValue(row, VoiceColumnName.Request), // @REQUEST
							userEp == null ? 1476294385117L : userEp
									.getEndPointId(), // @USER_ID 
							"客户批量提交");  // description
				}
			}
		}
	}
	private void saveFiles(List<FileItem> l) throws Throwable {
		// TODO Auto-generated method stub
		if (validateRequest(l)) {

			for (FileItem fi : l) {
				if (!fi.isFormField()) {
					readXls(fi.getInputStream());
					break;
				}
			}
		}
	}
}
