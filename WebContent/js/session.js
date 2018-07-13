$(document).ready(function(){
	var socket = null; 
	var tipIndex = 0;
	var pagination=10;
	var logListUrl="https://"+host+"/signalmaster/rest/runtime/list";
	var timer;
	var today=new Date();
	var year=today.getFullYear();
	var month=zero(today.getMonth()+1);
	var day=zero(today.getDate());
	var toDate=year+"-"+month+"-"+day+" 00:00:00";
	var textDate=year+"-"+month+"-"+day+" "+zero(today.getHours())+":"+zero(today.getMinutes())+":"+zero(today.getSeconds());
	var todaySessionUrl='';
	todaySessionUrl="https://"+host+"/signalmaster/rest/chat_monitor/timeline/"+groupId+"/null/"+toDate;

	if(window.localStorage.data==undefined){
		var layerIndex=layer.alert("未登录，请先登陆！",{
		  	icon:5,
		  	btn:['确定'],
		  	yes:function(index, layero){
		  		window.location.href="login.html";
		  		layer.close(layerIndex);
		  	}
		})
	}else{
		var robotListSession=JSON.parse(window.localStorage.data);
		var userName=window.localStorage.user;
		var password=window.localStorage.pwd;
		var sessionId=window.localStorage.sessionId;
	}
	
	var allRobots=robotListSession[0].userGroupName;
	var groupId=robotListSession[0].userGroupId;
	var userId=robotListSession[0].userId;
	var groupName=robotListSession[0].userGroupName;

	videojs.options.flash.swf = "js/video-js/video-js.swf";

	//自定义滚动条
	$('.talk_title').niceScroll({
		cursorcolor: "#aaa",//#CC0071 光标颜色
		cursoropacitymax: 1, //改变不透明度非常光标处于活动状态（scrollabar“可见”状态），范围从1到0
		touchbehavior: false, //使光标拖动滚动像在台式电脑触摸设备
		cursorwidth: "5px", //像素光标的宽度
		cursorborder: "0", // 游标边框css定义
		cursorborderradius: "5px",//以像素为光标边界半径
		autohidemode: false, //是否隐藏滚动条
	});

	$(".all_robots").val(allRobots);
	 //加载完成显示全部
	$(".all_robots").addClass("all_robots_current");	

	//当前会话机器
	currentSessionRobot();

	//输入对话框选中
	$("#session_input_text").focus(function(){
		$(".session_input_box").css("background","#fcfcfc");
	})
	$("#session_input_text").blur(function(){
		$(".session_input_box").css("background","#f9f9f9");
	})

	//websockit链接

	initWebSocket(userName, password);
	
	$("#hand_mode").change(function(){
		whichRobot();
		var sendData={
    		"cmd":"manual_mode_switch",
    		"data":{"target":searchId}
    	}
    	socket.send(JSON.stringify(sendData));
		if($("#hand_mode").is(':checked')){
			_thisElement.attr("mode","true");
			$("#session_send").attr("disabled",false);
			$("#session_pass").attr("disabled",false);
			$("#session_command").attr("disabled",false);
			$("#source_path").attr("disabled",false);
			$("#command_param").attr("disabled",false);
			$("#session_third").attr("disabled",false);
			$("#session_thirdParam").attr("disabled",false);
			$("#session_input_text").attr("readonly",false);
			$("#session_input_text").focus();
			$(".session_command button").attr("disabled",false);
			$("#face_pack").click(function(){
				$(".face_list").removeClass("displayNone");
			})
		}else{
			_thisElement.attr("mode","false");
			$("#session_send").attr("disabled",true);
			$("#session_pass").attr("disabled",true);
			$("#session_command").attr("disabled",true);
			$("#source_path").attr("disabled",true);
			$("#command_param").attr("disabled",true);
			$("#session_third").attr("disabled",true);
			$("#session_thirdParam").attr("disabled",true);
			$("#session_input_text").attr("readonly",true);
			$(".session_command button").attr("disabled",true);
			$("#face_pack").click(function(){
				$(".face_list").addClass("displayNone");
			})
		}
    })

    //表情包发送
    $("#face_pack").click(function(){
    	$(".face_list").removeClass("displayNone");
    })
    $(".face_list ul li").click(function(){
    	var _this=$(this);
    	sendCommand(_this);
    })
    $(".arrow_btn,#nod,#shake_head,#stop_move,#play_video,#update_config,#dance,#patrol,#add_voice,#down_voice,#battery").click(function(){
    	var _this=$(this);
    	sendCommand(_this);
    })

    //视频等按钮操作

    
    $("body").get(0).onclick=function(event){
		event = event ? event : window.event;   
		var obj = event.srcElement ? event.srcElement : event.target;
		if(obj.className!="face_list" && obj.id!="face_pack" && obj.className!="clearfix face_list_box"){
			$(".face_list").addClass("displayNone");
		}
	}

    $("#session_input_text").keyup(function(event){
    	if(event.which==13){
			$("#session_send").trigger('click');
		}
    })

    $("#session_send").click(function(){
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
    })

    //发送命令
    function sendCommand(_this){
    	whichRobot();
    	var thisCommandParam=_this.attr("param");
    	var thisCommand=parseFloat(_this.attr("command"));
    	var text="";
    	var path="";
    	var emotion="";
    	if(thisCommand=="1007" ){
    		text="$perform-hint$";
    		path="$dance_audio$";
    	}
    	if(thisCommand=='1003'){
    		text=_this.attr("title");
    	}
    	if(thisCommand=='1001'){
    		emotion = _this.attr("param");
    	}
    	var sendData={
			"cmd":"manual_talk",
			"data":{"target":searchId,
				"text":text,
				"command":thisCommand,
				"commandParam":thisCommandParam,
				"thirdPartyApiId":0,
				"thirdPartyApiParamsValueId":0,
				"path":path,
				"emotion":emotion
			}
		}
    	console.log(sendData);
    	socket.send(JSON.stringify(sendData));
    	$(".face_list").addClass("displayNone");
    	$("#session_command option:eq(0)").attr("selected",true);
    	$("#session_third option:eq(0)").attr("selected",true);
    	$("#session_thirdParam option:eq(0)").attr("selected",true);
    }

    //发送消息
    function sendSession(sessionInputText){
    	var command_param='';
		if($("#command_param").css("display")=="none"){
			command_param=$("#robot_command option:selected").val();
		}else{
			command_param=$("#command_param").val();
		}
		if($("#session_text option:selected").val()!="none"){
			sessionInputText = $("#session_text option:selected").val();
		}
		var sendData={
			"cmd":"manual_talk",
			"data":{"target":searchId,
				"text":sessionInputText,
				"command":parseFloat($("#session_command option:selected").val()),
				"commandParam":command_param,
				"thirdPartyApiId":parseFloat($("#session_third option:selected").val()),
				"thirdPartyApiParamsValueId":parseFloat($("#session_thirdParam option:selected").val()),
				"path":$("#source_path").val(),
				"emotion":""
			}
		}
		console.log(sendData);
		socket.send(JSON.stringify(sendData));
		$("#session_input_text").val('');
		$("#session_input_text").focus();
    	$("#session_command option:eq(0)").attr("selected",true);
    	$("#session_third option:eq(0)").attr("selected",true);
    	$("#session_thirdParam option:eq(0)").attr("selected",true);
    }

    $("#session_pass").click(function(){
    	whichRobot();
    	var sendData={
			"cmd":"manual_talk",
			"data":{"target":searchId,"text":"."}
		}
		socket.send(JSON.stringify(sendData));
		$("#session_input_text").focus();
    })


	$(".all_robots").click(function(){
		if(!($(this).hasClass("all_robots_current"))){
			layer.closeAll("tips");
			var tipsContent="id："+groupId;
			clearInterval(timer);
			timer=setTimeout(function(){
				layer.tips(tipsContent,$(".all_robots"),{
				   	tips: [1, '#3595CC'],
				  	time: 5000
				});
			},2000);
			$("#session_send").attr("disabled",true);
			$("#session_pass").attr("disabled",true);
			$("#session_input_text").attr("readonly",true);
			$(".session_command").addClass("displayNone");
			$("#more_session").html('');
			$(".close_more_session").css("display","block");
			$(".session_auto").css("display",'none');
			$(".talk_list").html('');
			$(".session_loaded").hide();
			$(".sessionHis_more").hide();
			$(".all_robots").addClass("all_robots_current");
			$("#robots input").removeClass('robotCurrent');
			$(".talk_robot").text($(".all_robots").val());
		}
	})

	//更多记录
	$(".close_more_session").click(function(){
		$(this).hide();
		$(".session_loaded").show();
		$("#more_session").show();
		whichRobot();
		if(groupFlag){
			todaySessionUrl="https://"+host+"/signalmaster/rest/chat_monitor/timeline/"+groupId+"/null/"+toDate;
		}else{
			var sessionSn=sn;
			todaySessionUrl="https://"+host+"/signalmaster/rest/chat_monitor/timeline/0/"+sessionSn+"/"+toDate;
		}
		var currentSessionNum=$(".talk_left").length;
		sessionGet(todaySessionUrl,function(){
			if(data==undefined || data.length<=currentSessionNum){
				$("#more_session").html('暂无历史记录！');
				$(".session_loaded img").attr('src','images/icon_his.png').css('height','12px');
			}else{
				$(".sessionHis_more").css('display','block');
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

	})

	//命令，第三方，参数
    createSelectList("https://"+host+"/signalmaster/rest/voice/command/list",$("#session_command"));
    createSelectList("https://"+host+"/signalmaster/rest/voice/_3rd/list",$("#session_third"));
    $("#session_command").change(function(){
    	var selected_command=$("#session_command option:selected");
    	isRobotCommand(selected_command.text());
    })

    $("#session_third").change(function(){
    	var selected_third=$("#session_third option:selected");
    	createSelectList("https://"+host+"/signalmaster/rest/voice/_3rd/params/list/"+selected_third.val(),$("#session_thirdParam"));
    })

	function createSelectList(url,parent){
		parent.html("<option value='0'>无</option>");
		multiSubmit(url,function(){
			if(!message=="OK"){
				layer.alert("获取数据失败！")
			}else{
				if(data!=undefined){
					var session_command='';
					for(var i=0,len=data.length;i<len;i++){
						session_command+='<option value='+data[i].id+'>'+data[i].name+'</option>';
					}
					parent.append(session_command);
				}
			}
		})
	}

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

	function initWebSocket(userName, password) {
	    // 与信令服务器的WebSocket连接
	    var loginData = 
	    {
	    	"cmd" : "get_bind_list",
	    	"data":{"sessionId":sessionId}
	    };
	    
	    if (socket == null) {
	    	socket = new WebSocket("wss://"+host+"/signalmaster/ws");     
		    socket.onopen = function(arg) {
		        socket.send(JSON.stringify(loginData)); 
		    }; 
		    socket.onclose = function(arg) {
		    	console.log('closed');
		    	window.close();
		    	layer.alert('与服务器的网络连接已断开，请检查网络设置！', {
		    		  skin: 'layui-layer-demo' //样式类名
		    		  ,closeBtn: 0
		    		}, function(index){
		    		  initWebSocket(userName, password);
		    		  layer.close(index);
		    		});	    	
		    };
		    socket.onerror = function(arg) {
		    	alert("error:" + arg);
		    }
		    socket.onmessage = function (event) {
		    	var json = JSON.parse(event.data);
		    	console.log(json);
				if (json.cmd === 'error') {
					layer.close(tipIndex);
					layer.alert('发生错误，状态码：[' + json.code + "]，原因：" + json.message
							, {icon: 5
						, title:'错误提示'
						, area: ['420px', '180px']
						, end : function (){$('#userName').select();}
					});
		     	} else if (json.cmd === 'get_bind_list_done') {
		    		robotList = json.data;
		    		layer.closeAll();	
		    		refreshRobotListView();	
		    		robotClick();
		    	} else if(json.cmd === 'custom_talk'){
		    		var customTalk=json.data;
		    		var robotSn=customTalk.requestEpSn;
		    		var currentRobotSn=$("#robots").find(".robotCurrent").attr("sn");
		    		if(currentRobotSn==robotSn){
		    			createSession(customTalk,$(".talk_list"))
		    		}
		    	} else if (json.cmd === 'endpoint_status_changed') {
		    		var changedRobot = json.data;
		    		var robotHtmlList=$("#robots input");
		    		console.log(robotHtmlList);
		    		console.log(json);
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
		        } else if (json.cmd === "remote_video_status_changed"){
		        	var liveVideoData=json.data;
		        	var liveConnected=liveVideoData.status;
		        	var videoIndex;
		        	if(liveConnected=='connected'){
		        		$("#video_box").removeClass("displayNone");
		        		var liveSn=liveVideoData.sn;
		        		var rtmpUrl='rtmp://'+host+'/live/'+liveSn+'_r';
		        		var videoJsp="https://"+host+"/signalmaster/video_web.jsp?url="+rtmpUrl;
		        		videoIndex=layer.open({
							title:"远程视频",
							shade: false,
							type:2,
							content:videoJsp,
							area:["600px","500px"],
							btn:['结束远程视频'],
							yes:function(){
								sendCommand($("#play_video"));
								layer.close(videoIndex);
							},
							end:function(){
								sendCommand($("#play_video"));
							}
						})
		        	}else{
		        		layer.close(videoIndex);
		        	} 	
		        }
		    };
	    } else {
	    	socket.send(JSON.stringify(loginData) ); 
	    }
	}

	function refreshRobotListView(){
		$("#robots").html('');
		var all='';
		for (i =0 ; i < robotList.length; i++){
			var robot = robotList[i];
			var robotItem="<input onlineOr="+robot.robotLatestStatusOnline+" mode="+robot.robotManualMode+" robotName="+robot.robotName+" sn="+robot.robotImei+" userId="+robot.userId+" robotId="+robot.robotId+" groupId="+robot.userGroupId+" groupName="+robot.userGroupName+" type=button value="+robot.robotName+(robot.robotLatestStatusOnline? "&nbsp-&nbsp[在线]" : "&nbsp-&nbsp[离线]")+">"
			all=all+robotItem;
			userName = robot.userName + "";
		}
		$("#robots").append(all);
		robotClick();
		$("#robots input").hover(function(){
			var _this=$(this);
			showTips(_this);
		},function(){
			clearInterval(timer);
		})
		$(".all_robots").hover(function(){
			var _this=$(this);
			var tipsContent="id："+groupId;
			clearInterval(timer);
			timer=setTimeout(function(){
				tipIndex=layer.tips(tipsContent,_this,{
				   	tips: [1, '#3595CC'],
				  	time: 5000
				});
			},2000);
		},function(){
			clearInterval(timer);
		})

		$(".all_robots").trigger('click');
	}

	function robotClick(){
		//切换机器人
		$("#robots input").click(function(){
			if(!($(this).hasClass("robotCurrent"))){
				layer.closeAll("tips");
				showTips($(this));
				if($(this).attr("mode")=="false"){
					$("#session_send").attr("disabled",true);
					$("#session_pass").attr("disabled",true);
					$("#session_command").attr("disabled",true);
					$("#source_path").attr("disabled",true);
					$("#command_param").attr("disabled",true);
					$("#session_third").attr("disabled",true);
					$("#session_thirdParam").attr("disabled",true);
					$("#session_input_text").attr("readonly",true);
					$(".session_command button").attr("disabled",true);
					$("#face_pack").click(function(){
						$(".face_list").addClass("displayNone");
					});
				}else{
					$("#session_send").attr("disabled",false);
					$("#session_pass").attr("disabled",false);
					$("#session_command").attr("disabled",false);
					$("#source_path").attr("disabled",false);
					$("#command_param").attr("disabled",false);
					$("#session_third").attr("disabled",false);
					$("#session_thirdParam").attr("disabled",false);
					$("#session_input_text").attr("readonly",false);
					$(".session_command button").attr("disabled",false);
					$("#face_pack").click(function(){
						$(".face_list").removeClass("displayNone");
					});
				}
				$(".session_auto").css("display","block");
				$(".session_command").removeClass("displayNone");
				$("#more_session").html('');
				$(".close_more_session").css("display","block");
				$(".talk_list").html('');
				$(".session_loaded").hide();
				$(".sessionHis_more").hide();
				$(this).addClass('robotCurrent').siblings().removeClass('robotCurrent');
				$(".all_robots").removeClass("all_robots_current");
				$(".talk_robot").html($(this).val());
				if($(this).attr("mode")=="true"){
					$("#hand_mode").get(0).checked=true;
				}else{
					$("#hand_mode").get(0).checked=false;
				}
			}	
		})
	}

	function showTips(_this){
		var tipsContent="sn："+_this.attr("sn")+"<br />id："+_this.attr("robotId");
		clearInterval(timer);
		timer=setTimeout(function(){
			tipIndex=layer.tips(tipsContent,_this,{
			   	tips: [1, '#3595CC'],
			  	time: 5000
			});
		},2000);
	}
	
})



function trim(str){
	return str.replace(/(^\s+)|(\s+$)/g,"");
}

//当前会话机器显示
function currentSessionRobot(){
	whichRobot();
	if(groupFlag){
		$(".talk_robot").text($(".all_robots").val())
	}else{
		$(".talk_robot").text(robotNameSession);
	} 
}

/*搜索信息*/
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
		error:function(){
			alert("服务器异常")
		}
	})
}

//创建对话
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






