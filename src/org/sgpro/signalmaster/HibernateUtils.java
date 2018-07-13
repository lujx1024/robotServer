package org.sgpro.signalmaster;

import java.util.Iterator;

import org.hibernate.cfg.Configuration;
import org.hibernate.mapping.Column;
import org.hibernate.mapping.PersistentClass;
import org.hibernate.mapping.Property;

public class HibernateUtils {

	public  static Configuration hibernateConf;

	static {
		
		if (hibernateConf == null) {
			hibernateConf = new Configuration();
			hibernateConf.configure("hibernate.cfg.xml");
		}
	}

	private static PersistentClass getPersistentClass(Class<?> clazz) {
		synchronized (HibernateUtils.class) {
			PersistentClass pc = hibernateConf.getClassMapping(
					clazz.getName());
			if (pc == null) {
				hibernateConf .addClass(clazz);
				pc = hibernateConf.getClassMapping(clazz.getName());

			}
			return pc;
		}
	}

	/**
	 * 功能描述：获取实体对应的表名
	 * 
	 * @param clazz
	 *            实体类
	 * @return 表名
	 */
	public static String getTableName(Class<?> clazz) {
		return getPersistentClass(clazz).getTable().getName();
	}

	/**
	 * 功能描述：获取实体对应表的主键字段名称
	 * 
	 * @param clazz
	 *            实体类
	 * @return 主键字段名称
	 */
	public static String getPkColumnName(Class<?> clazz) {

		return getPersistentClass(clazz).getTable().getPrimaryKey()
				.getColumn(0).getName();

	}

	/**
	 * 功能描述：通过实体类和属性，获取实体类属性对应的表字段名称
	 * 
	 * @param clazz
	 *            实体类
	 * @param propertyName
	 *            属性名称
	 * @return 字段名称
	 */
	public static String getColumnName(Class<?> clazz, String propertyName) {
		PersistentClass persistentClass = getPersistentClass(clazz);
		Property property = persistentClass.getProperty(propertyName);
		Iterator<?> it = property.getColumnIterator();
		if (it.hasNext()) {
			Column column = (Column) it.next();
			return column.getName();
		}
		return null;
	}

}
