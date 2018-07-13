var pagination=8;
var tipIndex='';
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
}else{
	var robotList=JSON.parse(window.localStorage.data);
	var groupId=JSON.parse(window.localStorage.data)[0].userGroupId;
}
var uploadFileUrl ="https://"+host+"/signalmaster/upload";
var layerIndex;
/**
 * 创建整个table分页
 * @param parentTable
 * @param data
 * @param pagination
 * @param fn
 */
function createPage(parentTable,data,pagination,fn){
	$(".pageBox").html('');
	var pageContent='<a href="javascript:;" class="pre_page"></a>\
					<div class="pageNum fl"></div>\
					<a href="javascript:;" class="next_page"></a>\
					<div class="fr page_skip">\
						到<input type="text">页0\
						<a href="javascript:;">GO</a>\
					</div>';
	$(".pageBox").append(pageContent);
	var pageCount=Math.ceil(data.length/pagination);
	$(".pageNum").html('');

	$(".counts_page").text(pageCount);
	$(".counts_num").text(data.length);
	//插入页数
	if(pageCount<=7){
		for(var i=1;i<=pageCount;i++){
			var pageNum=$("<a href='javascript:;'>"+i+"</a>");
			pageNum.appendTo($(".pageNum"));
		}
	}else{
		for(var i=1;i<=5;i++){
			var pageNum=$("<a href='javascript:;'>"+i+"</a>");
			pageNum.appendTo($(".pageNum"));
		}
		($("<a href='javascript:;' class='page_omit'>...</a>")).appendTo($(".pageNum"));
		($("<a href='javascript:;'>"+pageCount+"</a>")).appendTo($(".pageNum"));
	}

	//创建第一页
	fn(parentTable,data,1,pagination);
	$(".pageNum a").eq(0).addClass('page_current');

	//点击相对页
	$(".pageNum a").click(function(){
		if(!($(this).hasClass("page_omit"))){
			var num=parseFloat($(this).text());
			if($(this).next().hasClass("page_omit")){
				if(num<(pageCount-2)){
					for(var i=0;i<($(".pageNum a").length)-2;i++){
						var textNext=parseFloat($(".pageNum a").eq(i).text());
						$(".pageNum a").eq(i).text(textNext+1);
					}
					$(this).prev().addClass('page_current').siblings().removeClass('page_current');
				}else{
					$(this).next().text(pageCount-1);
					$(this).next().removeClass("page_omit");
					$(this).addClass('page_current').siblings().removeClass('page_current');
				}	
			}else{
				$(this).addClass('page_current').siblings().removeClass('page_current');
			}

			if($(this).prev().hasClass("page_omit") && num==pageCount){
				var lastPageDis=pageCount-6;
				for(var i=0;i<=7;i++){
					$(".pageNum a").eq(i).text(i+lastPageDis);
				}
				$(".pageNum a:last").prev().removeClass('page_omit');
				$(".pageNum a:last").addClass('page_current').siblings().removeClass('page_current');
			}

			if(num==($(".pageNum a:first").text()) && num!=1){
				var prevAddOmit=$(".pageNum a").length-2;
				for(var i=0;i<($(".pageNum a").length)-2;i++){
					var textPrev=parseFloat($(".pageNum a").eq(i).text());
					$(".pageNum a").eq(i).text(textPrev-1);
				}
				
				$(".pageNum a").eq(prevAddOmit).addClass('page_omit');
				$(".pageNum a").eq(prevAddOmit).text("...");
				$(this).next().addClass('page_current').siblings().removeClass('page_current');
			}
			fn(parentTable,data,num,pagination);
		}	
	});

	/*下一页*/
	$(".next_page").click(function(){
		var nextIndex=0;
		var nextTargetIndex=0;
		$(".pageNum a").each(function(){
			if($(this).hasClass("page_current")){
				nextIndex=parseFloat($(this).text());
				nextTargetIndex=$(this).index();
			}
		});
		var nextTarget=$(".pageNum a").eq(nextTargetIndex);
		if((nextTarget.next().next().hasClass("page_omit"))){
			if(nextIndex<(pageCount-3)){
				for(var i=0;i<($(".pageNum a").length)-2;i++){
					var textNext=parseFloat($(".pageNum a").eq(i).text());
					$(".pageNum a").eq(i).text(textNext+1);
				}
				nextTarget.addClass('page_current').siblings().removeClass('page_current');
			}else{
				nextTarget.next().next().text(pageCount-1);
				nextTarget.next().next().removeClass("page_omit");
				nextTarget.next().addClass('page_current').siblings().removeClass('page_current');
			}
			fn(parentTable,data,nextIndex+1,pagination);	
		}else if(nextIndex<pageCount){
			nextTarget.next().addClass('page_current').siblings().removeClass('page_current');
			fn(parentTable,data,nextIndex+1,pagination);
		}
	})	

	/*上一页*/
	$(".pre_page").click(function(){
		var preIndex=0;
		var preTargetIndex=0;
		$(".pageNum a").each(function(){
			if($(this).hasClass("page_current")){
				preIndex=parseFloat($(this).text());
				preTargetIndex=$(this).index();
			}
		})
		if(preIndex==(parseFloat($(".pageNum a:first").text())+1) && preIndex>2){
			var prevAddOmit=$(".pageNum a").length-2;
			for(var i=0;i<prevAddOmit;i++){
				var textPrev=parseFloat($(".pageNum a").eq(i).text());
				$(".pageNum a").eq(i).text(textPrev-1);
			}
			$(".pageNum a").eq(prevAddOmit).addClass('page_omit');
			$(".pageNum a").eq(prevAddOmit).text("...");
			$(".pageNum a").eq(preTargetIndex).addClass('page_current').siblings().removeClass('page_current');
			fn(parentTable,data,preIndex-1,pagination);
		}else if(preIndex>1){
			$(".pageNum a").eq(preTargetIndex).prev().addClass('page_current').siblings().removeClass('page_current');
			fn(parentTable,data,preIndex-1,pagination);
		}
	})

	/*跳转*/
	$(".page_skip a").click(function(){
		var skipIndex=parseFloat($(".page_skip input").val());
		var skipTarget=false;
		var skipPlace=0;
		var firstChild=($(".pageNum a:first")).text();
		skip();
		function skip(){
			if(skipIndex<=pageCount){
				$(".pageNum a").each(function(){
					if($(this).text()==skipIndex){
						skipTarget=true;
						skipPlace=$(this).index();
					}
				})
				if(skipTarget){
					$(".pageNum a").eq(skipPlace).trigger('click');
				}else if((pageCount-skipIndex)<7){
					$(".pageNum a:last").trigger('click');
					skip();
				}else{
					for(var i=0;i<5;i++){
						$(".pageNum a").eq(i).text(skipIndex);
						skipIndex++;
					}
					$(".pageNum a").eq(5).text("...");
					$(".pageNum a").eq(5).addClass("page_omit");
					$(".pageNum a").eq(skipPlace).trigger('click');
				}
			}
		}
	});

	$(".page_skip").keyup(function(event){
		if(event.which==13){
			$(".page_skip a").trigger('click');
		}
	});

}


/*获取当前页*/
function getCurrentPage(){
	$(".pageNum a").each(function(){
		if($(this).hasClass('page_current')){
			editCurrentpage=parseFloat($(this).text());
		}
	});
}


//提交表单
function subForm(subUrl,subData,callback){
	$.ajax({
		cache:false,
		type:"POST",
		url:subUrl,
		data:subData,
		success:function(result){
			subResult=result;
			layer.close(layerIndex);
			if(callback){
				callback();
			}
		},
		error:function(){
			alert('服务器异常！');
		}
	});
}

//提交新建组
function subNewScene(subUrl,subData,callback){
	$.ajax({
		cache:false,
		type:"POST",
		url:subUrl,
		data:subData,
		success:function(result){
			subNewSceneResult=result;	
			if(callback){
				callback();
			}
		},
		error:function(){
			alert('服务器异常！');
		}
	});
}

//上传文件
function uploadByForm(form,url,callback) {
	var formData = new FormData(form);
	$.ajax({
		url : url,
		type : 'POST',
		data : formData,
		dataType:"json",
		processData : false,
		contentType : false,
		success : function(responseStr) {
			responseStrResult=responseStr;
        	uploadUrl=responseStr.url;
        	if(callback){
            	callback();
            }
            
		},
		error : function(responseStr) {
			alert('服务器异常，上传失败！');
		}
	});
}

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


//应用管理
//编辑时插入输入框
function insertInput(protoData,callback){
	var protoData=protoData || {};
	for(var key in protoData){
		var oldDate=protoData[key].text();
		protoData[key].text("");
		if(key!="keyenable"){
			protoData[key].append($('<textarea class="appedit_'+key+'">'+oldDate+'</textarea>'));
		}else{
			protoData[key].append($('<input type="checkbox" class="appedit_enable"/>'));
			$(".appedit_enable").get(0).checked=eval(oldDate);
		}
	}
	if(callback){
		callback();
	}
}


//获取应用信息
function findAppKeyName(list){
	list.each(function(){
		switch($(this).attr('keyName')){
			case 'appName':
				keyname=$(this);
				break;
			case 'description':
				keydes=$(this);
				break;
			case 'packageName':
				keypackage=$(this);
			case 'ownerName':
				keyowner=$(this);
				break;
			case 'versionName':
				keyversion=$(this);
				break;
			case 'releaseNote':
				keyrelease=$(this);
				break;
			case 'datetime':
				keydate=$(this);
				break;
			case 'enable':
				keyenable=$(this);
				break;
		}
	});
}

$(document).ready(function(){
	//插入头部header
	var header='<div class="wapper_welcome">\
		<span class="fl"><i class="fa fa-home fa-2x"></i>欢迎进入奥拓智能机器人后台管理系统</span>\
		<div class="fr wapper_user">\
			<span><span>您好， </span><span class="user_name"></span>&nbsp&nbsp<i class="fa fa-user-circle fa-2x"></i></span>\
			<a href="javascript:;" class="user_quit">退出</a><a href="modify_pwd.html" class="modify_pwd">修改密码</a>\
		</div>\
	</div>';
	$("body").prepend(header);

	//菜单栏切换
	$(".menu_bar i").click(function(){
		$(".menu").toggleClass("displayNone");
	});

	//获取用户名
	var userName=window.localStorage.user;
	$(".user_name").text(userName);

	//退出
	$(".user_quit").click(function(){
		$.ajax({
			cache:false,
			type:'GET',
			url:"https://"+host+"/signalmaster/rest/admin/logout",
			success:function(result){
				console.log(result);
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

	$(".modify_pwd").click(function(){
		window.localStorage.prevPage=window.location.href;
	});

//
//	$("#table tbody tr").mouseenter(function(){
//		console.log("mouseenter"+$(this).css("background-color"));
//		$(this).removeClass("table_tr_mouseout")
//		$(this).addClass("table_tr_mouseenter");
//	}).mouseout(function(){
//		console.log("mouseout"+$(this).css("background-color"));
//		$(this).removeClass("table_tr_mouseenter")
//		$(this).addClass("table_tr_mouseout");
//		
//	});
	
	/**
	 * 设置机器人列表数据展示table隔行斑马线
	 * 表头背景色固定，且不受时间影响
	 * 奇数行（从数据行开始，不包含表头）背景色为白色，透明度为0.8
	 * 偶数行（从数据行开始，不包含表头）背景色为浅灰色，透明度为0.8
	 * 数据行（不包含表头）响应鼠标事件：鼠标悬停(mouseenter)、鼠标移出(mouseout),悬停时透明度设置为1，移出时设置透明度为0.8
	 */
	$("#table tbody tr:nth-last-child(even)").css({"background":"white","opacity":"0.8"});
	$("#table tbody tr[class!='table_title']:nth-last-child(odd)").css({"background":"#E0DEDE","opacity":"0.8"});
	$("#table tbody tr:nth-last-child(even)").mouseenter(function(){
		$(this).css("opacity","1");
	}).mouseout(function(){
		$(this).css("opacity","0.8");
	});
	$("#table tbody tr[class!='table_title']:nth-last-child(odd)").mouseenter(function(){
		$(this).css("opacity","1");
	}).mouseout(function(){
		$(this).css("opacity","0.8");
	});
});

/**
 * 检查是否为空值
 * @param json
 */
function checkNull(json){
	nullFlag=false;
	for(var key in json){
		if(json[key]=='' && key!="enable"){
			nullFlag=true;
		}
	}
}

/**
 * 检查是在哪个机器上
 */
function whichRobot(){
	if($(".all_robots").hasClass("all_robots_current")){
		searchId=groupId;
		groupFlag=true;
	}else{
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

/**
 * 创建机器人列表_用户
 * @param robotList
 * @param callback
 */
function createRobotsUser(robotList,callback){
	multiSubmit("https://"+host+"/signalmaster/rest/set_config/scenes/"+groupId,function(){
		if(message=="OK"){
			for(var i=0;i<data.length;i++){
				var group='<div class="robot_group_box">\
							<div class="delete_scene displayNone" sceneId='+data[i].id.id+'></div>\
							<div class="robot_group_title" sceneId='+data[i].id.id+'>'+data[i].id.name+'</div>\
							<input type="text" value="'+data[i].id.name+'" class="scene_title_edit displayNone"sceneId='+data[i].id.id+' />\
							<ul id="scene'+data[i].id.id+'" class="clearfix" sceneId='+data[i].id.id+'></ul>\
						</div>';
				$("#not_grouped").before(group);
			}
		}else{
			layer.alert(message);
		}
		for(i =0 ; i < robotList.length; i++){
			var robot=robotList[i];
			$(".robot_group_box ul").each(function(){
				if($(this).attr("sceneId")==robot.userGroupSceneId){
					$(this).append('<li robotName='+robot.robotName+' sn='+robot.robotImei+' userId='+robot.userId+' robotId='+robot.robotId+' groupId='+robot.userGroupId+' groupName='+robot.userGroupName+' sceneId='+robot.userGroupSceneId+'>'+robot.robotName+'</li>');
				}
			});
		}
		var robotTip='';
		$("#robot_group ul li").hover(function(){
			var _this=$(this);
			var tipsContent="sn："+_this.attr("sn")+"<br />id："+_this.attr("robotId");
			timer=setTimeout(function(){
				robotTip=layer.tips(tipsContent,_this,{
				   	tips: [1, '#3595CC'],
				  	time: 6000
				});
			},1000);
		},function(){
			clearInterval(timer);
			$("body").get(0).onmouseover=function(event){
				event = event ? event : window.event;   
				var obj = event.srcElement ? event.srcElement : event.target;
				if($(obj).attr("sn")==undefined && obj.className!="layui-layer-content" && $(obj).attr("sceneId")==undefined){
					layer.close(robotTip);
					$("body").get(0).onmouseover=null;
				}
			}	;		
		});
		$(".all_robots").hover(function(){
			var _this=$(this);
			var tipsContent="id："+$("#robot_group ul li").eq(0).attr("groupId");
			timer=setTimeout(function(){
				robotTip=layer.tips(tipsContent,_this,{
				   	tips: [1, '#3595CC'],
				  	time: 6000
				});
			},1000);
		},function(){
			clearInterval(timer);
		});
		if(callback){
			callback();
		}
	});
	
}

function createRobots(robotList){
	var all='';
	for (var i =0 ; i < robotList.length; i++){
		var robot = robotList[i];
		var robotItem="<input robotName="+robot.robotName+" sn="+robot.robotImei+" userId="+robot.userId+" robotId="+robot.robotId+" groupId="+robot.userGroupId+" groupName="+robot.userGroupName+" type=button value="+robot.robotName+">";
		all=all+robotItem;
		userName = robot.userName + "";
	}
	$("#robots").append(all);
	$("#robots input").hover(function(){
		var _this=$(this);
		var tipsContent="sn："+_this.attr("sn")+"<br />id："+_this.attr("robotId");
		timer=setTimeout(function(){
			tipIndex=layer.tips(tipsContent,_this,{
			   	tips: [1, '#3595CC'],
			  	time: 4000
			});
		},1000);
	},function(){
		clearInterval(timer);
	});
	$(".all_robots").hover(function(){
		var _this=$(this);
		var tipsContent="id："+$("#robots input").eq(0).attr("groupId");
		timer=setTimeout(function(){
			tipIndex=layer.tips(tipsContent,_this,{
			   	tips: [1, '#3595CC'],
			  	time: 4000
			});
		},1000);
	},function(){
		clearInterval(timer);
	});
}


//获取关键字
function getKeyword(){
	if($("#search_ipt").val()==''){
		var keyword=null;
	}else{
		var keyword=$("#search_ipt").val();
	}
	return keyword;
}

//layerLoad
function layerLoad(){
	loadIndex=layer.load(2, {shade: [0.7,'#000']});
}

function trim(str){
	return str.replace(/(^\s+)|(\s+$)/g,"");
}

//配置升级
function arrayFormat(array,type){
	var arrayValue='';
	var arrayValueVideo='';
	if(type=="list" || type=="module_list"){
		for(var i=0;i<array.length;i++){
			arrayValue+='<span><input type="text" value='+array[i]+' disabled="disabled" /><img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /><i class="icon-pencil editable_btn"></i><i class="icon-save editable_savebtn displayNone"></i></span>';
		}
	}else if(type=="menu_list"){
		for(var i=0;i<array.length;i++){
			arrayValue+='<span><input type="text" value='+array[i]+' disabled="disabled" /><img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /><i class="icon-pencil editable_btn"></i><i class="icon-save editable_savebtn displayNone"></i></span>';
		}

	}else if(type=="image_list"){
		var httpsReg=/^(http|https):\/\//;
		for(var i=0;i<array.length;i++){
			//sunff 防止图片为Null
			if(array[i]==null){
				continue;
			}
			if(array[i].match(httpsReg)){
				arrayValue+='<span class="image_list_box"><img src="'+array[i]+'" class="image_list" /><img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /></span>';
			}else{
				arrayValueVideo+='<div class="image_list_box_video clearfix"><em class="image_list_videosrc fl">本地视频：</em><input type="text" value='+array[i]+' class="fl image_list_input" /><img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /></div>';
			}	
		}
	}else if(type=="patrol"){
		for(var i=0;i<array.length;i++){
			if(array[i].index!=undefined){
				var index='<input type="number" disabled="disabled" pathName="index" value='+array[i].index+'>';
			}else{
				var index='<input type="number" disabled="disabled" pathName="index">';
			}
			arrayValue+='<div class="patrol_list">\
			<div class="clearfix marginBottom10"><em>定位点：</em><div class="fl patrol_position"><input type="radio" name=xyr'+i+' checked="checked" disabled="disabled" indexClass="patrol_index" notIndexClass="patrol_xyr" /><em>位置</em><input type="radio" name=xyr'+i+' disabled="disabled" indexClass="patrol_xyr" notIndexClass="patrol_index" /><em>坐标</em></div></div>\
			<div class="clearfix marginBottom10 patrol_index"><em>定位点编号：</em>'+index+'</div>\
			<div class="clearfix marginBottom10 patrol_xyr displayNone"><em>x：</em><input type="number" disabled="disabled" pathName="x" value='+array[i].x+' /><em>y：</em><input type="number" disabled="disabled" pathName="y" value='+array[i].y+' /><em>r：</em><input type="number" disabled="disabled" pathName="r" value='+array[i].r+' /></div>\
			<div class="clearfix marginBottom10"><em>语音播报：</em><input type="text" value='+array[i].content+' pathName="content" disabled="disabled" /></div>\
			<div class="clearfix marginBottom10"><em>停留时间(ms)：</em><input type="number" value='+array[i].stay+' pathName="stay" disabled="disabled" /></div>\
			<img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /><i class="icon-pencil patrol_edit"></i></i>\
			</div><i class="icon-long-arrow-right path_next"></i>';
		}
	}else if(type=="menu_matrix"){
		for(var i=0;i<array.length;i++){
			arrayValue+='<div class="matrix_list">\
				<input type="hidden" id="hidden-input" class="demo matrix_color" value='+array[i].background+' size="7" disabled="disabled"><div class="matrix_other">\
				<img src='+array[i].icon+' class="matrix_icon"/>\
				<input class="matrix_content" value='+array[i].content+' disabled="disabled"></div>\
				<img src="images/icon_close_blue.png" class="array_close" dataType='+type+' />\
			</div>';
		}
	}
	return {arrayValue:arrayValue,arrayValueVideo:arrayValueVideo};
}

function arrayFormatPreview(array,type,candidate){
	var arrayValue='';
	var addBtnType='';
	var arrayValueVideo='';
	if(type=="list"){
		if(candidate!=''){
			for(var i=0;i<array.length;i++){
				arrayValue+='<li class="senior_type_list"><input disabled candidateValue='+array[i].value+' type="text" value='+array[i].name+' /><img src="images/icon_close_blue.png" class="array_close"/></li>';
			}
		}else{
			for(var i=0;i<array.length;i++){
				arrayValue+='<li class="senior_type_list"><input type="text" value='+array[i]+' /><img src="images/icon_close_blue.png" class="array_close"/></li>';
			}
		}
		addBtnType='<input type="button" value="添加" class="list_add_btn"/>';
	}else if(type=="module_list"){
		if(candidate!=''){
			for(var i=0;i<array.length;i++){
				arrayValue+='<li class="senior_type_list"><input disabled candidateValue='+array[i].value+' type="text" value='+array[i].name+' /><img src="images/icon_close_blue.png" class="array_close"/></li>';
			}
		}else{
			for(var i=0;i<array.length;i++){
				arrayValue+='<li class="senior_type_list"><input type="text" value='+array[i]+' /><img src="images/icon_close_blue.png" class="array_close"/></li>';
			}
		}
		addBtnType='<input type="button" value="添加" class="module_add_btn"/>';
	}else if(type=="menu_list"){
		for(var i=0;i<array.length;i++){
			arrayValue+='<li class="senior_type_list"><input type="text" value='+array[i]+' /><img src="images/icon_close_blue.png" class="array_close"/></li>';
		}
		addBtnType='<input type="button" value="添加" class="menu_add_btn"/>';
	}else if(type=="image_list"){
		var httpsReg=/^(http|https):\/\//;
		for(var i=0;i<array.length;i++){
			if(array[i].match(httpsReg)){
				arrayValue+='<li class="image_list_box"><img src="'+array[i]+'" class="image_list" width="200" /><img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /></li>';
			}else{
				arrayValueVideo+='<li class="image_list_box_video clearfix"><em class="image_list_videosrc fl">本地视频：</em><input type="text" value='+array[i]+' class="fl image_list_input" /><img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /></li>';
			}
		}
		addBtnType='<input type="button" value="添加" class="img_add_btn"/>';
	}else if(type=="patrol"){
		for(var i=0;i<array.length;i++){
			if(array[i].index!=undefined){
				var index=array[i].index;
			}else{
				var index='';
			}
			arrayValue+='<li class="senior_patrol_box"><div class="senior_patrol_list">\
			<div class="clearfix marginBottom10"><em>定位点：</em><div class="fl patrol_position"><input type="radio" name=xyr'+i+' checked="checked" indexClass="patrol_index" notIndexClass="patrol_xyr" /><em>位置</em><input type="radio" name=xyr'+i+' indexClass="patrol_xyr" notIndexClass="patrol_index" /><em>坐标</em></div></div>\
			<div class="clearfix marginBottom10 patrol_index"><em>定位点编号：</em><input type="number" pathName="index" value='+index+'></div>\
			<div class="clearfix marginBottom10 patrol_xyr displayNone"><em>x：</em><input type="number" pathName="x" value='+array[i].x+' /><em>y：</em><input type="number" pathName="y" value='+array[i].y+' /><em>r：</em><input type="number" pathName="r" value='+array[i].r+' /></div>\
			<div class="clearfix marginBottom10"><em>语音播报：</em><input type="text" value='+array[i].content+' pathName="content" /></div>\
			<div class="clearfix marginBottom10"><em>停留时间(ms)：</em><input type="number" value='+array[i].stay+' pathName="stay" /></div>\
			</div><img src="images/icon_close_blue.png" class="array_close" dataType='+type+' /></li>';
		}
		addBtnType='<input type="button" value="添加" class="patrol_add_btn"/>';
	}else if(type=="command_list"){
		arrayValue='<li class="command_list_box"><textarea>'+array+'</textarea></li>';
		addBtnType='';
	}else if(type="menu_matrix"){
		for(var i=0;i<array.length;i++){
			arrayValue+='<li class="matrix_list senior_matrix_box">\
				<input type="hidden" id="hidden-input" class="demo matrix_color" value='+array[i].background+' disabled="disabled" ><div class="matrix_other">\
				<img src='+array[i].icon+' class="matrix_icon"/>\
				<input class="matrix_content" value='+array[i].content+' disabled="disabled" ></div>\
				<img src="images/icon_close_blue.png" class="array_close" dataType="menu_matrix" /></li>';
		}
		addBtnType='<input type="button" value="添加" class="matrix_add_btn"/>';
	}
	return {arrayValue:arrayValue,addBtnType:addBtnType,arrayValueVideo:arrayValueVideo};
}

//candidate value转换
function candidateFormat(candidate,value){
	console.log(candidate);
	console.log(value);
	var valueArray=[];
	for(var i=0;i<value.length;i++){
		var valueJson={};
		var hasValue=false;
		for(var j=0;j<candidate.length;j++){
			if(value[i]==candidate[j].value){
				valueJson.value=candidate[j].value;
				valueJson.name=candidate[j].name;
				hasValue=true;
				break;
			}			
		}
		if(!hasValue){
			valueJson.value=value[i];
			valueJson.name=value[i];
		}
		valueArray.push(valueJson);
	}
	return valueArray;
}

function candidateSelect(candidate,value){
	var valueArray=[];
	for(var i=0;i<value.length;i++){
		var valueJson={};
		for(var j=0;j<candidate.length;j++){
			if(value[i]==candidate[j].value){
				candidate.splice(j,1);
				j--;
			}			
		}
	}
	return candidate;
}

//编辑提交
function editSubmitString(_this,currentValue,callback){	
	var ownerId=whichRobotCommon().ownerId;
	var priority=whichRobotCommon().priority;
	var submitData={
		user_id:userId,
		owner_id:ownerId,
		priority:priority,
		config_key:_this.attr("configKey"),
		config_value:currentValue
	};
	console.log(submitData);
	subForm("https://"+host+"/signalmaster/rest/set_config",submitData,function(){
		if(callback){
			callback();
		}
	});
}

function editKeyup(objParent,objEle){
	objParent.on("keyup",objEle,function(event){
		if(event.which==13){
			$(this).trigger("blur");
		}
	});
}

function isInteger(obj){
	return obj%1===0;
}

function limit(_this,number,limitL,limitH,oldValue,callback){
	var limitFlag=false;
	if(isNaN(limitL) && number>limitH){
		var layerMessage="请输入小于等于 "+limitH+" 的整数！";
		layer.tips(layerMessage,_this);
		_this.val(oldValue);
	}else if(number<limitL && isNaN(limitH)){
		var layerMessage="请输入大于等于 "+limitL+" 的整数！";
		layer.tips(layerMessage,_this);
		_this.val(oldValueInte);
	}else if(number<limitL || number>limitH){
		var layerMessage="请输入在 "+limitL+"-"+limitH+" 之间的整数！";
		layer.tips(layerMessage,_this);
		_this.val(oldValue);
	}else{
		editSubmitString(_this,number,callback);
	}
}

//get 巡游路径提交值
function getPath(obj){
	var path=[];
	var isNull;
	obj.each(function(){
		var _this=$(this);
		var _thisValue=_this.find("input[type!='radio']");
		var index=parseFloat(_this.find("input[pathName='index']").val());
		var x=parseFloat(_this.find("input[pathName='x']").val());
		var y=parseFloat(_this.find("input[pathName='y']").val());
		var r=parseFloat(_this.find("input[pathName='r']").val());
		var content=trim(_this.find("input[pathName='content']").val());
		var stay=parseFloat(trim(_this.find("input[pathName='stay']").val()));
		isNull=true;
		for(var i=0;i<_thisValue.length;i++){
			if(_thisValue[i].value){
				isNull=false;
				break;
			}
		}
		if(!isNull){
			if(index=='' || isNaN(index)){
				var pathJson={x:x,y:y,r:r,content:content,stay:stay};
			}else{
				var pathJson={x:x,y:y,r:r,content:content,stay:stay,index:index};
			}
			path.push(pathJson);
		}else{
			layer.tips("新增路径的内容不能全部为空，请输入！",_this);
			return false;
		}
	});
	return {path:path,isNull:isNull};
}

//六宫格界面提交值
function getMatrix(obj){
	var matrix=[];
	var martrixValue={};
	var isNull;
	obj.each(function(){
		var _this=$(this);
		var _thisBackground=_this.find(".matrix_color").val();
		var _thisIcon=_this.find(".matrix_icon").attr("src");
		var _thisContent=_this.find(".matrix_content").val();
		isNull=false;
		if(_thisContent==''){
			isNull=true;
			layer.tips("模块内容不能为空，请输入！",_this.find(".matrix_content"));
			return false;
		}else if(_thisIcon=='images/icon_add.png'){
			isNull=true;
			layer.tips("请上传icon图标",_this.find(".matrix_icon"));
			return false;
		}else{
			var matrixJson={background:_thisBackground,icon:_thisIcon,content:_thisContent};
			matrix.push(matrixJson);
		}
	});

	martrixValue.items=matrix;
	return {martrixValue:martrixValue,isNull:isNull};
}

function uploadFileNew(callback){
	$(".loadfile").click(function(){
		var _thisParent=$(this);
		_thisParent.siblings(".upload_fileOk").css("visibility",'hidden');
		$(this).children().val('');
		$(this).children().change(function(){
			var _this=$(this).val();
			_thisParent.siblings(".upload_fileOk").css({'visibility':'visible','font-size':'13px'});	
			var urlIndex=_this.lastIndexOf("\\")+1;
			var fileUrl=_this.substring(urlIndex);
			_thisParent.siblings(".upload_fileOk").text(fileUrl);
		});

	});
	//上传文件
	$("#upload_btn").click(function(){
		var _this=$(this);
		var _thisParent=_this.parent();
		if(_thisParent.siblings(".upload_fileOk").css("visibility")=="visible"){
			_thisParent.siblings(".upload_fileOk").html("<i class='icon-spinner' style='color:#bbb'></i>上传中...");
			uploadByForm($("#fileForm")[0],uploadFileUrl,function(){
				$(".upload_fileOk").html("<i class='icon-check'></i>上传成功！");
				if(callback){
					callback();
				}
				//_thisParent.parent().parent().siblings(".matrix_upload_icon").val(uploadUrl);
			});
		}else{
			layer.alert("请选择要上传的文件！");
		}
	});
}

function uploadIcon(_this){
	var fileHtml='<form role="form" id="fileForm" method="post" enctype="multipart/form-data">\
    	<div class="infoLayerList">\
	    	<em>上传图标：</em>\
	    	<a href="#" class="loadfile">选择文件<input type="file" name="file" style="min-width:120px;"></a>\
	    	<div class="upload_fileOk"><i class="icon-check"></i>上传成功！</div>\
	    	<div style="margin:15px 0 0 74px;"><input type="button" id="upload_btn" value="开始上传"/>\
	    	</div>\
    	</div>\
    </form>';
	layer.open({
		title:"上传图片",
		area:["400px","300px"],
		content:fileHtml
	});
	uploadFileNew(function(){
		_this.attr("src",uploadUrl);
	});
}

/**
 * 机器人列表加载记住位置
 */
function bookPosBackRobot(bookPos){
	if(bookPos=="all"){
		$(".all_robots").trigger("click");
	}else{
		$("#robots input").each(function(){
			var _this=$(this);
			var _thisSn=_this.attr("sn");
			if(bookPos==_thisSn){
				_this.trigger("click");
			}
		});
	}
}

//包括场景的加载记录位置
function bookPosBackAll(bookPos){
	if(bookPos=="all"){
		$(".all_robots").trigger("click");
	}else{
		var sceneIdFlag=false;
		$(".robot_group_title").each(function(){
			var _this=$(this);
			var _thisId=_this.attr("sceneId");
			if(bookPos==_thisId){
				sceneIdFlag=true;
				_this.trigger("click");
			}
		});
		if(!sceneIdFlag){
			$(".robot_group_box ul li").each(function(){
				var _this=$(this);
				var _thisSn=_this.attr("sn");
				if(bookPos==_thisSn){
					_this.trigger("click");
				}
			});
		}
	}
}