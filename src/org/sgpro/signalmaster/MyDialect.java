package org.sgpro.signalmaster;

import org.hibernate.dialect.SQLServer2005Dialect;

public class MyDialect extends SQLServer2005Dialect {
	
	
	public MyDialect() {
		super();
		// TODO Auto-generated constructor stub
		// registerColumnType(Types.LONGNVARCHAR, "nvarchar(max)");
		//  registerColumnType(Types.VARCHAR, 65535, "varchar($1)");
		// registerColumnType(Types.VARCHAR, "nvarchar($l)");
		// registerColumnType(Types.VARCHAR, 65535, "varchar($l)");
		
		// registerColumnType(Types.LONGNVARCHAR, 65535, "varchar($l)");
		// registerColumnType(Types.LONGNVARCHAR, 65535, "varchar($l)");
		// registerHibernateType(Types.LONGVARCHAR, 65535, "varchar($l)");
		// registerColumnType(Types.CLOB, "nvarchar(max)");  
	}

}
