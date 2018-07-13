var getRobotArgument;
$(document).ready(function(){
	var socket = ""; 
	var handcheck = "";
	var currentNum = 0;
	var remindTimer;
	var remindCount = 0;
	var localHost=window.location.href;
//	var localHost='https://www.aotorobot.com/signalmaster/session.html?sn=sssddsd&session=asfasd&userId=sf111&robotId=sdfsafs&height=320px';
	var regHost=/\/\/(.*?)\//;
	var host=localHost.match(regHost)[1];
	var isNull= localHost.indexOf("null");
	var moveIntervalTimer;
	var startX,startY,width,height,largeHeader;
	var moveFlag = true;
	
	if(localHost == undefined || localHost == null || isNull != -1){
		window.location.href = "error.html";
	}else{
		var urlArugment = localHost.split("?")[1].split("&");
		var robotSn = urlArugment[0].split("sn=")[1];
		var sessionId = urlArugment[1].split("session=")[1];
		var userId = urlArugment[2].split("userId=")[1];
		var robotId = urlArugment[3].split("robotId=")[1];
		var countNum = 0;
		
		var dqheight =screen.availHeight;
		var dqwidth = screen.availWidth;
		largeHeader = document.getElementById("panelId");
		largeHeader.style.height = (dqheight/2) +'px';
		
		
		initWebSocket();
		/**
		 固定按钮点击事件
		**/
	    $(document).off("click",".command_button").on("click",".command_button",function(){
	    	var currenthank = $(".hand_auto").text();
	    	if(currenthank == "手动"){
		    	var _this = this;
		    	currentNum = Math.round(Math.random()*5);
		    	sendCommand(_this);
			}else{
				$.alertView("只有在手动情况下才能下发指令!");
			}
	    });
	
		var moveObj = document.getElementById("moveId");
	    moveObj.addEventListener("touchstart", function(e){
	    	var currenthank = $(".hand_auto").text();
	    	if(currenthank == "手动"){
			    e.preventDefault();
			    startX = e.targetTouches[0].clientX,
			    startY = e.targetTouches[0].clientY;
			    
			}else{
				$.alertView("只有在手动情况下才能下发指令!");
			}
		});

		moveObj.addEventListener("touchmove", function(e){
			e.preventDefault();
		    var moveEndX = e.targetTouches[0].clientX;
		    var moveEndY = e.targetTouches[0].clientY;
		    var move_X = moveEndX - startX;
		    var move_Y = moveEndY - startY;
		   
			var Vx = move_X + 44;
			var Vy = move_Y + 44;
			
			if(Vx > 90){
				Vx = 90;
			}else if(Vx < 0){
				Vx = 0;
			}
			
			if(Vy > 90){
				Vy = 90;
			}else if(Vy < 0){
				Vy = 0;
			}else{
				Vy = Vy;
			}
			$(".moveBtn").css('left', Vx+'px');
			$(".moveBtn").css('top', Vy+'px');

		    if ( Math.abs(move_X) > Math.abs(move_Y) && move_X > 0 ) {
		    	if(moveFlag){
					moveFlag = false;
					sendMoveCommand("right");
			    	moveIntervalTimer = setInterval(function(){
//			    		$("#print").append("right");
			    		sendMoveCommand("right");
			    	},200);
		    	}
		    }
		    else if ( Math.abs(move_X) > Math.abs(move_Y) && move_X < 0 ) {
		    	if(moveFlag){
					moveFlag = false;
			        sendMoveCommand("left");
			        moveIntervalTimer = setInterval(function(){
//			    		$("#print").append("left");
			    		sendMoveCommand("left");
			    	},200);
		    	}
		    }
		    else if ( Math.abs(move_Y) > Math.abs(move_X) && move_Y > 0) {
		    	if(moveFlag){
					moveFlag = false;
			        sendMoveCommand("back");
			        moveIntervalTimer = setInterval(function(){
//			    		$("#print").append("back");
			    		sendMoveCommand("back");
			    	},200);
		    	}
		    }
		    else if ( Math.abs(move_Y) > Math.abs(move_X) && move_Y < 0 ) {
		    	if(moveFlag){
					moveFlag = false;
			        sendMoveCommand("forward");
			        moveIntervalTimer = setInterval(function(){
//			    		$("#print").append("forward");
			    		sendMoveCommand("forward");
			    	},200);
		    	}
		    }
		});

		moveObj.addEventListener("touchend", function(e){
			moveFlag = true;
			e.preventDefault();
			clearInterval(moveIntervalTimer);
//		    $("#print").append("end");
		    sendMoveCommand("stop");
		    $(".moveBtn").css('left', '45px');
			$(".moveBtn").css('top', '45px');
		});
		
		moveObj.addEventListener("touchcancel", function(e){
			moveFlag = true;
			e.preventDefault();
			clearInterval(moveIntervalTimer);
//		    $("#print").append("end");
		    sendMoveCommand("stop");
		    $(".moveBtn").css('left', '45px');
			$(".moveBtn").css('top', '45px');
		});
		
		function sendMoveCommand(deriction){
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
	            "data":{"target":robotId,
	                "runningParam":thisCommandParam
	            }
	        };
	        socket.send(JSON.stringify(sendData));
		}
	    
	    /**
	           手动/自动点击切换
	    **/
	    $(document).off("click",".hand_auto").on("click",".hand_auto",function(){
	    	
	    	var manualModeStatus = "";
	    	if(handcheck == true){
	    		manualModeStatus = "0";
	    	}else{
	    		manualModeStatus = "1";
	    	}
		    var sendData={
	    		"cmd":"manual_mode_switch",
	    		"data":{
	    			"target":robotId,
	    			"manualModeStatus" : manualModeStatus
	    		}
	    	}
	    	socket.send(JSON.stringify(sendData));
			
	    });
	    
	    function sendCommand(_this){
	    	var thisCommandParam = _this.getAttribute("param");
	    	var thisCommand = parseFloat(_this.getAttribute("command"));
	    	var thisText="";
	    	var thisPath="";
	    	var thisEmotion = "";
	    	if(thisCommand=="1007" ){
	    		thisText="$perform-hint$";
	    		thisPath="$dance_audio$";
	    	}else if(thisCommand=="1000"){
	    		thisPath= thisCommandParam;
	    		thisCommandParam = "";
	    	}else if(thisCommand=="1003"){
	    		thisText="好的，请跟我来";
	    	}else if(thisCommand=="1008"){
	    		thisText="好的，我要回去充电了";
	    	}
	    	
	    	var sendData={
				"cmd":"manual_talk",
				"data":{
					"target":robotId,
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
	                "data":{"target":robotId,
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
	    }
	    /*
	    	建立websocket服务 
	    */
		function initWebSocket() {
		    // 与信令服务器的WebSocket连接
		    var loginData = 
		    	{
		    	"cmd" : "get_bind_list",
		    	"data":{
	                "sessionId":sessionId,
	                "userId" :userId
	            }
		    };
		    socket = new WebSocket("wss://"+host+"/signalmaster/ws");     
			socket.onopen = function(arg) {
			    socket.send(JSON.stringify(loginData)); 
			}; 
			socket.onclose = function(arg) {
				countNum ++;
				if(countNum <4){
					initWebSocket();
				}else{
					countNum = 0;
					android.queryState();
				}
			   	
			};
			socket.onerror = function(arg) {
			   	window.location.href = "error.html";
			}
			socket.onmessage = function (event) {
			    var json = JSON.parse(event.data);
				if (json.cmd === 'error') {
					window.location.href = "error.html";
			    }else if (json.cmd === 'get_bind_list_done') {
		     		//获取机器人列表数据
		    		var robotList = json.data;
                  	compareRobot(robotList);
		    	}else if (json.cmd === 'endpoint_status_changed') {
		    		socket.send(JSON.stringify(loginData)); 
		    	}else if(json.cmd === 'not_limits'){
					window.location.href = "freshen.html";
		    	}else if(json.cmd === 'manual_mode_switch_succeed'){
		    		socket.send(JSON.stringify(loginData)); 
               }else if (json.cmd === 'status_remind') {//电池电量提醒和静音的指令
               	//电量低
               		if (json.power === '1'|| json.power === '0') {
               			var currentPower = json.power;
               			powerReminding(currentPower);
               		}
               	} 	
			};
		}
		
		
		//将所有机器人数据进行对比，找到手动/自动的状态
		function compareRobot(robotList){
			$.each(robotList,function(index){
				if(robotList[index].robotId == robotId){
					handcheck = robotList[index].robotManualMode;
					if(handcheck == true){
						$(".hand_auto").text("手动");
					}else{
						$(".hand_auto").text("自动");
					}
				}
				
			});
		}
		
		function getRobotArgument(resutlState){
			if(resutlState === "1"){
				initWebSocket();
			}else{
				window.location.href = "freshen.html";
			}
		}
		
		//powerReminding("0");
		function powerReminding(power) {
			clearInterval(remindTimer);
		    if (power === '0') {
		        remindTimer = setInterval(function() {
		            remindCount++ % 2 ? $(".remind_div").show() : $(".remind_div").hide();
		        }, 1000);
		    } else {
		        $(".remind_div").hide();
		    }
		}
	}
});
	
