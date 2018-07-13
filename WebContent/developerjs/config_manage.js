$(document).ready(function(){
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
	}
	
	var all='';
	var groupId=robotList[0].userGroupId;
	var userId=robotList[0].userId;
	var groupName=robotList[0].userGroupName;
	var configUrl="https://"+host+"/signalmaster/rest/config/define/"+getKeyWord();
	var configTypeUrl="https://"+host+"/signalmaster/rest/config/kinds";
	
	getConfigType(configTypeUrl,function(){
		//getAllConfig(configUrl);
		$(".config_manage_list").html("请搜索配置......");
		$("#search_text").click(function(){
			if(getKeyWord()==null){
				$(".config_manage_list").html("请搜索配置......")
			}else{
				getAllConfig("https://"+host+"/signalmaster/rest/config/define/"+getKeyWord());
			}	
		})
		$("#search_ipt").keyup(function(event){
			if(event.which==13){
				$("#search_text").trigger("click");
			}
		})
	})

	function getKeyWord(){
		var searchInput=$("#search_ipt").val();
		var keyWord='';
		if(searchInput==''){
			keyWord=null;
		}else{
			keyWord=searchInput;
		}
		return keyWord;
	}

	function getAllConfig(url,callback){
		$.ajax({
			cache:false,
			type:'GET',
			url:url,
			success:function(result){
				data=result.data;
				console.log(data)
				if(data!=undefined){
					$(".config_manage_list").html("");
					createConfig(data,configType);
					if(callback){
						callback();
					}
				}else{
					$(".config_manage_list").html("搜索无结果!");
				}
				layer.closeAll();
				
			},
			error:function(result){
				alert('服务器异常！')
			}
		})
	}
	function getConfigType(url,callback){
		$.ajax({
			cache:false,
			type:'GET',
			url:url,
			success:function(result){
				configType=result.data;
				if(configType!=undefined){
					console.log(configType)
				}else{
					$(".common_config_list").html("");
				}
				layer.closeAll();
				if(callback){
					callback();
				}
			},
			error:function(result){
				alert('服务器异常！')
			}
		})
	}
	
	function createConfig(objData,configTypeData){
		var configTypeHtml='';
		for(var j=0;j<configTypeData.length;j++){
			configTypeHtml+='<span class="fl configtype_list"><input type="checkbox" disabled typeValue='+configTypeData[j].value+' />'+configTypeData[j].name+'</span>'	
		}
		for(var i=0;i<objData.length;i++){		
			var configHtml='<li>\
								<label class="cm_title">'+objData[i].name+'</label>\
								<div class="config_edit_box clearfix"><button class="config_edit fr"><i class="icon-pencil" style="margin-right:5px"></i>编辑</button><button class="config_save_cancle fr displayNone">取消</button><button class="config_save fr displayNone">保存</button></div>\
								<div class="cm_container clearfix"><div class="cm_list_box">\
									<label>名称</label>\
									<input type="text" disabled class="config_name" value='+objData[i].name+' disabled>\
								</div>\
								<div class="cm_list_box clearfix">\
									<div class="fl">\
										<label>类型</label>\
										<select disabled class="config_type" typeValue='+objData[i].type+'>\
											<option value="string">string</option><option value="bool">bool</option><option value="integer">integer</option><option value="float">float</option><option value="list">list</option><option value="image_list">image_list</option><option value="module_list">module_list</option><option value="command_list">command_list</option><option value="patrol">patrol</option><option value="menu_list">menu_list</option><option value="menu_matrix">menu_matrix</option>\
										</select>\
									</div>\
									<div class="fl displayNone limit_dis">\
										<label class="config_limit">最小值</label>\
										<input type="number" class="config_limitL" disabled value='+objData[i].limitL+'>\
									</div>\
									<div class="fl displayNone limit_dis">\
										<label class="config_limit">最大值</label>\
										<input type="number" class="config_limitH" disabled value='+objData[i].limitH+'>\
									</div>\
								</div>\
								<div class="cm_list_box clearfix">\
									<div class="fl"><label>所属</label>\
									<select disabled class="config_ownerType" ownerType='+objData[i].ownerType+' ownerId='+objData[i].ownerId+'><option value="1">系统配置</option><option value="2">行业配置</option><option value="3">企业配置</option><option value="4">场景配置</option></select></div>\
									<div class="fl displayNone ownerType_dis">\
										<select disabled class="config_ownerId" style="margin-left:12px;width:250px;" ownerId='+objData[i].ownerId+'><option>请选择行业</option></select>\
									</div>\
								</div>\
								<div class="cm_list_box">\
									<label>正则表达式</label>\
									<input type="text"  class="config_pattern" disabled value='+objData[i].pattern+'>\
								</div>\
								<div class="cm_list_box">\
									<label>描述</label>\
									<input type="text" value='+objData[i].description+' class="config_des" disabled>\
								</div>\
								<div class="cm_list_box">\
									<label>所属模块</label>\
									<div class="config_level" level='+objData[i].level+'>'+configTypeHtml+'</div>\
								</div>\
								<div class="cm_list_box">\
									<label>备选值</label>\
									<div class="config_candidate"><div class="config_candidate_list clearfix"></div><span class="candidate_value displayNone">'+objData[i].candidate+'</span><button class="config_add_candi displayNone">增加备选值</button></div>\
								</div>\
								<div class="cm_list_box">\
									<label>默认值</label>\
									<textarea class="config_value" disabled>'+objData[i].value+'</textarea>\
								</div></div>\
							</li>'
			$(".config_manage_list").append(configHtml);
			var allWidth=$(".config_manage_list").width()-195;
			$(".config_level").width(allWidth);
			$(".cm_list_box textarea").width(allWidth);
			$(".cm_list_box .config_candidate").width(allWidth);
			$(".config_des").width(allWidth);
		}

		var configCancleHtml='';
		//类型初始化
		$(".config_type").each(function(){
			var _this=$(this);
			var _thisValue=_this.attr("typeValue");
			_this.val(_thisValue);
			if(_thisValue=="integer" || _thisValue=="float"){
				_this.parent().siblings(".limit_dis").removeClass("displayNone")
			}
		})

		//所属初始化
		multiSubmit("https://"+host+"/signalmaster/rest/config/industries/null",function(){
			if(message=="OK"){
				$('.config_ownerId').html('');
				var hangyeOptions='';
				for(var i=0;i<data.length;i++){
					hangyeOptions+='<option value='+data[i].value+'>'+data[i].name+'</option>'
				}
				multiSubmit("https://"+host+"/signalmaster/rest/config/userGroups/0/null",function(){
					if(message=="OK"){
						$('.config_ownerId').html('');
						var qiyeOptions='';
						for(var i=0;i<data.length;i++){
							qiyeOptions+='<option value='+data[i].value+'>'+data[i].name+'</option>'
						}
					}
					multiSubmit("https://"+host+"/signalmaster/rest/config/userGroupsScenes/0/null",function(){
						if(message=="OK"){
							$('.config_ownerId').html('');
							var changjingOptions='';
							for(var i=0;i<data.length;i++){
								changjingOptions+='<option value='+data[i].value+'>'+data[i].name+'</option>'
							}
						}
						$(".config_ownerType").each(function(){
							var _this=$(this);
							var _thisValue=_this.attr("ownerType");
							var _thisOwnerId=parseFloat(_this.attr("ownerId"));
							var _thisSiblings=_this.parent().siblings('.ownerType_dis');
							var _thisTarget=_thisSiblings.find(".config_ownerId");
							_this.val(_thisValue);
							if(_thisValue=="2"){
								_thisSiblings.removeClass("displayNone");
								_thisTarget.append(hangyeOptions);
								_thisTarget.val(_thisOwnerId)
							}else if(_thisValue=="3"){
								_thisSiblings.removeClass("displayNone");
								_thisTarget.append(qiyeOptions);
								_thisTarget.val(_thisOwnerId)
							}else if(_thisValue=="4"){
								_thisSiblings.removeClass("displayNone");
								_thisTarget.append(changjingOptions);
								_thisTarget.val(_thisOwnerId)
							}
						})
					})
				})
			}
			
		})
		

		//备选值初始化
		$(".candidate_value").each(function(){
			var _this=$(this);
			var _thisValue=_this.html();
			if(_thisValue!=''){
				_thisValue=eval("("+_thisValue+")").items;
				for(var i=0;i<_thisValue.length;i++){
					var candidateHtml='<span candidate='+_thisValue[i].value+'>'+_thisValue[i].name+'<img src="images/icon_close_blue.png" class="array_close displayNone" datatype="list"><i class="icon-pencil editable_btn displayNone"></i></span>';
					_this.siblings(".config_candidate_list").append(candidateHtml);
				}
			}
		})
		$(".config_candidate").on("click",".editable_btn",function(){
			var _this=$(this);
			var _thisParent=_this.parent();
			var _thisOldValue=_thisParent.attr("candidate");
			var _thisOldName=_thisParent.text();
			var candidateHtml='<div class="config_candi_add"><label>name</label><input type="text" value='+_thisOldName+' id="can_name" ></div><div class="config_candi_add"><label>value</label><input type="text" value='+_thisOldValue+' id="can_value" ></div>';
			layer.open({
				title:"增加备选值",
				area:['300px','300px'],
				content:candidateHtml,
				yes:function(index){
					var _thisNewValue=trim($("#can_value").val());
					var _thisNewName=trim($("#can_name").val());
					if(_thisNewName==''){
						layer.tips("输入不能为空！",$("#can_name"));
					}else if(_thisNewValue==''){
						layer.tips("输入不能为空！",$("#can_value"));
					}else{
						_thisParent.html(_thisNewName+'<img src="images/icon_close_blue.png" class="array_close" datatype="list"><i class="icon-pencil editable_btn"></i>');
						_thisParent.attr("candidate",_thisNewValue);
						layer.close(index);
					}
					
				}
			})
		})
		$(".config_add_candi").click(function(){
			var _this=$(this);
			var candidateHtml='<div class="config_candi_add"><label>name</label><input type="text" id="can_name" ></div><div class="config_candi_add"><label>value</label><input type="text" id="can_value" ></div>';
			layer.open({
				title:"增加备选值",
				area:['300px','300px'],
				content:candidateHtml,
				yes:function(index){
					var _thisNewValue=trim($("#can_value").val());
					var _thisNewName=trim($("#can_name").val());
					if(_thisNewName==''){
						layer.tips("输入不能为空！",$("#can_name"));
					}else if(_thisNewValue==''){
						layer.tips("输入不能为空！",$("#can_value"));
					}else{
						var candidateHtml='<span candidate='+_thisNewValue+'>'+_thisNewName+'<img src="images/icon_close_blue.png" class="array_close" datatype="list"><i class="icon-pencil editable_btn"></i></span>';
						_this.siblings(".config_candidate_list").append(candidateHtml);
						layer.close(index);
					}
				}
			})
		})

		//删除candidate
		$(".config_candidate").on("click",".array_close",function(){
			$(this).parent().remove();
		})

		//level初始化
		$(".config_level").each(function(){
			var _this=$(this);
			var _thisLevel=parseFloat(_this.attr("level"));
			var _thisChildren=_this.find("input[type='checkbox']");
			_thisChildren.each(function(){
				var typeValue=parseFloat($(this).attr("typeValue"));
				if((_thisLevel & typeValue)>0){
					$(this).attr("checked",true);
				}
			})
		})

		//类型、所属选择
		$(".config_type").change(function(){
			var _this=$(this);
			if(_this.val()=="integer" || _this.val()=="float"){
				_this.parent().siblings(".limit_dis").removeClass("displayNone");
			}else{
				_this.parent().siblings(".limit_dis").addClass("displayNone");
			}
		})
		$(".config_ownerType").change(function(){
			var _this=$(this);
			var _thisValue=_this.val();
			var _thisSiblings=_this.parent().siblings('.ownerType_dis');
			if(_thisValue=="2"){
				_thisSiblings.removeClass("displayNone");
				getSuoShu("https://"+host+"/signalmaster/rest/config/industries/null")
			}else if(_thisValue=="3"){
				_thisSiblings.removeClass("displayNone");
				getSuoShu("https://"+host+"/signalmaster/rest/config/userGroups/0/null")
			}else if(_thisValue=="4"){
				_thisSiblings.removeClass("displayNone");
				getSuoShu("https://"+host+"/signalmaster/rest/config/userGroupsScenes/0/null")
			}else{
				_thisSiblings.addClass("displayNone");
			}
		})

		//最大值最小值判断
		$(".config_limitH").blur(function(){
			var _this=$(this);
			var _thisLow=_this.parent().siblings(".limit_dis").find(".config_limitL")
			if(_this.val()!='' && _thisLow.val()!=''){
				var low=parseFloat(_thisLow.val());
				var high=parseFloat(_this.val());
				var highOr=limitLClimitH(low,high,_this);
				if(!highOr){
					_this.val(low+1);
				}
			}	
		})
		$(".config_limitL").blur(function(){
			var _this=$(this);
			var _thisHigh=_this.parent().siblings(".limit_dis").find(".config_limitH");
			if(_this.val()!='' && _thisHigh.val()!=''){
				var high=parseFloat(_thisHigh.val());
				var low=parseFloat(_this.val());
				var highOr=limitLClimitH(low,high,_this);
				if(!highOr){
					_this.val(0)
				}
				
			}	
		})

		//取消
		$(".config_save_cancle").click(function(){
			getAllConfig("https://"+host+"/signalmaster/rest/config/define/"+getKeyWord());
		})

		//编辑
		$(".config_edit").click(function(){
			var _this=$(this);
			cancleTarget=_this.parent().siblings(".cm_container");
			var _thisDataBox=_this.parent().siblings(".cm_container").find(".cm_list_box");
			var _thisParentParent=_this.parent().parent();
			
			_this.addClass("displayNone");
			_this.siblings(".config_save").removeClass("displayNone");
			_this.siblings(".config_save_cancle").removeClass("displayNone");
			_thisDataBox.find("input").attr("disabled",false);
			_thisDataBox.find("select").attr("disabled",false);
			_thisDataBox.find("textarea").attr("disabled",false);
			_thisDataBox.find(".config_ownerTypeName").attr("disabled",true);
			_thisDataBox.find(".config_name").attr("disabled",true);
			_thisDataBox.find(".editable_btn").removeClass("displayNone");
			_thisDataBox.find(".array_close").removeClass("displayNone");
			_thisDataBox.find(".config_add_candi").removeClass("displayNone");
		})

		//保存
		$(".config_save").click(function(){
			var _this=$(this);
			var _thisDataBox=_this.parent().siblings(".cm_container").find(".cm_list_box");

			var name=trim(_thisDataBox.find(".config_name").val());
			var des=trim(_thisDataBox.find(".config_des").val());
			var value=trim(_thisDataBox.find(".config_value").val());
			var nullFlag=checkConfigNull(name,des,value);
			if(!nullFlag){
				layer.tips("名称、描述、默认值中不能有空，请输入！",_this);
			}else{
				if(_thisDataBox.find(".config_ownerType").val()==1){
					var ownerId=0;
					var ownerName=_thisDataBox.find(".config_ownerType").find("option:selected").text();
				}else{
					var ownerId=parseFloat(_thisDataBox.find(".config_ownerId").val());
					var ownerName=_thisDataBox.find(".config_ownerId").find("option:selected").text();
				}
				if(_thisDataBox.find(".config_type").val()!="integer" && _thisDataBox.find(".config_type").val()!="float"){
					var limitL='';
					var limitH='';
				}else{
					var limitL=_thisDataBox.find(".config_limitL").val();
					var limitH=_thisDataBox.find(".config_limitH").val();
				}

				var candidateArray=[];
				var candidate={};
				if(_thisDataBox.find(".config_candidate_list span").length!=0){
					_thisDataBox.find(".config_candidate_list span").each(function(){
						var _this=$(this);
						var preJson={};
						preJson.name=_this.text();
						preJson.value=_this.attr("candidate");
						candidateArray.push(preJson);
					})
					candidate.items=candidateArray;
					candidate=JSON.stringify(candidate);
				}else{
					candidate='';
				}

				var level=0;
				_thisDataBox.find(".config_level").find("input[type='checkbox']").each(function(){
					var _this=$(this);
					var _thisValue=parseFloat(_this.attr("typeValue"));
					if(_this.get(0).checked==true){
						level=level | _thisValue;
					}
				})
				var configSaveValue={
					name:name,
					ownerId:ownerId,
					ownerName:ownerName,
					ownerType:parseFloat(_thisDataBox.find(".config_ownerType").val()),
					ownerTypeName:_thisDataBox.find(".config_ownerType").find("option:selected").text(),
					type:_thisDataBox.find(".config_type").val(),
					value:value,
					level:level,
					limitL:limitL,
					limitH:limitH,
					candidate:candidate,
					pattern:_thisDataBox.find(".config_pattern").val(),
					description:des

				}
				console.log(configSaveValue)
				subForm("https://"+host+"/signalmaster/rest/config/define/save",configSaveValue,function(){
					if(subResult.message=="OK"){
						_this.addClass("displayNone");
						_this.siblings(".config_save_cancle").addClass("displayNone");
						_this.siblings(".config_edit").removeClass("displayNone");
						_thisDataBox.find("input").attr("disabled",true);
						_thisDataBox.find("select").attr("disabled",true);
						_thisDataBox.find("textarea").attr("disabled",true);
						_thisDataBox.find(".editable_btn").addClass("displayNone");
						_thisDataBox.find(".array_close").addClass("displayNone");
						_thisDataBox.find(".config_add_candi").addClass("displayNone");
						layer.alert("保存成功",{
							icon:1,
							yes:function(index){
								getAllConfig("https://"+host+"/signalmaster/rest/config/define/"+getKeyWord());
								layer.close(index);
							}
						})
					}else{
						layer.alert("保存失败："+subResult.message,{
							icon:5,
							yes:function(index){
								getAllConfig("https://"+host+"/signalmaster/rest/config/define/"+getKeyWord());
								layer.close(index);
							}
						})
					}
				})
			}
			
		})
	}

	//新增
	$("#addBtn").click(function(){
		getConfigType(configTypeUrl,function(){
			var configTypeHtml='';
			for(var j=0;j<configType.length;j++){
				configTypeHtml+='<span class="fl configtype_list"><input type="checkbox" typeValue='+configType[j].value+' />'+configType[j].name+'</span>'	
			}
			var addConfigHtml='<div class="cm_container clearfix" style="padding:20px 0"><div class="cm_list_box">\
					<label>名称</label>\
					<input type="text" class="config_name" id="add_name">\
				</div>\
				<div class="cm_list_box clearfix">\
					<div class="fl">\
						<label>类型</label>\
						<select class="config_type" id="add_type">\
							<option value="string">string</option><option value="bool">bool</option><option value="integer">integer</option><option value="float">float</option><option value="list">list</option><option value="image_list">image_list</option><option value="module_list">module_list</option><option value="command_list">command_list</option><option value="patrol">patrol</option><option value="menu_list">menu_list</option><option value="menu_matrix">menu_matrix</option>\
						</select>\
					</div>\
					<div class="fl displayNone limit_dis">\
						<label class="config_limit">最小值</label>\
						<input type="number" id="add_limitL" style="width:80px" class="config_limitL" >\
					</div>\
					<div class="fl displayNone limit_dis">\
						<label class="config_limit">最大值</label>\
						<input type="number" id="add_limitH" style="width:80px" class="config_limitH" >\
					</div>\
				</div>\
				<div class="cm_list_box clearfix">\
					<div class="fl"><label>所属</label>\
					<select class="config_ownerType"  id="add_ownerType"><option value="1">系统配置</option><option value="2">行业配置</option><option value="3">企业配置</option><option value="4">场景配置</option></select></div>\
					<div class="fl displayNone ownerType_dis">\
						<select class="config_ownerId" id="add_ownerType_dis" style="margin-left:12px;width:250px;"><option>请选择行业</option></select>\
					</div>\
				</div>\
				<div class="cm_list_box">\
					<label>正则表达式</label>\
					<input type="text" class="config_pattern" id="add_pattern">\
				</div>\
				<div class="cm_list_box">\
					<label>描述</label>\
					<input type="text" class="config_des" id="add_des">\
				</div>\
				<div class="cm_list_box">\
					<label>所属模块</label>\
					<div class="config_level" id="add_level">'+configTypeHtml+'</div>\
				</div>\
				<div class="cm_list_box">\
					<label>备选值</label>\
					<div class="config_candidate" id="add_candi" style="width:555px"><div class="config_candidate_list clearfix"></div><button class="config_add_candi" id="add_candi_btn">增加备选值</button></div>\
				</div>\
				<div class="cm_list_box">\
					<label>默认值</label>\
					<textarea class="config_value" id="add_value" style="width:555px"></textarea>\
				</div></div>'
			var config_index=layer.open({
				title:"新增配置",
				type: 1,
				btn:["确定"],
				area:['800px','500px'],
				content:addConfigHtml,
				yes:function(index){
					var name=trim($("#add_name").val());
					var des=trim($("#add_des").val());
					var value=trim($("#add_value").val());
					var nullFlag=checkConfigNull(name,des,value);
					if(!nullFlag){
						layer.tips("名称、描述、默认值中不能有空，请输入！",$(".layui-layer-btn0"))
					}else{
						if($("#add_ownerType").val()==1){
							var ownerId=0;
							var ownerName=$("#add_ownerType").find("option:selected").text();
						}else{
							var ownerId=parseFloat($("#add_ownerType_dis").val());
							var ownerName=$("#add_ownerType_dis").find("option:selected").text();
						}
						if($("#add_type").val()!="integer" &&$("#add_type").val()!="float"){
							var limitL='';
							var limitH='';
						}else{
							var limitL=$("#add_limitL").val();
							var limitH=$("#add_limitH").val();
						}

						var candidateArray=[];
						var candidate={};
						if($("#add_candi .config_candidate_list span").length!=0){
							$("#add_candi .config_candidate_list span").each(function(){
								var _this=$(this);
								var preJson={};
								preJson.name=_this.text();
								preJson.value=_this.attr("candidate");
								candidateArray.push(preJson);
							})
							candidate.items=candidateArray;
							candidate=JSON.stringify(candidate);
						}else{
							candidate='';
						}

						var level=0;
						$("#add_level").find("input[type='checkbox']").each(function(){
							var _this=$(this);
							var _thisValue=parseFloat(_this.attr("typeValue"));
							if(_this.get(0).checked==true){
								level=level | _thisValue;
							}
						})
						var configSaveValue={
							name:name,
							ownerId:ownerId,
							ownerName:ownerName,
							ownerType:parseFloat($("#add_ownerType").val()),
							ownerTypeName:$("#add_ownerType").find("option:selected").text(),
							type:$("#add_type").val(),
							value:value,
							level:level,
							limitL:limitL,
							limitH:limitH,
							candidate:candidate,
							pattern:$("#add_pattern").val(),
							description:des

						}
						console.log(configSaveValue);
						subForm("https://"+host+"/signalmaster/rest/config/define/save",configSaveValue,function(){
							if(subResult.message=="OK"){
								layer.alert("保存成功",{
									icon:1,
									yes:function(index){
										if(getKeyWord()==null){
											$(".config_manage_list").html("请搜索配置......");
										}else{
											getAllConfig("https://"+host+"/signalmaster/rest/config/define/"+getKeyWord());
										}
										layer.closeAll();
									}
								})
							}else{
								layer.alert("保存失败："+subResult.message,{
									icon:5,
									yes:function(index){
										getAllConfig("https://"+host+"/signalmaster/rest/config/define/"+getKeyWord());
										layer.closeAll();
									}
								})
							}
						})
					}
					
				}
			})

			$("#add_limitH").blur(function(){
				var _this=$(this);
				if(_this.val()!='' && $("#add_limitL").val()!=''){
					var low=parseFloat($("#add_limitL").val());
					var high=parseFloat(_this.val());
					var highOr=limitLClimitH(low,high,_this);
					if(!highOr){
						_this.val(low+1);
					}
				}	
			})
			$("#add_limitL").blur(function(){
				var _this=$(this);
				if(_this.val()!='' && $("#add_limitH").val()!=''){
					var high=parseFloat($("#add_limitH").val());
					var low=parseFloat(_this.val());
					var highOr=limitLClimitH(low,high,_this);
					if(!highOr){
						_this.val(0);
					}
				}	
			})

			$("#add_type").change(function(){
				var _this=$(this);
				if(_this.val()=="integer" || _this.val()=="float"){
					_this.parent().siblings(".limit_dis").removeClass("displayNone");
				}else{
					_this.parent().siblings(".limit_dis").addClass("displayNone");
				}
			})

			$("#add_ownerType").change(function(){
				var _this=$(this);
				var _thisValue=_this.val();
				var _thisSiblings=_this.parent().siblings('.ownerType_dis');
				if(_thisValue=="2"){
					_thisSiblings.removeClass("displayNone");
					getSuoShu("https://"+host+"/signalmaster/rest/config/industries/null")
				}else if(_thisValue=="3"){
					_thisSiblings.removeClass("displayNone");
					getSuoShu("https://"+host+"/signalmaster/rest/config/userGroups/0/null")
				}else if(_thisValue=="4"){
					_thisSiblings.removeClass("displayNone");
					getSuoShu("https://"+host+"/signalmaster/rest/config/userGroupsScenes/0/null")
				}else{
					_thisSiblings.addClass("displayNone");
				}
			})

			$("#add_candi_btn").click(function(){
				var _this=$(this);
				var candidateHtml='<div class="config_candi_add"><label>name</label><input type="text" id="can_name" ></div><div class="config_candi_add"><label>value</label><input type="text" id="can_value" ></div>';
				layer.alert(candidateHtml,{
					yes:function(index){
						var _thisNewValue=trim($("#can_value").val());
						var _thisNewName=trim($("#can_name").val());
						if(_thisNewName==''){
							layer.tips("输入不能为空！",$("#can_name"));
						}else if(_thisNewValue==''){
							layer.tips("输入不能为空！",$("#can_value"));
						}else{
							var candidateHtml='<span candidate='+_thisNewValue+'>'+_thisNewName+'<img src="images/icon_close_blue.png" class="array_close" datatype="list"></span>';
							_this.siblings(".config_candidate_list").append(candidateHtml);
							layer.close(index);
							$(".array_close").click(function(){
								$(this).parent().remove();
							})
						}
					}
				})
			})


		})
	})
})

function limitLClimitH(low,high,thisTarget){
	if(low>=high){
		layer.tips("最大值必须大于最小值",thisTarget);
		return false;
	}else{
		return true;
	}
}

function getSuoShu(url,callback){
	multiSubmit(url,function(){
		if(message=="OK"){
			$('.config_ownerId').html('');
			var options='';
			for(var i=0;i<data.length;i++){
				options+='<option value='+data[i].value+'>'+data[i].name+'</option>'
			}
			$('.config_ownerId').append(options);
			if(callback){
				callback();
			}
		}
	})
}

function checkConfigNull(name,des,value){
	if(name=='' || des=='' || value==''){
		return false;
	}else{
		return true;
	}
}

