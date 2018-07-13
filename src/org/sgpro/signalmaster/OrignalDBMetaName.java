package org.sgpro.signalmaster;

import org.hibernate.cfg.ImprovedNamingStrategy;

public class OrignalDBMetaName extends ImprovedNamingStrategy {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	 
	@Override
	public String columnName(String columnName) {
		// TODO Auto-generated method stub
		return columnName;
	}
	
	@Override
	public String propertyToColumnName(String propertyName) {
		// TODO Auto-generated method stub
		return propertyName;
	}

}
