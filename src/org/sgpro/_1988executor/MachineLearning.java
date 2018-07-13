package org.sgpro._1988executor;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.sgpro.db.EntKeyWords;
import org.sgpro.db.ViewVoiceGroupId;
import org.sgpro.db.ViewWordGroupFlowToVoiceGroupRuleOrignal;
import org.sgpro.signalmaster.ViewUtils;
import org.sgpro.util.ObjectCast;
import org.sgpro.util.StringUtil;

public class MachineLearning implements _1988 {

	@Override
	public void execute(HttpServletRequest req, ViewVoiceGroupId obj,
			String... args) {
		// TODO Auto-generated method stub

		try {

			if (args == null || args.length < 3) {
				throw new Exception("参数不足");
			}

			long userId = ObjectCast.castStringToObject(Long.class, args[0],
					null);
			long robotId = ObjectCast.castStringToObject(Long.class, args[1],
					null);

			String request = null;
			String answer = null;

			if (args.length == 3) {

				String contextName = args[2];

				String mlInput = ViewUtils.dbFunc("DBO.FUNC_GET_CONTEXT_VALUE",
						robotId, contextName, "").toString();

				if (StringUtil.isNullOrEmpty(mlInput)) {
					throw new Exception("参数有误");
				}
				List<EntKeyWords> qVerbs = ViewUtils.dbProcQuery(
						EntKeyWords.class, "SP_LIST_KEY_WORD", 531);
				List<EntKeyWords> answerVerbs = ViewUtils.dbProcQuery(
						EntKeyWords.class, "SP_LIST_KEY_WORD", 532);

				int firstFlag = -1;
				int lastFlag = -1;
				EntKeyWords qw = null;

				for (EntKeyWords q : qVerbs) {
					firstFlag = mlInput.lastIndexOf(q.getKw());
					if (firstFlag > 0) {
						qw = q;
						break;
					}
				}

				EntKeyWords aw = null;
				for (EntKeyWords ans : answerVerbs) {
					lastFlag = mlInput.lastIndexOf(ans.getKw());
					if (lastFlag > 0) {
						aw = ans;
						break;
					}
				}

				if (firstFlag >= 0 && lastFlag > firstFlag) {

					int qwl = qw.getKw().length();
					int awl = aw.getKw().length();

					request = mlInput
							.substring(firstFlag + qwl, lastFlag - awl);
					answer = mlInput.substring(lastFlag + awl);

					List<EntKeyWords> prefix = ViewUtils.dbProcQuery(
							EntKeyWords.class, "SP_LIST_KEY_WORD", 535);
					List<EntKeyWords> postfix = ViewUtils.dbProcQuery(
							EntKeyWords.class, "SP_LIST_KEY_WORD", 536);

					for (EntKeyWords pre : prefix) {
						if (request.startsWith(pre.getKw())) {
							request = request.replaceFirst(pre.getKw(), "");
							break;
						}
					}

					for (EntKeyWords suf : postfix) {
						if (request.endsWith(suf.getKw())) {
							request = request.substring(0,
									request.lastIndexOf(suf.getKw()));
							break;
						}
					}
				}
			} else if (args.length >= 4) {
				request = ViewUtils.dbFunc("DBO.FUNC_GET_CONTEXT_VALUE",
						robotId, args[2], "").toString();
				answer = ViewUtils.dbFunc("DBO.FUNC_GET_CONTEXT_VALUE",
						robotId, args[3], "").toString();
			}

			if (StringUtil.isNullOrEmpty(request)) {
				throw new Exception("参数有误");
			}

			ViewUtils.dbProcQuery(
					ViewWordGroupFlowToVoiceGroupRuleOrignal.class,
					"SP_CUSOMER_SAVE_ORIGNAL_VOICE_V2", null, // @ORGINAL_RULE_ID
					null, // @VOICE_ID
					request, // @NAME
					null,// @PATH
					null,// @EMOTION
					answer,// @TEXT
					null, null, null, null, null, "4", // @CAT
					request, // @REQUEST
					userId,// userid
					"机器学习");

			ViewWordGroupFlowToVoiceGroupRuleOrignal newGen = ViewUtils
					.getViewDataFirstIndex(ViewUtils.dbProcQuery(
							ViewWordGroupFlowToVoiceGroupRuleOrignal.class,
							"SP_GET_RULE_ORIGNAL", userId, request));

			if (newGen != null) {
				obj.setVoiceText("我学会了， 谢谢你");
			} else {
				obj.setVoiceText("一知半解啦");
			}

			ViewUtils.dbProc("SP_DELETE_SESSION_CONTEXT", robotId, args[2]);

			if (args.length >= 4) {
				ViewUtils.dbProc("SP_DELETE_SESSION_CONTEXT", robotId, args[3]);
			}
		} catch (Throwable t) {
			obj.setVoiceText("没学会，失败了！原因：" + t.getMessage());
		}

	}

}
