package org.sgpro.signalmaster;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.HeaderParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.MediaType;

import org.hibernate.Transaction;
import org.sgpro.db.EntKeyWords;
import org.sgpro.db.EntVoiceGroup;
import org.sgpro.db.EntWordGroup;
import org.sgpro.db.EntWordGroupFlow;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewFlowVoiceRule;
/**
 */
@Path("/kw")
public class Keyword  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public Keyword() {
        super();
        // TODO Auto-generated constructor stub
    }
    
    @Context 
    private HttpServletRequest request;
    @Context 
    private HttpServletResponse  response;
 
    @Path("/search/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query(
  		  @PathParam("kw") String kw 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(
					ViewUtils.dbProcQuery(EntKeyWords.class, "SP_GET_KEY_WORD", kw)
					);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    
    /**
     * 查找未使用的单词
     * @param kw
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/noref/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String queryNoRef(
  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(
					ViewUtils.dbProcQuery(EntKeyWords.class, "SP_GET_NO_REF_WORD"));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    @Path("/list/{group_id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String list(
  		  @PathParam("group_id") Long group_id 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntKeyWords.class, "SP_LIST_KEY_WORD", group_id));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    @Path("/list-group/{flow_id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String listGroup(
  		  @PathParam("flow_id") Long flow_id 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
 		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntWordGroup.class, "SP_LIST_KEY_WORD_GROUP", flow_id));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    @Path("/search-group/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String queryGroup(
  		  @PathParam("kw") String kw 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntWordGroup.class, "SP_GET_KEY_WORD_GROUP", kw)
					);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    /**
     * 未使用词组
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/noref-group/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String queryNoRefGroup(
  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntWordGroup.class, "SP_GET_NO_REF_WORD_GROUP")
					);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    /**
     * 空词组
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/empty-group/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String queryEmptyGroup(
  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntWordGroup.class, "SP_GET_EMPTY_WORD_GROUP")
					);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    
    @Path("/search-group-flow/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String queryGroupFlow(
  		  @PathParam("kw") String kw 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntWordGroupFlow.class, "SP_GET_KEY_WORD_GROUP_FLOW", kw));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    

    /**
     * 未使用句法
     * @param kw
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/noref-group-flow/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String queryNoRefGroupFlow(
  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntWordGroupFlow.class, "SP_GET_NO_REF_WORD_GROUP_FLOW"));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }

    /**
     * 空句法
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/empty-group-flow/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String queryEmptyFlow(
  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntWordGroup.class, "[SP_GET_EMPTY_WORD_GROUP_FLOW]")
					);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    @Path("/ref/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String ref(
  		  @PathParam("id") Long id 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProcQuery(EntWordGroup.class, "SP_REF_WORD_GROUP", id));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    @Path("/ref-group/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String refGroup(
  		  @PathParam("id") Long id 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.dbProcQuery(EntWordGroupFlow.class, "SP_REF_WORD_GROUP_FLOW", id));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
    @Path("/ref-group-flow/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String refGroupFlow(
  		  @PathParam("id") Long id 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewFlowVoiceRule.class, "SP_REF_RULE_BY_WORD_GROUP_FLOW", id)));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
    }
    
	@Path("/save/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String save(
			@FormParam("id") Long id,
			@FormParam("kw") String kw,
			@FormParam("cat") Long cat
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION, EntKeyWords.class, "SP_SAVE_KEY_WORD", id, id, kw, cat));
			
			// r.setData(ViewUtils.dbProcQuery(EntKeyWords.class, "SP_SAVE_KEY_WORD", id, kw, cat));
			trans.commit();
		} catch (Throwable t) {
			r = Result.unknowException(t);
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					r = Result.unknowException(t1);
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}
	
	@Path("/save-group/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveGroup(
			@FormParam("id") Long id,
			@FormParam("name") String name,
			@FormParam("description") String description
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION, EntWordGroup.class, "SP_SAVE_WORD_GROUP", id, id, name, description));
			// r.setData(ViewUtils.dbProcQuery(EntWordGroup.class, "SP_SAVE_WORD_GROUP", id, name, description));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}
	
	@Path("/save-group-flow/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveGroupFlow(
			@FormParam("id") Long id,
			@FormParam("name") String name,
			@FormParam("description") String description
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			r.setData(DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION, EntWordGroupFlow.class, "SP_SAVE_WORD_GROUP_FLOW", id, id, name, description));
			// r.setData(ViewUtils.dbProcQuery(EntWordGroupFlow.class, "SP_SAVE_WORD_GROUP_FLOW", id, name, description));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
				}
			}
		}
		
		return r.toString();
	}
	
	@Path("/delete/{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String delete(
			@PathParam("id") Long id 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_WORD", id, id);
//			ViewUtils.dbProc("SP_DELETE_WORD", id);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	
	@Path("/delete-group/{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteGroup(
			@PathParam("id") Long id 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_WORD_GROUP", id, id);
			// ViewUtils.dbProc("SP_DELETE_WORD_GROUP", id);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	@Path("/delete-group-flow/{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String deleteGroupFlow(
			@PathParam("id") Long id 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_WORD_GROUP_FLOW", id, id);
			// ViewUtils.dbProc("SP_DELETE_WORD_GROUP_FLOW", id);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	@Path("/set-to-group/{group_id}/{id}/{create}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String setGroup(
			@PathParam("group_id") Long group_id ,
			@PathParam("id") Long id ,
			@PathParam("create") boolean create 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_SET_KEY_WORD_TO_GROUP", id, group_id, id, create);
			// ViewUtils.dbProc("SP_SET_KEY_WORD_TO_GROUP", group_id, id, create);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	@Path("/set-to-flow/{flow_id}/{group_id}/{create}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String setFlow(
			@PathParam("flow_id") Long flow_id ,
			@PathParam("group_id") Long group_id ,
			@PathParam("create") boolean create 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_SET_WORD_GROUP_TO_FLOW", group_id, flow_id, group_id,  create);
			// ViewUtils.dbProc("SP_SET_WORD_GROUP_TO_FLOW", flow_id, group_id,  create);
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					trans.rollback();
					r = Result.unknowException(t);
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
}
