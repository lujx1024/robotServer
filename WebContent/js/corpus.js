var thirdParamResultList=[];
$(document).ready(function(){
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
		var applySn=JSON.parse(window.localStorage.data)[0].robotImei;
		var appGroup=JSON.parse(window.localStorage.data)[0].userGroupName;
		var groupId=JSON.parse(window.localStorage.data)[0].userGroupId;
		var userId=JSON.parse(window.localStorage.data)[0].userId;
		var robotList=JSON.parse(window.localStorage.data);
	}
	var container = document.getElementById('corpus');
	var selection = [0,0,0,0];
	corpusDataSubmit=[];
	
	//测试会话机器人列表
	for(var i=0;i<robotList.length;i++){
		var robotListOption='<option value='+robotList[i].robotImei+'>'+robotList[i].robotName+"-"+robotList[i].robotImei+'</option>';
		$("#corpus_robots_list").append(robotListOption);
	}
	//测试会话查询
	$(".corpus_test_btn").click(function(){
		if(trim($(".corpus_test_ipt").val())==''){
			layer.tips("内容输入不能为空！",$('.corpus_test_ipt'),{
				tips:[1,"#f90"]
			})
		}else{
			var startTime=(new Date()).getTime();
			var corpusTestSn=$("#corpus_robots_list option:selected").val();
			var corpusTestIpt=$(".corpus_test_ipt").val();
			var corpusTestUrl="https://"+host+"/signalmaster/rest/auto_talk/"+corpusTestSn+"/mode/"+corpusTestIpt;
			multiSubmit(corpusTestUrl,function(){
				var disTime=endTimeCorpus-startTime;
				if(message!="OK"){
					layer.alert("获取信息出错，请刷新页面重试！")
				}else{
					if(data!=undefined){
						var corpusTestResult='<table id="corpus_result">\
							<tr><td width="75">会话目的</td><td>'+data.voiceName+'</td></tr>\
							<tr><td>音频播放</td><td>'+data.voicePath+'</td></tr>\
							<tr><td>语音文字</td><td>'+data.voiceText+'</td></tr>\
							<tr><td>会话类别</td><td>'+data.voiceCat+'</td></tr>\
							<tr><td>类别描述</td><td>'+data.voiceDescription+'</td></tr>\
							<tr><td>命令</td><td>'+data.voiceCommand+'</td></tr>\
							<tr><td>命令参数</td><td>'+data.voiceCommandParam+'</td></tr>\
							<tr><td>第三方名</td><td>'+data.voiceThirdPartyApiName+'</td></tr>\
							<tr><td>标签</td><td>'+data.voiceIncProp+'</td></tr>\
							<tr><td>表情播放</td><td>'+data.voiceEmotion+'</td></tr>\
						</table><div class="fr" style="margin-top:10px;color:#333">本次测试耗时： '+disTime+' ms</div>';
						layer.open({
							type:1,
							title:'测试结果',
						  	skin: 'layui-layer-rim', //加上边框
						  	area: ['600px', '450px'], //宽高
						  	content:corpusTestResult
						})
					}else{
						layer.alert("暂无此会话，请检查输入的测试会话内容是否有误，然后重新尝试！")
					}
				}
					
			})
		}
		
	})

	//压力测试
	$(".corpus_webtest_btn").click(function(){
		var corpusWebtest=trim($(".corpus_test_ipt").val());
		if(corpusWebtest==''){
			layer.tips("内容输入不能为空！",$('.corpus_test_ipt'),{
				tips:[1,"#f90"]
			})
		}else{
			var webtestHtml='<div class="clearfix corpus_webtest"><label>输入次数：</label><input type="number" value="50" id="testtime" /><input type="button" value="开始测试" id="start_test" /></div><div class="testing displayNone">玩命测试中，请勿关闭窗口或者刷新页面</div><div class="displayNone echarts_box"><div id="main" style="width:750px;height:250px;margin-top:30px"></div><div class="webResult webRed"></div></div><div class="probar_box displayNone"><div class="probar_child"><span class="probar_num"></span></div></div>';
			layer.open({
				title:"会话压力测试",
				btn:[],
				content:webtestHtml,
				area:["800px","450px"],
				cancel: function(index, layero){ 
					if($("#start_test").get(0).disabled==false){
					    layer.close(index)
					}
					return false; 
				}   
			})

			$("#testtime").change(function(){
				var _this=$(this);
				var _thisValue=parseFloat(_this.val());
				if(!isInteger(_thisValue)){
					layer.tips("请输入整数！",_this);
				}else if(_thisValue<=0){
					layer.tips("请输入大于0的整数！",_this);
					_this.val(1);
				}
			})

			$("#start_test").click(function(){
				var corpusTestSn=$("#corpus_robots_list option:selected").val();
				var corpusTestIpt=$(".corpus_test_ipt").val();
				var corpusTestUrl="https://"+host+"/signalmaster/rest/auto_talk/"+corpusTestSn+"/mode/"+corpusTestIpt;
				var testTime=parseFloat($("#testtime").val());
				var testResult=[];
				var averageCount=0;
				var xAxisData=[];
				$(".probar_box").removeClass("displayNone");
				$(".probar_child").width(0);
				$(".probar_num").removeClass("displayNone").html(0);
				$(".echarts_box").addClass("displayNone");
				$(this).attr("disabled",true);
				$(".testing").removeClass("displayNone");
				for(var i=0;i<testTime;i++){
					xAxisData.push(i+1);
				}
				var startTime=0;
				funcs(testTime,testTime);
				function funcs(times,all){
					startTime=(new Date()).getTime();
					if(times<=0){
						return;
					}else{
						corpusTest(corpusTestUrl,function(){
							times--;
							var width=parseInt(((all-times)/all)*100);
							$(".probar_child").animate({"width":width+"%"},function(){
								$(".probar_num").html(width+"%");
								if(width==100){
									var webCount=0;
									var allCount=0;
									$("#start_test").attr("disabled",false);
									setTimeout(function(){
										$(".probar_box").addClass("displayNone");
										$(".testing").addClass("displayNone");
										$(".echarts_box").removeClass("displayNone");
										echarts_line(xAxisData,testResult);
										for(i=0;i<testResult.length;i++){
											if(testResult[i]>1500){
												webCount++;
											}
											allCount+=testResult[i];
										}
										var webPercent=webCount/testResult.length;
										var allAverage=allCount/testResult.length;
										if(webPercent>0.1 || allAverage>1000){
											$(".webResult").html("网络状况不良");
											$(".webResult").addClass("webRed");
										}else{
											$(".webResult").html("网络状况良好");
											$(".webResult").removeClass("webRed");
										}

									},300)
								}
							});
							setTimeout(function(){
								funcs(times,all)
							},1000);
						})
					}
				}				

				function corpusTest(submitUrl,callback){
					$.ajax({
						cache:false,
						type:'GET',
						url:submitUrl,
						success:function(result){
							endTimeCorpus=new Date();
							endTimeCorpus=endTimeCorpus.getTime();
							var disTime=endTimeCorpus-startTime;
							testResult.push(disTime);
							if(callback){
								callback();
							}
						},
						error:function(result){
							layer.alert('服务器异常，测试中断！');
						}
					})
				}
				
			})
		}
	})



  	getCommandList(function(){
  		getThirdList(function(){
  			getThirdParamList(function(){
  				dataLoad();	
	  			//上传表格
			  	$(".loadexcel").click(function(){
					$(".upload_fileOk").css("visibility",'hidden');
					$(this).children().val('');
					$(this).children().change(function(){
						var _this=$(this).val();
						$('.upload_fileOk').css({'visibility':'visible','font-size':'13px'});	
						var urlIndex=_this.lastIndexOf("\\")+1;
						var fileUrl=_this.substring(urlIndex);
						$('.upload_fileOk').text(fileUrl);
					});
				})
			  	var uploadExcelUrl="https://"+host+"/signalmaster/upload_voice_table";
			  	$("#excel_btn").click(function(){
			  		if($('.upload_fileOk').css('visibility')=="visible"){
			  			$(".upload_fileOk").html("<i class='icon-spinner' style='color:#bbb'></i>上传中...");
				  		uploadByForm($("#excelForm")[0],uploadExcelUrl,function(){
				  			if(responseStrResult.message=="用户未登录"){
				  				$(".upload_fileOk").html("");
				  				layer.alert("登录失效，请退出重新登录！");
				  			}else if(responseStrResult.message=="OK"){
				  				$(".upload_fileOk").html("<i class='icon-check'></i>上传成功！");
								dataLoad();
				  			}else{
				  				$(".upload_fileOk").html("<i class='icon-window-close'></i>上传失败！");
				  			}
				  			
						});
			  		}else{
			  			layer.alert("请选择要上传的文件！")
			  		}					
			  	})

			  	$("#addrow").click(function(){
			  		hot.alter('insert_row',hot.countRows());
			  		$("#save_addrow").attr("disabled",false);
			  		hot.selectCell(hot.countRows()-1,0);
			  	})

			  	//删除
			  	$("#deleterow").click(function(){
			  		if(selection[0]>selection[2]){
						var ridx = selection[2];
						var colx=selection[1];
						var eidx = selection[0];
					}else{
						var ridx = selection[0];
						var colx=selection[1];
						var eidx = selection[2];
					}
					var deleTip="确认删除吗？";
					var layerIndex=layer.alert(deleTip,{
					  	icon:0,
					  	btn:['确定','取消'],
					  	yes:function(index, layero){
					  		for(var i=0;i<selectionDataList.length;i++){
						  		if((selectionDataList[i].ridxValue)!=null){
									var deleteUrl="https://"+host+"/signalmaster/rest/rule/orignal/delete/"+selectionDataList[i].ridxValue+"/"+selectionDataList[i].ridxVoiceId;
									multiSubmit(deleteUrl,function(){
										if(message!="OK"){
											layer.alert("删除失败，请重新操作！")
										}
										dataLoad();
									})
								}else{
									hot.alter('remove_row',ridx,1);
									//selection = [0,0,0,0];
								}
							}
					  		layer.close(index);
					  	},btn2:function(index, layero){
					  		layer.close(index);
					  		hot.selectCell(ridx,colx);
					  	}
					})		
			  	})
			  	//搜索
			  	$("#search_ipt").keyup(function(event){
			  		if(event.which==13){
			  			dataLoad();	
			  		}
			  	})

			  	$("#search_text").click(function(){
			  		dataLoad();
			  	})

			  	//有效性以及句法扩展
		  		$("#enabled").click(function(){
		  			for(var i=0;i<selectionDataList.length;i++){
		  				multiSubmit("https://"+host+"/signalmaster/rest/voice/enabled/"+selectionDataList[i].ridxVoiceId+"/true",function(){
		  					if(message!="OK"){
								layer.alert("操作失败，请重新操作！")
							}
							dataLoad();
			  			})
		  			}
					  		
		  		})
		  		$("#dis_enabled").click(function(){
		  			for(var i=0;i<selectionDataList.length;i++){
		  				multiSubmit("https://"+host+"/signalmaster/rest/voice/enabled/"+selectionDataList[i].ridxVoiceId+"/false",function(){
		  					if(message!="OK"){
								layer.alert("操作失败，请重新操作！")
							}
							dataLoad();
			  			}) 
		  			}
					 		
		  		})
		  		$("#extended").click(function(){
		  			for(var i=0;i<selectionDataList.length;i++){
		  				multiSubmit("https://"+host+"/signalmaster/rest/rule/orignal/gen/"+userId+"/"+selectionDataList[i].ridxValue,function(){
		  					if(message!="OK"){
								layer.alert("扩展失败，请重新操作！")
							}
							dataLoad();
			  			})
		  			}
					  		
		  		})

		  		$("#save_addrow").click(function(){
//		  			if(corpusData != undefined){
		  			if(typeof(corpusData)!="undefined"){
		  				if(corpusData.name!='' && corpusData.request!=''){
				  			var subUrl="https://"+host+"/signalmaster/rest/rule/orignal/save";
				  			subExcel(subUrl,corpusData,function(){
				  				if(saveMessage!="OK"){
				  					layer.alert("保存失败！")
				  				}else{
				  					layer.alert("保存成功！");
				  					dataLoad();
				  					corpusData=undefined;
				  				}	
				  			});
						}else{
							layer.alert("提问目的和提问方式不能为空，请填写！",{
								icon:2,
								yes:function(index, layero){
							  		layer.close(index);
							  		if(corpusData.name==''){
							  			hot.selectCell(afterChangeSaveRow,0);
							  		}else{
							  			hot.selectCell(afterChangeSaveRow,1);
							  		}
							  		
							  	}
							})	
						}
		  			}	
				})
  			})
  		});
  	});

  	function dataLoad(callback){
  		var url="https://"+host+"/signalmaster/rest/rule/orignal/search/"+userId+"/"+getKeyword();
  		multiSubmit(url,function(){
  			if(message!="OK"){
  				layer.alert("获取信息出错，请刷新页面重试！")
  			}else{
	  			$("#corpus").html("");
		  		createTable(data);
  			}		
	  	})
  	}
	
  	function getCommandList(callback){
  		multiSubmit("https://"+host+"/signalmaster/rest/voice/command/list",function(){
  			if(message!="OK"){
  				layer.alert("获取信息出错，请刷新页面重试！")
  			}else{
  				if(data!=undefined){
	  				commandDataList=getDataToArray(["无"],data,"name");
					commandList=getDataToArray(['',null,'无'],data,"name");
					commandListNum=getDataToArray([0,0,0],data,"id");
	  			}else{
	  				commandDataList=[0];
					commandList=['',null,"无"];
					commandListNum=[0,0,0];
	  			}
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
  				if(data!=undefined){
	  				thirdDataList=getDataToArray(["无"],data,"description");
					thirdList=getDataToArray(['',null,"无"],data,"description");
					thirdListNum=getDataToArray([0,0,0],data,"id");
	  			}else{
	  				thirdDataList=[0]
					thirdList=['',null,"无"];
					thirdListNum=[0,0,0];
	  			}
  			}
			if(callback){
				callback();
			}
			
	  	})  	
  	}
  	function getThirdParamList(callback){
  		multiSubmit("https://"+host+"/signalmaster/rest/voice/_3rd/params/list",function(){
  			if(message!="OK"){
  				layer.alert("获取信息出错，请刷新页面重试！")
  			}else{
  				if(data!=undefined){
  					var firstString=[data[0].thirdPartyApiId];
		  			var bigArray=[];
		  			data.sort(function(j1,j2){
		  				return j1.thirdPartyApiId-j2.thirdPartyApiId;
		  			})
		  			var thirdApi=data[0].thirdPartyApiId;
		  			thirdParamResultList=[{thirdPartyApiId:0,thirdParamArray:["无"]}];
		  			var arrayParam=["无",data[0].descirption];
		  			thirdNumArray=[0,0,0,data[0].id];
		  			thirdContentArray=["",null,"无",data[0].descirption];
		  			for(var i=1;i<data.length;i++){
		  				thirdNumArray.push(data[i].id);
		  				thirdContentArray.push(data[i].descirption);
		  				if(data[i].thirdPartyApiId==thirdApi){
		  					arrayParam.push(data[i].descirption);
		  					if(i==(data.length-1)){
		  						thirdParamResultList.push({thirdPartyApiId:thirdApi,thirdParamArray:arrayParam});
		  					}
		  				}else{
		  					thirdParamResultList.push({thirdPartyApiId:thirdApi,thirdParamArray:arrayParam});
		  					arrayParam=["无",data[i].descirption];
		  					thirdApi=data[i].thirdPartyApiId;
		  					if(i==(data.length-1)){
		  						thirdParamResultList.push({thirdPartyApiId:thirdApi,thirdParamArray:arrayParam});
		  					}
		  				}
		  			}
  				}else{
  					thirdNumArray=[0,0,0];
		  			thirdContentArray=["",null,"无"];
  				}
  			} 		
			if(callback){
				callback();
			}
	  	}) 
  	}

  	function getDataToArray(start,object,value){
  		var targetArray=start;
  			for(var i=0;i<object.length;i++){
				targetArray.push(object[i][value])
			}
		return targetArray;
  	}

  	function createTable(data){
  		hot = new Handsontable(container,{
	    data: getCorpusData(data),
	    stretchH: 'all',
	    manualColumnResize:true,
	    manualRowResize:true,
	    autoWrapRow: true,
	    autoColumnSize:true,
	    rowHeaders: true,
    	colHeaders: true,
	    colHeaders: ['提问目的', '提问方式', '回答方式','音频路径','表情','命令','参数','第三方','第三方参数','标签'],
	    columns: [
	        	{},
	        	{},
	        	{},
	        	{},
	        	{},
	        	{	
	        		width:160,
	        		type: 'dropdown',
	        		source: commandDataList
	        	},
	        	{},
	        	{
	        		width:160,
	        		type: 'dropdown',
	        		source: thirdDataList,
	        	},
	        	{
	        		type: 'dropdown',
	        		source: ["无"]
	        	},
	        	{}
	    	],
		    afterSelectionEnd: function(x1, y1, x2, y2){
		    	$("body").get(0).onclick=null;
				selection = [x1,y1,x2,y2];
				selectionDataList=[];
				if(selection[0]>selection[2]){
					var selectionStart=selection[2];
					var selectionEnd=selection[0]
				}else{
					var selectionStart=selection[0];
					var selectionEnd=selection[2]
				}
				for(var i=selectionStart;i<=selectionEnd;i++){
					selectionDataList.push({ridxValue:hot.getCellMeta(i,0).orignalRuleId,ridxVoiceId:hot.getCellMeta(i,0).voiceId})
				}
				$("#deleterow,#enabled,#extended,#dis_enabled").attr("disabled",false);
			},
			afterDeselect:function(){
				$("body").get(0).onclick=function(event){
					event = event ? event : window.event;   
					var obj = event.srcElement ? event.srcElement : event.target;
					if(obj.id=="deleterow" || obj.id=="enabled" || obj.id=="extended" || obj.className=="layui-layer-btn1"){
						$("#deleterow,#enabled,#extended,#dis_enabled").attr("disabled",false);
					}else{
						$("#deleterow,#enabled,#extended,#dis_enabled").attr("disabled",true);
					}
				}
			}    
	    });

	    if(data!=undefined){
    		for(var i=0;i<data.length;i++){
		    	var extended=false;
		    	hot.setCellMeta(i,0,"voiceId",data[i].voiceId);
		    	hot.setCellMeta(i,0,"orignalRuleId",data[i].orignalRuleId);
		    	if(data[i].genWordGroupFlowId!=0){
		    		extended=true;
		    	}
				for(var j=0;j<10;j++){
					if(i<23){
						if(data[i].voiceEnabled==false){
							hot.getCell(i,j).style.background = '#dcdcdc';
						}else if(extended==true){
							hot.getCell(i,j).style.background = '#6aab44';
							hot.getCell(i,j).style.color="#fff";
						}else{
							hot.getCell(i,j).style.background = '#fff';
						}
					}
					hot.setCellMeta(i,j,"enabled",data[i].voiceEnabled);
					hot.setCellMeta(i,j,"extended",extended);
				}

				hot.getCellMeta(i,8).source=checkThirdParam(data[i].thirdPartyApiId);
			}
    	}
		hot.addHook('afterRenderer', function(td, row, col, prop, value, cellProperties){
	    	if(cellProperties.enabled==false){
	  			td.style.background = '#dcdcdc';
	  		}else{
	  			if(cellProperties.extended==true){
		  			td.style.background = '#6aab44';
		  			td.style.color="#fff";
		  		}else{
		  			td.style.background = '#fff';
		  		}
	  		}
	  	})	
	  	afterChangeSave();		
  	}

  	function bindDumpButton() {
      	if (typeof Handsontable === "undefined") {
        	return;
      	}
      	Handsontable.Dom.addEvent(document.body, 'click', function (e) {
        	var element = e.target || e.srcElement;
        	if (element.nodeName == "BUTTON" && element.name == 'dump') {
          	var name = element.getAttribute('data-dump');
         	var instance = element.getAttribute('data-instance');
          	var hot = window[instance];
        	}
        });
    }
  	bindDumpButton();


  	//获取表格数据
  	function getCorpusData(data){
  		var corpusData=[];
  		if(data==undefined){
  			corpusData=[['','','','','','','','','','']]
  		}else{
  			for(var i=0;i<data.length;i++){
		  		var command=data[i].command;
		  		var third=data[i].thirdPartyApiId;
		  		var thirdParam=data[i].thirdPartyApiParamsValueId;

		  		if(command==0){
		  			command="无";
		  		}else{
		  			command=commandChange(data[i].command,commandListNum,commandList);
		  		}
		  		if(third==0){
		  			third="无";
		  		}else{
		  			third=commandChange(data[i].thirdPartyApiId,thirdListNum,thirdList);
		  		}
		  		if(thirdParam==0){
		  			thirdParam="无";
		  		}else{
		  			thirdParam=commandChange(data[i].thirdPartyApiParamsValueId,thirdNumArray,thirdContentArray);
		  		}
		  		for(var key in data[i]){
		  			if(key=="genWordGroupFlowId"){
		  			}
		  		}
		  		var subData=[data[i].name,data[i].request,data[i].text,data[i].path,data[i].emotion,command,data[i].commandParam,third,thirdParam,data[i].incProp];
		  		corpusData.push(subData);
		  	}
  		}	
  		return corpusData;
	}

	//表格改变提交
	function afterChangeSave(callback){
		hot.addHook('afterChange', function(changes,source){
			var subUrl="https://"+host+"/signalmaster/rest/rule/orignal/save";
	  		var dataSave=changes[0];
	  		afterChangeSaveRow=dataSave[0];
	  		afterChangeSaveCol=dataSave[1]+1;
	  		var oldValue=dataSave[2];
	  		var newValue=dataSave[3];
	  		var changeData=hot.getDataAtRow(afterChangeSaveRow);
	  		var voiceId=hot.getCellMeta(afterChangeSaveRow,0).voiceId;
	  		var orignalRuleId=hot.getCellMeta(afterChangeSaveRow,0).orignalRuleId;
	  		var scrollLeft=$(".ht_master .wtHolder").scrollLeft();
	  		if(dataSave[1]==7){
				checkDownInput(afterChangeSaveRow,7,oldValue,function(){
					if(dropDownTdFlag){
						save(function(){
							hot.getCellMeta(afterChangeSaveRow,8).source=checkThirdParam(commandChange(changeData[7],thirdList,thirdListNum));
						});					
					}	
				});	
			}else if(dataSave[1]==5){
				checkDownInput(afterChangeSaveRow,5,oldValue,function(){
					if(dropDownTdFlag){
						save();
					}
				})
			}else if(dataSave[1]==8){
				checkDownInput(afterChangeSaveRow,8,oldValue,function(){
					if(dropDownTdFlag){
						save();
					}
				})
			}else{
				save();
			}
			function save(callback){
				if(voiceId!=undefined){
		  			if(changeData[0]=='' || changeData[1]==''){
	  					layer.alert("提问目的和提问方式不能为空，请填写！",{
		  					icon:2,
		  					yes:function(index, layero){
						  		layer.close(index);
						  		if(changeData[0]==""){
				  					hot.selectCell(afterChangeSaveRow,0);
				  				}else{
				  					hot.selectCell(afterChangeSaveRow,1);
				  				}					  		
						  	}
		  				})	
	  				}else if(oldValue!=newValue){
			  			corpusData={
			  				orignalRuleId:orignalRuleId,
			  				voiceId:voiceId,
			  				thirdPartyApi:commandChange(changeData[7],thirdList,thirdListNum),
			  				name:changeData[0],
			  				request:changeData[1],
			  				path:changeData[3],
			  				emotion:changeData[4],
			  				text:changeData[2],
			  				command:commandChange(changeData[5],commandList,commandListNum),
			  				commandParam:changeData[6],
			  				thirdPartyApiParamsValueId:commandChange(changeData[8],thirdContentArray,thirdNumArray),
			  				incProp:changeData[9],
			  				userId:userId
			  			}
			  			subExcel(subUrl,corpusData,function(){
							if(saveMessage!="OK"){
			  					layer.alert("保存失败！");
			  				}else{
			  					corpusData=undefined;
			  				}
						})		
			  		}
		  		}else{
	  				voiceId='';
	  				var name=nullToValue(changeData[0],'');
	  				var request=nullToValue(changeData[1],'');
					corpusData={
		  				orignalRuleId:nullToValue(null,0),
		  				voiceId:voiceId,
		  				thirdPartyApi:commandChange(changeData[7],thirdList,thirdListNum),
		  				name:name,
		  				request:request,
		  				path:nullToValue(changeData[3],''),
		  				emotion:nullToValue(changeData[4],''),
		  				text:nullToValue(changeData[2],''),
		  				command:commandChange(changeData[5],commandList,commandListNum),
		  				commandParam:nullToValue(changeData[6],''),
		  				thirdPartyApiParamsValueId:commandChange(changeData[8],thirdContentArray,thirdNumArray),
		  				incProp:nullToValue(changeData[9],''),
		  				userId:userId
		  			}
		  		}
		  		if(callback){
					callback();
				}
			}	
	  	});
	  	if(callback){
			callback()
		}
	}		
})

function checkThirdParam(value){
	var third=[];
	var flag=false;
	for(var i=0;i<thirdParamResultList.length;i++){
		if(value==thirdParamResultList[i].thirdPartyApiId){
			third=thirdParamResultList[i].thirdParamArray;
			break;
		}else{
			third=["无"];
		}
	}
	return third;
}

/**
 * 检测下拉列表的输入
 * @param row
 * @param col
 * @param oldValue
 * @param callback
 */
function checkDownInput(row,col,oldValue,callback){
	var dropDownTd=hot.getCell(row,col);
	if($(dropDownTd).hasClass("htInvalid")){
		dropDownTdFlag=false;
		layer.alert("内容错误，请双击选择下拉框中的内容！",{
			yes:function(index, layero){
		  		layer.close(index);
		  		hot.selectCell(row,col);
		  		hot.setDataAtCell(row,col,oldValue)
		  	}
		});
	}else{
		dropDownTdFlag=true;
	}

	if(callback){
		callback();
	}
}

function subExcel(subUrl,subData,callback){
	$.ajax({
		cache:false,
		type:"POST",
		url:subUrl,
		data:subData,
		success:function(result){
			resultF=result;
			saveMessage=result.message;
			if(callback){
				callback();
			}
		},
		error:function(){
			alert('服务器异常！');
		}
	})

}

function nullToValue(input, value) {
	return input == null? value : input;	
}

//命令与数字相互转换
function commandChange(name,arraySource,arrayTarget){
	var i=0;
	while(i<arraySource.length){
		switch(name){
			case arraySource[i]:
				return arrayTarget[i];
				break;
		}
		i++;
	}
}

/*折线图*/
function echarts_line(xAxisData,data){
	require.config({
        paths: {
            echarts: 'js/echarts/build/dist'
        }
    });
	require(
        [
            'echarts',
            'echarts/chart/line'
        ],
        function (ec) {
            var myChart = ec.init(document.getElementById('main')); 
            var option = {
			    title : {
			        text: '会话压力测试结果'
			    },
			    tooltip : {
			        trigger: 'axis'
			    },
			    toolbox: {
			        show : true,
			    },
			    calculable : true,
			    xAxis : [
			        {
			            type : 'category',
			            boundaryGap : false,
			            data : xAxisData
			        }
			    ],
			    yAxis : [
			        {	
			            type : 'value',
			            axisLabel : {
			                formatter: '{value} ms'
			            }
			        }
			    ],
			    series : [
			        {
			            name:'测试结果',
			            type:'line',
			            data:data,
			            markPoint : {
			                data : [
			                    {type : 'max', name: '最大值'},
			                    {type : 'min', name: '最小值'}
			                ]
			            },
			            markLine : {
			                data : [
			                    {type : 'average', name: '平均值'}
			                ]
			            },
			            smooth:true
			        }
			    ]
			};
            myChart.setOption(option); 
        }
    );
}