package org.sgpro.signalmaster;
/**
 * @author lvdw
 * 2018-07-13
 * 互联互通接口
 * */

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.sgpro.db.HibSf;
import org.sgpro.util.DateUtil;

@Path("/connect")
public class Connectivity extends HttpServlet {
	static Logger logger = Logger.getLogger(Connectivity.class.getName());

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Connectivity() {
		super();
		// TODO Auto-generated constructor stub
	}

	@Context
	private HttpServletRequest request;
	@Context
	private HttpServletResponse response;

	/**
	 * 输出日志
	 */
	long prevTicks = 0;

	public void outputLog(String str) {
		long thisTics = System.currentTimeMillis();
		long tooks = prevTicks == 0 ? 0 : thisTics - prevTicks;
		logger.info(String.format("CURRENT:[%s] TOOKS:[%04d] %s", DateUtil.toDefaultFmtString(thisTics), tooks, str));
		prevTicks = thisTics;
	}

	/**
	 * 根据机器人名称查询机器人所管控的所有灯具
	 * 
	 * @param robotName
	 *            机器人名称
	 * @return 机器人的灯具控制信息
	 */
	@Path("selectlamp")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String selectLamp(@FormParam("robotName") String robotName) {
		// 返回结果
		Result r = Result.success();

		Connection connection = null;

		CallableStatement callable = null;
		ResultSet rs = null;

		// 结果集容器
		List<Map<String, Object>> controlInfo = new ArrayList<>();

		boolean robotNameIsNull = true;

		if (!StringUtils.isEmpty(robotName)) {
			robotNameIsNull = false;
		}

		// 拼接字符串
		String sql = "SELECT c.ID id ,c.DEVICE_ID deviceId, c.ROBOT_SN robotSn,r.NAME robotName,c.LAMP_NAME lambName,c.LAMP_INDEX lambIndex,c.STATUS lambStatus FROM [dbo].[ENT_ROBOT] r,dbo.ENT_CONNECTIVITY_LAMP c where c.ROBOT_SN=r.IMEI";

		// 若机器人名称不为空，则拼接模糊查询
		if (!robotNameIsNull) {
			sql += " AND r.NAME LIKE ? ";
		}
		connection = HibSf.getConnection();
		try {
			callable = connection.prepareCall(sql);

			// 若机器人名称不为空，则拼接模糊查询
			if (!robotNameIsNull) {
				callable.setString(1, "%" + robotName + "%");
			}
			// 获取查询结果
			rs = callable.executeQuery();
			// 迭代取结果
			while (rs.next()) {
				Map<String, Object> map = new HashMap<>();
				map.put("robotSn", rs.getString("robotSn"));
				map.put("robotName", rs.getString("robotName"));
				map.put("lambName", rs.getString("lambName"));
				map.put("lambIndex", rs.getInt("lambIndex"));
				map.put("lambStatus", rs.getInt("lambStatus"));
				map.put("id", rs.getInt("id"));
				map.put("deviceId", rs.getString("deviceId"));
				controlInfo.add(map);
			}
			System.err.println(controlInfo);
			r.setData(controlInfo);

		} catch (SQLException e) {
			r = Result.unknowException(e);
			e.printStackTrace();
		} finally {
			// 关闭所有连接
			closeConnectionObject(rs, callable, connection);
		}
		return r.toString();
	}
	/**
	 * 根据机器人Sn号查询机器人所管控的左右灯具
	 * 
	 * @param robotSn
	 *            机器人名称
	 * @return 机器人的灯具控制信息
	 */
	@Path("selectlamp/{robotSn}")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String selectLampBySn(@PathParam("robotSn") String robotSn) {
		// 返回结果
		Result r = Result.success();

		Connection connection = null;

		CallableStatement callable = null;
		ResultSet rs = null;

		// 结果集容器
		List<Map<String, Object>> controlInfo = new ArrayList<>();

		boolean robotNameIsNull = true;

		if (!StringUtils.isEmpty(robotSn)) {
			robotNameIsNull = false;
		}

		// 拼接字符串
		String sql = "SELECT c.ID id ,c.DEVICE_ID deviceId, c.ROBOT_SN robotSn,r.NAME robotName,c.LAMP_NAME lambName,c.LAMP_INDEX lambIndex,c.STATUS lambStatus FROM [dbo].[ENT_ROBOT] r,dbo.ENT_CONNECTIVITY_LAMP c where c.ROBOT_SN=r.IMEI";

		// 若机器人名称不为空，则拼接模糊查询
		if (!robotNameIsNull) {
			sql += " AND c.ROBOT_SN LIKE ? ";
		}
		try {
			connection = HibSf.getConnection();
			callable = connection.prepareCall(sql);

			// 若机器人名称不为空，则拼接模糊查询
			if (!robotNameIsNull) {
				callable.setString(1, "%" + robotSn + "%");
			}
			// 获取查询结果
			rs = callable.executeQuery();

			// 迭代取结果
			while (rs.next()) {

				Map<String, Object> map = new HashMap<>();
				map.put("robotSn", rs.getString("robotSn"));
				map.put("robotName", rs.getString("robotName"));
				map.put("lambName", rs.getString("lambName"));
				map.put("lambIndex", rs.getInt("lambIndex"));
				map.put("lambStatus", rs.getInt("lambStatus"));
				map.put("id", rs.getInt("id"));
				map.put("deviceId", rs.getString("deviceId"));
				controlInfo.add(map);
			}
			System.err.println(controlInfo);
			r.setData(controlInfo);

		} catch (SQLException e) {
			r = Result.unknowException(e);
			e.printStackTrace();
		} finally {
			// 关闭所有连接
			closeConnectionObject(rs, callable, connection);

		}
		return r.toString();

	}
	/**
	 * 增加灯路信号信息
	 */
	@Path("savelamp")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveLamp(@FormParam("robotSn") String robotSn, @FormParam("lampName") String lampName,
			@FormParam("lampIndex") String lampIndex) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			r.setData(ViewUtils.dbProc(" SP_CONNECT_SAVE_LAMP", robotSn, lampName, lampIndex, "LAMP"));
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

	/**
	 * 修改灯路电源信号
	 */
	@Path("updatelamp")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String updateLamp(@FormParam("id") long id, @FormParam("robotSn") String robotSn,
			@FormParam("lampName") String lampName, @FormParam("lampIndex") String lampIndex) throws Throwable {
		Result r = Result.success();
		Transaction trans = null;

		try {
			trans = HibSf.getSession().beginTransaction();

			r.setData(ViewUtils.dbProc(" SP_CONNECT_UPDATE_LAMP", id, robotSn, lampName, lampIndex, "LAMP"));
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

	/**
	 * 删除信息
	 */
	@Path("deletelamp")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteLamp(@FormParam("id") String ids) throws Throwable {

		Result r = Result.success();

		Transaction trans = null;
		//id列表
		String[] idList = null;

		//获取需要删除的记录的id列表
		if (!StringUtils.isEmpty(ids)) {
			idList = ids.split(",");

		}
		try {

			trans = HibSf.getSession().beginTransaction();
			for (String id : idList) {
				ViewUtils.dbSql("DELETE FROM dbo.ENT_CONNECTIVITY_LAMP WHERE ID = ? ", id);

			}

			// recordLog(000l, "删除用户" + userId, "");

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
	
	/**
	 * 关闭数据连接参数
	 * @param rs 结果集
	 * @param ps  preparedStatement
	 * @param conn 数据库连接
 	 */
	public void closeConnectionObject(ResultSet rs,PreparedStatement ps,Connection conn){
		if(rs!=null){
			try {
				rs.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(ps!=null){
			try {
				ps.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		if(conn!=null){
			try {
				conn.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

}
