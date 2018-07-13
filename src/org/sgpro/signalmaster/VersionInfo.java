package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
/**
 */
@Path("/version")
public class VersionInfo  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private static Version version = null;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public VersionInfo() {
        super();
    }
    
    public static class Version {
    	// private String signalmasterVersion = "1.0.20170110";
    	/**
    	 * 1.0.20170111   解决百度API 停运问题，第三方的html tag 全过滤
    	 * 1.0.20170119 html tag 过滤bug， 逗号输出
    	 * 1.0.20170206   回收科大讯飞模块控制权
    	 * 1.0.20170306   增强配置管理，远程遥控，远程视频
    	 * 1.0.20170309   视频转置
    	 * 1.0.20170313   加入网络测试工具
    	 * 1.0.20170314   加入状态自动切换, 加入人脸识别API
    	 * 1.0.20170322   加入配置项设置API
    	 * 1.0.20170325   加入配置项BITSET API，区分常用配置，客户端配置，用户配置，高级配置，开发者配置
    	 * 1.0.20170327   高级配置，常用配置前端页面链接修改
    	 * 1.0.20170328   加入手动切换通知，加入http客户端登录，加入获取配置owner列表的API,行业列表，企业列表，场景列表
    	 * 1.0.20170405   开发者模式
    	 * 1.0.20170407   无法回答的智能推荐
    	 * 1.0.20170408   改进机器ping设置online
    	 * 1.0.20170410   改进机器状态显示
    	 * 1.0.20170412   加入打印模板
    	 * 1.0.20170413   状态logout bug，导致数据库死锁，修正登录bug
    	 * 1.0.20170415   开发者模式加入日志和会话记录
    	 * 1.0.20170419   加入典型第三方API NLP
    	 * 1.0.20170503   加入语料工具的权限check，修改数据库密码
    	 * 1.0.20170504   登录失效的code修改为82
    	 * 1.0.20170523   加入空语料和未引用语料的搜索
    	 * 1.0.20170605   加入第三方API的支持API
    	 * 1.0.20170622   完善第三方API的支持
    	 * 1.0.20170815   加入dbscript，snapshot
    	 */
    	
    	private String signalmasterVersion = "1.0.20170815";

    	private String dbVersion = "<n/a>";
    	private String tomcatVersion = "<n/a>";
    	
    	@Override
    	public String toString() {
    		// TODO Auto-generated method stub
    		return GsonProvider.getGson().toJson(this).toString();
    	}
    }
    
    public static Version getVersion() {
    	if (version  == null) {
    		version = new Version();
    	}
    	return version;
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
    //@Context
    //private ApplicationContext app;

    
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String version(
  		) throws Throwable {
    	
    	Result r = Result.success();
    	Transaction trans = null;
    	try {
    		response.addHeader("Access-Control-Allow-Origin" , "*");
    		version = getVersion();
    		trans = HibSf.getSession().beginTransaction();
    		version.dbVersion = (String)ViewUtils.dbFunc("dbo.[FUNC_GET_META_SETTINGS]", "DB_VERSION" , "undefined");
    		r.setData(getVersion());
    		trans.commit();
    	} catch (Throwable th) {
			r = Result.unknowException(th);
			th.printStackTrace();
			
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
}
