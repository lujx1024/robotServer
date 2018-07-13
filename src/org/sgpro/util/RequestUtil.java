package org.sgpro.util;

import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletInputStream;
import javax.servlet.ServletRequest;
import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import config.Log4jInit;
import net.sf.json.JSONObject;

public class RequestUtil {
	static Logger logger = Logger.getLogger(RequestUtil.class.getName());
	public static JSONObject requestToJson(ServletRequest req) throws Throwable {
		JSONObject obj = null;
		if (req != null) {
			// req.getParameterNames()
			obj = new JSONObject();
			List<?> names = CollectionUtil.enumeration(req.getParameterNames());
			for (Object name : names) {
				String n = name.toString();
				String[] vs = req.getParameterValues(n);
				int vsCount = vs == null ? 0 : vs.length;
				if (vsCount == 1) {
					obj.put(n, vs[0]);
				} else if (vsCount > 1) {
					obj.put(n, vs);
				}
				logger.info(n + ":" + obj.opt(n));

			}
		}
		return obj;
	}

	public static JSONObject requestParaMapToJson(Map<String, String[]> map)
			throws Throwable {
		JSONObject obj = null;
		if (map != null) {
			// req.getParameterNames()
			obj = new JSONObject();
			for (String name : map.keySet()) {
				String n = name.toString();
				String[] vs = map.get(n);
				int vsCount = vs == null ? 0 : vs.length;
				if (vsCount == 1) {
					obj.put(n, vs[0]);
				} else if (vsCount > 1) {
					obj.put(n, vs);
				}
				logger.info(n + ":" + obj.opt(n));
			}
		}
		return obj;
	}

	public static void parseParameters(Map map, String data, String encoding)
			throws UnsupportedEncodingException {
		if ((data == null) || (data.length() <= 0)) {
			return;
		}

		byte[] bytes = null;
		try {
			if (encoding == null)
				bytes = data.getBytes();
			else
				bytes = data.getBytes(encoding);
		} catch (UnsupportedEncodingException uee) {
		}
		parseParameters(map, bytes, encoding);
	}

	public static void parseParameters(Map map, byte[] data, String encoding)
			throws UnsupportedEncodingException {
		if ((data != null) && (data.length > 0)) {
			int ix = 0;
			int ox = 0;
			String key = null;
			String value = null;
			while (ix < data.length) {
				byte c = data[(ix++)];
				switch ((char) c) {
				case '&':
					value = new String(data, 0, ox, encoding);
					if (key != null) {
						putMapEntry(map, key, value);
						key = null;
					}
					ox = 0;
					break;
				case '=':
					if (key == null) {
						key = new String(data, 0, ox, encoding);
						ox = 0;
					} else {
						data[(ox++)] = c;
					}
					break;
				case '+':
					data[(ox++)] = 32;
					break;
				case '%':
					data[(ox++)] = (byte) ((convertHexDigit(data[(ix++)]) << 4) + convertHexDigit(data[(ix++)]));

					break;
				default:
					data[(ox++)] = c;
				}
			}

			if (key != null) {
				value = new String(data, 0, ox, encoding);
				putMapEntry(map, key, value);
			}
		}
	}

	private static void putMapEntry(Map<String, String[]> map, String name, String value) {
		String[] newValues = null;
		String[] oldValues = (String[]) (String[]) map.get(name);
		if (oldValues == null) {
			newValues = new String[1];
			newValues[0] = value;
		} else {
			newValues = new String[oldValues.length + 1];
			System.arraycopy(oldValues, 0, newValues, 0, oldValues.length);
			newValues[oldValues.length] = value;
		}
		map.put(name, newValues);
	}

	private static byte convertHexDigit(byte b) {
		if ((b >= 48) && (b <= 57))
			return (byte) (b - 48);
		if ((b >= 97) && (b <= 102))
			return (byte) (b - 97 + 10);
		if ((b >= 65) && (b <= 70))
			return (byte) (b - 65 + 10);
		return 0;
	}

	public static String dumpDataToString(ServletInputStream inputStream)
			throws IOException {
		// TODO Auto-generated method stub
		InputStreamReader isr = new InputStreamReader(inputStream);
		char[] cbuf = new char[1024];
		StringBuffer sb = new StringBuffer();
		int count;
		while ((count = isr.read(cbuf, 0, 100)) > 0) {
			sb.append(cbuf, 0, count);
		}
		String ret = sb.toString();
		// System.out.println(ret);
		isr.close();
		return ret;
	}

	public static void dumpParameter(HttpServletRequest req) {
		// TODO Auto-generated method stub
		List<?> names = CollectionUtil.enumeration(req.getParameterNames());
		for (Object name : names) {
			String n = name.toString();
			String v = req.getParameter(n);
			logger.info(n + ":" + v);
		}

	}

	public static void dumpProperties(HttpServletRequest req) {
		// TODO Auto-generated method stub
		if (req != null) {
			List<?> names = CollectionUtil.enumeration(req.getAttributeNames());
			for (Object name : names) {
				String n = name.toString();
				String v = req.getAttribute(n).toString();
				logger.info(n + ":" + v);
			}

		}
	}

	public static void dumpHeaders(HttpServletRequest req) {
		// TODO Auto-generated method stub
		if (req != null) {
			List<?> names = CollectionUtil.enumeration(req.getHeaderNames());
			for (Object name : names) {
				String n = name.toString();
				List<?> subv = CollectionUtil.enumeration(req.getHeaders(n));

				logger.info(n + ":");
				for (Object subVName : subv) {
					logger.info(subVName + " ");
				}

				System.out.println();
			}

		}
	}
}
