package org.sgpro.signalmaster;

import java.util.HashSet;
import java.util.Iterator;
import java.util.Random;
import java.util.Set;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.apache.log4j.Logger;
import org.hibernate.Transaction;
import org.sgpro.db.EntExam;
import org.sgpro.db.EntExamHome;
import org.sgpro.db.HibSf;
import org.sgpro.db.TblQuestion;

import config.Log4jInit;
/**
 */
@Path("/exam")
public class GetRobotExam  extends HttpServlet  {
	static Logger logger = Logger.getLogger(GetRobotExam.class.getName());
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public GetRobotExam() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    final static int GROUP_SIZE = 4;
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    @Path("/{exam_id}/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String exam(
  		  @PathParam("exam_id") Long exam_id 
  		) throws Throwable {
    	
    	Result r = Result.success();
    	
    	try {
       		
    		response.addHeader("Access-Control-Allow-Origin" , "*");

    		Transaction trans = HibSf.getSession().beginTransaction();
    		EntExamHome eeh = new EntExamHome();
    		EntExam exam = eeh.findById(exam_id);
    		
    		
    		int count = exam.getTblQuestions().size();
    		Random rd = new Random();
    		
//    		List<Integer> indexArr = new ArrayList<Integer>();
//    		
//    		for (int i = 0; i < GROUP_SIZE; i++) {
//    			indexArr.add(rd.nextInt(count));
//    		}
    		
//    		logger.info(indexArr);
    		
    		Set<TblQuestion> selected = new HashSet<TblQuestion>();
    		int i = 0;
    		int index = 0;
    		Iterator<TblQuestion> it = null;
    		
    		for (i = 0; i < GROUP_SIZE; i++) {
        		it = exam.getTblQuestions().iterator();
        		int fetchIndex = rd.nextInt(exam.getTblQuestions().size());
        		index = 0;
        		while (it.hasNext()) {
        			if (index++ == fetchIndex) {
        				TblQuestion  item = (TblQuestion) it.next();
        				selected.add(item);
        				exam.getTblQuestions().remove(item);
        				break;
        			}
        		}
    		}
//    		while (it.hasNext()) {
//    			TblQuestion  item = (TblQuestion) it.next();
//    			
//    			selected.
//    			selected.add(item);
//    			if (selected.size() >= GROUP_SIZE) {
//    				exam.getTblQuestions().clear();
//    				exam.getTblQuestions().addAll(selected);
//    				break;
//    			}
//    		}
    		exam.getTblQuestions().clear();
    		exam.getTblQuestions().addAll(selected);
    		r.setData(exam);
    		logger.info(exam_id + ":" + ":" + r.toString());
    		trans.commit();
    	} catch (Throwable th) {
    		r = Result.unknowException(th);
    		th.printStackTrace();
    	}
    	
    	return r.toString();
    }
}
