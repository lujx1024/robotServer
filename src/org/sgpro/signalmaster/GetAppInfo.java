package org.sgpro.signalmaster;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;









import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.log4j.Logger;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.sgpro.db.EntRobot;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewConfigModuleBitMask;
import org.sgpro.db.ViewRobotAppBindList;
import org.sgpro.db.ViewRobotAppBindListId;
import org.sgpro.util.DateUtil;

import com.google.gson.Gson;

import config.Log4jInit;
/**
 * 该接口用来检测当前机器人上的APK是否有更新
 * @author LvDW
 * */

@Path("/getAppInfo")
public class GetAppInfo extends HttpServlet{
	static Logger logger = Logger.getLogger(GetAppInfo.class.getName());
//	private String sn;
//	private List<apkList> apkList = new ArrayList<apkList>();
//	

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	
	@Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;

	class ApkInfo{
		private String apkName;
		private String apkVersion;
		private String isUpdate;
		private String downLoadUrl;
		private String apkDscription;
		
		
		
		public String getApkDscription() {
			return apkDscription;
		}
		public void setApkDscription(String apkDscription) {
			this.apkDscription = apkDscription;
		}
		public String getApkName() {
			return apkName;
		}
		public void setApkName(String apkName) {
			this.apkName = apkName;
		}
		public String getApkVersion() {
			return apkVersion;
		}
		public void setApkVersion(String apkVersion) {
			this.apkVersion = apkVersion;
		}
		public String getIsUpdate() {
			return isUpdate;
		}
		public void setIsUpdate(String isUpdate) {
			this.isUpdate = isUpdate;
		}
		public String getDownLoadUrl() {
			return downLoadUrl;
		}
		public void setDownLoadUrl(String downLoadUrl) {
			this.downLoadUrl = downLoadUrl;
		}
	}
	
	
	long prevTicks = 0;
    public void outputLog(String str) {
    	long thisTics = System.currentTimeMillis();
    	long tooks = prevTicks == 0? 0 : thisTics - prevTicks;
    	logger.info(
    			String.format("CURRENT:[%s] TOOKS:[%04d] %s" ,  DateUtil.toDefaultFmtString(thisTics) , tooks , str));
    	prevTicks = thisTics;
    }
	
	
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	@SuppressWarnings("unchecked")
	public String getAppConfig(
			@FormParam("sn") String sn
		   ,@FormParam("apkList") String apkList
		   )throws Throwable{
		
		outputLog("接受到终端的请求，开始检查apk版本更新");
		String apkName="";
		String apkVersion="";
		String nowApkVersion = "";
		ApkInfo apkInfo = new ApkInfo();
		List<ApkInfo> newApkList = new ArrayList<ApkInfo>();
		Map<String,Object> map = new HashMap<String,Object>();
		
		Result r = Result.success();
    	Transaction trans = null;
		try{
			JSONArray jsonArray = JSONArray.fromObject(apkList);
			List<Map<String,String>> list = (List) jsonArray;
			
			
			//启事物
			trans = HibSf.getSession().beginTransaction();
			
					
			//此查询方式是查询一个集合
			String sql = "SELECT  * FROM VIEW_ROBOT_APP_BIND_LIST WHERE ROBOT_IMEI = '" +sn+"'"; 
			List<Object> en = ViewUtils.getViewDataList(
					HibSf.getSession()
					.createSQLQuery(sql).addEntity(ViewRobotAppBindList.class).list()
					);
			
			List<ViewRobotAppBindListId> vr = new ArrayList<ViewRobotAppBindListId>();
			
			for(int i = 0;i<en.size();i++){
				Object object = en.get(i);
				if(object instanceof ViewRobotAppBindListId ){
					vr.add((ViewRobotAppBindListId)(object));
				}
			}
			
			
			//查询数据库获取到当前的apkName对应的apkVersion以及DownLoadUrl
			//此查询方式是查询一条记录
//			ViewRobotAppBindList en = (ViewRobotAppBindList) ViewUtils.getViewDataFirstIndex(
//		    		ViewUtils.sqlQuery("SELECT TOP 1 * FROM VIEW_ROBOT_APP_BIND_LIST WHERE ROBOT_IMEI = ? AND APP_PACKAGE_NAME = ?", ViewRobotAppBindList.class, sn,apkName));
//			nowApkVersion = en.getId().getLastestVersionName();
			
			int isHave = 0;		
			for(int j = 0;j<vr.size();j++){
				isHave = 0;
				for(int i=0;i<list.size();i++){
					try{
						Map<String,String> apkMap = list.get(i);
						apkInfo = new ApkInfo();
						apkName = apkMap.get("apkName");
						apkVersion = apkMap.get("apkVersion");
						nowApkVersion = vr.get(j).getLastestVersionName();
						
						if(apkName.equals(vr.get(j).getAppPackageName())){
							//比较终端发送过来的版本号以及查询出来的版本号
							
							boolean nRet = compareVersion(apkVersion,nowApkVersion);
							if(nRet){
								apkInfo.setApkName(apkName);
								apkInfo.setApkVersion(nowApkVersion);
								apkInfo.setIsUpdate("1");
								apkInfo.setDownLoadUrl(vr.get(j).getDownloadUrl());
								apkInfo.setApkDscription(vr.get(j).getDescription());
							}else{
								apkInfo.setApkName(apkName);
								apkInfo.setApkVersion(apkVersion);
								apkInfo.setIsUpdate("0");
								apkInfo.setDownLoadUrl("");
								apkInfo.setApkDscription(vr.get(j).getDescription());
							}
							
							newApkList.add(apkInfo);
							outputLog(apkName+"检查成功！");
							
							isHave = 1;
							break;
						}
					}catch(Exception e){
						e.getMessage();
						outputLog(apkName+"检查失败！");
					}
				}
				
				if(isHave==0){
					apkInfo = new ApkInfo();
					apkInfo.setApkName(vr.get(j).getAppPackageName());
					apkInfo.setApkVersion(vr.get(j).getLastestVersionName());
					apkInfo.setIsUpdate("1");
					apkInfo.setDownLoadUrl(vr.get(j).getDownloadUrl());
					apkInfo.setApkDscription(vr.get(j).getDescription());
					outputLog(apkName+"检查成功！,此apk为新的apk");
					newApkList.add(apkInfo);
				}
				
			}
			r.setData(newApkList);
			
//			map.put("sn", sn);
//			map.put("apkList", newApkList);
			
//			JSONObject json = JSONObject.fromObject(map);
//			Gson gson = new Gson();
//			String json = gson.toJson(map).toString();
//			r.setData(json);
			
			trans.commit();
			
		}catch(Throwable e){
			r = Result.unknowException(e);
			
			e.printStackTrace();
			
			try {
				if (trans != null) {
					trans.rollback();
				}
			} catch (Throwable t) {
				r = Result.unknowException(t);
				t.printStackTrace();
			}
		}
		  
		
		
		
		return r.toString();
		
	}
	
	
	/**
	 * 比较版本号
	 * 当前版本号大于终端版本号 返回1
	 * 当前版本号小于或者等于终端版本号  返回 0
	 * */
	public boolean compareVersion(String apkVersion,String nowApkVersion){
		boolean result = false;
		try{
			String[] apkVersionList = apkVersion.substring(1, apkVersion.length()).split("\\.",3);
			String[] nowApkVersionList = nowApkVersion.substring(1, apkVersion.length()).split("\\.",3);
			for(int i = 0;i<3;i++){
				if(Integer.valueOf(apkVersionList[i])<Integer.valueOf(nowApkVersionList[i])){
					result = true;
					break;
				}
			}
		}catch(Throwable e){
			outputLog("版本号比较的时候出错了"+e);
			e.printStackTrace();
		}
		
		return result;
		
	}
	
}
