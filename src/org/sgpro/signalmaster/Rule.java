package org.sgpro.signalmaster;

import java.util.ArrayList;
import java.util.List;

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
import org.sgpro.db.EntUser;
import org.sgpro.db.EntVoiceGroup;
import org.sgpro.db.EntWordGroup;
import org.sgpro.db.EntWordGroupFlow;
import org.sgpro.db.HibSf;
import org.sgpro.db.TblWordGroupFlowToVoiceGroupRuleOrignal;
import org.sgpro.db.TblWordGroupFlowToVoiceGroupRuleOrignalHome;
import org.sgpro.db.ViewFlowVoiceRule;
import org.sgpro.db.ViewWordGroupFlowToVoiceGroupRuleOrignalV2;
import org.sgpro.util.ChineseGramaLex;
import org.sgpro.util.ChineseGramaLex.LexItem;
import org.sgpro.util.CollectionUtil;
import org.sgpro.util.DateUtil;
import org.sgpro.util.StringUtil;
/**
 */
@Path("/rule")
public class Rule  extends HttpServlet  {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
     * @see HttpServlet#HttpServlet()
     */
    public Rule() {
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
  		) throws Throwable {

		Result r = Result.success();
		Transaction trans = null;
		try {
			trans = HibSf.getSession().beginTransaction();
			
			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewFlowVoiceRule.class, "SP_GET_RULE", kw)));
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
			@FormParam("flowId") Long wordGroupFlow,
			@FormParam("voiceId") Long voiceGroup,
			@FormParam("enable") Boolean enable,
			@FormParam("useFullyMatch") Boolean useFullyMatch,
			@FormParam("description") String description
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
					, ViewFlowVoiceRule.class, "SP_SET_WORD_GROUP_FLOW_TO_VOICE", id
					, id
					, wordGroupFlow 
					, voiceGroup
					, description
					, enable == null? true : enable
					, useFullyMatch == null? false : useFullyMatch)));			
			
//			r.setData(
//					@ID AS BIGINT
//					  , @WORD_GROUP_FLOW_ID AS BIGINT
//					  , @VOICE_GROUP_ID AS BIGINT
//					  , @DESCRIPTION AS NVARCHAR(1024)
//					  , @ENABLE BIT					
//					ViewUtils.getViewDataList(
//					ViewUtils.dbProcQuery(ViewFlowVoiceRule.class, "SP_SET_WORD_GROUP_FLOW_TO_VOICE"
//							, id
//							, wordGroupFlow
//							, voiceGroup
//							, description
//							, enable == null? true : enable
//							, useFullyMatch == null? false : useFullyMatch
//							)
//					));
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
    		DBFunctionUtils.editKnowledgeBase(ACCESS_KEY, VERSION, "SP_DELETE_RULE", id, id);
			// ViewUtils.dbProc( "SP_DELETE_RULE", id);
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
	
	@Path("/orignal/delete/{id}/{voiceId}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String orginalDelete(
			 @PathParam("id") Long id 
				,@PathParam("voiceId") Long voiceId 
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		response.addHeader("Access-Control-Allow-Origin" , "*");
		try {
			trans = HibSf.getSession().beginTransaction();
			ViewUtils.dbProc( "SP_DELETE_RULE_ORIGNAL_V2",  id, voiceId);
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
	
	
	@Path("/orignal/search/{createUserId}/{kw}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String orignalQuery(
			@PathParam("createUserId") String createUserId 
			, @PathParam("kw") String kw 
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		response.addHeader("Access-Control-Allow-Origin" , "*");
		try {
			trans = HibSf.getSession().beginTransaction();

			r.setData(
					ViewUtils.getViewDataList(
					ViewUtils.dbProcQuery(ViewWordGroupFlowToVoiceGroupRuleOrignalV2.class, "SP_GET_RULE_ORIGNAL_V2", createUserId, kw)));
			
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
	
	@Path("/orignal/save")
	@POST
	@Produces(MediaType.APPLICATION_JSON)
	public String orignalSave(
		     @FormParam("orignalRuleId") Long orignalRuleId 
		    ,@FormParam("voiceId") Long voiceId 
		    ,@FormParam("thirdPartyApi") Long thirdPartyApi  
		    ,@FormParam("request") String input  // 提问方式
		    ,@FormParam("name") String name  // 提问目的
		    ,@FormParam("path") String path  
		    ,@FormParam("emotion") String emotion  
		    ,@FormParam("text") String text // 回答
		    ,@FormParam("command") Long command  
		    ,@FormParam("commandParam") String commandParam  
		    ,@FormParam("thirdPartyApiParamsValueId")Long thirdPartyApiParamsValueId 
		    ,@FormParam("incProp") String incProp  
		    ,@FormParam("excProp") String excProp  
		    ,@FormParam("cat") String cat  
		    ,@FormParam("description") String description  
		    ,@FormParam("userId") String userId 
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		response.addHeader("Access-Control-Allow-Origin" , "*");
		try {
			trans = HibSf.getSession().beginTransaction();

			r.setData(ViewUtils.getViewDataList(
			ViewUtils.dbProcQuery(ViewWordGroupFlowToVoiceGroupRuleOrignalV2.class,
					"SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2",
					orignalRuleId, // @ORGINAL_RULE_ID
					voiceId, // @VOICE_ID
					emptyToNull(name), // @NAME
					emptyToNull(path),// @PATH
					emptyToNull(emotion),// @EMOTION
					emptyToNull(text),// @TEXT
					zeroToNull(command),
					emptyToNull(commandParam), //@COMMAND_PARAM
					zeroToNull(thirdPartyApi),
					zeroToNull(thirdPartyApiParamsValueId),
					emptyToNull(incProp), // @INC_PROP
					"4", // @CAT
					emptyToNull(input), // @REQUEST
					userId,  // userid
					"客户自助提交")));  
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
	private Long zeroToNull(Long num) {
		return  num != null && num == 0? null : num;
	}
	
	private String emptyToNull(String str) {
		return emptyTo(str, null);
	}
	
	private String emptyTo(String str, String rep) {
		return "".equals(str)? rep : str;
	}

	@Path("/orignal/gen/{userId}/{orginalRuleId}")
	@GET
	@Produces(MediaType.APPLICATION_JSON)
	public String orignalGen(
			  @PathParam("userId") Long userId 
			, @PathParam("orginalRuleId") Long orginalRuleId 
			) throws Throwable {
		
		Result r = Result.success();
		Transaction trans = null;
		
		if (response != null) {
			response.addHeader("Access-Control-Allow-Origin" , "*");
		}

		try {
			trans = HibSf.getSession().beginTransaction();
			// 获得 request.
			TblWordGroupFlowToVoiceGroupRuleOrignalHome h = new TblWordGroupFlowToVoiceGroupRuleOrignalHome();
			TblWordGroupFlowToVoiceGroupRuleOrignal raw =
			// h.findById(orginalRuleId);
			ViewUtils
					.getViewDataFirstIndex(HibSf
							.getSession()
							.createSQLQuery(
									"SELECT TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.* FROM TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL "
											+ " LEFT JOIN  ENT_WORD_GROUP_FLOW on (GEN_WORD_GROUP_FLOW_ID = ENT_WORD_GROUP_FLOW.ID) "
											+ " WHERE TBL_WORD_GROUP_FLOW_TO_VOICE_GROUP_RULE_ORIGNAL.ID="
											+ orginalRuleId)
							.addEntity(
									TblWordGroupFlowToVoiceGroupRuleOrignal.class)
							.list());

			if (raw != null) {
				String rawRequest = raw.getRequest();

				// 先查 flowid， 存在则直接使用
				// if (raw.getEntWordGroupFlow() == null) 
				{

					// 分词
					ChineseGramaLex lex = //new SCWS();
							 new ChineseGramaLex.BsonNLP();
					List<LexItem> ret = lex.analyze(rawRequest);

					List<EntKeyWords> genKws = new ArrayList<>();
					if (ret != null) {
						for (LexItem item : ret) {
							if (item != null
									&& StringUtil.isNotNullAndEmpy(item
											.getValue())) {
								// 开始生成单词
								EntKeyWords e = ViewUtils
										.getViewDataFirstIndex(ViewUtils
												.dbProcQuery(EntKeyWords.class,
														"SP_SAVE_KEY_WORD",
														null, item.getValue()));

								if (e == null) {
									throw new RuntimeException("[分词系统]:"
											+ item.getValue() + "生成失败");
								}
								genKws.add(e);
							}
						}
					}

					List<EntWordGroup> wgs = new ArrayList<>();
					// 生成词组
					for (EntKeyWords kw : genKws) {
						// 先找现成的引用
						EntWordGroup kwg = ViewUtils
								.getViewDataFirstIndex(ViewUtils.dbProcQuery(
										EntWordGroup.class,
										"SP_REF_WORD_GROUP", kw.getId()));

						if (kwg == null) {
							// 未找到词组，生成一个引用
							kwg = ViewUtils.getViewDataFirstIndex(ViewUtils
									.dbProcQuery(EntWordGroup.class,
											"SP_SAVE_WORD_GROUP", null, "词组-"
													+ kw.getKw(), "LEX自动生成词组-"
													+ kw.getKw()));
							
							if (kwg == null) {
								throw new RuntimeException("[分词系统]:" + kw
										+ "的词组生成失败");
							}
							
							ViewUtils.dbProc("SP_SET_KEY_WORD_TO_GROUP",
									kwg.getId(), kw.getId(), true);
						}


						wgs.add(kwg);
					}

					if (!CollectionUtil.isCollectionEmpty(wgs)) {
						// 由词组生成句法

						EntWordGroupFlow flow = ViewUtils
								.getViewDataFirstIndex(ViewUtils.dbProcQuery(
										EntWordGroupFlow.class,
										"SP_SAVE_WORD_GROUP_FLOW", null, "句法-"
												+ rawRequest, "LEX自动生成句法-"
												+ rawRequest));
						// 将词组挂靠句法
						for (EntWordGroup group : wgs) {
							ViewUtils.dbProc("SP_SET_WORD_GROUP_TO_FLOW",
									flow.getId(), group.getId(), true);
						}

						// 生成应答组
						EntVoiceGroup evg = ViewUtils.getViewDataFirstIndex
								(ViewUtils.dbProcQuery(EntVoiceGroup.class
								, "SP_SAVE_VOICE_GROUP"
								, null
								, "应答组-" + raw.getRequest()
								, "应答组-" + raw.getRequest() + "(自动生成)"));
						
						// 将应答设置到应答组
						ViewUtils.dbProc("SP_SET_VOICE_TO_GROUP", evg.getId(), raw.getEntVoice().getId(), true);

						
						// 保存 rule
						Object rule = ViewUtils.getViewData(ViewUtils
								.dbProcQuery(ViewFlowVoiceRule.class,
										"SP_SET_WORD_GROUP_FLOW_TO_VOICE",
										null, flow.getId(), evg.getId(),
										"规则-" + raw.getRequest() + "(自动生成)", true,
										false));
						if (rule == null) {
							throw new RuntimeException("[分词系统] 生成规则失败: "
									+ raw.getRequest());
						}

						raw.setEntWordGroupFlow(flow);
						raw.setGenDatetime(DateUtil.getNow());
						raw.setUpdateDatetime(DateUtil.getNow());
						EntUser updUser = new EntUser();
						updUser.setId(userId);
						raw.setEntUserByUpdateUserId(updUser);

						// 保存 orignal rule.
						h.persist(raw);

					}
				}
			}
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
