$(document).ready(function(){
	var pagination=10;
	var logListUrl="https://"+host+"/signalmaster/rest/runtime/list";
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
		var robotList=JSON.parse(window.localStorage.data);
		var sn=robotList[0].robotImei;
		var bookPos=window.localStorage.bookPos;
	}
	
	var allRobots=robotList[0].userGroupName;
	var groupId=robotList[0].userGroupId;
	var userId=robotList[0].userId;
	var groupName=robotList[0].userGroupName;

	$(".all_robots").val(allRobots);

	createRobots(robotList);

	var logData={
		groupId:groupId,
		range:10,
		unit:"minute",
		keyword:null,
		maxCount:100,
	}

    //创建包显示列表
    var packageUrl="https://"+host+"/signalmaster/rest/app_lastest_version/"+sn;
    packageList(packageUrl,function(){
    	$("#log_package_list").html('');
    	$("#log_package_list").html("<option selected='selected'>全部包</option>");
    	for(var i=0;i<data.length;i++){
    		$("#log_package_list").append("<option value=''>"+data[i].appPackageName+"</option>")
    	}
   		
   		//切换机器人
   		$("#robots input").click(function(){
   			$(".all_robots").removeClass("all_robots_current");
   			$(this).addClass("robotCurrent").siblings().removeClass("robotCurrent");
   			var changeData=logList();
   			layerLoad();
   			getLogList(logListUrl,changeData);
   			window.localStorage.bookPos=$(this).attr("sn");
   		})
   		$(".all_robots").click(function(){
   			$("#robots input").removeClass("robotCurrent");
   			$(this).addClass("all_robots_current");
   			var allData=logList();
   			layerLoad();
   			getLogList(logListUrl,allData);
   			window.localStorage.bookPos="all";
   		})

   		bookPosBackRobot(bookPos);

   		//时间点切换
   		$(".log_time input").click(function(){
   			$(this).addClass("current").siblings().removeClass("current");
   			if($(this).attr("name")=="defined"){
   				$(".log_definedtime").show();
   				//日历插件
				var now=new Date();
				var nowYear=now.getFullYear();
				var nowMonth=zero(now.getMonth()+1);
				var nowDay=zero(now.getDate());	
				var endDay=nowYear+"-"+nowMonth+"-"+nowDay;

				var date=new Date(now.getTime()-6*24*3600*1000);
				var weekYear=date.getFullYear();
				var weekMonth=zero(date.getMonth()+1);
				var weekDay=zero(date.getDate());	
				var startDay=weekYear+"-"+weekMonth+"-"+weekDay;

				$("#log_strat").val(startDay);
				$("#log_end").val(endDay);
				$("#log_strat").focus(function(){
					laydate({
				        elem: '#log_strat',
				        min:startDay+' 00:00:00',
				        max:endDay+' 00:00:00',
				        choose:function(dates){
				        	if(dates>$("#log_end").val()){
				        		$("#log_end").val(dates);
				        	}
				        	var rangeData=logList();
				        	layerLoad();
				        	getLogList(logListUrl,rangeData);

				        }
				    })
				})  
			    $("#log_end").focus(function(){
			    	laydate({
				        elem:"#log_end",
				        min:$("#log_strat").val()+' 00:00:00',
				        max:endDay+' 00:00:00',
				        choose:function(){
				        	var rangeData=logList();
				        	layerLoad();
				        	getLogList(logListUrl,rangeData);
				        }
				    })
			    })
   			}else{
   				$(".log_definedtime").hide();
   				var timeData=logList();
   				layerLoad();
   				getLogList(logListUrl,timeData);
   			}
   			
   		})

   		//全部包
   		$("#log_package_list").change(function(){
   			var packageData=logList();
   			layerLoad();
   			getLogList(logListUrl,packageData);
   		})

   		//最大条数
   		$("#max_count").change(function(){
   			var maxData=logList();
   			layerLoad();
   			getLogList(logListUrl,maxData);
   		})

   		$("#max_count").keyup(function(event){
   			if(parseFloat($(this).val())>500){
   				$(this).val(100);
   				layer.alert('最多显示500条!',{icon:2},function(){
   					var maxData=logList();
   					layerLoad();
   					getLogList(logListUrl,maxData);
   				});
   					
   			}
   			if(event.which == 13){
   				var maxData=logList();
   				layerLoad();
   				getLogList(logListUrl,maxData);
   				$(this).blur();
   			}
   		})

   		//搜索
   		$("#search_ipt").keyup(function(event){
   			if(event.which==13){
   				layerLoad();
   				var searchData=logList();
   				getLogList(logListUrl,searchData);
   			}
   		})

   		$("#search_text").click(function(){
   			layerLoad();
   			var searchData=logList();
   			getLogList(logListUrl,searchData);
   		})

    });
})

//layerLoad
function layerLoad(){
	loadIndex=layer.load(2, {shade: [0.7,'#000']})
}

//创建包显示列表
function packageList(url,callback){
	$.ajax({
		cache:false,
		type:"GET",
		url:url,
		success:function(result){
			data=result.data;
			if(result.code==0){
				if(callback){
					callback();
				}
			}else{
				layer.alert(result.message)
			}	
		},
		error:function(){
			layer.closeAll();
			layer.alert('服务器异常！');
		}
	})
}

function getLogList(url,data,callback){
	$.ajax({
		cache:false,
		type:"POST",
		url:url,
		data:data,
		success:function(result){	
			getLogData=result.data;
			layer.closeAll();
			if(result.code==0){
				createPage($("#table"),getLogData,pagination,creatLogs);
				if(callback){
					callback();
				}
			}else{
				layer.alert(result.message);
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
						<td>软件包名</td>\
						<td width="120">类型</td>\
						<td>消息</td>\
						<td>详细</td>\
						<td width="100">时间</td>\
					</tr>');
		dataTrTitle.appendTo(parent);

		//判断是不是最后一页
		if(num==pageCount){
			for(var i=((num-1)*pagination);i<(data.length);i++){
				var dataTr=$('<tr>\
					<td>'+data[i].robotId+'</td>\
					<td>'+data[i].app+'</td>\
					<td>'+data[i].type+'</td>\
					<td>'+data[i].msg+'</td>\
					<td>'+data[i].details+'</td>\
					<td>'+data[i].dateTime+'</td>\
				</tr>');
				dataTr.appendTo(parent);

			}
		}else{
			for(var i=((num-1)*pagination);i<(num*pagination);i++){
				var dataTr=$('<tr>\
					<td>'+data[i].robotId+'</td>\
					<td>'+data[i].app+'</td>\
					<td>'+data[i].type+'</td>\
					<td>'+data[i].msg+'</td>\
					<td>'+data[i].details+'</td>\
					<td>'+data[i].dateTime+'</td>\
				</tr>');
				dataTr.appendTo(parent);
			}
		}
	}
	
}

//各种情况下显示
function logList(){
	whichRobot();
	getPackage();
	checkTime();
	var packageName=getPackage();
	var keyword=getKeyword();
	var maxCount=getMaxCount();
	if(endFlag){
		if(groupFlag){
			if(packageName=="all"){
				dataList={
					groupId:searchId,
					end:end,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount
				}
			}else{
				dataList={
					groupId:searchId,
					end:end,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount,
					packageName:packageName
				}
			}
			
		}else{
			if(packageName=="all"){
				dataList={
					sn:sn,
					end:end,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount
				}
			}else{
				dataList={
					sn:sn,
					end:end,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount,
					packageName:packageName
				}
			}
			
		}
	}else{
		if(groupFlag){
			if(packageName=="all"){
				dataList={
					groupId:searchId,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount
				}
			}else{
				dataList={
					groupId:searchId,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount,
					packageName:packageName
				}
			}
			
		}else{
			if(packageName=="all"){
				dataList={
					sn:sn,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount
				}
			}else{
				dataList={
					sn:sn,
					range:range,
					unit:unit,
					keyword:keyword,
					maxCount:maxCount,
					packageName:packageName
				}
			}
			
		}
	}
	
	return dataList;
}
//检查时间段
function checkTime(){
	$(".log_time input").each(function(){
		if($(this).hasClass("current") && $(this).attr("name")!='defined'){
			range=eval($(this).attr("range"));
			unit=$(this).attr("name")
			endFlag=false;
		}else if($(this).hasClass("current") && $(this).attr("name")=='defined'){
			unit='day';
			range=countDefinedRange().rangeDefined;
			end=countDefinedRange().end;
			endFlag=true;
		}
	})
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

//获取包名
function getPackage(){
	var packageName=$("#log_package_list").children('option:selected').text(); 
	if(packageName=="全部包"){
		packageName="all";
	}
	return packageName;
}


//获取显示条数
function getMaxCount(){
	if($("#max_count").val()==''){
		var maxCount=100;
	}else{
		var maxCount=parseFloat($("#max_count").val());
	}
	return maxCount;
}



