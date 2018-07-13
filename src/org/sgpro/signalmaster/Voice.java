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
import org.sgpro.db.EntThirdPartyApi;
import org.sgpro.db.EntThirdPartyApiParam;
import org.sgpro.db.EntThirdPartyApiParamValue;
import org.sgpro.db.EntThirdPartyApiParamValueId;
import org.sgpro.db.EntThirdPartyApiParamsValue;
import org.sgpro.db.EntThirdPartyApiParamsValueId;
import org.sgpro.db.EntVoice;
import org.sgpro.db.EntVoiceCommand;
import org.sgpro.db.EntVoiceGroup;
import org.sgpro.db.EntVoiceHome;
import org.sgpro.db.HibSf;
import org.sgpro.db.ViewEntity;
import org.sgpro.db.ViewFlowVoiceRule;
import org.sgpro.db.ViewThirdPartyApiParamValue;
import org.sgpro.db.ViewThirdPartyApiParamValueItem;
import org.sgpro.db.ViewValidThirdPartyApiParamsValue;
import org.sgpro.db.ViewVoiceSimple;
/**
 */
@Path("/voice")
public class Voice  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public Voice() {
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
			r.setData(ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewVoiceSimple.class, "SP_GET_VOICE_SIMPLE", kw)));
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
     * 查找未使用的应答
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    
    @Path("/noref")
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
			r.setData(ViewUtils.getViewDataList(ViewUtils.dbProcQuery(ViewVoiceSimple.class, "SP_GET_NO_REF_VOICE")));
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
    
    
    @Path("/enabled/{id}/{b}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String enabled(
    		@PathParam("id") Long id 
    		, @PathParam("b") Boolean b 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
    		) throws Throwable {
    	
    	Result r = Result.success();
    	Transaction trans = null;
		response.addHeader("Access-Control-Allow-Origin" , "*");
    	try {
    		trans = HibSf.getSession().beginTransaction();
    		
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_SET_VOICE_ENABLED", id, id, b);
//    		
//    		ViewUtils.dbProc("SP_SAVE_WORDS_OPERATION_LOG", ACCESS_KEY, VERSION, "SP_SET_VOICE_ENABLED",  id,  b);    		
//    		ViewUtils.dbProc("SP_SET_VOICE_ENABLED", id, b);
//    		
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
			r.setData(ViewUtils.dbProcQuery(EntVoiceGroup.class, "SP_REF_VOICE_GROUP", id));
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
			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewFlowVoiceRule.class, "SP_REF_RULE_BY_VOICE_GROUP", id)));
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
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewVoiceSimple.class, "SP_LIST_VOICE_SIMPLE", group_id)));
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
    
    @Path("/_3rd/list/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String _3rdParamList(
    		@PathParam("id") Long apiId 
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
    		response.addHeader("Access-Control-Allow-Origin" , "*");
			trans = HibSf.getSession().beginTransaction();
			HibSf.getSession().clear();
			
			r.setData(
					ViewUtils.dbProcQuery(EntThirdPartyApiParam.class
							, "SP_LIST_THIRD_PARTY_API_PARAM", apiId));
			
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
    
    @Path("/_3rd/param-value/list/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String _3rdParamValueItemList(
    		@PathParam("id") Long valueId 
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
    		response.addHeader("Access-Control-Allow-Origin" , "*");
			trans = HibSf.getSession().beginTransaction();
			HibSf.getSession().clear();
			
			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewThirdPartyApiParamValueItem.class
							, "SP_LIST_THIRD_PARTY_API_PARAM_VALUE_ITEM", valueId)));
			
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
    
    @Path("/command/list")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String commandList(
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
    		response.addHeader("Access-Control-Allow-Origin" , "*");
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewEntity.class
							, "SP_GET_ENTITY_FOR_VOICE_COMMAND")));
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
    
    @Path("/_3rd/list")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String _3rdList(
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
    		response.addHeader("Access-Control-Allow-Origin" , "*");
			trans = HibSf.getSession().beginTransaction();
			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewEntity.class
							, "SP_GET_ENTITY_FOR_THIRD_PARTY")));
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
    
    @Path("/_3rd/params/list")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String _3rdParamsAll(
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
    		response.addHeader("Access-Control-Allow-Origin" , "*");
			trans = HibSf.getSession().beginTransaction();
			HibSf.getSession().clear();
			
			r.setData(ViewUtils
					.getViewDataList(HibSf
							.getSession()
							.createSQLQuery(
									"SELECT * FROM VIEW_VALID_THIRD_PARTY_API_PARAMS_VALUE")
							.addEntity(ViewValidThirdPartyApiParamsValue.class)
							.list()));
			
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
    
    @Path("/_3rd/params/list/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String _3rdParamValueList(
    		@PathParam("id") Long apiId 
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
    		response.addHeader("Access-Control-Allow-Origin" , "*");
			trans = HibSf.getSession().beginTransaction();
			HibSf.getSession().clear();
			
			r.setData(ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewEntity.class
							, "SP_GET_ENTITY_FOR_THIRD_PARTY_PARAMS_VALUE", apiId)));
			
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
					ViewUtils.dbProcQuery(EntVoiceGroup.class, "SP_GET_VOICE_GROUP", kw));
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
    
    @Path("/search-thirdparty/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rd(
  		  @PathParam("kw") String kw 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntThirdPartyApi.class, "SP_GET_THIRD_PARTY_API", kw));
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
    
    @Path("/select-thirdparty/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rd4SelectorEntity(
  		  @PathParam("kw") String kw 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntThirdPartyApi.class, "SP_SELECT_THIRD_PARTY_API", kw));
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
    
    @Path("/get-thirdparty/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String get3Rd(
  		  @PathParam("id") Long id 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntThirdPartyApi.class, "SP_GET_THIRD_PARTY_API_BY_ID", id));
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
    
    @Path("/search-thirdparty-param/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rdParam(
  		  @PathParam("kw") String kw 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntThirdPartyApiParam.class, "SP_GET_THIRD_PARTY_API_PARAM", kw));
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
    
    @Path("/search-thirdparty-param/{apiId}/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rdParamByApiId(
  		  @PathParam("kw") String kw 
  		, @PathParam("apiId") String apiId 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntThirdPartyApiParam.class, "SP_GET_THIRD_PARTY_API_PARAM_BY_API_ID", apiId, kw));
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
     * 查找第三方值组
     * @param kw
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/search-thirdparty-param-value/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rdParamValue(
  		  @PathParam("kw") String kw 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewThirdPartyApiParamValue.class, "SP_GET_THIRD_PARTY_API_PARAM_VALUE", kw)));
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
     * 查找第三方值组
     * @param kw
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/search-thirdparty-param-value/{apiId}/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rdParamValueByApiId(
  		   @PathParam("kw") String kw 
  		,  @PathParam("apiId") Long apiId
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewThirdPartyApiParamValue.class
							, "SP_GET_THIRD_PARTY_API_PARAM_VALUE_BY_API_ID", apiId, kw)));
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
    
    
    @Path("/select-thirdparty-param/{apiId}/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rdParamByApiIdSelectEntity(
  		  @PathParam("kw") String kw 
  		, @PathParam("apiId") String apiId 
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntThirdPartyApiParam.class, "SP_SELECT_THIRD_PARTY_API_PARAM_BY_API_ID", apiId, kw));
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
     * 查找第三方值组
     * @param kw
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/select-thirdparty-param-value/{apiId}/{kw}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String query3rdParamValueByApiIdForSelectEntity(
  		   @PathParam("kw") String kw 
  		,  @PathParam("apiId") Long apiId
  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewThirdPartyApiParamValue.class
							, "SP_SELECT_THIRD_PARTY_API_PARAM_VALUE_BY_API_ID", apiId, kw)));
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
     * 查找第三方值组
     * @param kw
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/get-thirdparty-param-value/{id}")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String get3RdParamValue(
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
					ViewUtils.dbProcQuery(ViewThirdPartyApiParamValue.class
							, "SP_GET_THIRD_PARTY_API_PARAM_VALUE_BY_ID", id)));
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
     * 未使用的应答组
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
					ViewUtils.dbProcQuery(EntVoiceGroup.class, "SP_GET_NO_REF_VOICE_GROUP"));
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
     * 空应答组
     * @param ACCESS_KEY
     * @param VERSION
     * @return
     * @throws Throwable
     */
    @Path("/empty-group/")
    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public String emptyGroup(
  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.dbProcQuery(EntVoiceGroup.class, "SP_GET_EMPTY_VOICE_GROUP"));
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
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_VOICE", id, id);
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
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_VOICE_GROUP", id, id);
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
	
	@Path("/delete-thirdparty/{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String delete3rd(
			@PathParam("id") Long id 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_THIRD_PARTY_API", id, id);
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

	@Path("/delete-thirdparty-param/{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String delete3rdParam(
			@PathParam("id") Long id 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_THIRD_PARTY_API_PARAM", id, id);
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

	@Path("/delete-thirdparty-param-value/{id}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String delete3rdParamValue(
			@PathParam("id") Long id 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_THIRD_PARTY_API_PARAM_VALUE", id, id);
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
	
	@Path("/delete-thirdparty-param-value-item/{id}/{param_id}/{create}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String delete3rdParamValueItem(
			@PathParam("id") Long id 
			,  @PathParam("param_id") Long param_id 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_THIRD_PARTY_API_PARAM_VALUE_ITEM", id, id, param_id);
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
	
	public Long zeroToNull(Long num) {
		return  num != null && num == 0? null : num;
	}
	
	public String emptyToNull(String str) {
		return emptyTo(str, null);
	}
	
	public String emptyTo(String str, String rep) {
		return "".equals(str)? rep : str;
	}
	
	/**
	 * voice 保存
	 * @param id
	 * @param kw
	 * @return
	 */
	@Path("/save/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String save(
		     @FormParam("id") Long id 
		    ,@FormParam("thirdPartyApiId") Long apiId  
		    ,@FormParam("name") String name  
		    ,@FormParam("path") String path  
		    ,@FormParam("emotion") String emotion  
		    ,@FormParam("text") String text 
		    ,@FormParam("command") Long command  
		    ,@FormParam("commandParam") String commandParam  
		    ,@FormParam("thirdPartyApiParamsValueId")Long apiValueId 
		    ,@FormParam("incProp") String incProp  
		    ,@FormParam("excProp") String excProp  
		    ,@FormParam("cat") String cat  
		    ,@FormParam("enabled") boolean enabled  
		    ,@FormParam("description") String description  
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.getViewDataList(
					DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION
					, ViewVoiceSimple.class, "SP_SAVE_VOICE",  zeroToNull(id)
					, zeroToNull(id)
					, emptyTo(name, "未命名" + System.currentTimeMillis())
					, emptyToNull(path)
					, emptyToNull(emotion)
					, emptyToNull(text)
					, zeroToNull(command)
					, emptyToNull(commandParam)
					, zeroToNull(apiId)
					, zeroToNull(apiValueId)
					, emptyToNull(incProp)
					, emptyToNull(excProp)
					, emptyTo(cat, "1")
					, enabled
					, emptyTo(description, "螺趣语义解析")
					)));
					
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					r = Result.unknowException(t);
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	/**
	 * 第三方 保存
	 * @param id
	 * @param kw
	 * @return
	 */
	@Path("/save-thirdparty/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveThirdParty(
		       @FormParam("id") Long id 
		    ,  @FormParam("name") String name  
		    ,  @FormParam("url") String url  
		    ,  @FormParam("method") String method 
		    ,  @FormParam("resultType") String resultType  
		    ,  @FormParam("enable") boolean enabled  
		    ,  @FormParam("runAtServer") boolean runAtServer  
		    ,  @FormParam("description") String description  
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION
					, EntThirdPartyApi.class, "SP_SAVE_THIRD_PARTY_API",  zeroToNull(id)
					, zeroToNull(id)
					, emptyTo(name, "未命名" + System.currentTimeMillis())
					, emptyToNull(url)
					, emptyToNull(method)
					, emptyToNull(resultType)
					, runAtServer
					, enabled
					, emptyTo(description, "未命名第三方API")
					));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					r = Result.unknowException(t);
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	/**
	 * 第三方参数 保存
	 * @param id
	 * @param kw
	 * @return
	 */
	@Path("/save-thirdparty-param/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveThirdPartyParam(
		       @FormParam("id") Long id 
		    ,  @FormParam("name") String name  
		    ,  @FormParam("defaultValue") String defaultValue  
		    ,  @FormParam("header0Body1") boolean header0Body1  
		    ,  @FormParam("optional") boolean optional  
		    ,  @FormParam("description") String description  
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION
					, EntThirdPartyApiParam.class, "SP_SAVE_THIRD_PARTY_API_PARAM",  zeroToNull(id)
					, zeroToNull(id)
					, emptyTo(name, "未命名" + System.currentTimeMillis())
					, header0Body1
					, optional
					, emptyTo(defaultValue, "")
					, emptyTo(description, "未命名第三方API参数")
					));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					r = Result.unknowException(t);
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	/**
	 * 第三方参数值 保存
	 * @param id
	 * @param kw
	 * @return
	 */
	@Path("/save-thirdparty-param-value/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveThirdPartyParamValue(
		       @FormParam("id") Long id 
		    ,  @FormParam("name") String name  
		    ,  @FormParam("apiId") String apiId  
		    ,  @FormParam("enabled") boolean enabled  
		    ,  @FormParam("description") String description  
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(ViewUtils.getViewDataList(
					DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION
					, ViewThirdPartyApiParamValue.class, "SP_SAVE_THIRD_PARTY_API_PARAM_VALUE",  zeroToNull(id)
					, zeroToNull(id)
					, emptyTo(name, "未命名" + System.currentTimeMillis())
					, apiId
					, enabled
					, emptyTo(description, "未命名第三方API参数值组")
					)));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					r = Result.unknowException(t);
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}

	/**
	 * 第三方参数值项保存
	 * @param id
	 * @param kw
	 * @return
	 */
	@Path("/save-thirdparty-param-value-item/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String saveThirdPartyParamValueItem(
		       @FormParam("valueId") Long valueId 
		    ,  @FormParam("paramId") Long paramId  
		    ,  @FormParam("paramValue") String paramValue  
		    ,  @FormParam("description") String description  
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(ViewUtils.getViewDataList(
					DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION
					, ViewThirdPartyApiParamValueItem.class, "SP_SAVE_THIRD_PARTY_API_PARAM_VALUE_ITEM",  paramId
					, valueId
					, paramId
					, paramValue
					, description
					)));
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					r = Result.unknowException(t);
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}

	
	@Deprecated
	/**
	 * voice 保存
	 * @param id
	 * @param kw
	 * @return
	 */
	@Path("/dropSave/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String dropSave(
		     @FormParam("id") Long id 
		    ,@FormParam("thirdPartyApiId") Long apiId  
		    ,@FormParam("name") String name  
		    ,@FormParam("path") String path  
		    ,@FormParam("emotion") String emotion  
		    ,@FormParam("text") String text 
		    ,@FormParam("command") Long command  
		    ,@FormParam("commandParam") String commandParam  
		    ,@FormParam("thirdPartyApiParamsValueId")Long apiValueId 
		    ,@FormParam("incProp") String incProp  
		    ,@FormParam("excProp") String excProp  
		    ,@FormParam("cat") String cat  
		    ,@FormParam("enabled") boolean enabled  
		    ,@FormParam("description") String description  
			) {
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			EntVoiceHome evh = new EntVoiceHome();
			EntVoice ev = null;

			if (id != null && id != 0) {
				ev = evh.findById(id);
			} else {
				ev = new EntVoice();
			}

			ev.setCat(emptyTo(cat, "1"));
			if (command != null && command != 0) {
				EntVoiceCommand entCmd = new EntVoiceCommand();
				entCmd.setId(command);
				ev.setEntVoiceCommand(entCmd);
			} else {
				ev.setEntVoiceCommand(null);
			}			
			ev.setCommandParam(emptyToNull(commandParam));
			ev.setDescription(emptyTo(description, "螺趣语义解析"));
			ev.setEmotion(emptyToNull(emotion));

			EntThirdPartyApiParamsValue entThirdPartyApiParamsValue = null;

			EntThirdPartyApi entThirdPartyApi = null;
			EntThirdPartyApiParamsValueId valueEntity = null;
			
			if (apiId != null && apiId != 0) {
				entThirdPartyApi = new EntThirdPartyApi();
				entThirdPartyApi.setId(apiId);
				
				if (apiValueId != null && apiValueId != 0) {
					valueEntity = new EntThirdPartyApiParamsValueId(apiValueId, apiId);
					entThirdPartyApiParamsValue = new EntThirdPartyApiParamsValue();
					entThirdPartyApiParamsValue.setId(valueEntity);
					entThirdPartyApiParamsValue.setEntThirdPartyApi(entThirdPartyApi);
					// ev.setEntThirdPartyApiParamsValue(entThirdPartyApiParamsValue);
				}
			} 
			
			ev.setExcProp(emptyToNull(excProp));
			ev.setIncProp(emptyToNull(incProp));
			ev.setName(emptyTo(name, "未命名" + System.currentTimeMillis()));
			ev.setPath(emptyToNull(path));
			ev.setText(emptyToNull(text));
			ev.setEnabled(enabled);
			evh.persist(ev);
			EntVoice saved = ViewUtils.getViewDataFirstIndex(evh.findByExample(ev));
			
			if (saved != null) {
				r.setData(
						ViewUtils.getViewDataList(
								ViewUtils.dbProcQuery(ViewVoiceSimple.class
										,"SP_GET_VOICE_BY_ID"
										, saved.getId())));
			}
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					r = Result.unknowException(t);
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return r.toString();
	}
	
	
	/**
	 * voice 创建
	 * @param id
	 * @param kw
	 * @return
	 */
	@Path("/create/")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public EntVoice create(
		     @FormParam("id") Long id 
		    ,@FormParam("entThirdPartyApi") Long apiId  
		    ,@FormParam("name") String name  
		    ,@FormParam("path") String path  
		    ,@FormParam("emotion") String emotion  
		    ,@FormParam("text") String text 
		    ,@FormParam("command") Long command  
		    ,@FormParam("commandParam") String commandParam  
		    ,@FormParam("thirdPartyApiParamsValueId")Long apiValueId 
		    ,@FormParam("incProp") String incProp  
		    ,@FormParam("excProp") String excProp  
		    ,@FormParam("cat") String cat  
		    ,@FormParam("enabled") boolean enabled  
		    ,@FormParam("description") String description  
			) {
		Result r = Result.success();
		Transaction trans = null;
		EntVoice ev = null;
		
		try {
			trans = HibSf.getSession().beginTransaction();
			EntVoiceHome evh = new EntVoiceHome();

			if (id != null && id != 0) {
				ev = evh.findById(id);
			} else {
				ev = new EntVoice();
			}

			ev.setCat(emptyTo(cat, "1"));
			if (command != null && command != 0) {
				EntVoiceCommand entCmd = new EntVoiceCommand();
				entCmd.setId(command);
				ev.setEntVoiceCommand(entCmd);
			} else {
				ev.setEntVoiceCommand(null);
			}			
			ev.setCommandParam(emptyToNull(commandParam));
			ev.setDescription(emptyTo(description, "螺趣语义解析"));
			ev.setEmotion(emptyToNull(emotion));


			EntThirdPartyApi entThirdPartyApi = null;
			EntThirdPartyApiParamValue entThirdPartyApiParamValue;
			
			if (apiId != null && apiId != 0) {
				entThirdPartyApi = new EntThirdPartyApi();
				entThirdPartyApi.setId(apiId);
				
				ev.setEntThirdPartyApi(entThirdPartyApi);
				if (apiValueId != null && apiValueId != 0) {
					entThirdPartyApiParamValue = new EntThirdPartyApiParamValue(id, entThirdPartyApi, name, enabled);
					ev.setEntThirdPartyApiParamValue(entThirdPartyApiParamValue);
				}
			} 
			
			ev.setExcProp(emptyToNull(excProp));
			ev.setIncProp(emptyToNull(incProp));
			ev.setName(emptyTo(name, "未命名" + System.currentTimeMillis()));
			ev.setPath(emptyToNull(path));
			ev.setText(emptyToNull(text));
			// ev.setThirdPartyApiParamsValueId(zeroToNull(thirdPartyApiParamsValueId));
			ev.setEnabled(enabled);
			evh.persist(ev);
			EntVoice saved = ViewUtils.getViewDataFirstIndex(evh.findByExample(ev));
			
			if (saved != null) {
				r.setData(
						ViewUtils.getViewDataList(
								ViewUtils.dbProcQuery(ViewVoiceSimple.class
										,"SP_GET_VOICE_BY_ID"
										, saved.getId())));
			}
			trans.commit();
		} catch (Throwable t) {
			if (trans != null) {
				try {
					r = Result.unknowException(t);
					trans.rollback();
				} catch (Throwable t1) {
					t1.printStackTrace();
					r = Result.unknowException(t1);
				}
			}
		}
		
		return ev;
	}
	
	/**
	 * voice 组保存
	 * @param id
	 * @param name
	 * @param description
	 * @return
	 */
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
			r.setData(DBFunctionUtils.editKnowledgeBaseQ(ACCESS_KEY, VERSION, EntVoiceGroup.class, "SP_SAVE_VOICE_GROUP", id, id, name, description));

			// r.setData(ViewUtils.dbProcQuery(EntVoiceGroup.class, "SP_SAVE_VOICE_GROUP", id, name, description));
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
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_SET_VOICE_TO_GROUP", id, group_id, id, create);
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
	
	@Path("/_3rd/set-to-api/{api_id}/{api_param_id}/{create}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String setThirdPartyApi(
			@PathParam("api_id") Long api_id ,
			@PathParam("api_param_id") Long api_param_id ,
			@PathParam("create") boolean create 
    		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
      		,  @HeaderParam(Admin.VERSION) String VERSION  		  
			
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_SET_THIRD_PARTY_API_PARAM_TO_API", api_param_id, api_id, api_param_id, create);
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
	
	   @Path("/ref-thirdparty/{id}")
	    @GET
	    @Produces(MediaType.APPLICATION_JSON)
	    public String ref3rd(
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
						ViewUtils.dbProcQuery(ViewVoiceSimple.class, "SP_REF_VOICE_BY_THIRD_PARTY_API", id)));
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
	   
	   @Path("/ref-thirdparty-param-value/{id}")
	    @GET
	    @Produces(MediaType.APPLICATION_JSON)
	    public String ref3rdParamValue(
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
						ViewUtils.dbProcQuery(ViewVoiceSimple.class, "SP_REF_VOICE_BY_THIRD_PARTY_API_PARAM_VALUE_ID", id)));
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
	   
	   
	   @Path("/ref-thirdparty-param/{id}")
	    @GET
	    @Produces(MediaType.APPLICATION_JSON)
	    public String ref3rdParam(
	  		  @PathParam("id") Long id 
	  		,  @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
	  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
	  		) throws Throwable {

			Result r = Result.success();
			Transaction trans = null;
			try {
				trans = HibSf.getSession().beginTransaction();
				r.setData(
						ViewUtils.dbProcQuery(EntThirdPartyApi.class, "SP_REF_THIRD_PARTY_API_BY_PARAM_ID", id));
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
	     * 未使用的API
	     * @param ACCESS_KEY
	     * @param VERSION
	     * @return
	     * @throws Throwable
	     */
	    @Path("/noref-thirdparty/")
	    @GET
	    @Produces(MediaType.APPLICATION_JSON)
	    public String queryNoRef3rd(
	  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
	  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
	  		) throws Throwable {

			Result r = Result.success();
			Transaction trans = null;
			try {
				trans = HibSf.getSession().beginTransaction();
				
				r.setData(
						ViewUtils.dbProcQuery(EntThirdPartyApi.class, "SP_GET_NO_REF_THIRD_PARTY_API"));
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
	     * 未使用的API参数
	     * @param ACCESS_KEY
	     * @param VERSION
	     * @return
	     * @throws Throwable
	     */
	    @Path("/noref-thirdparty-param/")
	    @GET
	    @Produces(MediaType.APPLICATION_JSON)
	    public String queryNoRef3rdParam(
	  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
	  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
	  		) throws Throwable {

			Result r = Result.success();
			Transaction trans = null;
			try {
				trans = HibSf.getSession().beginTransaction();
				
				r.setData(
						ViewUtils.dbProcQuery(EntThirdPartyApiParam.class, "SP_GET_NO_REF_THIRD_PARTY_API_PARAM"));
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
	     * 未使用的API参数
	     * @param ACCESS_KEY
	     * @param VERSION
	     * @return
	     * @throws Throwable
	     */
	    @Path("/noref-thirdparty-param-value/")
	    @GET
	    @Produces(MediaType.APPLICATION_JSON)
	    public String queryNoRef3rdParamValue(
	  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
	  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
	  		) throws Throwable {

			Result r = Result.success();
			Transaction trans = null;
			try {
				trans = HibSf.getSession().beginTransaction();
				
				r.setData(
						ViewUtils.getViewDataList(
						ViewUtils.dbProcQuery(ViewThirdPartyApiParamValue.class, "SP_GET_NO_REF_THIRD_PARTY_API_PARAM_VALUE")));
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
	     * 空应答组
	     * @param ACCESS_KEY
	     * @param VERSION
	     * @return
	     * @throws Throwable
	     */
	    @Path("/empty-thirdparty-param-value/")
	    @GET
	    @Produces(MediaType.APPLICATION_JSON)
	    public String empty3rdparamValue(
	  		   @HeaderParam(Admin.ACCESS_KEY) String ACCESS_KEY
	  		,  @HeaderParam(Admin.VERSION) String VERSION  		  
	  		) throws Throwable {

			Result r = Result.success();
			Transaction trans = null;
			try {
				trans = HibSf.getSession().beginTransaction();
				
				r.setData(ViewUtils.getViewDataList(
						ViewUtils.dbProcQuery(ViewThirdPartyApiParamValue.class, "SP_GET_EMPTY_THIRD_PARTY_API_PARAM_VALUE")));
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
