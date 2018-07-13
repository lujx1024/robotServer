$(document).ready(function(){
	var socket = null; 
	var tipIndex = 0;
	var pagination=10;
	var today=new Date();
	var year=today.getFullYear();
	var month=zero(today.getMonth()+1);
	var day=zero(today.getDate());
	var toDate=year+"-"+month+"-"+day;

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
		var bookPos=window.localStorage.bookPos;
	}
	
	var allRobots=robotListSession[0].userGroupName;
	var groupId=robotListSession[0].userGroupId;
	var userId=robotListSession[0].userId;
	var groupName=robotListSession[0].userGroupName;

	$(".all_robots").val(allRobots);
	 //加载完成显示全部
	//$(".all_robots").addClass("all_robots_current");	

	createRobots(robotListSession);

	$(".all_robots").click(function(){
		$(".all_robots").addClass("all_robots_current");
		$("#robots input").removeClass('robotCurrent');
		layerLoad();
		createExceptionList();
		window.localStorage.bookPos="all";
	})

	$(".session_recoed_notime").click(function(){
		$(".log_definedtime").slideUp();
		layerLoad();
		createExceptionList();
	})
	$("#robots input").click(function(){
		$(".all_robots").removeClass("all_robots_current");
		$(this).addClass("robotCurrent").siblings().removeClass("robotCurrent");
		layerLoad();
		createExceptionList();
		window.localStorage.bookPos=$(this).attr("sn");
	})

	bookPosBackRobot(bookPos);

	//搜索
	$("#search_ipt").keyup(function(event){
		if(event.which==13){
			layerLoad();
			createExceptionList();
		}
	})
	$("#search_text").click(function(){
		layerLoad();
		createExceptionList();
	})

	//历史记录
	$(".session_recoed_time").click(function(){
		$(".log_definedtime").slideDown();
		var now=new Date();
		var now2=new Date(now.getTime()-1*24*3600*1000);
		var nowYear=now2.getFullYear();
		var nowMonth=zero(now2.getMonth()+1);
		var nowDay=zero(now2.getDate());	
		var endDay=nowYear+"-"+nowMonth+"-"+nowDay;

		var date=new Date(now.getTime()-6*24*3600*1000);
		var weekYear=date.getFullYear();
		var weekMonth=zero(date.getMonth()+1);
		var weekDay=zero(date.getDate());	
		var startDay=weekYear+"-"+weekMonth+"-"+weekDay;

		$("#log_strat").val(startDay);
		$("#log_end").val(endDay);
		layerLoad();
		createExceptionList();
		$("#log_strat").focus(function(){
			var prevDate=$("#log_strat").val();
			laydate({
		        elem: '#log_strat',
		        min:startDay+' 00:00:00',
		        max:endDay+' 00:00:00',
		        choose:function(dates){
		        	if(dates>$("#log_end").val()){
		        		$("#log_end").val(dates);
		        	}
		        	if(dates!=prevDate){
		        		layerLoad();
		        		createExceptionList();
		        	}	        		
		        }
		    })
		})  
	    $("#log_end").focus(function(){
	    	var prevDateEnd=$("#log_end").val();
	    	laydate({
		        elem:"#log_end",
		        min:$("#log_strat").val()+' 00:00:00',
		        max:endDay+' 00:00:00',
		        choose:function(dates){
		        	if(dates!=prevDateEnd){
		        		layerLoad();
		        		createExceptionList()
		        	}
		        }
		    })
	    })
	})

	//各种情况下显示
	function createExceptionList(){
		whichRobot();
		var keyword=getKeyword();
		var systemData={};
		var historyFlag=checkTodayOrHistory();
		if(!historyFlag){
			if(groupFlag){
				systemData={
					groupId:groupId,
					sn:'',
					end:toDate,
					range:0,
					keyword:keyword
				}
			}else{
				systemData={
					groupId:"",
					sn:sn,
					end:toDate,
					range:0,
					keyword:keyword
				}
			}
		}else{
			var end=countDefinedRange().end;
			var range=countDefinedRange().rangeDefined;
			if(groupFlag){
				systemData={
					groupId:groupId,
					sn:'',
					end:end,
					range:range,
					keyword:keyword
				}
			}else{
				systemData={
					groupId:"",
					sn:sn,
					end:end,
					range:range,
					keyword:keyword
				}
			} 
		}
		getSessionList(systemData);
	}

	//计算自定义的时间
	function countDefinedRange(){
		var startDay=$("#log_strat").val();
		var endDay=$("#log_end").val();
		var sYear=startDay.substring(0,4);
		var sMonth=parseFloat(startDay.substring(5,7))-1;;
		var sDay=startDay.substring(8);
		var dateStart=new Date();
		dateStart.setFullYear(sYear,sMonth,sDay);
		dateStart=dateStart.getTime();
		var eYear=endDay.substring(0,4);
		var eMonth=parseFloat(endDay.substring(5,7))-1;;
		var eDay=endDay.substring(8);
		var dateEnd=new Date();
		dateEnd.setFullYear(eYear,eMonth,eDay);
		dateEnd=dateEnd.getTime();
		var rangeDis=dateEnd-dateStart;
		var rangeDefined=parseInt(rangeDis/(3600*1000*24));
		var end=$("#log_end").val();
		return {"rangeDefined":rangeDefined,"end":end};
	}
})


function trim(str){
	return str.replace(/(^\s+)|(\s+$)/g,"");
}

//layerLoad
function layerLoad(){
	loadIndex=layer.load(2, {shade: [0.7,'#000']})
}

function getSessionList(systemData,callback){
	$.ajax({
		cache:false,
		type:"POST",
		url:"https://"+host+"/signalmaster/rest/robot_exception/list",
		data:systemData,
		success:function(result){	
			getLogData=result.data;
			if(result.message!="OK"){
				layer.alert("获取数据失败！");
			}else{
				if(getLogData!=undefined){
					createPage($("#table"),getLogData,pagination,creatLogs);
				}else{
					$("#table").html("暂无数据！");
					$(".pageNum").html('');
					$(".counts_page").text(0);
				$(".counts_num").text(0);
				}
			}
			layer.closeAll();
			if(callback){
				callback();
			}
		},
		error:function(){
			layer.closeAll();
			layer.alert('服务器异常！');
		}
	})
}

//创建列表
function creatLogs(parent,data,num,pagination){
	if(data.length==0){
		parent.html('暂无数据!');
	}else{
		parent.html('');
		var pageCount=Math.ceil(data.length/pagination);
		var dataTrTitle=$('<tr class="table_title">\
						<td width="16%">机器人ID</td>\
						<td width="9%">消息</td>\
						<td>描述</td>\
						<td>详细</td>\
						<td width="100">时间</td>\
					</tr>');
		dataTrTitle.appendTo(parent);

		//判断是不是最后一页
		if(num==pageCount){
			for(var i=((num-1)*pagination);i<(data.length);i++){
				var dataTr=$('<tr>\
					<td>'+data[i].robotImei+'</td>\
					<td>'+data[i].message+'</td>\
					<td>'+data[i].description+'</td>\
					<td>'+data[i].note+'</td>\
					<td>'+data[i].dateTime+'</td>\
				</tr>');
				dataTr.appendTo(parent);

			}
		}else{
			for(var i=((num-1)*pagination);i<(num*pagination);i++){
				var dataTr=$('<tr>\
					<td>'+data[i].robotImei+'</td>\
					<td>'+data[i].message+'</td>\
					<td>'+data[i].description+'</td>\
					<td>'+data[i].note+'</td>\
					<td>'+data[i].dateTime+'</td>\
				</tr>');
				dataTr.appendTo(parent);
			}
		}
	}
	
}

//判断是今天还是历史记录
function checkTodayOrHistory(){
	return $(".session_recoed_time")[0].checked;
}




