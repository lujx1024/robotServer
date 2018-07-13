package org.sgpro._nlp_external;

import org.sgpro.db.ViewVoiceGroupId;

/**
 * 第三方语义处理器
 * @author 101000401
 *
 */
public interface NLP {
	void execute(Object context, ViewVoiceGroupId voice, String...args) throws Throwable;
	
	String description();
}
