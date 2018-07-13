package config;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.log4j.PropertyConfigurator;

/**
 * Servlet implementation class Log4jInit
 */
@WebServlet("/Log4jInit")
public class Log4jInit extends HttpServlet {
	private static final long serialVersionUID = 1L;
	/**
	 * @see Servlet#init(ServletConfig)
	 */
	static Logger logger = Logger.getLogger(Log4jInit.class.getName());
	public void init() throws ServletException {
		System.out.println("logger初始化......");
		// TODO Auto-generated method stub
		//通过web.xml来动态取得配置文件
//		String file = getInitParameter("log4j-init-file");
		String prefix = this.getServletContext().getRealPath("/");  
		System.out.println("prefix:"+prefix);
		String file = prefix+"WEB-INF\\classes\\config\\log4j.properties";
		System.out.println("file:"+file);
		// 如果没有给出相应的配置文件，则不进行初始化
		if(file != null)
		{
			System.out.println("----------start init------------------");
			PropertyConfigurator.configure(file);
			logger.info("Start of the main() in TestLog4j");
			logger.error("Start of the main() in TestLog4j");
		}else{
			System.out.println("===========没有初始化配置文件！==============");
		}
	}
}