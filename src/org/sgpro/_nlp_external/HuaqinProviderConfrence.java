package org.sgpro._nlp_external;

import java.sql.Types;

import org.sgpro.db.ViewVoiceGroupId;
import org.sgpro.signalmaster.AutoTalkV2;
import org.sgpro.signalmaster.ViewUtils;
import org.sgpro.signalmaster.ViewUtils.ProcParam;

public class HuaqinProviderConfrence implements NLP {

	@Override
	public void execute(Object context, ViewVoiceGroupId voice, String... args)
			throws Throwable {
//		 , @VOICE_COMMAND BIGINT OUTPUT
//		 , @VOICE_COMMAND_PARAM NVARCHAR(MAX) OUTPUT
//		 , @VOICE_TEXT NVARCHAR(1024) OUTPUT 
		AutoTalkV2  ctx =  (AutoTalkV2) context;

		ctx.outputLog("供应商大会座位查找-启动");
		ProcParam input = ProcParam.genParam(args[0]);
		ProcParam voiceCat = ProcParam.genOutputParam(voice.getVoiceCat(),  Types.VARCHAR);
		ProcParam voiceCommand = ProcParam.genOutputParam(voice.getVoiceCommand(),  Types.BIGINT);
		ProcParam voiceCommandParam = ProcParam.genOutputParam(voice.getVoiceCommandParam() , Types.VARCHAR);
		ProcParam voiceText = ProcParam.genOutputParam(voice.getVoiceText() ,Types.VARCHAR);
		
		// TODO Auto-generated method stub
		ViewUtils.dbProcWithOutput("SP_CUSTOM_FIND_HUAQIN_2016_PROVIDER_CONFRENCE_INFO"
				, input , voiceCat, voiceCommand, voiceCommandParam, voiceText);
		
		voice.setVoiceCat((String) voiceCat.o);
		voice.setVoiceCommand((Long) voiceCommand.o);
		voice.setVoiceCommandParam((String) voiceCommandParam.o);
		voice.setVoiceText((String) voiceText.o);
		
		if ("3".equals(voice.getVoiceCat())) {
			voice.setVoiceEmotion(null);
			voice.setVoicePath(null);
			voice.setVoiceName(null);
		}
		ctx.outputLog("供应商大会座位查找-完成");
	}

	@Override
	public String description() {
		// TODO Auto-generated method stub
		return "2016华勤供应商大会找座次";
	}
	
}
