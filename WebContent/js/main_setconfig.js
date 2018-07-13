var pagination=10;
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
	var groupId=robotList[0].userGroupId;
	var userId=robotList[0].userId;
	var groupName=robotList[0].userGroupName;
	var loadSn=robotList[0].robotImei;
	var groupUrl="https://"+host+"/signalmaster/rest/config/search/"+groupId+"/null"
}

var uploadFileUrl ="https://"+host+"/signalmaster/upload";
var layerIndex;

/*创建table列表*/
function createPageContent(parent,data,num,pagination){
	var dataOwner;
	var regJson=/^\s*\{/;
	parent.html('');
	var pageCount=Math.ceil(data.length/pagination);
	var dataTrTitle=$('<tr class="table_title">\
					<td width="20%">配置名</td>\
					<td width="25%">配置值</td>\
					<td>描述</td>\
					<td width="16%">应用范围</td>\
					<td width="100px">操作</td>\
				</tr>');
	dataTrTitle.appendTo(parent);

	//判断是不是最后一页
	if(num==pageCount){
		for(var i=((num-1)*pagination);i<(data.length);i++){
			var dataTr=$('<tr>\
				<td keyName="config_key">'+data[i].name+'</td>\
				<td keyName="config_value">'+data[i].value+'</td>\
				<td keyName="description">'+data[i].description+'</td>\
				<td keyName="ownerName">'+data[i].ownerName+'</td>\
				<td>\
					<input type="button" class="editBtn" title="编辑" name="编辑" robotId='+data[i].ownerId+'>\
					<input type="button" class="deleteBtn" title="删除" name="删除" priority='+data[i].priority+' robotId='+data[i].ownerId+'>\
					<input type="button" class="expansion" title="扩大" name="扩大">\
				</td>\
			</tr>');
			dataTr.appendTo(parent);

		}
	}else{
		for(var i=((num-1)*pagination);i<(num*pagination);i++){
			var dataTr=$('<tr>\
				<td keyName="config_key">'+data[i].name+'</td>\
				<td keyName="config_value">'+data[i].value+'</td>\
				<td keyName="description">'+data[i].description+'</td>\
				<td keyName="ownerName">'+data[i].ownerName+'</td>\
				<td>\
					<input type="button" class="editBtn" title="编辑" name="编辑" robotId='+data[i].ownerId+'>\
					<input type="button" class="deleteBtn" title="删除" name="删除" priority='+data[i].priority+' robotId='+data[i].ownerId+'>\
					<input type="button" class="expansion" title="扩大" name="扩大">\
				</td>\
			</tr>');
			dataTr.appendTo(parent);
		}
	}
	
	var imgReg=/^[a-zA-z]+:\/\/[\S]{0,}(\.(jpg|jpeg|png|gif|bmp))$/i;
	($("#table td")).each(function(){
		if($(this).text().match(imgReg)){
			var _thisLink=$(this).text();
			$(this).html('<img src="images/icon_img.png"><span style="display:none">'+_thisLink+'</span>');
			var _thisImg1='<img src='+_thisLink+' style="width:100%;padding:30px">' ;
			$(this).click(function(){
				layer.open({
					title : '放大图',
					type: 1,
					skin: 'layui-layer-rim', //加上边框
					area:[ '500px','550px'], //宽高
					content:_thisImg1
				});
			})
		}	
	})

	//json格式化
	$("#table td[keyName='config_value']").each(function(){
		if(($(this).text()).match(regJson)!=null){
			var _thisJson=$(this).text();
			$(this).addClass('json_value');
			$(this).html('<img src="images/icon_json.png"><span style="display:none">'+_thisJson+'</span>');
			$(this).children("img").click(function(){
				var _thisJsonHtml='<div id="jsonHtml"></div>';
				layer.open({
					title : '配置值',
					type: 1,
					skin: 'layui-layer-rim', //加上边框
					area:[ '500px','450px'], //宽高
					content: _thisJsonHtml
				});
				$("#jsonHtml").JSONView(_thisJson);
			})
		}	
	})

	//删除按钮的禁用
	$(".deleteBtn").each(function(){
		if($(this).attr('priority')==1){
			$(this).attr('disabled',true);
			$(this).next().attr('disabled',true);
		}else if($(this).attr('priority')==2){
			$(this).next().attr('disabled',true);
		}
	})

	/*删除*/
	$(".deleteBtn").click(function(){
		var _this=$(this);
		deleteForm(_this);
	})

	/*扩大*/
	$(".expansion").click(function(){
		var _this=$(this);
		expansion(robotList,_this);
	})

	/*编辑*/
	$(".editBtn").click(function(){
		var eidtPrio=$(this).siblings('.deleteBtn').attr("priority");
		var _this=$(this);
		var editList=_this.parent().siblings();
		var editSn=getInfo();
		var editData={};
		var robotIndexId=_this.attr("robotId");
		findKeyName(editList);
		if(keyvalue.children('span').length!=0){
			editWeb(robotList,editSn,eidtPrio,robotIndexId)	
		}else{
			editLine(robotList,editSn,eidtPrio,robotIndexId);	
		}
	})
}


/*编辑*/
function editLine(robotList,editSn,eidtPrio,robotIndexId){
	var keyvalueTxt=keyvalue.text();
	var keydesTxt=keydes.text();
	var editValueChange=false;
	keydes.text('');
	keyvalue.text('');
	keyvalue.append($('<textarea class="edit_value">'+keyvalueTxt+'</textarea>'));
	keydes.append($('<textarea class="edit_des">'+keydesTxt+'</textarea>'));
	$(".edit_value").focus();

	$(".edit_des").blur(function(){
		judgeFocus(keyvalueTxt,keydesTxt,eidtPrio,editSn,robotIndexId);
	})

	$(".edit_value").blur(function(){
		judgeFocus(keyvalueTxt,keydesTxt,eidtPrio,editSn,robotIndexId);
	})

}

function judgeFocus(keyvalueTxt,keydesTxt,eidtPrio,editSn,robotIndexId){
	var editRobotId;
	var editCheck=1;
	var keyvalueTxtNew=$('.edit_value').val();
	var keydesTxtNew=$('.edit_des').val();
	var editSubUrl='';
	var keyWords='';
	if($("#search_ipt").val()==''){
		keyWords='null';
	}else{
		keyWords=$("#search_ipt").val();
	}
	getCurrentPage();
	whichRobot();
	setTimeout(function(){
		var getRobotId='';
		if($(".edit_value").is(":focus") || $(".edit_des").is(":focus")){
			judgeFlag=false;
		}else if(keyvalueTxtNew!=keyvalueTxt || keydesTxtNew!=keydesTxt){
			if(eidtPrio==2){
				editCheck=2;
			}else if(eidtPrio==3){
				for(var i=0;i<robotList.length;i++){
					if(robotList[i].robotId==robotIndexId){
						editRobotId=robotList[i].robotId;
					}
				}
				editCheck=3;
			}

			if(groupFlag){
				if(editCheck==2){
					editData={
						user_id:userId,
						group_id:groupId,
						config_key:keyname.text(),
						config_value:$(".edit_value").val(),
						description:$(".edit_des").val()
					}
				}else if(editCheck==3){
					editData={
						user_id:userId,
						robot_id:editRobotId,
						config_key:keyname.text(),
						config_value:$(".edit_value").val(),
						description:$(".edit_des").val()
					}
				}else{
					editData={
						user_id:userId,
						group_id:groupId,
						config_key:keyname.text(),
						config_value:$(".edit_value").val(),
						description:$(".edit_des").val()
					}
				}
				editSubUrl="https://"+host+"/signalmaster/rest/config/search/"+groupId+"/"+keyWords;
			}else{
				if(editCheck==2){
					editData={
						user_id:editSn.userId,
						robot_id:editSn.robotId,
						config_key:keyname.text(),
						config_value:$(".edit_value").val(),
						description:$(".edit_des").val()
					}
				}else if(editCheck==3){
					editData={
						user_id:editSn.userId,
						robot_id:editRobotId,
						config_key:keyname.text(),
						config_value:$(".edit_value").val(),
						description:$(".edit_des").val()
					}
				}else{
					editData={
						user_id:editSn.userId,
						robot_id:editSn.robotId,
						config_key:keyname.text(),
						config_value:$(".edit_value").val(),
						description:$(".edit_des").val()
					}		
				}
				editSubUrl="https://"+host+"/signalmaster/rest/config/"+editSn.sn+"/"+keyWords;	
			}

			subForm("https://"+host+"/signalmaster/rest/set_config",editData,function(){
				$(".edit_value").remove();
				keyvalue.text(keyvalueTxt);
				$(".edit_des").remove();
				keydes.text(keydesTxt);
				changeRobots(editSubUrl,function(){
					$(".page_skip input").val(editCurrentpage);
					$(".page_skip a").trigger('click');
				});
			})
		}else{
			$(".edit_value").remove();
			keyvalue.text(keyvalueTxt);
			$(".edit_des").remove();
			keydes.text(keydesTxt);
		}
	},0.1)
}

function editWeb(robotList,editSn,eidtPrio,robotIndexId){
	var getRobotId='';
	var editFormHtml='\
	<div id="editInfo" class="infoLayer">\
	    <div class="infoLayerList"><label>配置名：</label><input type="text" value='+keyname.text()+' name="config_key" disabled="disabled"/></div>\
	    <div class="infoLayerList"><label>配置值：</label><textarea name="config_value">'+keyvalue.text()+'</textarea></div>\
	    <form role="form" id="fileForm" method="post" enctype="multipart/form-data">\
	    	<div class="infoLayerList">\
		    	<label>上传文件：</label>\
		    	<a href="#" class="loadfile">选择文件<input type="file" name="file"></a>\
		    	<div class="upload_fileOk"><i class="icon-check"></i>上传成功！</div>\
		    	<div style="margin:5px 0 0 82px;"><input type="button" id="upload_btn" value="开始上传"/>\
		    	<input type="button" value="重置" id="reset_value"/></div>\
	    	</div>\
	    </form>\
	    <div class="infoLayerList"><label>配置描述：</label><textarea name="description">'+keydes.text()+'</textarea></div>\
	    <div class="group_tip">请选择应用范围</div>\
	    <div class="exRange">\
	    	<label>应用范围：</label>\
	    	<input type="checkbox" id="groupName" name='+groupName+' />\
	    	<span>'+groupName+'</span></div>\
	    <div id="robotCheck" class="clearfix"></div>\
	    <div class="formsub_box clearfix">\
		    <input id="editSubmit" type="button" value="确定" class="submit_btn fl"/>\
		    <input id="editCancle" type="button" value="取消" class="cancle_btn fr"/>\
	    </div>\
	</div>';

	var layerIndex=layer.open({
	  	title : '编辑配置',
	  	type: 1,
	  	skin: 'layui-layer-rim', //加上边框
	  	area: ['552px', '624px'], //宽高
	  	content: editFormHtml
	});

	for(var i=0;i<robotList.length;i++){
		var owerHtml='<div class="fl"><input type="checkbox" sn='+robotList[i].robotImei+'  name='+robotList[i].robotId+'><span style=margin-right:5px;>'+robotList[i].robotName+'</span></div>';
		$("#robotCheck").append(owerHtml);
	}

	var editCheck=1;
	if(eidtPrio==3){
		$("#editInfo input[type='checkbox']").each(function(){
			$(this).get(0).disabled=true;
			if(($(this).attr("name"))==robotIndexId){
				$(this).get(0).checked=true;
			}
		})
		editCheck=3;
	}else{
		whichRobot();
		if(groupFlag){
			$("#editInfo input[type='checkbox']").each(function(){
				$(this).get(0).disabled=true;
				$(this).get(0).checked=true;	
			})
		}else{
			var robotAll='';
			$("#robots input").each(function(){
				if($(this).hasClass('robotCurrent')){
					robotAll=$(this).attr("sn");
				}
			})

			$("#editInfo input[type='checkbox']").each(function(){
				$(this).get(0).disabled=true;
				if(($(this).attr("sn"))==robotAll){
					$(this).get(0).checked=true;
				}
			})
		}	
	}

	uploadFile();

	$("#editSubmit").click(function(){
			editSubmit(editCheck,editSn,layerIndex);
	})
	$("#editCancle").click(function(){
		layer.close(layerIndex);
	})	
}
function editSubmit(editCheck,editSn,layerIndex){
	whichRobot();
	getCurrentPage();
	var keyWords='';
	if($("#search_ipt").val()==''){
		keyWords='null';
	}else{
		keyWords=$("#search_ipt").val();
	}

	if(groupFlag){
		if(editCheck==3){
			$("#robotCheck input[type='checkbox']").each(function(){
				if($(this).prop('checked')){
					editData={
						user_id:userId,
						robot_id:$(this).attr('name'),
						config_key:$("#editInfo input[name='config_key']").val(),
						config_value:$("#editInfo textarea[name='config_value']").val(),
						description:$("#editInfo textarea[name='description']").val(),
					}
				}		
			})
		}else{
			editData={
				user_id:userId,
				group_id:groupId,
				config_key:$("#editInfo input[name='config_key']").val(),
				config_value:$("#editInfo textarea[name='config_value']").val(),
				description:$("#editInfo textarea[name='description']").val(),
			}
		}
		editSubUrl="https://"+host+"/signalmaster/rest/config/search/"+groupId+"/"+keyWords;
	}else{
		if(editCheck==3){
			$("#robotCheck input[type='checkbox']").each(function(){
				if($(this).prop('checked')){
					editData={
						user_id:editSn.userId,
						robot_id:$(this).attr('name'),
						config_key:$("#editInfo input[name='config_key']").val(),
						config_value:$("#editInfo textarea[name='config_value']").val(),
						description:$("#editInfo textarea[name='description']").val(),
					}
				}
				
			})
		}else{
			editData={
				user_id:editSn.userId,
				robot_id:editSn.robotId,
				config_key:$("#editInfo input[name='config_key']").val(),
				config_value:$("#editInfo textarea[name='config_value']").val(),
				description:$("#editInfo textarea[name='description']").val(),
			}
		}
		editSubUrl="https://"+host+"/signalmaster/rest/config/"+editSn.sn+"/"+keyWords;
	}
	
	subForm("https://"+host+"/signalmaster/rest/set_config",editData,function(){
		layer.close(layerIndex);
		changeRobots(editSubUrl,function(){
			$(".page_skip input").val(editCurrentpage);
			$(".page_skip a").trigger('click');
		});
	})

}


//切换机器人
function changeRobots(url,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:url,
		success:function(result){
			data=result.data;
			layer.closeAll();
			if(result.code==0){
				if(data!=undefined){
					createPage($("#table"),data,pagination,createPageContent);
				}else{
					$("#table").html("");
					$(".counts_page").text(0);
					$(".counts_num").text(0);
				}
				if(callback){
					callback();
				}
			}else{
				layer.alert(result.message)
			}	
		},
		error:function(result){
			alert('服务器异常！')
		}
	})
}

/*获取机器人关键字信息*/
function getInfo(){
	var sn,userId,robotId,groupId,groupName;
	$("#robots input").each(function(){
		if($(this).hasClass('robotCurrent')){
			sn=$(this).attr('sn');
			userId=$(this).attr('userId');
			robotId=$(this).attr('robotId');
			groupId=$(this).attr('groupId');
			groupName=$(this).attr('groupName');
		}
	})
	return {"sn":sn,"userId":userId,"robotId":robotId,"groupId":groupId,"groupName":groupName};
}

/*弹出层及全选判断*/
function checkInfo(robotList,Layerform,callback){
	layerIndex=layer.open({
		type:1,
		title:'新增配置',
	  	skin: 'layui-layer-rim', //加上边框
	  	area: ['552px', '624px'], //宽高
	  	content:Layerform
	})

	for(var i=0;i<robotList.length;i++){
		var owerHtml='<div class="fl"><input type="checkbox" name='+robotList[i].robotId+' /><span>'+robotList[i].robotName+'</span></div>';
		$("#robotCheck").append(owerHtml);
	}

	$("#addCancle").click(function(){
		layer.close(layerIndex);
	})

	uploadFile();
	//全选判断
	var checkFlag=false;
	checkAll();

	if(callback){
		callback();
	}
}

function uploadFile(){

	$(".loadfile").click(function(){
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
	//上传文件
	$("#upload_btn").click(function(){
		if($(".upload_fileOk").css("visibility")=="visible"){
			$(".upload_fileOk").html("<i class='icon-spinner' style='color:#bbb'></i>上传中...");
			uploadByForm($("#fileForm")[0],uploadFileUrl,function(){
				$(".upload_fileOk").html("<i class='icon-check'></i>上传成功！");
				$(".infoLayer textarea[name='config_value']").val(uploadUrl)
				$(".infoLayer textarea[name='config_value']").attr('disabled',true);
			});
		}else{
			layer.alert("请选择要上传的文件！")
		}
	})
	$("#reset_value").click(function(){
		$(".upload_fileOk").css("visibility",'hidden');
		$(".infoLayer textarea[name='config_value']").val('')
		$(".infoLayer textarea[name='config_value']").attr('disabled',false);
	})
}
function checkAll(){
	//全选判断
	var checkedIf=$("#groupName").prop('checked');
	$("#groupName").click(function(){
		$(this).attr('checked',!checkedIf);
		if($(this).prop("checked")){
			$("#robotCheck input[type='checkbox']").each(function(){
				$(this).get(0).checked=true;
				$(this).attr('disabled',true);	
			})
			checkFlag=true;
		}else{
			$("#robotCheck input[type='checkbox']").each(function(){
				$(this).get(0).checked=false;
				$(this).attr('disabled',false);
			})
			checkFlag=false;				
		}
		checkedIf=$("#groupName").prop('checked');
	})
	if($("#robotCheck input[type='checkbox']").length>1){
		$("#robotCheck input[type='checkbox']").click(function(){
			var groupCheck=0;
			$("#robotCheck input[type='checkbox']").each(function(){
				if($(this).prop('checked')){
					groupCheck++;
				}
			})
			if(groupCheck==($("#robotCheck input[type='checkbox']").length)){
				$("#groupName").get(0).checked=true;
				checkFlag=true;
			}else{
				$("#groupName").get(0).checked=false;
				checkFlag=false;
			}
		})
	}else{
		checkFlag=false;
	}
}


//删除
function deleteForm(_this){
	var delSn=getInfo();
	var delPriority=_this.attr('priority');
	var delData={};
	var _thisSiblingNode=_this.parent().siblings();
	whichRobot();
	var keyWords='';

	if($("#search_ipt").val()==''){
		keyWords='null';
	}else{
		keyWords=$("#search_ipt").val();
	}

	if(groupFlag){
		deleteUrl="https://"+host+"/signalmaster/rest/config/search/"+groupId+"/"+keyWords;
	}else{
		deleteUrl="https://"+host+"/signalmaster/rest/config/"+delSn.sn+"/"+keyWords;
	}

	findKeyName(_thisSiblingNode);
	if(delPriority==2){
		delData={
			user_Id:userId,
			group_id:groupId,
			config_key:_thisSiblingNode.eq(0).text()
		}
	}else{
		delData={
			user_id:userId,
			robot_id:_this.attr("robotId"),
			config_key:_thisSiblingNode.eq(0).text()
		}
	}
	var deleTip='确认删除 '+keyowner.text()+' 的 '+keydes.text()+' 吗？'

	var layerIndex=layer.alert(deleTip,{
	  	icon:0,
	  	btn:['确定','取消'],
	  	yes:function(index, layero){
	  		subForm("https://"+host+"/signalmaster/rest/delete_config",delData,function(){
	  			changeRobots(deleteUrl)
	  		})
	  		layer.close(layerIndex);
	  	},btn2:function(index, layero){
	  		layer.close(layerIndex);
	  	}
	})
}

/*扩大*/
function expansion(robotList,_this){
	var exList=_this.parent().siblings();
	var exSn=getInfo();
	var exData={};

	whichRobot();
	var keyWords='';

	if($("#search_ipt").val()==''){
		keyWords='null';
	}else{
		keyWords=$("#search_ipt").val();
	}

	if(groupFlag){
		exUrl="https://"+host+"/signalmaster/rest/config/search/"+groupId+"/"+keyWords;
	}else{
		exUrl="https://"+host+"/signalmaster/rest/config/"+exSn.sn+"/"+keyWords;
	}

	findKeyName(exList);
	var expanHtml='\
	<form id="expansionForm">\
	    <div class="group_tip">请选择应用范围</div>\
	    <div class="exRange">\
	    	<label>应用范围：</label>\
	    	<input type="checkbox" id="groupName" name='+groupName+' />\
	    	<span>'+groupName+'</span></div>\
	    <div id="robotCheck" class="clearfix"></div>\
	    <div class="formsub_box">\
	    	<input id="exSubmit" type="button" value="确定" class="submit_btn fl"/>\
	    	<input id="exCancle" type="button" value="取消" class="cancle_btn fr"/><br />\
	    </div>\
	</form>\
	';
	var layerIndex=layer.open({
		title : '修改范围',
		  type: 1,
		  skin: 'layui-layer-rim', //加上边框
		  area: ["492px","280px"], //宽高
		  content: expanHtml
	});

	for(var i=0;i<robotList.length;i++){
		var owerHtml='<div class="fl"><input id="Checkbox5" type="checkbox"  name='+robotList[i].robotId+' /><span style=margin-right:8px;>'+robotList[i].robotName+'</span></div>';
		$(owerHtml).appendTo($("#robotCheck"));
	}

	checkAll();

	$("#exSubmit").click(function(){
		var tipShow=true;
		$("#expansionForm input[type='checkbox']").each(function(){
			if($(this).prop('checked')){
				tipShow=false;
			}
		})
		if(tipShow){
			$(".group_tip").show();
		}else{
			if(checkFlag){
				exData={
					user_id:userId,
					group_id:groupId,
					config_key:keyname.text(),
					config_value:keyvalue.text(),
					description:keydes.text()
				}
				subForm("https://"+host+"/signalmaster/rest/set_config",exData,function(){
					layer.close(layerIndex);
					changeRobots(exUrl);
				})			
			}else{
				$("#robotCheck input[type='checkbox']").each(function(){
					if($(this).prop('checked')){
						exData={
							user_id:exSn.userId,
							robot_id:$(this).attr('name'),
							config_key:keyname.text(),
							config_value:keyvalue.text(),
							description:keydes.text()
						}
						subForm("https://"+host+"/signalmaster/rest/set_config",exData,function(){
							layer.close(layerIndex);
							changeRobots(exUrl);
						})		
					}	
				})
			}
			

		}
		
	})
	$("#exCancle").click(function(){
		layer.close(layerIndex);
	})
}

function findKeyName(list){
	list.each(function(){
		switch($(this).attr('keyName')){
			case 'config_key':
				keyname=$(this);
				break;
			case 'config_value':
				keyvalue=$(this);
				break;
			case 'description':
				keydes=$(this);
			case 'ownerName':
				keyowner=$(this);
				break;
		}
	})
}

//搜索
function searchProperty(searchHost,groupUrl)
{	
	var searchKey = $("#search_ipt").val();
	if(searchKey.length > 0){
		var searchUrl=searchHost+"/"+searchKey;
		multiSubmit(searchUrl,function(){
			if(data!=undefined){
				createPage($("#table"),data,pagination,createPageContent);
			}else{
				$("#table").html("");
				$(".pageNum").html('');
				$(".counts_page").text(0);
				$(".counts_num").text(0);
			}
			layer.closeAll();	
		})
	}else {
		changeRobots(groupUrl);
	}
}

function searchDown(){
	var searchSn=getInfo();
	whichRobot();
	var searchHost='';
	if(groupFlag){
		searchHost="https://"+host+"/signalmaster/rest/config/search/"+groupId;
		groupUrl="https://"+host+"/signalmaster/rest/config/search/"+groupId+"/null";
	}else{
		searchHost="https://"+host+"/signalmaster/rest/config/"+searchSn.sn;
		groupUrl=searchHost;
	}
	searchProperty(searchHost,groupUrl);
}

