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
		var bookPos=window.localStorage.bookPos;
	}
	
	var allRobots=robotListSession[0].userGroupName;
	var groupId=robotListSession[0].userGroupId;
	var userId=robotListSession[0].userId;
	var groupName=robotListSession[0].userGroupName;

	$(".all_robots").val(allRobots);

	createRobots(robotListSession);	

	$(".all_robots").click(function(){
		$(".all_robots").addClass("all_robots_current");
		$("#robots input").removeClass('robotCurrent');
		layerLoad();
		createSessionList();
		window.localStorage.bookPos="all";
	})
	$(".session_recoed_notime").click(function(){
		$(".log_definedtime").slideUp();
		layerLoad();
		createSessionList();
	})
	$("#robots input").click(function(){
		$(".all_robots").removeClass("all_robots_current");
		$(this).addClass("robotCurrent").siblings().removeClass("robotCurrent");
		layerLoad();
		createSessionList();
		window.localStorage.bookPos=$(this).attr("sn");
	})

	bookPosBackRobot(bookPos);

	//选择类别
	$("#session_catelist").change(function(){
		layerLoad();
		createSessionList();

	})

	//搜索
	$("#search_ipt").keyup(function(event){
		if(event.which==13){
			layerLoad();
			createSessionList();
		}
	})
	$("#search_text").click(function(){
		layerLoad();
		createSessionList();
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
		createSessionList();
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
		        		var session_record_start=dates+" 00:00:00";
			        	var session_record_end=$("#log_end").val()+" 23:59:59";
			        	chooseTime(session_record_start,session_record_end);
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
		        		var session_record_start=$("#log_strat").val()+" 00:00:00";
			        	var session_record_end=dates+" 23:59:59";
			        	chooseTime(session_record_start,session_record_end);
		        	}
		        }
		    })
	    })
	})

	function chooseTime(start,end){
		whichRobot();
    	if(groupFlag){
    		var session_historyUrl="https://"+host+"/signalmaster/rest/chat_monitor/history/"+groupId+"/0/"+start+"/"+end+"/"+$("#session_catelist option:selected").val()+"/"+getKeyword();
    	}else{
    		var session_historyUrl="https://"+host+"/signalmaster/rest/chat_monitor/history/0/"+sn+"/"+start+"/"+end+"/"+$("#session_catelist option:selected").val()+"/"+getKeyword();
    	}
    	layerLoad();
    	getSessionList(session_historyUrl);
	}
	
})


//layerLoad
function layerLoad(){
	loadIndex=layer.load(2, {shade: [0.7,'#000']})
}

function getSessionList(url,callback){
	$.ajax({
		cache:false,
		type:"GET",
		url:url,
		success:function(result){	
			getLogData=result.data;
			if(result.message!="OK"){
				layer.alert("获取数据失败！")
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
	console.log(data)
	if(data.length==0){
		parent.html('暂无数据!');
	}else{
		parent.html('');
		var pageCount=Math.ceil(data.length/pagination);
		var dataTrTitle=$('<tr class="table_title">\
						<td width="17%">机器人ID</td>\
						<td width="10%">响应类别</td>\
						<td width="15%">提问</td>\
						<td>回复</td>\
						<td width="13%">执行时间（ms）</td>\
						<td width="100">时间</td>\
					</tr>');
		dataTrTitle.appendTo(parent);

		//判断是不是最后一页
		if(num==pageCount){
			for(var i=((num-1)*pagination);i<(data.length);i++){
				var dataTr=$('<tr kind='+data[i].response1+'>\
					<td>'+data[i].requestEpSn+'</td>\
					<td>'+data[i].kind+'</td>\
					<td>'+data[i].request+'</td>\
					<td>'+data[i].text+'</td>\
					<td>'+data[i].execMillsecs+'</td>\
					<td>'+data[i].dateTime+'</td>\
				</tr>');
				dataTr.appendTo(parent);
			}
		}else{
			for(var i=((num-1)*pagination);i<(num*pagination);i++){
				var dataTr=$('<tr kind='+data[i].response1+'>\
					<td>'+data[i].requestEpSn+'</td>\
					<td>'+data[i].kind+'</td>\
					<td>'+data[i].request+'</td>\
					<td>'+data[i].text+'</td>\
					<td>'+data[i].execMillsecs+'</td>\
					<td>'+data[i].dateTime+'</td>\
				</tr>');
				dataTr.appendTo(parent);
			}
		}
	}

	//无法回答、外部语义创建语料
	var layerBtn='';
	$("#table tr").hover(function(){
		var _this=$(this);
		var _thisTd=_this.children("td");
		var target=_thisTd.eq(2);
		var _thisKind=_this.attr("kind");
		if(_thisKind==2 || _thisKind==3){
			var btnHtml='<input type="button" class="record_corpus" value=创建语料>'
			layerBtn=layer.tips(btnHtml,target,{
				tips:[2],
				time:99999999
			});
			$(".record_corpus").click(function(){
				var newCorpusHtml='<div class="record_new_box fl"><div class="record_new_corpus clearfix"><label>提问目的</label><input type="text" id="record_name" value='+_thisTd.eq(2).text()+' /></div>\
					<div class="record_new_corpus clearfix"><label>提问</label><input type="text" value='+_thisTd.eq(2).text()+' id="record_request" /></div>\
					<div class="record_new_corpus clearfix"><label>回答</label><textarea id="record_text"></textarea></div>\
					<div class="record_new_corpus clearfix"><label>表情</label><input type="text"  id="record_emotion" /></div>\
					<div class="record_new_corpus clearfix"><label>音频路径</label><input type="text" id="record_path" /></div></div>\
					<div class="record_new_box fl"><div class="record_new_corpus clearfix"><label>命令</label><select id="record_command"><option value="0">无</option></select></div>\
					<div class="record_new_corpus clearfix"><label>参数</label><textarea id="record_commandParam"></textarea></div>\
					<div class="record_new_corpus clearfix"><label>第三方</label><select id="record_third"><option value="0">无</option></select></div>\
					<div class="record_new_corpus clearfix"><label>第三方参数</label><select id="record_thirdParam"></select></div></div>\
				'
				layer.open({
					title:"新增语料",
					area:["750px","500px"],
					content:newCorpusHtml,
					yes:function(index){
						var name=trim($("#record_name").val());
						var request=trim($("#record_request").val());
						var text=trim($("#record_text").val());
						if(name=='' || request=='' || text==''){
							layer.tips("提问目的、提问、回答中不能有空值，请输入！",$(".layui-layer-btn0"),{tips:[1,"#f90"]})
						}else{
							var subUrl="https://"+host+"/signalmaster/rest/rule/orignal/save";
							var corpusData={
				  				orignalRuleId:0,
				  				voiceId:"",
				  				thirdPartyApi:parseFloat($("#record_third").val()),
				  				name:name,
				  				request:request,
				  				path:$("#record_path").val(),
				  				emotion:$("#record_emotion").val(),
				  				text:text,
				  				command:parseFloat($("#record_command").val()),
				  				commandParam:$("#record_commandParam").val(),
				  				thirdPartyApiParamsValueId:parseFloat($("#record_thirdParam").val()),
				  				incProp:'',
				  				userId:JSON.parse(window.localStorage.data)[0].userId
				  			}
				  			subForm(subUrl,corpusData,function(){
								if(subResult.message!="OK"){
				  					layer.alert("新增语料失败！");
				  				}else{
				  					layer.close(index);
				  					layer.alert("新增语料成功！")
				  				}
							})
						}
					}
				})

				$("#record_request").blur(function(){
					var _this=$(this);
					if(trim(_this.val())==''){
						layer.tips("提问不能为空！",_this);
					}
				})
				$("#record_name").blur(function(){
					var _this=$(this);
					if(trim(_this.val())==''){
						layer.tips("提问目的不能为空！",_this);
					}
				})
				$("#record_text").blur(function(){
					var _this=$(this);
					if(trim(_this.val())==''){
						layer.tips("回答不能为空！",_this);
					}
				})

				getCommandList(function(){
					console.log(corpusData)
					var commandOptions='';
					for(var i=0;i<corpusData.length;i++){
						commandOptions+='<option value='+corpusData[i].id+'>'+corpusData[i].name+'</option>'
					}
					$("#record_command").append(commandOptions)
				})
				getThirdList(function(){
					console.log(corpusData)
					var commandOptions='';
					for(var i=0;i<corpusData.length;i++){
						commandOptions+='<option value='+corpusData[i].id+'>'+corpusData[i].name+'</option>'
					}
					$("#record_third").append(commandOptions)
					var selected_third=$("#record_third option:selected");
			    	createSelectList("https://"+host+"/signalmaster/rest/voice/_3rd/params/list/"+selected_third.val(),$("#record_thirdParam"));
				})
				$("#record_third").change(function(){
			    	var selected_third=$("#record_third option:selected");
			    	createSelectList("https://"+host+"/signalmaster/rest/voice/_3rd/params/list/"+selected_third.val(),$("#record_thirdParam"));
			    })


			})
		}
		
	},function(){
		$("body").get(0).onmouseover=function(event){
			event = event ? event : window.event;   
			var obj = event.srcElement ? event.srcElement : event.target;
			if(obj.className!="record_corpus" && obj.className!="layui-layer-content" && $(obj).parent().attr("kind")!=2 && $(obj).parent().attr("kind")!=3){
				layer.close(layerBtn);
			}
		}	
	})
	
}

//各种情况下显示
function createSessionList(){
	whichRobot();
	var typeNum=$("#session_catelist option:selected").val();
	var keyword=getKeyword();
	var session_todayUrl='';
	var historyFlag=checkTodayOrHistory();
	if(historyFlag){
		var session_record_start=$("#log_strat").val()+" 00:00:00";
		var session_record_end=$("#log_end").val()+" 23:59:59";
		if(groupFlag){
			session_todayUrl="https://"+host+"/signalmaster/rest/chat_monitor/history/"+groupId+"/0/"+session_record_start+"/"+session_record_end+"/"+typeNum+"/"+keyword;
		}else{
			session_todayUrl="https://"+host+"/signalmaster/rest/chat_monitor/history/0/"+sn+"/"+session_record_start+"/"+session_record_end+"/"+typeNum+"/"+keyword;
		}
	}else{
		if(groupFlag){
			session_todayUrl="https://"+host+"/signalmaster/rest/chat_monitor/today/"+groupId+"/0/"+typeNum+"/"+keyword;
		}else{
			session_todayUrl="https://"+host+"/signalmaster/rest/chat_monitor/today/0/"+sn+"/"+typeNum+"/"+keyword;
		}
	}
	getSessionList(session_todayUrl);
}

//判断是今天还是历史记录
function checkTodayOrHistory(){
	return $(".session_recoed_time")[0].checked
}

//创建语料
function getCommandList(callback){
	multiSubmit("https://"+host+"/signalmaster/rest/voice/command/list",function(){
		if(message!="OK"){
			layer.alert("获取信息出错，请刷新页面重试！")
		}else{
			corpusData=data;
		}
		if(callback){
			callback();
		}		
	})  	
}

function getThirdList(callback){
	multiSubmit("https://"+host+"/signalmaster/rest/voice/_3rd/list",function(){
		if(message!="OK"){
			layer.alert("获取信息出错，请刷新页面重试！")
		}else{
			corpusData=data;
		}
		if(callback){
			callback();
		}		
	})  	
}

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

