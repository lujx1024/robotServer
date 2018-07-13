var pagination=10;
var queueErrorArray;
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

function createCommonConfig(objData){
	$(".common_config_list").html("");
	$(".common_config_list").off("click",".editable_btn");
	$(".common_config_list").off("click",".editable_savebtn");
	$(".common_config_list").off("click",".array_close");
	
	for(var i=0;i<objData.length;i++){
		var dataList=''
		if(objData[i].type=="string"){
			if(objData[i].candidate!=''){
				var caOptions="";
				var candidate=eval("("+objData[i].candidate+")").items;
				for(var j=0;j<candidate.length;j++){
					if(objData[i].value==candidate[j].value){
						caOptions+='<option selected=selected value='+candidate[j].value+'>'+candidate[j].name+'</option>';
					}else{
						caOptions+='<option value='+candidate[j].value+'>'+candidate[j].name+'</option>';
					}				
				}
				dataList='<li dataType='+objData[i].type+'><label for="">'+objData[i].description+'</label><select class="edit_string_sel" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+'>'+caOptions+'</select><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
			}else{
				dataList='<li><label for="">'+objData[i].description+'</label><input type="text" class="edit_string" dataType='+objData[i].type+' value='+objData[i].value+' ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+'><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
			}		
		}else if(objData[i].type=="bool"){
			var checkedFlag='';
			if(objData[i].value=="true"){
				var checkbox='<div><input type="checkbox" checked="checked" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' class="js-switch js-check-change edit_bool"></div>';
			}else{
				var checkbox='<div><input type="checkbox" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' class="js-switch js-check-change edit_bool"></div>';
			}
			dataList='<li><label for="">'+objData[i].description+'</label>'+checkbox+'<button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="module_list"){
			var optionsArray=objData[i].value.split(",");
			var candidate=checkCandidate(objData[i],optionsArray).candidate;
			var moduleResult=checkCandidate(objData[i],optionsArray).checkResult;
			var optionsCon=arrayFormat(moduleResult,"module_list").arrayValue;
			dataList='<li><label for="">'+objData[i].description+'</label><div class="array_bar clearfix">'+optionsCon+'</div><button class="add_list" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>添加<span class="displayNone candidate">'+candidate+'</span></button><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="list"){
			var listArray=eval("("+objData[i].value+")").items;
			var candidate=checkCandidate(objData[i],listArray).candidate;
			var listResult=checkCandidate(objData[i],listArray).checkResult;
			var listArrayCon=arrayFormat(listResult,"list").arrayValue;
			dataList='<li><label for="">'+objData[i].description+'</label><div class="array_bar clearfix">'+listArrayCon+'</div><button class="add_list" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' dataType='+objData[i].type+' pattern='+objData[i].pattern+'>添加<span class="displayNone candidate">'+candidate+'</span></button><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="image_list"){
			var imageArray=eval("("+objData[i].value+")").value;
			var candidate=checkCandidate(objData[i],imageArray).candidate;
			var imageResult=checkCandidate(objData[i],imageArray).checkResult;
			var imageArrayCon=arrayFormat(imageResult,"image_list").arrayValue;
			var imageArrayConVideo=arrayFormat(imageResult,"image_list").arrayValueVideo;
			dataList='<li><label for="">'+objData[i].description+'</label><div class="image_list_type clearfix"><input type="radio" srcType="imageSrc" name="image_list" checked /><span class="fl">云端图片</span><input type="radio" srcType="videoSrc" name="image_list" /><span class="fl">本地视频</span></div><div class="array_bar clearfix">'+imageArrayCon+'</div><div class="clearfix array_bar_imageVideo displayNone">'+imageArrayConVideo+'</div><button class="add_image" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+'  dataType='+objData[i].type+' pattern='+objData[i].pattern+'>添加<span class="displayNone candidate">'+candidate+'</span></button><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="integer"){
			dataList='<li><label for="">'+objData[i].description+'</label><input type="number" class="edit_integer" dataType='+objData[i].type+' value='+objData[i].value+' limitL='+objData[i].limitL+' limitH='+objData[i].limitH+' ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+'><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="float"){
			dataList='<li><label for="">'+objData[i].description+'</label><input type="number" class="edit_float" dataType='+objData[i].type+' value='+objData[i].value+' limitL='+objData[i].limitL+' limitH='+objData[i].limitH+' ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+'><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="patrol"){
			var value=eval("("+objData[i].value+")");
			if(value.canInterupt==true){
				var checkbox='<input type="checkbox" class="js-switch js-check-change patrol_interupt" checked="checked">';
			}else{
				var checkbox='<input type="checkbox" class="js-switch js-check-change patrol_interupt">';
			}
			var patrolPath=value.path;
			var imageArrayCon=arrayFormat(patrolPath,"patrol").arrayValue;
			dataList='<li><label for="">'+objData[i].description+'</label>\
			<div class="clearfix marginBottom10"><span class="fl">是否可打断：</span>'+checkbox+'</div>\
			<div class="clearfix"><span class="fl">循环次数：</span><input type="number" value='+parseFloat(value.repeat)+' class="patrol_repeat" /></div>\
			<div class="array_bar_patrol clearfix">'+imageArrayCon+'</div><button class="add_path" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>继续添加巡游点<span class="displayNone candidate">'+candidate+'</span></button><button class="save_path displayNone">保存所有巡游点</button><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="menu_list"){
			var menuArray=eval("("+objData[i].value+")").items;
			var title=eval("("+objData[i].value+")").title;
			var candidate=checkCandidate(objData[i],menuArray).candidate;
			var menuResult=checkCandidate(objData[i],menuArray).checkResult;
			var memuArrayCon=arrayFormat(menuResult,"menu_list").arrayValue;
			dataList='<li><label for="">'+objData[i].description+'</label><input class="menu_title" value='+title+' /><div class="array_bar clearfix">'+memuArrayCon+'</div><button class="add_list" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' dataType='+objData[i].type+' pattern='+objData[i].pattern+'>添加<span class="displayNone candidate">'+candidate+'</span></button><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}else if(objData[i].type=="menu_matrix"){
			var matrixValue=eval("("+objData[i].value+")").items;
			var imageArrayCon=arrayFormat(matrixValue,"menu_matrix").arrayValue;
			dataList='<li><label for="">'+objData[i].description+'</label><input type="button" value="编辑" class="matrix_eidt" />\
			<div class="array_bar_matrix clearfix">'+imageArrayCon+'</div><button class="add_matrix" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>继续添加<span class="displayNone candidate">'+candidate+'</span></button><button class="save_matrix displayNone">保存</button><button class="cancle_matrix displayNone">取消</button><button class="default_btn" ownerId='+objData[i].ownerId+' priority='+objData[i].priority+' configKey='+objData[i].name+' pattern='+objData[i].pattern+'>使用默认值</button></li>';
		}
		$(".common_config_list").append(dataList);
	}

	var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
	elems.forEach(function(html) {
	  var switchery = new Switchery(html,{size:"small"});
	});

	var matrixHeight=$(".matrix_list").width();
	$(".matrix_list").height(matrixHeight);
	$('.demo').each( function() {
		$(this).minicolors({
			control: $(this).attr('data-control') || 'hue',
			defaultValue: $(this).attr('data-defaultValue') || '',
			inline: $(this).attr('data-inline') === 'true',
			letterCase: $(this).attr('data-letterCase') || 'lowercase',
			opacity: $(this).attr('data-opacity'),
			position: $(this).attr('data-position') || 'bottom left',
			change: function(hex, opacity) {
				if( !hex ) return;
				if( opacity ) hex += ', ' + opacity;
				try {
					console.log(hex);
				} catch(e) {}
			},
			theme: 'bootstrap'
		});
    });
    $(".minicolors-theme-bootstrap .minicolors-swatch").css({"width":"100%","height":matrixHeight});
    $(".minicolors input[type=hidden] + .minicolors-swatch").css("cursor","default");

	function parCandi(iptObj,obj){
		var result=[];
		for(var i=0;i<iptObj.length;i++){
			for(var j=0;j<obj.length;j++){
				if(iptObj[i]==obj[j].name){
					result.push(obj[j].value);
				}
			}
		}
		return result;
	}

	//删除
	closeTag();
	var imgIndex;
	var timer='';
	$(".image_list").hover(function(){
		var _this=$(this);
		var _thisSrc=_this.attr("src");
		timer=setTimeout(function(){
			imgIndex=layer.tips(("<div><img src="+_thisSrc+" style='width:400px;display:block;' /></div>"),_this,{
				tips:[2,"#fff"],
				time:100000000,
				area:["auto","auto"]
			})
		},1000)
	},function(){
		layer.close(imgIndex);
		clearTimeout(timer);
	})
	$(".default_btn").each(function(){
		var _this=$(this);
		if(parseFloat(_this.attr("priority"))==0){
			_this.attr("disabled",true);
		}
	})

	//使用默认值
	$(".default_btn").click(function(){
		var _this=$(this);
		var priority=parseFloat(_this.attr("priority"));
		var ownerId=_this.attr("ownerId");
		var priority=_this.attr("priority");
		var submitData={
			user_id:userId,
			owner_id:ownerId,
			priority:priority,
			config_key:_this.attr("configKey")
		};
		layer.alert("确定恢复默认值吗？",{
			icon:3,
			btn:["确定","取消"],
			yes:function(index){
				layer.close(index);
				subForm("https://"+host+"/signalmaster/rest/delete_config",submitData,function(){
					if(subResult.message=="OK"){
						layer.alert("已使用默认值",{
							icon:1,
							yes:function(index){
								getCurrentRobotCommon();
								layer.close(index);
							}
						})
					}else{
						layer.alert("使用默认值失败："+subResult.message,{icon:5});
					}
				})
			},
			btn2:function(index){
				layer.close(index);
			}
		})
		
	})

	//编辑提交
	var oldValueString,oldValueInte,oldValueFloat;
	editKeyup($(".common_config_list"),'.edit_string');
	editKeyup($(".common_config_list"),'.edit_integer');
	editKeyup($(".common_config_list"),'.edit_float');
	$(".edit_string").focus(function(){
		oldValueString=$(this).val();
	})
	$(".edit_string").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var currentValue=trim(_this.val());
		editSubmitString(_this,currentValue,function(){
			if(subResult.message=="OK"){
				layer.tips("修改保存成功！",_this);
				if(_thisPri==0){
					getCurrentRobotCommon();
				}
			}else{
				_this.val(oldValueString);
				layer.tips("保存失败："+subResult.message,_this);
			}
		});
	})

	$(".edit_string_sel").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var currentValue=_this.val();
		editSubmitString(_this,currentValue,function(){
			if(subResult.message=="OK"){
				layer.tips("修改保存成功",_this);
				if(_thisPri==0){
					getCurrentRobotCommon();
				}
			}else{
				layer.tips(subResult.message,_this);
			}
		});
	})

	$(".edit_integer").focus(function(){
		oldValueInte=$(this).val();
	})
	$(".edit_integer").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var currentValue=parseFloat(trim(_this.val()));
		var limitL=parseFloat(_this.attr("limitL"));
		var limitH=parseFloat(_this.attr("limitH"));
		if(isInteger(currentValue)){
			limit(_this,currentValue,limitL,limitH,oldValueInte,function(){
				if(subResult.message=="OK"){
					layer.tips("修改保存成功",_this);
					if(_thisPri==0){
						getCurrentRobotCommon();
					}
				}else{
					layer.tips(subResult.message,_this);
				}
			});
		}else{
			layer.tips("请输入整数",_this);
			_this.val(oldValueInte);
		}
	})

	$(".edit_float").focus(function(){
		oldValueFloat=$(this).val();
	})
	$(".edit_float").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var currentValue=parseFloat(trim(_this.val()));
		var limitL=parseFloat(_this.attr("limitL"));
		var limitH=parseFloat(_this.attr("limitH"));
		limit(_this,currentValue,limitL,limitH,oldValueFloat,function(){
			if(subResult.message=="OK"){
				layer.tips("修改保存成功",_this);
				if(_thisPri==0){
					getCurrentRobotCommon();
				}
			}else{
				layer.tips(subResult.message,_this);
			}
		});
	})

	var oldValueList='';
	var oldValueMenu='';
	$(".common_config_list").on("click",".editable_btn",function(){
		var _this=$(this);
		setTimeout(function(){
			_this.siblings("input").focus();
			oldValueList=_this.siblings("input").val();
		},1)
		_this.siblings("input").attr("disabled",false).addClass("active");
		_this.addClass("displayNone").siblings(".editable_savebtn").removeClass("displayNone");
	})

	$(".array_bar").on("blur","input",function(){
		var _this=$(this);
		var newValueList=trim($(this).val());
		var _thisValueEle=_this.parent().parent().find("input");
		var _thisCandiParent=_this.parent().parent().siblings(".add_list");
		var _thisPri=parseFloat(_thisCandiParent.attr("priority"));
		var _thisType=_thisCandiParent.attr("dataType");
		if(_thisType=="list" && oldValueList!=newValueList){
			var _thisValueJson=formatValue(_thisValueEle,"edit",'');
			_thisValueJson=JSON.stringify(_thisValueJson);
			editSubmitString(_thisCandiParent,_thisValueJson,function(){
				if(subResult.message=="OK"){
					layer.tips("修改保存成功！",_this);
					if(_thisPri==0){
						getCurrentRobotCommon();
					}
				}else{
					layer.tips("保存失败："+subResult.message,_this);
					_this.val(oldValueList);
				}
			});
		}else if(_thisType=="menu_list" && oldValueList!=newValueList){
			var _thisValueJson=formatValue(_thisValueEle,"edit",'');
			_thisValueJson.title=trim(_this.parent().parent().siblings(".menu_title").val());
			_thisValueJson=JSON.stringify(_thisValueJson);
			editSubmitString(_thisCandiParent,_thisValueJson,function(){
				if(subResult.message=="OK"){
					layer.tips("修改保存成功！",_this);
					if(_thisPri==0){
						getCurrentRobotCommon();
					}
				}else{
					layer.tips("保存失败："+subResult.message,_this);
					_this.val(oldValueList);
				}
			});
		}
		$(this).attr("disabled",true);
		$(this).removeClass("active");
		$(this).siblings(".editable_btn").removeClass("displayNone");
		$(this).siblings(".editable_savebtn").addClass("displayNone");
	})
	$(".menu_title").focus(function(){
		oldValueMenu=$(this).val();
	})
	$(".menu_title").blur(function(){
		var _this=$(this);
		var newValueMenu=trim($(this).val());
		var _thisCandiParent=_this.siblings(".add_list");
		var _thisPri=parseFloat(_thisCandiParent.attr("priority"));
		var _thisValueEle=_this.siblings(".array_bar").find("input");
		var _thisType=_thisCandiParent.attr("dataType");
		if(newValueMenu==''){
			layer.tips("输入不能为空！",_this);
			_this.focus();
		}else{
			if(oldValueMenu!=newValueMenu){
				var _thisValueJson=formatValue(_thisValueEle,"edit",'');
				_thisValueJson.title=newValueMenu;
				_thisValueJson=JSON.stringify(_thisValueJson);
				editSubmitString(_thisCandiParent,_thisValueJson,function(){
					if(subResult.message=="OK"){
						layer.tips("修改保存成功！",_this);
						if(_thisPri==0){
							getCurrentRobotCommon();
						}
					}else{
						layer.tips("保存失败："+subResult.message,_this);
						_this.val(oldValueMenu);
					}
				});
			}
		}
	})
	editKeyup($(".common_config_list"),'.menu_title');

	$(".common_config_list").on("click",".editable_savebtn",function(){
		$(this).siblings("input").trigger("blur");
		$(this).addClass("displayNone").siblings(".editable_btn").removeClass("displayNone");
	})
	editKeyup($(".array_bar"),'input');

	$(".edit_bool").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var _thisValueBool=_this.get(0).checked;
		editSubmitString(_this,_thisValueBool,function(){
			if(subResult.message!="OK"){
				layer.tips("保存失败："+subResult.message,_this);
				_this.get(0).checked=(!_thisValueBool);
			}else{
				if(_thisPri==0){
					getCurrentRobotCommon();
				}
			}
		});
	})

	$(".array_bar_patrol").on("click",".patrol_edit",function(){
		var _this=$(this);
		var _parent=_this.parent();
		_parent.find("input").attr("disabled",false).eq(2).focus();
		_this.addClass("displayNone");
		_parent.parent().siblings(".save_path").removeClass("displayNone");

	})

	$(".save_path").click(function(){
		var _this=$(this);
		var _thisParent=_this.parent();
		var parentObj=_this.siblings(".array_bar_patrol").children(".patrol_list");
		var _thisCandiParent=_this.siblings(".add_path");
		var _thisPri=parseFloat(_thisCandiParent.attr("priority"));
		var _thisInterupt=_thisParent.find(".patrol_interupt").get(0).checked;
		var _thisRepeat=_thisParent.find(".patrol_repeat").val();
		var patrolJson={};
		var isNull=getPath(parentObj).isNull;
		patrolJson.path=getPath(parentObj).path;
		patrolJson.canInterupt=_thisInterupt;
		patrolJson.repeat=_thisRepeat;
		patrolJson=JSON.stringify(patrolJson);
		if(!isNull){
			editSubmitString(_thisCandiParent,patrolJson,function(){
				if(subResult.message=="OK"){
					layer.alert("保存成功！",{
						icon:1,
						yes:function(index){
							if(_thisPri==0){
								getCurrentRobotCommon();
							}
							layer.close(index);
						}
					});
				}else{
					layer.alert("保存失败："+subResult.message,{icon:5,
						yes:function(index){
							getCurrentRobotCommon();
							layer.close(index);
						}
					});
					
				}
			});
			parentObj.find("input").attr("disabled",true);
			parentObj.children(".patrol_edit").removeClass("displayNone");
			_this.addClass("displayNone");
		}
		
	})

	$(".patrol_interupt").change(function(){
		var _this=$(this);
		var _thisPos=_this.siblings(".switchery");
		var parentObj=_this.parent().siblings(".array_bar_patrol").children(".patrol_list");
		var _thisParent=_this.parent().siblings(".add_path");
		var _thisPri=parseFloat(_thisParent.attr("priority"));
		var _thisInterupt=_this.get(0).checked;
		var patrolJson={};
		var _thisRepeat=parseFloat(_this.parent().siblings().children(".patrol_repeat").val());
		patrolJson.path=getPath(parentObj).path;
		patrolJson.canInterupt=_thisInterupt;
		patrolJson.repeat=_thisRepeat;
		patrolJson=JSON.stringify(patrolJson);
		editSubmitString(_thisParent,patrolJson,function(){
			if(subResult.message!="OK"){
				layer.tips("保存失败："+subResult.message,_thisPos);
				_this.get(0).checked=(!_thisInterupt);
			}else{
				layer.tips("修改保存成功",_thisPos);
				if(_thisPri==0){
					getCurrentRobotCommon();
				}
			}
		});
	})
	var oldValuePatrol;
	$(".patrol_repeat").focus(function(){
		oldValuePatrol=parseFloat($(this).val());
	})
	$(".patrol_repeat").change(function(){
		var _this=$(this);
		var patrolJson={};
		var parentObj=_this.parent().siblings(".array_bar_patrol").children(".patrol_list");
		var _thisParent=_this.parent().siblings(".add_path");
		var _thisPri=parseFloat(_thisParent.attr("priority"));
		var _thisInterupt=_this.parent().siblings().children(".patrol_interupt").get(0).checked;
		var _thisRepeat=parseFloat(_this.val());
		patrolJson.path=getPath(parentObj).path;
		patrolJson.canInterupt=_thisInterupt;
		patrolJson.repeat=_thisRepeat;
		patrolJson=JSON.stringify(patrolJson);
		editSubmitString(_thisParent,patrolJson,function(){
			if(subResult.message=="OK"){
				layer.tips("修改保存成功！",_this);
				if(_thisPri==0){
					getCurrentRobotCommon();
				}
			}else{
				layer.tips(('保存失败：'+subResult.message),_this);
				_this.val(oldValuePatrol);
			}
		})
	})
	editKeyup($(".common_config_list"),".patrol_repeat");

	$(".add_path").click(function(){
		var _this=$(this);
		var _thisParent=_this.siblings(".array_bar_patrol");
		var radioIndex=_thisParent.find(".patrol_list").length;
		var arrayValue='<div class="patrol_list">\
			<div class="clearfix marginBottom10"><em>定位点：</em><div class="fl patrol_position"><input type="radio" name=xyr'+radioIndex+' checked="checked" indexClass="patrol_index" notIndexClass="patrol_xyr" /><em>位置</em><input type="radio" name=xyr'+radioIndex+' indexClass="patrol_xyr" notIndexClass="patrol_index" /><em>坐标</em></div></div>\
			<div class="clearfix marginBottom10 patrol_index"><em>定位点编号：</em><input type="number" pathName="index" ></div>\
			<div class="clearfix marginBottom10 patrol_xyr displayNone"><em>x：</em><input type="number" pathName="x" /><em>y：</em><input type="number" pathName="y" /><em>r：</em><input type="number" pathName="r" /></div>\
			<div class="clearfix marginBottom10"><em>语音播报：</em><input type="text" pathName="content" /></div>\
			<div class="clearfix marginBottom10"><em>停留时间(ms)：</em><input type="number" pathName="stay" /></div>\
			<img src="images/icon_close_blue.png" class="array_close" dataType="patrol" /><i class="icon-pencil patrol_edit displayNone"></i></i>\
			</div><i class="icon-long-arrow-right path_next"></i>';
		_thisParent.append(arrayValue);
		_this.siblings(".save_path").removeClass("displayNone");
	})


	//巡游路径
	$(".array_bar_patrol").on("click",".patrol_position input[type='radio']",function(){
		var indexClass=$(this).attr("indexClass");
		var notIndexClass=$(this).attr("notIndexClass");
		$(this).parent().parent().siblings("."+indexClass).removeClass("displayNone");
		$(this).parent().parent().siblings("."+indexClass).children("input").eq(0).focus();
		$(this).parent().parent().siblings("."+notIndexClass).addClass("displayNone");
	})

	//添加
	$(".add_list").click(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var _thisType=_this.attr("dataType");
		var _thisTitle=_this.siblings(".menu_title").val();
		var _thisParent=$(this).siblings(".array_bar");
		var addListParent=_thisParent.find("input");
		var addListHtml='<textarea class="add_list_input" placeholder="请输入"></textarea>';
		layer.open({
		  	title : '添加',
		  	type: 1,
		  	skin: 'layui-layer-rim', //加上边框
		  	area: ['400px', '260px'], //宽高
		  	btn:["确定","取消"],
		  	yes:function(index){
		  		var addValue=trim($(".add_list_input").val());
		  		if(addValue!=''){
		  			if(_thisType=="list"){
		  				var _thisValueJson=formatValue(addListParent,"add",addValue);
		  				_thisValueJson=JSON.stringify(_thisValueJson);
		  			}else if(_thisType=="menu_list"){
		  				var _thisValueJson=formatValue(addListParent,"add",addValue);
		  				_thisValueJson.title=_thisTitle;
		  				_thisValueJson=JSON.stringify(_thisValueJson);
		  			}
		  			editSubmitString(_this,_thisValueJson,function(){
		  				if(subResult.message=="OK"){
		  					var addHtml='<span><input type="text" value='+addValue+' disabled="disabled" /><img src="images/icon_close_blue.png" class="array_close" dataType='+_thisType+' /><i class="icon-pencil editable_btn" ></i><i class="icon-save editable_savebtn displayNone"></i></span>';
		  					_thisParent.append(addHtml);
		  					layer.close(index);
		  					if(_thisPri==0){
								getCurrentRobotCommon();
							}
		  				}else{
		  					layer.close(index);
		  					layer.alert("添加失败："+subResult.message,{icon:5})
		  				}
		  			});
		  		}else{
		  			layer.tips("输入不能为空！",".add_list_input")
		  		}
		  	},
		  	content: addListHtml,
		});
	})

	//iamge_list添加
	var imageOldSrc='';
	$(".image_list_type input").click(function(){
		var _this=$(this);
		var _thisParent=_this.parent();
		if(_this.attr("srcType")=="videoSrc"){
			_thisParent.siblings(".array_bar_imageVideo").removeClass("displayNone");
			_thisParent.siblings(".array_bar").addClass("displayNone");
		}else{
			_thisParent.siblings(".array_bar").removeClass("displayNone");
			_thisParent.siblings(".array_bar_imageVideo").addClass("displayNone");
		}
	})
	$(".array_bar_imageVideo").on("focus",".image_list_input",function(){
		imageOldSrc=$(this).val();
	})
	$(".array_bar_imageVideo").on("blur",".image_list_input",function(){
		var _this=$(this);
		var _thisParent=_this.parent();
		var _thisParentParent=_thisParent.parent();
		var _thisAttr=_thisParentParent.siblings(".add_image");
		var _thisPri=_thisAttr.attr("priority");
		var _thisValue=trim(_this.val());
		var _thisVideoParent=_thisParentParent.children(".image_list_box_video");
		var _thisImageParent=_thisParentParent.siblings(".array_bar");
		var oldVideoList=[];
		var oldImageList=[];
		var imageList=[];
		var imageJson={};
		_thisVideoParent.find(".image_list_input").each(function(){
			if(trim($(this).val())!=''){
				oldVideoList.push($(this).val());
			}
		})
		_thisImageParent.find(".image_list").each(function(){
			oldImageList.push($(this).attr("src"));
		})
		imageList=oldVideoList.concat(oldImageList);
		imageJson.value=imageList;
	    imageJson=JSON.stringify(imageJson);
	    if(_thisValue==''){
	    	layer.tips("输入不能为空，请输入！",_this);
	    }else if(_thisValue!=imageOldSrc){
			editSubmitString(_thisAttr,imageJson,function(){
				if(subResult.message=="OK"){
					layer.alert("保存成功！",{
						icon:1,
						yes:function(index){
							if(_thisPri==0){
								getCurrentRobotCommon();
							}
							layer.close(index);
						}
					});	
				}else{
					layer.alert("保存失败："+subResult.message,{
						icon:5,
						yes:function(index){
							getCurrentRobotCommon();
							layer.close(index);
						}
					});					
				}
			});
		}
	})

	$(".add_image").click(function(){
		var imageJson={};
		var _this=$(this);
		var _thisSibling=_this.siblings(".image_list_type");
		var _thisPri=parseFloat(_this.attr("priority"));
		var _thisType=_this.attr('dataType');
		var _thisImageParent=_this.siblings(".array_bar");
		var _thisVideoParent=_this.siblings(".array_bar_imageVideo");
		var oldVideoList=[];
		var oldImageList=[];
		_thisImageParent.find(".image_list").each(function(){
			oldImageList.push($(this).attr("src"));
		})
		_thisVideoParent.find(".image_list_input").each(function(){
			if(trim($(this).val())!=''){
				oldVideoList.push($(this).val());
			}
		})
		if(_thisSibling.find("input[type=radio]:checked").attr("srcType")=="imageSrc"){
			var uploadHtml='\
				<div id="swfupload">\
				    <span id="spanButtonPlaceholder"></span>\
				    <p id="queueStatus"></p>\
				    <ol id="logList" class="clearfix"></ol>\
				</div>\
				<div class="formsub_box clearfix">\
				    <input id="swfUploadSubmit" type="button" value="确定" class="submit_btn fl"/>\
				    <input id="swfUploadCancle" type="button" value="取消" class="cancle_btn fr"/>\
			    </div>'
			var layerIndex=layer.open({
			  	title : '上传文件',
			  	type: 1,
			  	skin: 'layui-layer-rim', //加上边框
			  	area: ['800px', '600px'], //宽高
			  	content: uploadHtml
			});

			var swfUpload = new SWFUpload({  
		        upload_url:"https://"+host+"/signalmaster/upload",  
		        flash_url:'./js/swfupload/swfupload.swf',  
		        file_post_name: 'fileData',  
		        use_query_string: true,   
		        file_types: "*.jpg;*.png;*.jpeg;*.gif;*.bmp",  
		        file_types_description: '上报数据文件',  
		        file_size_limit: '102400',   
		        file_queue_limit: 3, 
		        file_dialog_start_handler: fileDialogStart,  
		        file_queued_handler: fileQueued,  
		        file_queue_error_handler: fileQueueError,  
		        file_dialog_complete_handler: fileDialogComplete,  
		        upload_start_handler: uploadStart,  
		        upload_progress_handler: uploadProgress,  
		        upload_success_handler: uploadSuccess,  
		        upload_complete_handler: uploadComplete,  
		          
		        button_placeholder_id: 'spanButtonPlaceholder',  
		        button_text: '<span class="whiteFont"></span>',  
		        button_text_style: '.whiteFont{ color: #FFFFFF; }',  
		        button_text_left_padding: 40,  
		        button_text_top_padding: 6,  
		        button_image_url:'./images/button.png',  
		        button_width: 134,  
		        button_height: 30,  
		        button_cursor: SWFUpload.CURSOR.HAND,  
		        button_window_mode: SWFUpload.WINDOW_MODE.TRANSPARENT,  	          
		        debug: false,    
		        custom_settings: {}  
		    });

		    $("#swfUploadSubmit").click(function(){
		    	var addImgArray=[];
		    	var imageInsertHtml='';
		    	$("#logList li").each(function(){
		    		if($(this).css("display")!="none"){
		    			var currentImageUrl=$(this).find("span.progressValue").attr("backUrl");
		    			imageInsertHtml+='<span class="image_list_box"><img src="'+currentImageUrl+'" class="image_list" /><img src="images/icon_close_blue.png" class="array_close" dataType='+_thisType+' /></span>';
		    			addImgArray.push(currentImageUrl);
		    		}
		    	})
		    	imageList=oldVideoList.concat(addImgArray).concat(oldImageList);
		    	imageJson.value=imageList;
		    	imageJson=JSON.stringify(imageJson);
		    	editSubmitString(_this,imageJson,function(){
		    		if(subResult.message=="OK"){
		    			_thisImageParent.append(imageInsertHtml);
		    			layer.closeAll();
		    			if(_thisPri==0){
							getCurrentRobotCommon();
						}
						$(".image_list").hover(function(){
							var _this=$(this);
							var _thisSrc=_this.attr("src");
							timer=setTimeout(function(){
								imgIndex=layer.tips(("<div><img src="+_thisSrc+" style='width:400px;display:block;' /></div>"),_this,{
									tips:[2,"#fff"],
									time:100000000,
									area:["auto","auto"]
								})
							},1000)
						},function(){
							layer.close(imgIndex);
							clearTimeout(timer);
						})
						$(".default_btn").each(function(){
							var _this=$(this);
							if(parseFloat(_this.attr("priority"))==0){
								_this.attr("disabled",true);
							}
						})
		    		}else{
		    			layer.alert("添加失败："+subResult.message,{icon:5});
		    			layer.closeAll();
		    		}
		    	});
		    })
		    $("#swfUploadCancle").click(function(){
		    	layer.close(layerIndex);
		    })
		}else{
			var videoInput='<div class="image_list_box_video clearfix"><em class="image_list_videosrc fl">本地视频：</em><input type="text" class="fl image_list_input" /><img src="images/icon_close_blue.png" class="array_close" dataType="image_list" /></div>';
			_thisVideoParent.append(videoInput);
		}
		
	})

	//六宫格画面
	$(".cancle_matrix").click(function(){
		getCurrentRobotCommon();
	})
	var matrixTips='';
	$(".save_matrix").click(function(){
		var _this=$(this);
		var _thisSiblings=_this.siblings(".add_matrix");
		var _thisPri=parseFloat(_thisSiblings.attr("priority"));
		var _thisParent=_this.siblings(".array_bar_matrix").children(".matrix_list");
		var _thisValue=getMatrix(_thisParent).martrixValue;
		var isNull=getMatrix(_thisParent).isNull;
		_thisValue=JSON.stringify(_thisValue);
		if(!isNull){
			editSubmitString(_thisSiblings,_thisValue,function(){
				if(subResult.message=="OK"){
					layer.alert("保存成功！",{
						icon:1,
						yes:function(index){
							if(_thisPri==0){
								getCurrentRobotCommon();
							}
							layer.close(index);
						}
					});	
				}else{
					layer.alert("保存失败："+subResult.message,{
						icon:5,
						yes:function(index){
							getCurrentRobotCommon();
							layer.close(index);
						}
					});					
				}	
			})
			$(".matrix_content").removeClass("matrix_content_edit").attr("disabled",true);
			$(".matrix_color").attr("disabled",true);
			$(".matrix_icon").css("cursor","default");
			$(".array_bar_matrix").off("click",".matrix_icon");
			$(".array_bar_matrix").off("click",".matrix_icon:last");
			$(".minicolors input[type=hidden] + .minicolors-swatch").css("cursor","default");
			_this.addClass("displayNone");
			$(".cancle_matrix").addClass("displayNone");
		}
	})

	$(".matrix_eidt").on("click",function(){
		$(".matrix_color").attr("disabled",false);
		$(".matrix_icon").css("cursor","pointer");
		$(".minicolors input[type=hidden] + .minicolors-swatch").css("cursor","pointer");
		$(".matrix_content").addClass("matrix_content_edit").attr("disabled",false);
		$(".save_matrix").removeClass("displayNone");
		$(".cancle_matrix").removeClass("displayNone");
		//上传icon
		$(".array_bar_matrix").on("click",".matrix_icon",function(){
			var _this=$(this);
			uploadIcon(_this);
		})
	})

	$(".add_matrix").click(function(){
		if($(".matrix_list").length>6){
			layer.alert("最多只有六个模块，不能再增加！")
		}else{
			var arrayValue='<div class="matrix_list">\
				<input type="hidden" id="hidden-input" class="demo matrix_color" value="#2eaef8" ><div class="matrix_other">\
				<img src="images/icon_add.png" class="matrix_icon"/>\
				<input class="matrix_content matrix_content_edit" ></div>\
				<img src="images/icon_close_blue.png" class="array_close" dataType="menu_matrix" />\
			</div>';
			$(".array_bar_matrix").append(arrayValue);
			var matrixHeight=$(".matrix_list").width();
			$(".matrix_list").height(matrixHeight);
			$('.demo').each( function() {
				$(this).minicolors({
					control: $(this).attr('data-control') || 'hue',
					defaultValue: $(this).attr('data-defaultValue') || '',
					inline: $(this).attr('data-inline') === 'true',
					letterCase: $(this).attr('data-letterCase') || 'lowercase',
					opacity: $(this).attr('data-opacity'),
					position: $(this).attr('data-position') || 'bottom left',
					change: function(hex, opacity) {
						if( !hex ) return;
						if( opacity ) hex += ', ' + opacity;
						try {
							console.log(hex);
						} catch(e) {}
					},
					theme: 'bootstrap'
				});
		    });
		    var matrixLength=$(".matrix_list").length-1;
		    $(".minicolors-theme-bootstrap .minicolors-swatch").eq(matrixLength).css({"width":"100%","height":matrixHeight});
		    $(".minicolors input[type=hidden] + .minicolors-swatch").eq(matrixLength).css("cursor","pointer");
		    $(".matrix_icon").eq(matrixLength).css("cursor","pointer");
		    $(".save_matrix").removeClass("displayNone");
		    $(".cancle_matrix").removeClass("displayNone");
		    $(".array_bar_matrix").on("click",".matrix_icon:last",function(){
				var _this=$(this);
				uploadIcon(_this);
			})
		}		
	})

	function formatValue(valueObj,actionType,addValue){
		var _thisValueJson={};
		var _thisValueArray=[];
		valueObj.each(function(){
			_thisValueArray.push($(this).val());
		})
		if(actionType=="edit"){
			_thisValueJson.items=_thisValueArray;
		}else if(actionType=="add"){
			_thisValueArray.push(addValue);
		  	_thisValueJson.items=_thisValueArray;
		}
		return _thisValueJson;
	}

	//check candidate
	function checkCandidate(checkObj,original){
		var checkResult=[];
		var candidate='';
		if(checkObj.candidate==''){
			checkResult=original;
		}else{
			if(checkObj.type!="string"){
				candidate=eval("("+checkObj.candidate+")").items;
				for(var i=0;i<original.length;i++){
					for(var j=0;j<candidate.length;j++){
						if(original[i]==candidate[j].value){
							original[i]=candidate[j].name;
						}
					}
				}
				checkResult=original;
			}	
		}
		return {checkResult:checkResult,candidate:checkObj.candidate};
	}

	function closeTag(){
		$(".common_config_list").on("click",".array_close",function(){
			var _this=$(this);
			var _thisType=_this.attr("dataType");
			var _thisParentParent=_this.parent().parent();
			var _thisCandiParent=_thisParentParent.siblings(".add_list");
			var _thisPri=_thisCandiParent.attr("priority");
			var _thisParentSiblings=_this.parent().siblings("span").children('input');
			if(_thisType=="list"){
				var _thisValueJson=formatValue(_thisParentSiblings,"edit",'');
  				_thisValueJson=JSON.stringify(_thisValueJson);
  				editSubmitString(_thisCandiParent,_thisValueJson,function(){
  					if(subResult.message=="OK"){
  						if(_thisPri==0){
  							getCurrentRobotCommon();
  						}else{
  							_this.parent().remove();
  						}
  					}else{
  						layer.alert("删除失败！"+subResult.message);
  					}
  				});
  				
			}else if(_thisType=="menu_list"){
				var _thisTitle=_thisParentParent.siblings(".menu_title").val();
				var _thisValueJson=formatValue(_thisParentSiblings,"edit",'');
				_thisValueJson.title=_thisTitle;
  				_thisValueJson=JSON.stringify(_thisValueJson);
  				editSubmitString(_thisCandiParent,_thisValueJson,function(){
  					if(subResult.message=="OK"){
  						if(_thisPri==0){
  							getCurrentRobotCommon();
  						}else{
  							_this.parent().remove();
  						}
  					}else{
  						layer.alert("删除失败！"+subResult.message);
  					}
  				});
			}else if(_thisType=="image_list"){
				var _thisValueArray=[];
				var _thisCheckTypeEle=_thisParentParent.siblings(".image_list_type");
				var _thisCheckType=_thisCheckTypeEle.children("input[type='radio']:checked").attr("srcType");
				if(_thisCheckType=="videoSrc"){
					var _thisInputVal=trim(_this.siblings(".image_list_input").val());
					if(_thisInputVal==''){
						_this.parent().remove();
					}else{
						var _thisImageParent=_thisParentParent.siblings(".array_bar");
						var _thisVideoParent=_this.parent().siblings(".image_list_box_video");
						var oldVideoList=[];
						var oldImageList=[];
						_thisImageParent.find(".image_list").each(function(){
							oldImageList.push($(this).attr("src"));
						})
						_thisVideoParent.find(".image_list_input").each(function(){
							if(trim($(this).val())!=''){
								oldVideoList.push($(this).val());
							}
						})
						_thisValueArray=oldVideoList.concat(oldImageList);
						var _thisValueJson={};
						_thisCandiParent=_thisParentParent.siblings(".add_image");
						_thisValueJson.value=_thisValueArray;
						_thisValueJson=JSON.stringify(_thisValueJson);
						editSubmitString(_thisCandiParent,_thisValueJson,function(){
							if(subResult.message=="OK"){
								if(_thisPri==0){
									getCurrentRobotCommon();
								}else{
									_this.parent().remove();
								}	
		  					}else{
		  						layer.alert("删除失败！"+subResult.message);
		  					}
						});
					}	
				}else{
					var _thisImageParent=_this.parent().siblings(".image_list_box");
					var _thisVideoParent=_thisParentParent.siblings(".array_bar_imageVideo");
					var oldVideoList=[];
					var oldImageList=[];
					_thisImageParent.find(".image_list").each(function(){
						oldImageList.push($(this).attr("src"));
					})
					_thisVideoParent.find(".image_list_input").each(function(){
						if(trim($(this).val())!=''){
							oldVideoList.push($(this).val());
						}
					})
					_thisValueArray=oldVideoList.concat(oldImageList);
					var _thisValueJson={};
					_thisCandiParent=_thisParentParent.siblings(".add_image");
					_thisValueJson.value=_thisValueArray;
					_thisValueJson=JSON.stringify(_thisValueJson);
					editSubmitString(_thisCandiParent,_thisValueJson,function(){
						if(subResult.message=="OK"){
	  						if(_thisPri==0){
								getCurrentRobotCommon();
							}else{
								_this.parent().remove();
							}
	  					}else{
	  						layer.alert("删除失败！"+subResult.message);
	  					}
					});
				}
			}else if(_thisType=="patrol"){
				var _thisJson={};
				_thisCandiParent=_thisParentParent.siblings(".add_path");
				var _thisInterupt=_thisParentParent.siblings().find(".patrol_interupt").get(0).checked;
				var _thisRepeat=parseFloat(_thisParentParent.siblings().find(".patrol_repeat").val());
				var _thisParent=_this.parent();
				var _thisNext=_thisParent.next();
				var _thisObj=_thisParent.siblings(".patrol_list");
				if(pathIsNull(_thisParent)){
					_thisParent.remove();
					_thisNext.remove();
				}else{
					_thisJson.path=getPath(_thisObj).path;
					_thisJson.canInterupt=_thisInterupt;
					_thisJson.repeat=_thisRepeat;
					_thisJson=JSON.stringify(_thisJson);
					editSubmitString(_thisCandiParent,_thisJson,function(){
						if(subResult.message=="OK"){
	  						_thisParent.remove();
							_thisNext.remove();
	  					}else{
	  						layer.alert("删除失败！"+subResult.message);
	  					}
					});
				}	
			}else if(_thisType=="menu_matrix"){
				var _thisJson={};
				_thisCandiParent=_thisParentParent.siblings(".add_matrix");
				var _thisPri=parseFloat(_thisCandiParent.attr("priority"));
				var _thisParent=_this.parent();
				var _thisObj=_thisParent.siblings(".matrix_list");
				var _thisValue=getMatrix(_thisObj).martrixValue;
				var isNull=matrixIsNull(_thisParent);
				console.log(isNull)
				_thisValue=JSON.stringify(_thisValue);
				if(isNull){
					_thisParent.remove();
				}else{
					editSubmitString(_thisCandiParent,_thisValue,function(){
						if(subResult.message=="OK"){
							if(_thisPri==0){
								getCurrentRobotCommon();
							}else{
								_thisParent.remove();
							}
	  						
	  					}else{
	  						layer.alert("删除失败！"+subResult.message);
	  					}
					});
				}	
			}
		})
	}

}

function pathIsNull(obj){
	var _thisValue=obj.find("input[type!='radio']");
	var isNull=true;
	for(var i=0;i<_thisValue.length;i++){
		if(_thisValue[i].value){
			isNull=false;
			break;
		}
	}
	return isNull;
}

function matrixIsNull(obj){
	var _thisValue=trim(obj.find(".matrix_content").val());
	var _thisIcon=obj.find(".matrix_icon").attr("src");
	var isNull=true;
	if(_thisValue!='' && _thisIcon!="images/icon_add.png"){
		isNull=false;
	}
	return isNull;
}


//切换机器人
function changeRobots(url,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:url,
		success:function(result){
			data=result.data;
			console.log(result)
			if(result.code==0){
				if(data!=undefined){
					createCommonConfig(data);
					if(callback){
						callback();
					}
				}else{
					$(".common_config_list").html("");
				}
				layer.closeAll();
			}else if(result.code==82){
				layer.closeAll()
				layer.alert(result.message,{
					yes:function(index){
						$(".user_quit").trigger("click");
					}
				});
			}else{
				layer.closeAll()
				layer.alert(result.message);
			}
			
		},
		error:function(result){
			alert('服务器异常！')
		}
	})
}

function getCurrentRobotCommon(){
	var ownerId=whichRobotCommon().ownerId;
	var priority=whichRobotCommon().priority;
	var currentRobotUrl='';
	if(ownerId==7){
		currentRobotUrl="https://"+host+"/signalmaster/rest/config/main/"+ownerId+"/255/null";
	}else{
		currentRobotUrl="https://"+host+"/signalmaster/rest/config/main/"+ownerId+"/"+priority+"/null";
	}
	changeRobots(currentRobotUrl);
}

//swfupload
function fileDialogStart() {  
    if (queueErrorArray) {  
        queueErrorArray = null;  
    }  
} 

function fileQueued(file) {  
    var swfUpload = this;  
    var listItem = '<li id="' + file.id + '"><div class="upload_mask">';  
    listItem += '<em>' + file.name + '</em>(' + Math.round(file.size/1024) + ' KB)';  
    listItem +='<div class="progressBar"><div class="progress"></div></div>' 
              +'<span class="progressValue"></span>' 
              + '<p class="status" >Pending</p>'  
              + '<span class="cancel" > </span>'  
              + '</div></li>';  
    $("#logList").append(listItem);  
    $("li#" + file.id + " .cancel").click(function(e) {  
        swfUpload.cancelUpload(file.id);  
        $("li#" + file.id).slideUp('fast');  
    })  
	//swfUpload.startUpload();  
}  

function fileQueueError(file,errorCode,message) {  
    if (errorCode == SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {  
        alert("上传队列中最多只能有3个文件等待上传.");  
        return;  
    }  
    if (!queueErrorArray) {  
        queueErrorArray = [];  
    }  
    var errorFile = {  
        file: file,  
        code: errorCode,  
        error: ''  
    };  
    switch (errorCode) {  
    case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:  
        errorFile.error = '文件大小超出限制.';  
        break;  
    case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:  
        errorFile.error = '文件类型受限.';  
        break;  
    case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:  
        errorFile.error = '文件为空文件.';  
        break;  
    default:  
        alert('加载入队列出错.');  
        break;  
    }  
    queueErrorArray.push(errorFile);  
}  

function fileQueueErrorM(file,errorCode,message) {  
    if (errorCode == SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED) {  
        alert("只能上传一张图片.");  
        return;  
    }  
    if (!queueErrorArray) {  
        queueErrorArray = [];  
    }  
    var errorFile = {  
        file: file,  
        code: errorCode,  
        error: ''  
    };  
    switch (errorCode) {  
    case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:  
        errorFile.error = '文件大小超出限制.';  
        break;  
    case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:  
        errorFile.error = '文件类型受限.';  
        break;  
    case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:  
        errorFile.error = '文件为空文件.';  
        break;  
    default:  
        alert('加载入队列出错.');  
        break;  
    }  
    queueErrorArray.push(errorFile);  
}  


function fileDialogComplete(numSelected,numQueued,numTotalInQueued) {  
    var swfupload = this;  
    if (queueErrorArray && queueErrorArray.length) {  
        var table = $('<table><tr><td>文件</td><td>大小</td></tr></table>');  
        for(var i in queueErrorArray) {  
            var tr = $('<tr></tr>');  
            var info = '<td>' + queueErrorArray[i].file.name + '<span style="color:red">('   
                        + queueErrorArray[i].error + ')</span></td>'  
                        + '<td>' + queueErrorArray[i].file.size + 'bytes</td>';  
            table.append(tr.append(info));  
        }  
        $.ligerDialog.open({  
            width: 500,  
            content: table,  
            title: '文件选择错误提示',  
            buttons: [{  
                text: '确定',  
                onclick: function(btn,dialog,index) {  
                    $("#queueStatus").text('选择文件: ' + numSelected   
                            + ' / 加入队列文件: ' + numQueued);  
                    swfupload.startUpload();  
                    dialog.close();  
                }  
            }]  
        });  
        queueErrorArray = [];  
    } else {  
        this.startUpload();  
    }  
}  

function uploadStart(file) {  
    if (file) {  
        $("#logList li#" + file.id).find('p.status').text('上传中...');  
        $("#logList li#" + file.id).find('p.progressValue').text('0%');  
    }  
} 

function uploadProgress(file,bytesCompleted,bytesTotal) {  
    var percentage = Math.round((bytesCompleted / bytesTotal) * 100);  
    $("#logList li#" + file.id).find('div.progress').css('width',percentage + '%');  
    $("#logList li#" + file.id).find('span.progressValue').text(percentage + '%');  
} 

function uploadSuccess(file,serverData,response) {  
    var url=eval("("+serverData+")").url;
    var item = $("#logList li#" + file.id);  
    item.find('div.progress').css('width','100%');  
    item.find('span.progressValue').css('color','#33b2ff').text('100%').attr("backurl",url);  
    item.find("div.upload_mask").css("display","block");
    item.addClass('success').find('p.status').html('上传完成!'); 
    item.css({"background":"url("+url+") no-repeat center"});
    item.css({"background-size":"contain"});
} 

function uploadComplete(file) {  
    this.uploadStart();  
} 