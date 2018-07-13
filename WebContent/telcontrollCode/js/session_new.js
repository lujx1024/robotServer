

$(document).ready(function(){
	var socket = null; 
	var timer;
    var timerInterval,intervalTimer;
	var config_layer = "";
    var configDelete_layer = "";
    var today=new Date();
    var year=today.getFullYear();
    var month=zero(today.getMonth()+1);
    var day=zero(today.getDate());
    var toDate=year+"-"+month+"-"+day+" 00:00:00";
    var textDate=year+"-"+month+"-"+day+" "+zero(today.getHours())+":"+zero(today.getMinutes())+":"+zero(today.getSeconds());
    var todaySessionUrl='';
    var testReg = /^[\u4e00-\u9fa5_a-zA-Z0-9]+$/;
	var userName=window.localStorage.controllerUser;
	var password=window.localStorage.controllerPwd;
	var sessionId=window.localStorage.controllerSessionId;
    var userId=window.localStorage.controllerUserId;
    var globalJson = {};
    var globalFlag = false;
    var refleshFlag = true;//网页刷新与刷新按钮标志
    var socketNum = 0;
    var width,height,moveHeigth,largeHeader,moveDivId,currentInterval;
    var globalIntervalFlag = true;

    //初始屏幕自适应
    function initHtml(){
        width = window.innerWidth;
        height = window.innerHeight;
        largeHeader = document.getElementById('controllPanelId');
        largeHeader.style.height = (height-50)+'px';
        moveHeigth = height *0.98 *0.98 * 0.3 -170;
        moveDivId = document.getElementById('moveDivId');
        moveDivId.style.paddingTop = (moveHeigth/2)+'px';
    }

    $(".chatImg").hide();   

    initHtml();
    addListeners();

    //监听页面大小
    function addListeners() {
        window.addEventListener('resize', initHtml);
    }
    /**
        禁止浏览器后退
    */
    if (window.history && window.history.pushState){
        $(window).on('popstate',function (){
            window.history.pushState('forward',null,'#');
            window.history.forward(1);
        });
    }
    window.history.pushState('forward',null,'#'); //在IE中必须得有这两行
    window.history.forward(1);

	/*
		自定义滚动条
	*/
	$('.talk_title').niceScroll({
		cursorcolor: "#aaa",//#CC0071 光标颜色
		cursoropacitymax: 1, //改变不透明度非常光标处于活动状态（scrollabar“可见”状态），范围从1到0
		touchbehavior: false, //使光标拖动滚动像在台式电脑触摸设备
		cursorwidth: "5px", //像素光标的宽度
		cursorborder: "0", // 游标边框css定义
		cursorborderradius: "5px",//以像素为光标边界半径
		autohidemode: false, //是否隐藏滚动条
	});

	//websockit链接
	initWebSocket(userName, password);

	/*
		命令下拉框
	*/
    createSelectList("https://"+host+"/signalmaster/rest/voice/command/list",$("#session_command"));

    $("#session_command").change(function(){
    	var selected_command=$("#session_command option:selected");
    	isRobotCommand(selected_command.text());
    });

    /*
		第三方下拉框
    */
    createSelectList("https://"+host+"/signalmaster/rest/voice/_3rd/list",$("#session_third"));

    $("#session_third").change(function(){
    	var selected_third=$("#session_third option:selected");
    	createSelectList("https://"+host+"/signalmaster/rest/voice/_3rd/params/list/"+selected_third.val(),$("#session_thirdParam"));
    });


    //判断是不是机器人命令组
	function isRobotCommand(commandValue){
		if(commandValue=="机器人命令组"){
			$("#command_param").addClass("displayNone");
			$("#robot_command").removeClass("displayNone");
		}else{
			$("#command_param").removeClass("displayNone");
			$("#robot_command").addClass("displayNone");
		}
	}

    /*
        机器人列表隐藏/显示
    */
    $(document).off("click",".robotImg").on("click",".robotImg",function(){
        if($(".robotImg").attr("src") == "img/show.png"){
            $(".talk_title").hide();
            $(".talk_container").css({"width":"100%"});
            $(".robotImg").attr("src","img/hide.png");
            $(".robotImg").attr("title","机器人列表隐藏");
        }else{
            $(".talk_title").show();
            $(".talk_container").css({"width":"80%"});
            $(".robotImg").attr("src","img/show.png");
            $(".robotImg").attr("title","机器人列表显示");
        }
        
    });
    /*
        会话隐藏/显示
    */

    $(document).off("click",".chatImg").on("click",".chatImg",function(){
        if($(".chatImg").attr("src") == "img/show.png"){
            $(".mainPanel_left").hide();
            $(".mainPanel_right").css({"width":"100%"});
            $(".chatImg").attr("src","img/hide.png");
            $(".chatImg").attr("title","会话隐藏");
        }else{
            $(".mainPanel_left").show();
            $(".mainPanel_right").css({"width":"60%"});
            $(".chatImg").attr("src","img/show.png");
            $(".chatImg").attr("title","会话显示");
        }
        
    });
    
    /*
        静音checkbox
    */
    $("#isSilent").change(function(){
        whichRobot();
        var isSilent="";
        if($("#isSilent").is(':checked')){
            isSilent = "-1";
        }else{
            isSilent = "1";
        }
        var requestJson={
            "cmd":"manual_talk",
            "data":{
                "target":searchId,
                "text":"",
                "command":2003,
                "commandParam":isSilent,
                "thirdPartyApiId":0,
                "thirdPartyApiParamsValueId":0,
                "path":"",
                "emotion":""
                }
            };
        socket.send(JSON.stringify(requestJson));
    });

	/*
		手动checkbox
	*/
	$("#hand_mode").change(function(){
		whichRobot();
		var manualModeStatus="";
        if($("#hand_mode").is(':checked')){
            manualModeStatus = "1";
        }else{
            manualModeStatus = "0";
        }
		var sendData={
    		"cmd":"manual_mode_switch",
    		"data":{
                "target":searchId,
                "manualModeStatus" : manualModeStatus
            }
    	};
    	socket.send(JSON.stringify(sendData));
		if($("#hand_mode").is(':checked')){
			_thisElement.attr("mode","true");
			$(".table_container").find("textarea").attr("readonly",false);
			$("#session_input_text").focus();
			$("#face_pack").click(function(){
				$(".face_list").removeClass("displayNone");
			})
			$(".disable_eable").attr("disabled",false);

			$(".move-up img").attr("src","img/move/up.png"); 
			$(".move-down img").attr("src","img/move/down.png"); 
			$(".move-content img").attr("src","img/move/content.png"); 
			$(".move-left img").attr("src","img/move/left.png"); 
			$(".move-right img").attr("src","img/move/right.png");

		}else{
			_thisElement.attr("mode","false");
			$(".table_container").find("textarea").attr("readonly",true);
			$("#face_pack").click(function(){
				$(".face_list").addClass("displayNone");
			})
			$(".disable_eable").attr("disabled",true);

			$(".move-up img").attr("src","img/move/up1.png"); 
			$(".move-down img").attr("src","img/move/down1.png"); 
			$(".move-content img").attr("src","img/move/content1.png"); 
			$(".move-left img").attr("src","img/move/left1.png"); 
			$(".move-right img").attr("src","img/move/right1.png"); 
		}
    });


    /*
	   固定按钮点击事件

    */
    $(document).off("click",".command_button").on("click",".command_button",function(){
    	var _this = this;
    	sendCommand(_this);

    });
    /*
        固定绑定查询的按钮
    */
    $(document).off("click",".bindcommand_button").on("click",".bindcommand_button",function(){
        var _this = $(this);
        var questionText = _this.attr("textValue");
        var currentRobot_sn = $("#robots").find(".robotCurrent").attr("sn");
        var currentUserId = userId;

        var currentJson = {
            currentRobot_sn : currentRobot_sn,
            currentUserId : currentUserId,
            questionText : questionText
        };
        getButtonTalkAnswer(currentJson);
    });

    /*
        提问问题下发
    */
    function getButtonTalkAnswer(requsetDate) {
        whichRobot();
        var requestUrl = "https://"+host+"/signalmaster/rest/remote_auto_talk/"+ requsetDate.currentRobot_sn +"/"+ requsetDate.currentUserId +"/" + requsetDate.questionText;
        $.ajax({
            cache:false,
            type:'GET',
            url:requestUrl,
            success:function(result){
                var answerData=result.data;
                if(result.code==0){
                    var thisText = answerData.voiceText;
                    var thisCommand = answerData.voiceCommand;
                    var thisCommandParam = answerData.voiceCommandParam;
                    var thisEmotion = answerData.voiceEmotion;
                    var thisPath = answerData.voicePath;
                    var thisThirdPartyApiId = 0;
                    var thisThirdPartyApiParamsValueId = 0;

                    var requestJson={
                        "cmd":"manual_talk",
                        "data":{
                            "target":searchId,
                            "text":thisText,
                            "command":parseFloat(thisCommand),
                            "commandParam":thisCommandParam,
                            "thirdPartyApiId":parseFloat(thisThirdPartyApiId),
                            "thirdPartyApiParamsValueId":parseFloat(thisThirdPartyApiParamsValueId),
                            "path":thisPath,
                            "emotion":thisEmotion
                        }
                    };
                    socket.send(JSON.stringify(requestJson));
                }else{
                    layer.alert(result.message);
                }
            },
            error:function(arg){
                // alert("服务器异常");
                alert("question_error:" + arg);
            }
        });
    }
    /*
    	动态生成的按钮点击事件
    */
    $(document).off("click",".userDefined_btn").on("click",".userDefined_btn",function(){
    	var _this = this;
    	sendUserDefinedCommand(_this);

    });

    /*
		移动按钮点击事件
    */
    $(document).off("click",".moveBtn").on("click",".moveBtn",function(){
        if($("#hand_mode").is(':checked')){
            var _this = this;
            sendCommand(_this);
        }
    });

    // $(".moveBtn").click(function(){
    // $(document).off("mousedown",".moveBtn").on("mousedown",".moveBtn",function(){
    // 	if($("#hand_mode").is(':checked')){
    // 		var _this = this;
    // 		var thisCommandParam=_this.getAttribute("param");
    //         timerInterval = setInterval(function(){
    //             keydowSendSession(thisCommandParam);
    //         },200);

    // 	}
    // });

    // $(document).off("mouseup",".moveBtn").on("mouseup",".moveBtn",function(){
    //     if($("#hand_mode").is(':checked')){
    //         clearInterval(timerInterval);
    //         keydowSendSession("stop");
    //     }
    // });
    /*
        上、下、左、右键盘快捷键
    */
    document.onkeydown=function(e){
        if(globalIntervalFlag){
            globalIntervalFlag = false;
            e=window.event||e;
        　　switch(e.keyCode){
        　　　　case 37: //左键
                keydowSendSession("left");
                intervalTimer = setInterval(function(){
                    keydowSendSession("left");
                },200);
        　　　　break;
        　　　　case 38: //向上键
        　　　　keydowSendSession("forward");
                intervalTimer = setInterval(function(){
                    keydowSendSession("forward");
                },200);
        　　　　break;
        　　　　case 39: //右键
        　　　　keydowSendSession("right");
                intervalTimer = setInterval(function(){
                    keydowSendSession("right");
                },200);
        　　　　break;
        　　　　case 40: //向下键
        　　　　keydowSendSession("back");
                intervalTimer = setInterval(function(){
                    keydowSendSession("back");
                },200);
                break;
                case 13:
                e.preventDefault();
                sendContentSession();
                default:
        　　　　break;
        　　}
        }
    　　
    }

    document.onkeyup=function(e){
        clearInterval(intervalTimer);
        globalIntervalFlag = true;
    　　e=window.event||e;
    　　switch(e.keyCode){
    　　　　case 37: //左键
            keydowSendSession("stop");
    　　　　break;
    　　　　case 38: //向上键
    　　　　keydowSendSession("stop");
    　　　　break;
    　　　　case 39: //右键
    　　　　keydowSendSession("stop");
    　　　　break;
    　　　　case 40: //向下键
    　　　　keydowSendSession("stop");
            default:
    　　　　break;
    　　}
    }


    /*
        上下左右快捷键触发的方法
    */
    function keydowSendSession(deriction){
        whichRobot();
        var thisCommandParam = "";
        if(deriction === "left"){
            thisCommandParam = "left";
        }else if(deriction === "right"){
            thisCommandParam = "right";
        }else if(deriction === "forward"){
            thisCommandParam = "forward";
        }else if(deriction === "back"){
            thisCommandParam = "back";
        }else{
            thisCommandParam = "stop";
        }
        
        var sendData={
            "cmd":"running_talk",
            "data":{"target":searchId,
                "runningParam":thisCommandParam
            }
        }
        // console.log(JSON.stringify(sendData));
        socket.send(JSON.stringify(sendData));
        
        $(".face_list").addClass("displayNone");
        $("#session_command option:first").prop("selected", 'selected');
        $("#session_third option:first").prop("selected", 'selected');
        $("#session_thirdParam option:first").prop("selected", 'selected');
        $("#session_text option:first").prop("selected", 'selected');
    }

    /*
		表情展现与隐藏事件
    */
   	 $("#face_pack").click(function() {
        $(".face_list").toggle();
    });

    /*
		各种表情点击事件	
    */
    $(document).off("click",".face_list ul li").on("click",".face_list ul li",function(){
    	var _this = this;
    	sendCommand(_this);

    });
    //表情
    $("body").get(0).onclick=function(event){
		event = event ? event : window.event;   
		var obj = event.srcElement ? event.srcElement : event.target;
		if(obj.className!="face_list" && obj.id!="face_pack" && obj.className!="clearfix face_list_box"){
			$(".face_list").addClass("displayNone");
		}
	}
    /***************************************************删除弹出框****************************************************/
    /*
        拓展配置删除
    */
    $(document).off("click","#commandDelete_Button").on("click","#commandDelete_Button",function(){
        var commandDeleteHtml = "<div class='deletePanel-div'>\
                                    <div class='deleteType-div'>\
                                        <label>选择类型:</label>\
                                        <input type='radio' id='delectType_text' checked='checked' name='voiceType' value='1'>文本回复\
                                        <input type='radio' id='delectType_button' name='voiceType' value='2' style='margin-left:30px;'>快捷键\
                                    </div>\
                                    <div class='deleteLabel'>\
                                        <label>所有配置:</label>\
                                        <label style='margin-left:185px;'>选中的配置:</label>\
                                    </div>\
                                    <div class='configCentent-div textPanel'>\
                                        <div class='deleteContent-div'>\
                                          <select multiple='multiple' id='text_select1'></select>\
                                        </div>\
                                        <div class='deleteContent-btn'><span id='text_selectRight_btn'>选中右移>></span><span id='text_selectLeft_btn'>选中左移>></span></div>\
                                        <div class='deleteContent-div'>\
                                          <select multiple='multiple' id='text_select2'></select>\
                                        </div>\
                                        <div style='text-align: center;margin-left: -50px'>\
                                            <input type='button' id='configDelete_text' class='configDelete-btn' value='删 除'>\
                                        </div>\
                                    </div>\
                                    <div class='configCentent-div btnPanel' style='display:none;'>\
                                        <div class='deleteContent-div'>\
                                          <select multiple='multiple' id='button_select1'></select>\
                                        </div>\
                                        <div class='deleteContent-btn'><span id='btn_selectRight_btn'>选中右移>></span><span id='btn_selectLeft_btn'>选中左移>></span></div>\
                                        <div class='deleteContent-div'>\
                                          <select multiple='multiple' id='button_select2'></select>\
                                        </div>\
                                        <div style='text-align: center;margin-left: -50px'>\
                                            <input type='button' id='configDelete_button' class='configDelete-btn' value='删 除'>\
                                        </div>\
                                    </div>\
                                </div>";
        configDelete_layer = layer.open({
            type: 1,
            title: '删除拓展配置页面',  //标题
             //加上边框
            closeBtn:1,
            moveType:0,
            area: ['500px', '400px'], //宽高
            content: commandDeleteHtml //弹窗内容
            });

        getUserDefinedConfig();

        /*
            按钮快捷键双击
        */
        $("#button_select1").dblclick(function(){
            $("#button_select1 option:selected").appendTo("#button_select2");
        });
        $("#button_select2").dblclick(function(){
            $("#button_select2 option:selected").appendTo("#button_select1");
        });
        /*
            文本快捷键双击
        */
        $("#text_select1").dblclick(function(){
            $("#text_select1 option:selected").appendTo("#text_select2"); 
        });
        $("#text_select2").dblclick(function(){
            $("#text_select2 option:selected").appendTo("#text_select1"); 
        });
    });
    

    $(document).off("click","#delectType_text").on("click","#delectType_text",function(){
        $(".textPanel").show();
        $(".btnPanel").hide();
    });

    $(document).off("click","#delectType_button").on("click","#delectType_button",function(){
        $(".textPanel").hide();
        $(".btnPanel").show();
    });


    /*
        文本
        删除弹出框向右移点击事件
    */
    $(document).off("click","#text_selectRight_btn").on("click","#text_selectRight_btn",function(){
        $("#text_select1 option:selected").appendTo("#text_select2");
       
    });

    /*
        文本
        删除弹出框向左移点击事件
    */
    $(document).off("click","#text_selectLeft_btn").on("click","#text_selectLeft_btn",function(){
        $("#text_select2 option:selected").appendTo("#text_select1");
    });
    /*
        双击
    */
    $("#text_select1").dblclick(function(){
            
        $("#text_select1 option:selected").appendTo("#text_select2"); 
            
    });
    /*
        文本
        删除弹出框向删除点击事件
    */
    $(document).off("click","#configDelete_text").on("click","#configDelete_text",function(){
        var VoidIdArray = [];
        $("#text_select2 option").each(function(){
            var currentVoiceId = $(this).attr("voiceId");
            VoidIdArray.push(currentVoiceId);
        });
        var currentVoiceId = VoidIdArray.toString();
        var deleteJson = {
            "userId": userId,
            "sessionId": sessionId,
            "voiceId": currentVoiceId
        };
        deleteConfig(deleteJson);
    }); 
    /*
        配置删除方法
    */
    function deleteConfig(deleteJson){
        var deleteConfigUrl = "https://"+host+"/signalmaster/rest/remote/deletevoice";
        $.ajax({
            cache:false,
            type:'POST',
            url:deleteConfigUrl,
            data:deleteJson,
            success:function(result){
                if(result.code==0){
                    var layerIndex=layer.alert("配置删除成功!",{
                        icon:1,
                        btn:['确定'],
                        yes:function(index, layero){
                            layer.close(layerIndex);
                            initUserDefinedPanel();
                            layer.close(configDelete_layer);
                        }
                    });
                }else{
                    layer.alert(result.message);
                }
            },
            error:function(arg){
                // alert("服务器异常");
                 alert("deleteInformation_error:" + arg);
            }
        });
    }

    /*
        快捷键
        删除弹出框向右移点击事件
    */
    $(document).off("click","#btn_selectRight_btn").on("click","#btn_selectRight_btn",function(){
        
        $("#button_select1 option:selected").appendTo("#button_select2");
        
    });

    /*
        快捷键
        删除弹出框向左移点击事件
    */
    $(document).off("click","#btn_selectLeft_btn").on("click","#btn_selectLeft_btn",function(){
        $("#button_select2 option:selected").appendTo("#button_select1");
    });


    /*
        快捷键
        删除弹出框向删除点击事件
    */
    $(document).off("click","#configDelete_button").on("click","#configDelete_button",function(){
        var VoidIdArray = [];
        $("#button_select2 option").each(function(){
            var currentVoiceId = $(this).attr("voiceId");
            VoidIdArray.push(currentVoiceId);
        });
        var currentVoiceId = VoidIdArray.toString();
        var deleteJson = {
            "userId": userId,
            "sessionId": sessionId,
            "voiceId": currentVoiceId
        };
        deleteConfig(deleteJson);
    });  
    /*
        获取存在的配置
    */
    function getUserDefinedConfig(){
        var getDataJson = {
                "robotImei": $("#robots").find(".robotCurrent").attr("sn"),
                "userId": userId,
                "sessionId": sessionId
        };
        getConfigUrl = "https://"+host+"/signalmaster/rest/remote/selectvoice";

        getRobotConfig(getDataJson,getConfigUrl,function(){
            var button_string = "";
            var text_string = "";
            $.each(data,function(index){
                if(data[index].voiceType == 1){
                    text_string += "<option voiceId ='"+data[index].voiceId +"' command='"+data[index].voiceCommand +"' commandParam='"+data[index].voiceCommandParam+"' path='"+data[index].voicePath +"' emotion='"+ data[index].voiceEmotion+"' text='" + data[index].voiceText + "' thirdPartyApiId='0' thirdPartyApiParamsValueId='0' title='"+ data[index].voiceName+"' value='"+ data[index].voiceText+"'>" + data[index].voiceName+"</option>";
                }else{
                     button_string += "<option voiceId ='"+data[index].voiceId +"' command='"+data[index].voiceCommand +"' commandParam='"+data[index].voiceCommandParam+"' path='"+data[index].voicePath +"' emotion='"+ data[index].voiceEmotion+"' text='" + data[index].voiceText + "' thirdPartyApiId='0' thirdPartyApiParamsValueId='0' title='"+ data[index].voiceName+"' value='"+ data[index].voiceText+"'>" + data[index].voiceName+"</option>";
                }
            });
            
            $("#text_select1").html(text_string);
            $("#button_select1").html(button_string);
        });
    }

    /*********************************************************************************************************/
    /*
		拓展按钮弹出框	
    */
    $(document).off("click","#commandAdd_Button").on("click","#commandAdd_Button",function(){
        var Robot_name = $("#robots").find(".robotCurrent").attr("robotname");
    	var commandAddHtml = "<div>\
    		<div style='margin-left:10px;' >\
    			<div class='aotoCommand'>\
    				<label>机器人名称:</label>\
    				<input type='text' value='"+ Robot_name +"' disabled='disabled' readonly='readonly' id='auto_robotName'>\
    			</div>\
                <div class='aotoCommand'>\
                    <label>语料名称:</label>\
                    <input type='text' id='auto_voiceName'>\
                </div>\
    			<div class='aotoCommand' id='auto_voiceType'>\
    				<label>类型:</label>\
    				<input type='radio' checked='checked' name='voiceType' value='1'>文本回复\
    				<input type='radio' name='voiceType' value='2' style='margin-left:30px;'>快捷键\
    			</div>\
    			<div class='aotoCommand' >\
    				<label>语料中包含的路径:</label>\
    				<input type='text' lay-verify='required' id='auto_voicePath'>\
    			</div>\
    			<div class='aotoCommand'>\
    				<label>语料文本:</label>\
    				<input type='text' id='auto_voiceText'>\
    			</div>\
    			<div class='aotoCommand'>\
    				<label>语料类型:</label>\
    				<select id='auto_voiceCat'>\
    					<option value='1' selected >系统语料</option>\
    					<option value='2'>未知回复</option>\
    					<option value='3'>第三方接口</option>\
    					<option value='4'>客户提供</option>\
    				</select>\
    			</div>\
    			<div class='aotoCommand'>\
    				<label>命令:</label>\
    				<input type='text' id='auto_voiceCommand'>\
    			</div>\
    			<div class='aotoCommand'>\
    				<label>命令参数:</label>\
    				<input type='text' id='auto_voiceCommandParam'>\
    			</div>\
    			<div class='aotoCommand'>\
    				<label>表情参数:</label>\
    				<input type='text' id='auto_voiceEmotion'>\
    			</div>\
    		</div>\
    		<div style='text-align: center;'>\
    			<input type='button' id='autoConfig-button' value='保 存'>\
    		</div>\
    	</div>";

    	config_layer = layer.open({
			type: 1,
			title: '拓展配置页面',  //标题
			 //加上边框
			closeBtn:1,
			moveType:0,
			area: ['540px', '380px'], //宽高
			content: commandAddHtml //弹窗内容
			});
    });

    /*
		拓展配置保存按钮事件
    */
    $(document).off("click","#autoConfig-button").on("click","#autoConfig-button",function(){
    	var auto_voiceName = $("#auto_voiceName").val();
    	var auto_voiceType = $('input[name="voiceType"]:checked').val();
    	var auto_voicePath = $("#auto_voicePath").val();
    	var auto_voiceText = $("#auto_voiceText").val();
    	var auto_voiceCat = $("#auto_voiceCat option:selected").val();
    	// var auto_voiceDescription = $("#auto_voiceDescription").val();
        var auto_voiceDescription = "";
    	var auto_voiceCommand = $("#auto_voiceCommand").val();
    	var auto_voiceCommandParam = $("#auto_voiceCommandParam").val();
    	// var auto_voiceThirdpardName = $("#auto_voiceThirdpardName").val();
    	// var auto_voiceThirdparTypeMethod = $("#auto_voiceThirdparTypeMethod").val();
    	// var auto_voiceThirdpartyapiHeaderparams = $("#auto_voiceThirdpartyapiHeaderparams").val();
    	// var auto_voiceThirdpartyapiUrl = $("#auto_voiceThirdpartyapiUrl").val();
        var auto_voiceThirdpardName = "";
        var auto_voiceThirdparTypeMethod = "";
        var auto_voiceThirdpartyapiHeaderparams = "";
        var auto_voiceThirdpartyapiUrl = "";
        var auto_voiceThirdpartyapiResulttype = "";
    	// var auto_voiceThirdpartyapiResulttype = $("#auto_voiceThirdpartyapiResulttype").val();
    	// var auto_voiceThirdpartyapiRunatserver = $('input[name="voiceThirdpartyapiRunatserver"]:checked').val();
        var auto_voiceThirdpartyapiRunatserver = "false";
    	// var auto_voiceIncprop = $("#auto_voiceIncprop").val();
    	// var auto_voiceExcerpt = $("#auto_voiceExcerpt").val();
        var auto_voiceIncprop = "";
        var auto_voiceExcerpt = "";
    	var auto_voiceEmotion = $("#auto_voiceEmotion").val();
    	// var auto_voiceEnabled = $('input[name="voiceEnabled"]:checked').val();
        var auto_voiceEnabled = "true";
    	// var auto_remake1 = $("#auto_remake1").val();
    	// var auto_remake2 = $("#auto_remake2").val();
        var auto_remake1 = "";
        var auto_remake2 = "";
    	var auto_userId = userId;
        var auto_robotSn = $("#robots").find(".robotCurrent").attr("sn");

    	var configJson = {
    		"voiceName" : auto_voiceName ,
    		"voiceType" : auto_voiceType ,
    		"voicePath" : auto_voicePath ,
    		"voiceText" : auto_voiceText ,
            "voiceCat" : auto_voiceCat,
    		"voiceDescription" : auto_voiceDescription ,
    		"voiceCommand" : auto_voiceCommand ,
    		"voiceCommandParam" : auto_voiceCommandParam ,
    		"voiceThirdpardName" : auto_voiceThirdpardName ,
    		"voiceThirdparTypeMethod" : auto_voiceThirdparTypeMethod ,
    		"voiceThirdpartyapiHeaderparams" : auto_voiceThirdpartyapiHeaderparams ,
    		"voiceThirdpartyapiUrl" : auto_voiceThirdpartyapiUrl ,
    		"voiceThirdpartyapiResulttype" : auto_voiceThirdpartyapiResulttype ,
    		"voiceThirdpartyapiRunatserver" : auto_voiceThirdpartyapiRunatserver ,
    		"voiceIncprop" : auto_voiceIncprop ,
    		"voiceExcerpt" : auto_voiceExcerpt ,
    		"voiceEmotion" : auto_voiceEmotion ,
    		"voiceEnabled" : auto_voiceEnabled ,
    		"remake1" : auto_remake1 ,
    		"remake2" : auto_remake2 ,
    		"userId" : auto_userId,
            "robotImei" : auto_robotSn
    	};
    	definedCommandSave(configJson);

    });

    /*
		获取问题查询结果
    */
    $(document).off("click","#session_getButton").on("click","#session_getButton",function(){
    // $("#session_getButton").click(function(){
    	var questionText = trim($("#session_question_text").val()).replace(/[\r\n]/g,"");
    	var currentRobot_sn = $("#robots").find(".robotCurrent").attr("sn");
    	var currentUserId = userId;

    	var currentJson = {
    		currentRobot_sn : currentRobot_sn,
    		currentUserId : currentUserId,
    		questionText : questionText
    	};
    	if(questionText == ""){
    		layer.tips('发送内容不能为空！', '#session_question_text');
    	}else{
            if(testReg.test(questionText)){
                getTalkAnswer(currentJson);
            }else{
                layer.alert('输入的只能为字母、数字、下划线或中文!', {
                      skin: 'layui-layer-demo' //样式类名
                      ,closeBtn: 0
                }, function(index){
                        layer.close(index);
                }); 
            }
    	}
    });
    /*
        文本回复下拉框点击事件
    */
    $(document).off("click","#session_text").on("click","#session_text",function(){
        
        var currentInputText = $("#session_text option:selected").attr("value");
        $("#session_input_text").val(currentInputText);
    });

    /*
        清空按钮
    */
    $(document).off("click","#session_clearButton").on("click","#session_clearButton",function(){
        $("#session_question_text").val("");
        $("#session_input_text").val("");
        $("#session_input_text").focus();
        $("#source_path").val("");
        $("#session_command option:first").prop("selected", 'selected');
        $("#session_third option:first").prop("selected", 'selected');
        $("#session_thirdParam option:first").prop("selected", 'selected');
        $("#session_text option:first").prop("selected", 'selected');
        globalJson = {};
        globalFlag = false;


    });

    /*
		文本发送点击事件
    */
    $("#session_send").click(function(){
        sendContentSession();
    })

    /*
        文本发送方法
    */
    function sendContentSession(){
        whichRobot();
        var sessionInputText=trim($("#session_input_text").val()).replace(/[\r\n]/g,"");
        if($("#session_command option:selected").text()=="无" && $("#session_third option:selected").text()=="无" && $("#session_text option:selected").text()=="无"){
            if(sessionInputText==''){
                layer.tips('发送内容不能为空！', '#session_input_text');
                $("#session_input_text").val('');
            }else{
                sendSession(sessionInputText);
            }
        }else{
            sendSession(sessionInputText);
        }
    }
     /*
		自动应答点击事件
     */
    $("#session_pass").click(function(){
    	whichRobot();
    	var sendData={
			"cmd":"manual_talk",
			"data":{"target":searchId,"text":"."}
		}
		socket.send(JSON.stringify(sendData));
		$("#session_input_text").focus();
    })

	/*
		建立websocket链接
	*/
	function initWebSocket(userName, password) {
	    // 与信令服务器的WebSocket连接
	    var loginData = 
	    {
	    	"cmd" : "get_bind_list",
	    	"data":{
                "sessionId":sessionId,
                "userId" :userId
            }
	    };
	    if (refleshFlag) {
	    	socket = new WebSocket("wss://"+host+"/signalmaster/ws");     
		    socket.onopen = function(arg) {
		        socket.send(JSON.stringify(loginData)); 
		    }; 
		    socket.onclose = function(arg) {
		    	// window.close();
		    	layer.alert('与服务器的网络连接已断开,请重新登录！', {
		    		  skin: 'layui-layer-demo' //样式类名
		    		  ,closeBtn: 0
		    		}, function(index){
                        socketNum++;
                        //是否为刷新
                       if(refleshFlag && socketNum < 4) {
                            initWebSocket(userName, password);
                       }else{
                            socketNum = 0;
                            window.location.href = "login.html";
                       }
                      layer.close(index);
		    		});	    	
		    };
		    socket.onerror = function(arg) {
		    	alert("error:" + arg);
		    }
		    socket.onmessage = function (event) {
		    	var json = JSON.parse(event.data);
				if (json.cmd === 'error') {
					layer.close(tipIndex);
					layer.alert('发生错误，状态码：[' + json.code + "]，原因：" + json.message
							, {icon: 5
						, title:'错误提示'
						, area: ['420px', '180px']
						, end : function (){$('#userName').select();}
					});
		     	} else if (json.cmd === 'get_bind_list_done') {
		     		//获取机器人列表数据
		    		var robotList = json.data;
		    		layer.closeAll();	
		    		refreshRobotListView(robotList);	
		    		robotClick();
		    	} else if(json.cmd === 'custom_talk'){
		    		var customTalk=json.data;
		    		var robotSn=customTalk.requestEpSn;
		    		var currentRobotSn=$("#robots").find(".robotCurrent").attr("sn");

                    $("#session_question_text").val("");
		    		if(currentRobotSn==robotSn){
		    			createSession(customTalk,$(".talk_list"));
		    		}
		    	} else if (json.cmd === 'endpoint_status_changed') {
		    		var changedRobot = json.data;
		    		var robotHtmlList=$("#robots input");
		        	for (var i = 0 ; i < robotHtmlList.length; i++) {
		        		var robot=$(robotHtmlList[i]);
		        		var robotId = parseFloat(robot.attr("robotId"));
		        		var robotStatus=eval("("+robot.attr("onlineOr")+")");
		        		var robotName=robot.attr("robotName");
		        		if (robotId == changedRobot.id && robotStatus!=changedRobot.online) {
		        			robot.val(robotName+(changedRobot.online? " - [在线]" : " - [离线]"));
		        			break;
		        		}
		        	}
		        }else if(json.cmd === 'not_limits'){
                    layer.alert('当前机器人被高级用户所控制，请等待！', {
                      skin: 'layui-layer-demo' //样式类名
                      ,closeBtn: 0
                    }, function(index){
                        $(".talk_container").hide();
                        $(".chatImg").hide();
                        layer.close(index);

                    }); 
                }else if(json.cmd === 'status_remind'){
                    var isSilent = json.sound;
                    if(isSilent == "0"){
                        $("#isSilent").get(0).checked=true;
                    }else{
                        $("#isSilent").get(0).checked=false;
                    }
                }
		    };
	    } else {
	    	socket.send(JSON.stringify(loginData)); 
	    }
	}
	/*
		文本命令发送
	*/
    function sendSession(sessionInputText){
  		whichRobot();
		var currentCommandParam=$("#command_param").val();
		var currentCommand = $("#session_command option:selected").val();
		var currentThirdPartyApiId = $("#session_third option:selected").val();
		var currentThirdPartyApiParamsValueId = $("#session_thirdParam option:selected").val();
		var currentPath = $("#source_path").val();
		var currentEmotion = "";

		if($("#session_text option:selected").val()!=""){
			sessionInputText = $("#session_text option:selected").val();
			currentCommandParam = $("#session_text option:selected").attr("commandParam");
			currentCommand = $("#session_text option:selected").attr("command");
			currentThirdPartyApiId = 0;
			currentThirdPartyApiParamsValueId = 0;
			currentPath = $("#session_text option:selected").attr("path");
			currentEmotion = $("#session_text option:selected").attr("emotion");

		}
        if(globalFlag === true){
            sessionInputText = globalJson.text;
            currentCommand = globalJson.command;
            currentCommandParam = globalJson.commandParam;
            currentThirdPartyApiId = globalJson.thisThirdPartyApiId;
            currentThirdPartyApiParamsValueId = globalJson.thisThirdPartyApiParamsValueId;
            currentPath = globalJson.path;
            currentEmotion = globalJson.emotion;
            globalJson = {};
            globalFlag = false;

        }
        globalFlag = false;
		var sendData={
			"cmd":"manual_talk",
			"data":{
				"target":searchId,
				"text":sessionInputText,
				"command":parseFloat(currentCommand),
				"commandParam":currentCommandParam,
				"thirdPartyApiId":parseFloat(currentThirdPartyApiId),
				"thirdPartyApiParamsValueId":parseFloat(currentThirdPartyApiParamsValueId),
				"path":currentPath,
				"emotion":currentEmotion
			}
		}

		socket.send(JSON.stringify(sendData));

		$("#session_input_text").val('');
		$("#session_input_text").focus();
    	// $("#session_command option:eq(0)").attr("selected",true);
        $("#session_command option:first").prop("selected", 'selected');
    	// $("#session_third option:eq(0)").attr("selected",true);
        $("#session_third option:first").prop("selected", 'selected');
    	// $("#session_thirdParam option:eq(0)").attr("selected",true);
        $("#session_thirdParam option:first").prop("selected", 'selected');
        // $("#session_text option:eq(0)").attr("selected",true);
        $("#session_text option:first").prop("selected", 'selected');
    }

	/*
		固定区域：各个按钮绑定的命令下发
	*/
    function sendCommand(_this){
    	whichRobot();
    	var thisCommandParam=_this.getAttribute("param");
    	var thisCommand=parseFloat(_this.getAttribute("command"));
    	var thisText="";
    	var thisPath="";
        var thisEmotion="";
    	if(thisCommand=="1007" ){
    		thisText="$perform-hint$";
    		thisPath="$dance_audio$";
    	}else if(thisCommand=="1000"){
            thisPath= thisCommandParam;
            thisCommandParam = "";
        }else if(thisCommand=="1001"){
            thisEmotion = _this.getAttribute("emotion");
            thisText = _this.getAttribute("textword");
        }

    	var sendData={
            "cmd":"manual_talk",
            "data":{"target":searchId,
                "text":thisText,
                "command":thisCommand,
                "commandParam":thisCommandParam,
                "thirdPartyApiId":0,
                "thirdPartyApiParamsValueId":0,
                "path":thisPath,
                "emotion":thisEmotion
            }
        }
        
        //中断所发JSON
        if(thisCommand=="2004"){
            sendData={
                "cmd":"stop_talk",
                "data":{"target":searchId,
                    "text":thisText,
                    "command":thisCommand,
                    "commandParam":thisCommandParam,
                    "thirdPartyApiId":0,
                    "thirdPartyApiParamsValueId":0,
                    "path":thisPath,
                    "emotion":thisEmotion
                }
            }
        }

    	socket.send(JSON.stringify(sendData));
    	$(".face_list").addClass("displayNone");
    	// $("#session_command option:eq(0)").attr("selected",true);
    	// $("#session_third option:eq(0)").attr("selected",true);
    	// $("#session_thirdParam option:eq(0)").attr("selected",true);

        $("#session_command option:first").prop("selected", 'selected');
        $("#session_third option:first").prop("selected", 'selected');
        $("#session_thirdParam option:first").prop("selected", 'selected');
        $("#session_text option:first").prop("selected", 'selected');
    }

    /*
		自定义拓展区域：动态生成按钮绑定的命令下发
	*/
    function sendUserDefinedCommand(_this){
    	whichRobot();
    	var thisCommandParam=_this.getAttribute("commandparam");
    	var thisCommand=parseFloat(_this.getAttribute("command"));
    	var thisPath=_this.getAttribute("path");
    	var thisEmotion=_this.getAttribute("emotion");
    	var thisText=_this.getAttribute("text");
    	var thisThirdpartyapiid=_this.getAttribute("thirdpartyapiid");
    	var thisThirdpartyapiparamsvalueid=_this.getAttribute("thirdpartyapiparamsvalueid");

    	var sendData={
			"cmd":"manual_talk",
			"data":{
				"target":searchId,
				"text":thisText,
				"command":thisCommand,
				"commandParam":thisCommandParam,
				"thirdPartyApiId":thisThirdpartyapiid,
				"thirdPartyApiParamsValueId":thisThirdpartyapiparamsvalueid,
				"path":thisPath,
				"emotion":thisEmotion,
			}
		}
    	socket.send(JSON.stringify(sendData));
    	$(".face_list").addClass("displayNone");
    	// $("#session_command option:eq(0)").attr("selected",true);
    	// $("#session_third option:eq(0)").attr("selected",true);
    	// $("#session_thirdParam option:eq(0)").attr("selected",true);

        $("#session_command option:first").prop("selected", 'selected');
        $("#session_third option:first").prop("selected", 'selected');
        $("#session_thirdParam option:first").prop("selected", 'selected');
        $("#session_text option:first").prop("selected", 'selected');
    }


    /*
		查看更多消息
    */
	$(".close_more_session").click(function(){
		$(this).hide();
		$(".session_loaded").show();
		$("#more_session").show();
		whichRobot();
		var sessionSn=$("#robots").find(".robotCurrent").attr("sn");
		todaySessionUrl="https://"+host+"/signalmaster/rest/chat_monitor/timeline/0/"+sessionSn+"/"+toDate;
		var currentSessionNum=$(".talk_left").length;
		sessionGet(todaySessionUrl,function(){

		if(data==undefined || data.length<=currentSessionNum){
			$("#more_session").html('暂无历史记录！');
			$(".session_loaded img").attr('src','images/icon_his.png').css('height','12px');
		}else{
			$(".session_loaded img").attr('src','images/icon_his.png').css('height','12px');
			var sessionIndex=0;
			if((data.length-currentSessionNum)<=20){
				sessionIndex=0;
			}else{
				sessionIndex=data.length-currentSessionNum-20;
			}
				for(var i=sessionIndex;i<(data.length-currentSessionNum);i++){
					var sessionStr='\
						<li class="clearfix">\
							<div class="talk_right">\
								<div class="clearfix">\
									<div class="avator2"></div>\
									<div class="talkInfo_box fr">\
										<div class="talkInfo_content">'+data[i].request+'</div>\
										<span class="talkInfo_time">'+data[i].dateTime+'</span>\
									</div>\
								</div>\
								<div class="talk_tip">\
									<img src="images/icon_arrow.png">\
									<div class="talk_tipInfo">\
										<p>模式：'+data[i].requestModel+'</p>\
										<p>地址：'+data[i].requestAddr+'</p>\
										<p>客户端版本：'+data[i].requestClientVersion+'</p>\
									</div>\
								</div>\
							</div>\
						</li>\
						<li class="clearfix">\
							<div class="talk_left">\
								<div class="clearfix">\
									<div class="avator1"></div>\
									<div class="talkInfo_box fl">\
										<div class="talkInfo_content">'+data[i].text+'</div>\
										<span class="talkInfo_time">'+data[i].dateTime+'</span>\
									</div>\
								</div>\
								<div class="talk_tip">\
									<img src="images/icon_arrow.png">\
									<div class="talk_tipInfo">\
										<p>响应时间：'+data[i].execMillsecs+'ms</p>\
										<p>响应类别：'+data[i].kind+'</p>\
									</div>\
								</div>\
							</div>\
						</li>'
					$("#more_session").append(sessionStr);
				}	

				$(".avator2").each(function(){
					$(this).css('margin-top',($(this).parent().height()-($(this).height()))+"px");
				})
				$(".avator1").each(function(){
					$(this).css('margin-top',($(this).parent().height()-($(this).height()))+"px");
				})
				$(".avator1,.avator2").hover(function(){
					$(this).parent().next().show();
				},function(){
					$(this).parent().next().hide();
				})
			}
			$(".talk_content").scrollTop($("#more_session")[0].scrollHeight);
		})
	});

    /*
        机器人刷新按钮点击事件
    */
    $(document).on("click",".reflesh-robot",function(){
        $(".talk_container").hide();
        $(".chatImg").hide();
        refleshFlag = false;
        initWebSocket(userName, password);

    });
	/*
		机器人刷新按钮事件
	*/

	// refreshRobotListView();
	//刷新机器人列表及相应事件
	function refreshRobotListView(robotList){
		$("#robots").html('');
		var all='';
        if(robotList !== undefined && robotList.length > 0){
    		for (i =0 ; i < robotList.length; i++){
    			var robot = robotList[i];
    			var robotItem="<input onlineOr="+robot.robotLatestStatusOnline+" mode="+robot.robotManualMode+" robotName="+robot.robotName+" sn="+robot.robotImei+" userId="+robot.userId+" robotId="+robot.robotId+" type=button value="+robot.robotName+(robot.robotLatestStatusOnline? "&nbsp-&nbsp[在线]" : "&nbsp-&nbsp[离线]")+">"
    			all=all+robotItem;
    			userName = robot.userName + "";
    		}
    		$("#robots").append(all);
    		robotClick();
    		var _this=$(this);
    		clearInterval(timer);
            $("#robots input").hover(function(){
                var _this=$(this);
                showTips(_this);
            },function(){
                clearInterval(timer);
            });
    		$(".all_robots").trigger('click');
        }
	}

	/*
		切换机器人
	*/

	function robotClick(){
		//切换机器人
		$(document).off("click","#robots input").on("click","#robots input",function(){
			$(".talk_container").show();
            
			layer.closeAll("tips");
			showTips($(this));
			$(this).addClass('robotCurrent').siblings().removeClass('robotCurrent');
			//获取每台机器人对应的数据和按钮
			initUserDefinedPanel();
		});
		
	}
    /*
        将页面按钮进行判断有效还是失效
    */
    function isDisableOrEnable(){
        $(".table_container textarea").val("");
        if($("#robots").find(".robotCurrent").attr("mode")=="true"){
            $("#hand_mode").get(0).checked=true;
        }else{
            $("#hand_mode").get(0).checked=false;
        }

        if($("#robots").find(".robotCurrent").attr("mode")=="false"){

            $(".table_container textarea").attr("readonly",true);
            $("#face_pack").click(function(){
                $(".face_list").addClass("displayNone");
            });
            $(".disable_eable").attr("disabled",true);
            //运动图片无效
            $(".move-up img").attr("src","img/move/up1.png"); 
            $(".move-down img").attr("src","img/move/down1.png"); 
            $(".move-content img").attr("src","img/move/content1.png"); 
            $(".move-left img").attr("src","img/move/left1.png"); 
            $(".move-right img").attr("src","img/move/right1.png"); 

        }else{
            $(".table_container textarea").attr("readonly",false);
            $("#face_pack").click(function(){
                $(".face_list").removeClass("displayNone");
            });
            $(".disable_eable").attr("disabled",false);
            //运动图片有效
            $(".move-up img").attr("src","img/move/up.png"); 
            $(".move-down img").attr("src","img/move/down.png"); 
            $(".move-content img").attr("src","img/move/content.png"); 
            $(".move-left img").attr("src","img/move/left.png"); 
            $(".move-right img").attr("src","img/move/right.png"); 
        }
        $("#more_session").html('');
        $(".close_more_session").css("display","block");
        $(".talk_list").html('');
        $(".session_loaded").hide();
    }

    /*
        渲染动态生成的页面
    */
    // initUserDefinedPanel();
    function initUserDefinedPanel(){
        var getDataJson = {
                "robotImei": $("#robots").find(".robotCurrent").attr("sn"),
                "userId": userId,
                "sessionId": sessionId
        };
        getConfigUrl = "https://"+host+"/signalmaster/rest/remote/selectvoice";

        getRobotConfig(getDataJson,getConfigUrl,function(){

            var button_string = "";
            var text_string = "<option value=''>无</option>";
            $.each(data,function(index){
                if(data[index].voiceType == 1){
                    text_string += "<option command='"+data[index].voiceCommand +"' commandParam='"+data[index].voiceCommandParam+"' path='"+data[index].voicePath +"' emotion='"+ data[index].voiceEmotion+"' text='" + data[index].voiceText + "' thirdPartyApiId='0' thirdPartyApiParamsValueId='0' value='"+ data[index].voiceText+"'>" + data[index].voiceName+"</option>";
                }else{
                     button_string += "<div class='fl session_command'><button class='disable_eable userDefined_btn' command='"+data[index].voiceCommand +"' commandParam='"+data[index].voiceCommandParam+"' path='"+data[index].voicePath +"' emotion='"+ data[index].voiceEmotion+"' text='" + data[index].voiceText + "' thirdPartyApiId='0' thirdPartyApiParamsValueId='0' title='"+ data[index].voiceName+"'>"+ data[index].voiceName +"</button></div>";
                }
            });
            $(".disable_eable").attr("disabled",false);
            $(".userDefined_btn").parent().remove();
            $("#session_text").html(text_string);
            $(button_string).appendTo(".userDefined");
            $(".chatImg").show();
            //渲染完页面重新判断是否有效
            isDisableOrEnable();       
        });
    }

	//机器人列表悬浮提示
	function showTips(_this){
		var tipsContent="sn："+_this.attr("sn")+"<br />id："+_this.attr("robotId");
		clearInterval(timer);
		timer=setTimeout(function(){
			tipIndex=layer.tips(tipsContent,_this,{
			   	tips: [1, '#3595CC'],
			  	time: 3000
			});
		},2000);
	}

	/*
		提问问题下发
	*/
	function getTalkAnswer(requsetDate) {
        whichRobot();
		var requestUrl = "https://"+host+"/signalmaster/rest/remote_auto_talk/"+ requsetDate.currentRobot_sn +"/"+ requsetDate.currentUserId +"/" + requsetDate.questionText;
        $.ajax({
			cache:false,
			type:'GET',
			url:requestUrl,
			success:function(result){
				var answerData=result.data;
				if(result.code==0){
					var thisText = answerData.voiceText;
                    var thisCommand = answerData.voiceCommand;
                    var thisCommandParam = answerData.voiceCommandParam;
                    var thisEmotion = answerData.voiceEmotion;
                    var thisPath = answerData.voicePath;
                    var thisThirdPartyApiId = 0;
                    var thisThirdPartyApiParamsValueId = 0;

                    globalJson = {
                        "text":thisText,
                        "command":parseFloat(thisCommand),
                        "commandParam":thisCommandParam,
                        "thirdPartyApiId":parseFloat(thisThirdPartyApiId),
                        "thirdPartyApiParamsValueId":parseFloat(thisThirdPartyApiParamsValueId),
                        "path":thisPath,
                        "emotion":thisEmotion
                    };
                    globalFlag = true;
                    if(thisText !== ""){
                        $("#session_input_text").val(thisText);
                    }else if(thisPath !== ""){
                        $("#session_input_text").val(thisPath);
                    }else if(thisEmotion !== ""){
                        $("#session_input_text").val(thisEmotion);
                    }
					
				}else{
					layer.alert(result.message);
				}
			},
			error:function(arg){
				// alert("服务器异常");
                alert("question_error:" + arg);
			}
		});
	}

	/*
		提问问题下发
	*/
	function definedCommandSave(JSONData) {
		var requestUrl = "https://"+host+"/signalmaster/rest/remote/savevoice";
		$.ajax({
			cache:false,
			type:'POST',
			url:requestUrl,
			data:JSONData,
			success:function(result){
				if(result.code==0){
					var layerIndex=layer.alert("配置保存成功",{
	  					icon:1,
	  					btn:['确定'],
	  					yes:function(index, layero){
	  						layer.close(layerIndex);
                            initUserDefinedPanel();
	 						layer.close(config_layer);
	  					}
	  				});
				}else{

					layer.alert(result.message);
				}
			},
			error:function(arg){
				// alert("服务器异常");
                alert("saveConfig_error:" + arg);
			}
		});
	}



});

/*
	去掉首尾空格
*/
function trim(str){
	return str.replace(/(^\s+)|(\s+$)/g,"");
}

/*
	获取机器人配置
*/
function getRobotConfig(JsonDatas,submitUrl,callback){
	$.ajax({
		cache:false,
		type:'POST',
		url:submitUrl,
		data:JsonDatas,
		success:function(result){
			data=result.data;
			if(result.code==0 && result.isSession =="1"){
				if(callback){
					callback();//重新刷新页面
				}
			}else if(result.code==0 && result.isSession =="0"){
                layer.alert('与服务器的网络连接已断开，请重新登录！', {
                      skin: 'layui-layer-demo' //样式类名
                      ,closeBtn: 0
                    }, function(index){
                      layer.close(index);
                      window.location.href = "login.html";
                    });    
            }else{
				layer.alert(result.message);
                $(".talk_container").hide();
                $(".chatImg").hide();

			}
		},
		error:function(arg){
			// alert("服务器异常");
             alert("getConfig_error:" + arg);
		}
	});
}

/*
	搜索信息
*/
function sessionGet(submitUrl,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:submitUrl,
		success:function(result){
			data=result.data;
			if(result.code==0){
				if(callback){
					callback();//重新刷新页面
				}
			}else{
				layer.alert(result.message);
			}
		},
		error:function(arg){
			// alert("服务器异常");
             alert("getInformation_error:" + arg);
		}
	});
}
/*
	聊天展示
*/
function createSession(dataSession,parent){
	
	if(dataSession.text==undefined){
		if(dataSession.request!="^"){
			var sessionStr='\
			<li class="clearfix">\
				<div class="talk_right">\
					<div class="clearfix">\
						<div class="avator2"></div>\
						<div class="talkInfo_box fr">\
							<div class="talkInfo_content">'+dataSession.request+'</div>\
							<span class="talkInfo_time">'+dataSession.dateTime+'</span>\
						</div>\
					</div>\
					<div class="talk_tip">\
						<img src="images/icon_arrow.png">\
						<div class="talk_tipInfo">\
							<p>模式：'+dataSession.requestModel+'</p>\
							<p>地址：'+dataSession.requestAddr+'</p>\
							<p>客户端版本：'+dataSession.requestClientVersion+'</p>\
						</div>\
					</div>\
				</div>\
			</li>'
		}	
	}else if(dataSession.request==undefined){
		var sessionStr='\
		<li class="clearfix">\
			<div class="talk_left">\
				<div class="clearfix">\
					<div class="avator1"></div>\
					<div class="talkInfo_box fl">\
						<div class="talkInfo_content">'+dataSession.text+'</div>\
						<span class="talkInfo_time">'+dataSession.dateTime+'</span>\
					</div>\
				</div>\
			</div>\
		</li>'
	}else{
		var execMillsecs='',kind='';
		var command=dataSession.command;
		if(dataSession.execMillsecs==undefined){
			execMillsecs="N/A";
		}else{
			execMillsecs=dataSession.execMillsecs;
		}
		if(dataSession.kind==undefined){
			kind="N/A";
		}else{
			kind=dataSession.kind;
		}
		switch(command){
			case 0:
				if(dataSession.text==''){
					var text="噪音";
				}else{
					var text=dataSession.text;
				}
				break;
			case 1004:
				var text="播报电量";
				break;
			case 95:
				var text="播放音乐";
				break;
			case 1009:
				var text="打印";
				break;
			case 93:
				var text="弹出输入框";
				break;
			case 98:
				var text="更新配置";
				break;
			case 1008:
				var text="回去充电";
				break;
			case 1001:
				var text="机器人命令组";
				break;
			case 92:
				var text="启动第三方应用";
				break;
			case 100:
				var text="设置音量";
				break;
			case 1433:
				var text="数据例程";
				break;
			case 1007:
				var text="跳舞";
				break;
			case 99:
				var text="退出会话";
				break;
			case 96:
				var text="显示分类菜单";
				break;
			case 91:
				var text="显示图片";
				break;
			case 90:
				var text="显示网页";
				break;
			case 1006:
				var text="显示系统信息";
				break;
			case 1003:
				var text="巡游";
				break;
			case 97:
				var text="远程视频";
				break;
			default:
				break;	
		}
		var sessionStr='\
		<li class="clearfix">\
			<div class="talk_left">\
				<div class="clearfix">\
					<div class="avator1"></div>\
					<div class="talkInfo_box fl">\
						<div class="talkInfo_content">'+text+'</div>\
						<span class="talkInfo_time">'+dataSession.dateTime+'</span>\
					</div>\
				</div>\
			</div>\
		</li>'
	}
	parent.append(sessionStr);
	$(".talk_list .avator1:last").css("margin-top",($(".talk_list .avator1:last").siblings().height()-$(".talk_list .avator1:last").height())+"px");
	$(".talk_list .avator2:last").css("margin-top",($(".talk_list .avator2:last").siblings().height()-$(".talk_list .avator2:last").height())+"px");
	$(".talk_left:last .talk_tip").css("bottom",-($(".talk_left:last .talk_tip").height()+11)+'px');
	$(".talk_right:last .talk_tip").css("bottom",-($(".talk_right:last .talk_tip").height()+11)+'px');
	$(".avator1,.avator2").hover(function(){
		$(this).parent().next().show();
	},function(){
		$(this).parent().next().hide();
	})
	$(".talk_content").scrollTop($(".talk_content")[0].scrollHeight);
}

/*
	动态创建下拉框数据
*/
function createSelectList(url,parent){

		parent.html("<option value='0'>无</option>");
		multiSubmit(url,function(){
			if(!message=="OK"){
				layer.alert("获取数据失败！");
			}else{
				if(data!=undefined){
					var session_command='';
					for(var i=0,len=data.length;i<len;i++){
						session_command+='<option value='+data[i].id+'>'+data[i].name+'</option>';
					}
					parent.append(session_command);
				}
			}
		});
	}
	