package org.sgpro.util;

import java.sql.Timestamp;
import java.util.Calendar;

/**
 * 日期工具
 * @author yinshengge
 *
 */
public class DateUtil {
	
	@SuppressWarnings("deprecation")
	public static Timestamp getMaxDate() {
		Timestamp now = getNow();
		now.setYear(now.getYear() + 100);
		return now;
	}
	
	public static Timestamp  getNow() {
		Timestamp ret = null;
		
		Calendar c  = Calendar.getInstance();
		ret = new Timestamp( c.getTime().getTime() );
		
		return ret;
	}
	
	@SuppressWarnings("deprecation")
	public static Timestamp getZeroDateTime() {
		return new Timestamp(0, 0 , 1, 0, 0, 0, 0); 
	}
	@SuppressWarnings("deprecation")
	public static String toDefaultFmtString(Timestamp ts) {

		String ret = "";
		
		if (ts != null) {
			ret = String.format("%d-%d-%d %d:%d:%d"
					, ts.getYear() + 1900
					, ts.getMonth() + 1
					, ts.getDate()
					, ts.getHours()
					, ts.getMinutes()
					, ts.getSeconds());
			
		}
		
		return ret;
	}
	
	public static String toDefaultFmtString(long millsec) {
		return toDefaultFmtString(new Timestamp(millsec));
	}
	
	@SuppressWarnings("deprecation")
	public static String getTimespanDescription() {
		// TODO Auto-generated method stub
		Timestamp now = getNow();
		String ret = null;
		
		switch (now.getHours()) {
		case 0:
		case 1:
		case 2:
		case 3:
		case 4:
			ret = "夜里";
			break;
		case 5:
		case 6:
		case 7:
		case 8:
			ret = "早上";
			break;
		case 9:
		case 10:
		case 11:
			ret = "上午";
			break;
		case 12:
			ret = "中午";
			break;
		case 13:
		case 14:
		case 15:
		case 16:
			ret = "下午";
			break;
		case 17:
		case 18:
			ret = "傍晚";
			break;
		case 19:
		case 20:
		case 21:
		case 22:
		case 23:
			ret = "晚上";
			break;
		}
		
		return ret;
	}
}
