package org.sgpro.apps;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBHelper {

	static Connection getConnection() throws Throwable {
		//SQLServerDriver.class.getName();
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		return DriverManager.getConnection(
				"jdbc:sqlserver://localhost:1433;databaseName=G2Robot"
				,"sgpro"
				,"4445632");
	}

	public static Throwable releaseConnection(Connection c) {
		// TODO Auto-generated method stub
		Throwable t = null;
		if (c != null) {
			try {
				c.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				t = e;
			}
		}
		return t;
	}
}
