
//var host="www.robotcheers.com";
var localHost=window.location.href;
var regHost=/\/\/(.*?)\//;
var host=localHost.match(regHost)[1];   
if(window.localStorage.data==undefined){
	var layerIndex=layer.alert("未登录，请先登陆！",{
	  	icon:5,
	  	btn:['确定'],
	  	yes:function(index, layero){
	  		window.location.href="login.html";
	  		layer.close(layerIndex);
	  	}
	});
}
var layerIndex;

/*搜索信息*/
function multiSubmit(submitUrl,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:submitUrl,
		success:function(result){
			endTimeCorpus=new Date();
			endTimeCorpus=endTimeCorpus.getTime();
			message=result.message;
			data=result.data;
			if(callback){
				callback();//重新刷新页面
			}
		},
		error:function(result){
			alert('服务器异常！');
		}
	});
}


$(document).ready(function(){
	//插入头部header
	var header='<div class="wapper_welcome">\
		<span class="fl"><i class="fa fa-home fa-2x"></i>欢迎进入奥拓智能机器人远程控制管理系统</span>\
		<div class="wapper_user" style="float:right;">\
			<span><span>您好， </span><span class="user_name"></span>&nbsp&nbsp<i class="fa fa-user-circle fa-2x"></i></span>\
			<a href="javascript:;" class="user_quit">退出</a>\
		</div>\
	</div>';
	$("body").prepend(header);

	//获取用户名
	var userName=window.localStorage.controllerUser;
	$(".user_name").text(userName);

	//退出
	$(".user_quit").click(function(){
		var userId = window.localStorage.controllerUserId;
		var sessionId = window.localStorage.controllerSessionId;
		var quitJson = {
			"userId" : userId,
			"sessionId":sessionId
		};
		$.ajax({
			cache:false,
			type:'POST',
			data: quitJson,
			url:"https://"+host+"/signalmaster/rest/remote/userlogout",
			success:function(result){
				if(result.code==0){
					window.location.href="login.html";
					window.localStorage.clear();
				}else{
					layer.alert(result.code);
				}
			},
			error:function(result){
				alert('服务器异常！');
			}
		});
	});

	// $(".modify_pwd").click(function(){
	// 	window.localStorage.prevPage=window.location.href;
	// });
	
});


/**
 * 检查是在哪个机器上
 */
function whichRobot(){
	$("#robots input").each(function(){
		if($(this).hasClass("robotCurrent")){
			searchId=$(this).attr("robotId");
			robotIdSession=$(this).attr("robotId");
			sn=$(this).attr("sn");
			robotNameSession=$(this).attr("robotName");
			groupFlag=false;
			_thisElement=$(this);
		}
	});
}


function whichRobotCommon(){
	var ownerId,priority;
	if($(".all_robots").hasClass("all_robots_current")){
		ownerId=groupId;
		priority=3;
	}else{
		var flag=false;
		$(".robot_group_box").each(function(){
			if($(this).hasClass("robot_group_box_current")){
				ownerId=parseFloat($(this).children("ul").attr("sceneId"));
				if(ownerId==0){
					ownerId=groupId;
					priority=3;
				}else{
					priority=5;
				}
				flag=true;
			}
		});
		if(!flag){
			$("#robot_group ul li").each(function(){
				if($(this).hasClass("robotCurrent")){
					ownerId=parseFloat($(this).attr("robotId"));
					priority=7;
				}
			});
		}	
	}
	return {ownerId:ownerId,priority:priority};
}

function zero(obj){
	return obj<10 ? "0"+obj:obj; 
}


//layerLoad
function layerLoad(){
	loadIndex=layer.load(2, {shade: [0.7,'#000']});
}

function trim(str){
	return str.replace(/(^\s+)|(\s+$)/g,"");
}
