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

/*创建table列表*/
function createPageContent(parent,data,num,pagination){
	console.log(data)
	var dataOwner;
	var regJson=/^\s*\{/;
	parent.html('');
	var pageCount=Math.ceil(data.length/pagination);

	//判断是不是最后一页
	if(num==pageCount){
		for(var i=((num-1)*pagination);i<(data.length);i++){
			typeList(data[i],i)
		}
	}else{
		for(var i=((num-1)*pagination);i<(num*pagination);i++){
			typeList(data[i],i)
		}
	}
	var keyTimer='';
	var keyIndex='';
	$(".table_senior tr td").hover(function(){
		var _this=$(this);
		var _thisAttr=_this.attr("configKey");
		clearTimeout(keyTimer);
		if(_thisAttr!=undefined){
			keyTimer=setTimeout(function(){
				keyIndex=layer.tips(_thisAttr,_this,{
				   	tips: [4, '#3595CC'],
				  	time: 6000
				})
			},500)
		}
	},function(){
		clearTimeout(keyTimer);	
	})

	function typeList(dataList,i){
		switch(dataList.type){
			case "string":
				if(dataList.candidate==''){
					var dataType=dataTr(dataList.name,'<input type="text" value='+dataList.value+' priority='+dataList.priority+' ownerId='+dataList.ownerId+' configKey='+dataList.name+' class="senior_edit_string" />',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
					dataType.appendTo(parent);
					$(".table_senior tr").eq(i%10).find(".senior_edit_string").attr("pattern",dataList.pattern)
				}else{
					var candidate=eval("("+dataList.candidate+")").items;
					var candiHtml='';
					for(var j=0;j<candidate.length;j++){
						if(dataList.value==candidate[j].value){
							candiHtml+='<option selected="selected" value='+candidate[j].value+'>'+candidate[j].name+'</option>';
						}else{
							candiHtml+='<option value='+candidate[j].value+'>'+candidate[j].name+'</option>'
						}
					}
					var dataType=dataTr(dataList.name,'<select priority='+dataList.priority+' ownerId='+dataList.ownerId+' configKey='+dataList.name+' class="senior_edit_select">'+candiHtml+'</select>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
					dataType.appendTo(parent);
					$(".table_senior tr").eq(i%10).find(".senior_edit_select").attr("pattern",dataList.pattern)
				}
				break;
			case "bool":
				var booleanBox='';
				if(dataList.value=="false"){
					booleanBox= '<input priority='+dataList.priority+' ownerId='+dataList.ownerId+' configKey='+dataList.name+' type="checkbox" class="senior_edit_bool js-switch js-check-change" />';
					
				}else{
					booleanBox= '<input priority='+dataList.priority+' ownerId='+dataList.ownerId+' configKey='+dataList.name+' type="checkbox" class="senior_edit_bool js-switch js-check-change" checked />';
				}
				var dataType=dataTr(dataList.name,booleanBox,dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find(".senior_edit_bool").attr("pattern",dataList.pattern)
				
				break;
			case "integer":
				var dataType=dataTr(dataList.name,'<input type="number" priority='+dataList.priority+' ownerId='+dataList.ownerId+' configKey='+dataList.name+' class="senior_edit_integer" value='+dataList.value+' limitL='+dataList.limitL+'  limitH='+dataList.limitH+' >',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find(".senior_edit_integer").attr("pattern",dataList.pattern)
				break;	
			case "float":
				var dataType=dataTr(dataList.name,'<input type="number" priority='+dataList.priority+' ownerId='+dataList.ownerId+' configKey='+dataList.name+' class="senior_edit_float" value='+dataList.value+' limitL='+dataList.limitL+' limitH='+dataList.limitH+' >',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find(".senior_edit_float").attr("pattern",dataList.pattern)
				break;
			case "list":
				var dataType=dataTr(dataList.name,'<img priority='+dataList.priority+' ownerId='+dataList.ownerId+' description='+dataList.description+' configKey='+dataList.name+' class="preview_btn" src="images/icon_json.png"><span class="list_value_con displayNone">'+dataList.value+'</span><span class="candidate_con displayNone">'+dataList.candidate+'</span>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find("img").attr("pattern",dataList.pattern);
				break;
			case "image_list":
				var dataType=dataTr(dataList.name,'<img priority='+dataList.priority+' ownerId='+dataList.ownerId+' description='+dataList.description+' configKey='+dataList.name+' class="preview_btn" src="images/icon_img.png"><span class="list_value_con displayNone">'+dataList.value+'</span>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find("img").attr("pattern",dataList.pattern);
				break;	
			case "module_list":
				var dataType=dataTr(dataList.name,'<img priority='+dataList.priority+' ownerId='+dataList.ownerId+' description='+dataList.description+' configKey='+dataList.name+' class="preview_btn" src="images/icon_json.png"><span class="list_value_con displayNone">'+dataList.value+'</span><span class="candidate_con displayNone">'+dataList.candidate+'</span>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find("img").attr("pattern",dataList.pattern);
				break;
			case "command_list":
				var dataType=dataTr(dataList.name,'<img priority='+dataList.priority+' ownerId='+dataList.ownerId+' description='+dataList.description+' configKey='+dataList.name+' class="preview_btn" src="images/icon_json.png"><span class="list_value_con displayNone">'+dataList.value+'</span><span class="candidate_con displayNone">'+dataList.candidate+'</span>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find("img").attr("pattern",dataList.pattern);
				break;
			case "patrol":
				var dataType=dataTr(dataList.name,'<img priority='+dataList.priority+' ownerId='+dataList.ownerId+' description='+dataList.description+' configKey='+dataList.name+' class="preview_btn" src="images/icon_json.png"><span class="list_value_con displayNone">'+dataList.value+'</span>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find("img").attr("pattern",dataList.pattern);
				break;
			case "menu_list":
				var dataType=dataTr(dataList.name,'<img priority='+dataList.priority+' ownerId='+dataList.ownerId+' description='+dataList.description+' configKey='+dataList.name+' class="preview_btn" src="images/icon_json.png"><span class="list_value_con displayNone">'+dataList.value+'</span>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find("img").attr("pattern",dataList.pattern);
				break;
			case "menu_matrix":
				var dataType=dataTr(dataList.name,'<img priority='+dataList.priority+' ownerId='+dataList.ownerId+' description='+dataList.description+' configKey='+dataList.name+' class="preview_btn" src="images/icon_json.png"><span class="list_value_con displayNone">'+dataList.value+'</span>',dataList.description,dataList.priority,dataList.ownerId,dataList.type);
				dataType.appendTo(parent);
				$(".table_senior tr").eq(i%10).find("img").attr("pattern",dataList.pattern);
				break;
			default:
				break;	 
		}
	}

	function dataTr(dataTr_name,dataTr_value,dataTr_des,dataTr_priority,dataTr_ownerId,dataTr_type){
		var dataTr=$('<tr>\
			<td keyName="description" configKey='+dataTr_name+'>'+dataTr_des+'</td>\
			<td keyName="config_value" dataType='+dataTr_type+'>'+dataTr_value+'</td>\
			<td class="operate_list">\
				<input type="button" value="使用默认值" class="senior_deletebtn" title="使用默认值" name="使用默认值" priority='+dataTr_priority+' ownerId='+dataTr_ownerId+' configKey='+dataTr_name+'>\
			</td>\
		</tr>');
		return dataTr;
	}

	$(".table_content td:nth-child(3)").css("width","150px");
	
	//list点击预览
	$(".preview_btn").click(function(){
		var _this=$(this);
		var _thisDes=_this.attr("description");
		var _thisKey=_this.attr("configKey");
		var _thisOwnerId=_this.attr("ownerId");
		var _thisPri=_this.attr("priority");
		var _thisType=_this.parent().attr("dataType");
		var _thisValue=_this.siblings(".list_value_con").html();
		var _thisCandidate=_this.siblings(".candidate_con").html();
		var _thisHtmlPath='';
		var _thisPathTitle='';
		var _thisArray=[];
		var candidateFlag=false;
		console.log(_thisValue)
		console.log(_thisCandidate)
		if(_thisType=="list"){
			_thisValueTime=eval("("+_thisValue+")").items;
			if(_thisCandidate==''){
				_thisValue=_thisValueTime;
				candidateFlag=false;
			}else{
				_thisCanArray=eval("("+_thisCandidate+")").items;
				candidateFlag=true;
				_thisValue=candidateFormat(_thisCanArray,_thisValueTime);
			}	
		}else if(_thisType=="module_list"){
			_thisValueTime=_thisValue.split(",");
			if(_thisCandidate==''){
				_thisValue=_thisValueTime;
				candidateFlag=false;
			}else{
				_thisCanArray=eval("("+_thisCandidate+")").items;
				candidateFlag=true;
				_thisValue=candidateFormat(_thisCanArray,_thisValueTime);
			}
		}else if(_thisType=="image_list"){
			_thisValueTime=eval("("+_thisValue+")").value;	
			_thisValue=_thisValueTime;
			_thisPathTitle='<div class="image_list_type clearfix"><input type="radio" srcType="imageSrc" name="image_list" style="margin-top:4px" checked /><span class="fl">云端图片</span><input type="radio" srcType="videoSrc" name="image_list" style="margin-top:4px" /><span class="fl">本地视频</span></div>';
		}else if(_thisType=="patrol"){
			_thisPathTitle='<label style="width:90px;height:30px;float:left;line-height:30px;text-align:right">路径：</label>';
			_thisValueTime=eval("("+_thisValue+")");
			_thisValue=_thisValueTime.path;
			if(_thisValueTime.canInterupt==true){
				_thisHtmlPath='\
				<div class="senior_canInterupt"><label for="">是否可打断：</label><input type="checkbox" checked class="caninter js-switch js-check-change" /></div>\
				<div class="senior_repeat"><label for="">重复次数：</label><input type="number" value='+_thisValueTime.repeat+' /></div>'
			}else{
				_thisHtmlPath='\
				<div class="senior_canInterupt"><label for="">是否可打断：</label><input type="checkbox" class="caninter js-switch js-check-change" /></div>\
				<div class="senior_repeat"><label for="">重复次数：</label><input type="number" value='+_thisValueTime.repeat+' /></div>'
			}
		}else if(_thisType=="menu_list"){
			_thisValueTime=eval("("+_thisValue+")");
			_thisValue=_thisValueTime.items;
			_thisHtmlPath='<div class="senior_menutitle"><input type="text" value='+_thisValueTime.title+' /></div>'
		}else if(_thisType=="command_list"){
			_thisValue=_thisValue;
		}else if(_thisType=="menu_matrix"){
			_thisValue=eval("("+_thisValue+")").items;
			_thisPathTitle='<input type="button" value="编辑" class="matrix_eidt" />'
		}
		var _thisChildArray=arrayFormatPreview(_thisValue,_thisType,candidateFlag).arrayValue;
		var _thisChildArrayVideo=arrayFormatPreview(_thisValue,_thisType,candidateFlag).arrayValueVideo;
		var _thisTypeBtn=arrayFormatPreview(_thisValue,_thisType,candidateFlag).addBtnType;
		if(_thisType=='image_list'){
			var _thisHtml='\
			<div class="senior_edit_box">'+_thisHtmlPath+'\
			    <div class="clearfix">'+_thisPathTitle+'<ul class="valuetype_array clearfix">'+_thisChildArray+'</ul><ul class="valuetype_array_video displayNone clearfix">'+_thisChildArrayVideo+'</ul></div>\
			    <div class="senior_btn_group clearfix">\
				    <input dataType='+_thisType+' configKey='+_thisKey+' ownerId='+_thisOwnerId+' priority='+_thisPri+' id="senior_delete_btn" type="button" value="使用默认值"/>'+_thisTypeBtn+'<input dataType='+_thisType+' configKey='+_thisKey+' ownerId='+_thisOwnerId+' priority='+_thisPri+' id="senior_save_btn" type="button" value="保存"/>\
			    </div>\
			</div>'
		}else{
			var _thisHtml='\
			<div class="senior_edit_box">'+_thisHtmlPath+'\
			    <div class="clearfix">'+_thisPathTitle+'<ul class="valuetype_array clearfix">'+_thisChildArray+'</ul></div>\
			    <div class="senior_btn_group clearfix">\
				    <input dataType='+_thisType+' configKey='+_thisKey+' ownerId='+_thisOwnerId+' priority='+_thisPri+' id="senior_delete_btn" type="button" value="使用默认值"/>'+_thisTypeBtn+'<input dataType='+_thisType+' configKey='+_thisKey+' ownerId='+_thisOwnerId+' priority='+_thisPri+' id="senior_save_btn" type="button" value="保存"/>\
			    </div>\
			</div>'
		}
		
		layer.open({
			title : _thisDes,
			type: 1,
			skin: 'layui-layer-rim', //加上边框
			area:[ '600px','550px'], //宽高
			content:_thisHtml
		});

		var elems = Array.prototype.slice.call(document.querySelectorAll('.caninter'));
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

	    //六宫格
	    $(".matrix_eidt").click(function(){
	    	$(".matrix_color").attr("disabled",false);
			$(".matrix_icon").css("cursor","pointer");
			$(".minicolors input[type=hidden] + .minicolors-swatch").css("cursor","pointer");
			$(".matrix_content").addClass("matrix_content_edit").attr("disabled",false);
			$(".valuetype_array li.senior_matrix_box .matrix_content").mouseover(function(){
				$(this).css("border","2px solod #fff")
			});
			//上传icon
			$(".valuetype_array").on("click",".matrix_icon",function(){
				var _this=$(this);
				uploadIcon(_this);
			})
	    })

		if(_thisPri==0){
			$("#senior_delete_btn").attr("disabled","disabled");
		}
		$("#senior_delete_btn").click(function(){
			var _this=$(this);
			var _thisOwnerId=_this.attr("ownerId");
			var _thisPrio=_this.attr("priority");
			var _thisConfigKey=_this.attr("configKey");
			var editSubUrl='';
			var submitData={
				user_id:userId,
				owner_id:_thisOwnerId,
				priority:_thisPrio,
				config_key:_thisConfigKey
			};
			getCurrentPage();
			layer.alert("确定使用默认值吗？",{
				icon:3,
				yes:function(index){
					subForm("https://"+host+"/signalmaster/rest/delete_config",submitData,function(){
						if(subResult.message=="OK"){
							layer.alert("已使用默认值",{
								icon:1,
								yes:function(index){
									searchDown(function(){
										$(".page_skip input").val(editCurrentpage);
										$(".page_skip a").trigger('click');
									})	
								}
							})
						}else{
							layer.tips("使用默认值失败："+subResult.message);
						}
					})
				}
			})
		})

		//删除节点
		$(".valuetype_array").on("click",".array_close",function(){
			$(this).parent().remove();
		})
		$(".valuetype_array_video").on("click",".array_close",function(){
			$(this).parent().remove();
		})

		//编辑
		$(".valuetype_array").on("focus",".senior_type_list input",function(){
			$(this).css({"background":"#fff","border":"1px solid #fff"})
		})
		$(".valuetype_array").on("blur",".senior_type_list input",function(){
			$(this).css({"background":"#aad0e6","border":"1px solid #aad0e6"})
		})

		$(".valuetype_array").on("click",".patrol_position input[type='radio']",function(){
			var indexClass=$(this).attr("indexClass");
			var notIndexClass=$(this).attr("notIndexClass");
			$(this).parent().parent().siblings("."+indexClass).removeClass("displayNone");
			$(this).parent().parent().siblings("."+indexClass).children("input").eq(0).focus();
			$(this).parent().parent().siblings("."+notIndexClass).addClass("displayNone");
		})

		$(".senior_repeat input").blur(function(){
			if(!isInteger(parseFloat($(this).val()))){
				layer.tips("请输入整数！",$(this));
				$(this).focus();
			}
		})

		//本地视频
		$(".image_list_type input").click(function(){
			var _this=$(this);
			var _thisParent=_this.parent();
			if(_this.attr("srcType")=="videoSrc"){
				_thisParent.siblings(".valuetype_array_video").removeClass("displayNone");
				_thisParent.siblings(".valuetype_array").addClass("displayNone");
			}else{
				_thisParent.siblings(".valuetype_array").removeClass("displayNone");
				_thisParent.siblings(".valuetype_array_video").addClass("displayNone");
			}
		})
		$(".valuetype_array_video").on("blur",".image_list_input",function(){
			var _this=$(this);
			var _thisValue=trim(_this.val());
		    if(_thisValue==''){
		    	layer.tips("输入不能为空，请输入！",_this);
		    }
		})

		$("#senior_save_btn").click(function(){
			var _this=$(this);
			var _thisPri=parseFloat(_this.attr("priority"));
			var _thisType=_this.attr("dataType");
			var _thisValueArray=[];
			var _thisValueJson={};
			getCurrentPage();
			if(_thisType=="list"){
				$(".valuetype_array li input").each(function(){
					if(trim($(this).val())!=''){
						if($(this).attr("candidateValue")!=undefined){
							_thisValueArray.push(trim($(this).attr("candidateValue")));
						}else{
							_thisValueArray.push(trim($(this).val()));
						}
					}
				})
				_thisValueJson.items=_thisValueArray;
				_thisValueJson=JSON.stringify(_thisValueJson);
				editSubmitString(_this,_thisValueJson,function(){
					if(subResult.message=="OK"){
						layer.alert("修改保存成功",{
							icon:1,
							yes:function(index){
								if(_thisPri==0){
									searchDown();
								}else{
									searchDown(function(){
										$(".page_skip input").val(editCurrentpage);
										$(".page_skip a").trigger('click');
									})
								}		
							}
						})
					}else{
						layer.alert("修改保存失败："+subResult.message,{icon:5});
					}
				});
			}else if(_thisType=="module_list"){
				$(".valuetype_array li input").each(function(){
					if(trim($(this).val())!=''){
						if($(this).attr("candidateValue")!=undefined){
							_thisValueArray.push(trim($(this).attr("candidateValue")));
						}else{
							_thisValueArray.push(trim($(this).val()))
						}	
					}
				})
				var _thisSubValue=_thisValueArray.join(",");
				editSubmitString(_this,_thisSubValue,function(){
					if(subResult.message=="OK"){
						layer.alert("修改保存成功",{
							icon:1,
							yes:function(index){
								searchDown(function(){
									$(".page_skip input").val(editCurrentpage);
									$(".page_skip a").trigger('click');
								})	
							}
						})
					}else{
						layer.alert("修改保存失败："+subResult.message,{icon:5});
					}
				});
			}else if(_thisType=="image_list"){
				var _thisValueVideo=[];
				$(".valuetype_array_video li .image_list_input").each(function(){
					var _this=$(this);
					var _thisVal=trim(_this.val());
					if(_thisVal!=''){
						_thisValueVideo.push(_thisVal);
					}
				})
				$(".valuetype_array li .image_list").each(function(){
					_thisValueArray.push($(this).attr("src"));
				})
				_thisValueArray=_thisValueVideo.concat(_thisValueArray);
				_thisValueJson.value=_thisValueArray;
				_thisValueJson=JSON.stringify(_thisValueJson);
				editSubmitString(_this,_thisValueJson,function(){
					if(subResult.message=="OK"){
						layer.alert("修改保存成功",{
							icon:1,
							yes:function(index){
								if(_thisPri==0){
									searchDown();
								}else{
									searchDown(function(){
										$(".page_skip input").val(editCurrentpage);
										$(".page_skip a").trigger('click');
									})
								}	
							}
						})
					}else{
						layer.alert("修改保存失败："+subResult.message,{icon:5});
					}
				});
			}else if(_thisType=="patrol"){
				var interupt=$(".senior_canInterupt input").get(0).checked;
				var repeat=parseFloat($(".senior_repeat input").val());
				if(isInteger(repeat)){
					var _thisPathValue=getPath($(".senior_patrol_box")).path;
					var isNull=getPath($(".senior_patrol_box")).isNull;
					var _thisEditValue={canInterupt:interupt,repeat:repeat,path:_thisPathValue};
					_thisEditValue=JSON.stringify(_thisEditValue);
					if(!isNull){
						editSubmitString(_this,_thisEditValue,function(){
							if(subResult.message=="OK"){
								layer.alert("修改保存成功",{
									icon:1,
									yes:function(index){
										if(_thisPri==0){
											searchDown();
										}else{
											searchDown(function(){
												$(".page_skip input").val(editCurrentpage);
												$(".page_skip a").trigger('click');
											})
										}	
									}
								})
							}else{
								layer.alert("修改保存失败："+subResult.message,{icon:5});
							}
						});
					}
				}else{
					layer.tips("请输入整数！",".senior_repeat input");
					$(".senior_repeat input").focus();
				}
			}else if(_thisType=="menu_list"){
				var _thisTitle=$(".senior_menutitle input");
				if(_thisTitle.val()==''){
					layer.tips("内容不能为空，请输入！",".senior_menutitle input");
					_thisTitle.focus();
				}else{
					$(".valuetype_array li input").each(function(){
						if(trim($(this).val())!=''){
							_thisValueArray.push(trim($(this).val()));
						}
					})
					_thisValueJson.title=_thisTitle.val();
					_thisValueJson.items=_thisValueArray;
					_thisValueJson=JSON.stringify(_thisValueJson);
					editSubmitString(_this,_thisValueJson,function(){
						if(subResult.message=="OK"){
							layer.alert("修改保存成功",{
								icon:1,
								yes:function(index){
									if(_thisPri==0){
										searchDown();
									}else{
										searchDown(function(){
											$(".page_skip input").val(editCurrentpage);
											$(".page_skip a").trigger('click');
										})
									}	
								}
							})
						}else{
							layer.alert("修改保存失败："+subResult.message,{icon:5});
						}
					});
				}
			}else if(_thisType=="command_list"){
				var _thisValueJson=$(".command_list_box textarea").val();
				editSubmitString(_this,_thisValueJson,function(){
					if(subResult.message=="OK"){
						layer.alert("修改保存成功",{
							icon:1,
							yes:function(index){
								if(_thisPri==0){
									searchDown();
								}else{
									searchDown(function(){
										$(".page_skip input").val(editCurrentpage);
										$(".page_skip a").trigger('click');
									})
								}
							}
						})
					}else{
						layer.alert("修改保存失败："+subResult.message,{icon:5});
					}
				});
			}else if(_thisType=="menu_matrix"){
				var _thisMatrixValue=getMatrix($(".senior_matrix_box")).martrixValue;
				_thisMatrixValue=JSON.stringify(_thisMatrixValue);
				var isNull=getMatrix($(".senior_matrix_box")).isNull;
				if(!isNull){
					editSubmitString(_this,_thisMatrixValue,function(){
						if(subResult.message=="OK"){
							layer.alert("修改保存成功",{
								icon:1,
								yes:function(index){
									if(_thisPri==0){
										searchDown();
									}else{
										searchDown(function(){
											$(".page_skip input").val(editCurrentpage);
											$(".page_skip a").trigger('click');
										})
									}
								}
							})
						}else{
							layer.alert("修改保存失败："+subResult.message,{icon:5});
						}
					});
					$(".matrix_content").removeClass("matrix_content_edit").attr("disabled",true);
					$(".matrix_color").attr("disabled",true);
					$(".matrix_icon").css("cursor","default");
					$(".valuetype_array").off("click",".matrix_icon");
					$(".valuetype_array").off("click",".matrix_icon:last");
					$(".minicolors input[type=hidden] + .minicolors-swatch").css("cursor","default");
				}
			}
			
		})

		$(".list_add_btn").click(function(){
			if(_thisCandidate==''){
				var arrayValue='<li class="senior_type_list"><input type="text" /><img src="images/icon_close_blue.png" class="array_close"/></li>';
				$(".valuetype_array").append(arrayValue);
			}else{
				var _thisCan=eval("("+_thisCandidate+")").items;
				var _thisCanValue=candidateSelect(_thisCan,_thisValueTime);
				var _thisCanOptions='';
				for(var i=0;i<_thisCanValue.length;i++){
					_thisCanOptions+='<option value='+_thisCanValue[i].value+'>'+_thisCanValue[i].name+'</option>'
				}
				var _thisCanSelect='<select id=candidata_select>'+_thisCanOptions+'</select>'
				layer.alert(_thisCanSelect,{
					yes:function(index){
						var candidataValue=$("#candidata_select").val();
						var value=$("#candidata_select option:selected").text();
						var arrayValue='<li class="senior_type_list"><input type="text" disabled candidatevalue='+candidataValue+' value='+value+' /><img src="images/icon_close_blue.png" class="array_close"/></li>';
						$(".valuetype_array").append(arrayValue);
						layer.close(index);
					}
				});
			}
		})

		$(".module_add_btn").click(function(){
			if(_thisCandidate==''){
				var arrayValue='<li class="senior_type_list"><input type="text" /><img src="images/icon_close_blue.png" class="array_close"/></li>';
				$(".valuetype_array").append(arrayValue);
			}else{
				var _thisCan=eval("("+_thisCandidate+")").items;
				var _thisCanValue=candidateSelect(_thisCan,_thisValueTime);
				var _thisCanOptions='';
				for(var i=0;i<_thisCanValue.length;i++){
					_thisCanOptions+='<option value='+_thisCanValue[i].value+'>'+_thisCanValue[i].name+'</option>'
				}
				var _thisCanSelect='<select id=candidata_select>'+_thisCanOptions+'</select>'
				layer.alert(_thisCanSelect,{
					yes:function(index){
						var candidataValue=$("#candidata_select").val();
						var value=$("#candidata_select option:selected").text();
						var arrayValue='<li class="senior_type_list"><input type="text" disabled candidatevalue='+candidataValue+' value='+value+' /><img src="images/icon_close_blue.png" class="array_close"/></li>';
						$(".valuetype_array").append(arrayValue);
						layer.close(index);
					}
				});
			}
			
		})

		$(".img_add_btn").click(function(){
			swfuploadNew();
		})

		$(".menu_add_btn").click(function(){
			var arrayValue='<li class="senior_type_list"><input type="text" /><img src="images/icon_close_blue.png" class="array_close"/></li>';
			$(".valuetype_array").append(arrayValue);
		})
		

		$(".patrol_add_btn").click(function(){
			var pathIndex=$(".valuetype_array li").length;
			var arrayValue='<li class="senior_patrol_box"><div class="senior_patrol_list">\
			<div class="clearfix marginBottom10"><em>定位点：</em><div class="fl patrol_position"><input type="radio" name=xyr'+pathIndex+' checked="checked" indexClass="patrol_index" notIndexClass="patrol_xyr" /><em>位置</em><input type="radio" name=xyr'+pathIndex+' indexClass="patrol_xyr" notIndexClass="patrol_index" /><em>坐标</em></div></div>\
			<div class="clearfix marginBottom10 patrol_index"><em>定位点编号：</em><input type="number" pathName="index"></div>\
			<div class="clearfix marginBottom10 patrol_xyr displayNone"><em>x：</em><input type="number" pathName="x" /><em>y：</em><input type="number" pathName="y" /><em>r：</em><input type="number" pathName="r" /></div>\
			<div class="clearfix marginBottom10"><em>语音播报：</em><input type="text" pathName="content" /></div>\
			<div class="clearfix marginBottom10"><em>停留时间(ms)：</em><input type="number" pathName="stay" /></div>\
			</div><img src="images/icon_close_blue.png" class="array_close" dataType=patrol /></li>';
			$(".valuetype_array").append(arrayValue);
		})

		$(".matrix_add_btn").click(function(){
			if($(".matrix_list").length>5){
				layer.alert("最多只有六个模块，不能再增加！")
			}else{
				var arrayValue='<li class="matrix_list senior_matrix_box">\
					<input type="hidden" id="hidden-input" class="demo matrix_color" value="#2eaef8" ><div class="matrix_other">\
					<img src="images/icon_add.png" class="matrix_icon"/>\
					<input class="matrix_content matrix_content_edit" ></div>\
					<img src="images/icon_close_blue.png" class="array_close" dataType="menu_matrix" />\
				</li>';
				$(".valuetype_array").append(arrayValue);
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
			    $(".valuetype_array").on("click",".matrix_icon:last",function(){
					var _this=$(this);
					uploadIcon(_this);
				})
			}
		})
	})



	//删除按钮的禁用
	$(".senior_deletebtn").each(function(){
		if($(this).attr('priority')==0){
			$(this).attr('disabled',true);
			$(this).next().attr('disabled',true);
		}
	})

	/*使用默认值*/
	$(".senior_deletebtn").click(function(){
		var _this=$(this);
		var _thisOwnerId=_this.attr("ownerId");
		var _thisPrio=_this.attr("priority");
		var _thisConfigKey=_this.attr("configKey");
		var submitData={
			user_id:userId,
			owner_id:_thisOwnerId,
			priority:_thisPrio,
			config_key:_thisConfigKey
		};
		getCurrentPage();
		layer.alert("确定恢复默认值吗？",{
			icon:3,
			btn:["确定",'取消'],
			yes:function(index){
				layer.close(index);
				subForm("https://"+host+"/signalmaster/rest/delete_config",submitData,function(){
					if(subResult.message=="OK"){
						layer.alert("已使用默认值",{
							icon:1,
							yes:function(index){
								searchDown(function(){
									$(".page_skip input").val(editCurrentpage);
									$(".page_skip a").trigger('click');
								})	
							}
						})
					}else{
						layer.layer("使用默认值失败："+subResult.message,{
							icon:5
						});
					}
				})
			},
			btn2:function(index){
				layer.close(index);
			}
		})
		

	})


	/*编辑*/
	//string
	var oldStringValue,oldIntegerValue,oldFloatValue;
	$(".senior_edit_string").focus(function(){
		oldStringValue=trim($(this).val());
	})
	$(".senior_edit_string").blur(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var currentValue=trim($(this).val());
		if(currentValue!=oldStringValue){
			editSubmitString(_this,currentValue,function(){
				if(subResult.message=="OK"){
					layer.tips("保存成功！",_this);
					if(_thisPri==0){
						searchDown();
					}
				}else{
					layer.tips("保存失败："+subResult.message,_this);
					_this.val(oldStringValue);
				}
			});
		}
	})
	editKeyup($("#table"),'.senior_edit_string');

	$(".senior_edit_select").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		editSubmitString(_this,_this.val(),function(){
			if(subResult.message=="OK"){
				layer.tips("保存成功！",_this);
				if(_thisPri==0){
					searchDown();
				}
			}else{
				layer.tips("保存失败："+subResult.message,_this);
			}
		});
	})

	$('.senior_edit_bool').change(function(){
		var _this=$(this);
		var _thisPos=_this.siblings(".switchery");
		var _thisPri=parseFloat(_this.attr("priority"));
		var currentValue=$(this).get(0).checked;
		editSubmitString(_this,currentValue,function(){
			if(subResult.message=="OK"){
				layer.tips("修改保存成功",_thisPos);
				if(_thisPri==0){
					searchDown();
				}
			}else{
				layer.tips("保存失败："+subResult.message,_thisPos);
				_this.get(0).checked=(!currentValue);
			}
		});
	})

	$(".senior_edit_integer").focus(function(){
		oldIntegerValue=trim($(this).val());
	})
	$(".senior_edit_integer").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var _thisLimitL=_this.attr("limitL");
		var _thisLimitH=_this.attr("limitH");
		var currentValue=parseFloat(_this.val());
		if(isInteger(currentValue)){
			limit(_this,currentValue,_thisLimitL,_thisLimitH,oldIntegerValue,function(){
				if(subResult.message=="OK"){
					layer.tips("保存成功！",_this);
					if(_thisPri==0){
						searchDown();
					}
				}else{
					layer.tips("保存失败："+subResult.message,_this);
					_this.val(oldIntegerValue);
				}
			})
		}else{
			layer.tips("请输入整数",_this);
			_this.val(oldIntegerValue);
		}
	})

	$(".senior_edit_float").focus(function(){
		oldFloatValue=trim($(this).val());
	})
	$(".senior_edit_float").change(function(){
		var _this=$(this);
		var _thisPri=parseFloat(_this.attr("priority"));
		var _thisLimitL=_this.attr("limitL");
		var _thisLimitH=_this.attr("limitH");
		var currentValue=parseFloat(_this.val());
		limit(_this,currentValue,_thisLimitL,_thisLimitH,oldIntegerValue,function(){
			if(subResult.message=="OK"){
				layer.tips("保存成功！",_this);
				if(_thisPri==0){
					searchDown();
				}
			}else{
				layer.tips("保存失败："+subResult.message,_this);
				_this.val(oldFloatValue);
			}
		})
	})

	var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
		elems.forEach(function(html) {
	  	var switchery = new Switchery(html,{size:"small"});
	});
}

function swfuploadNew(){
	var currentSrcType=$(".image_list_type input:checked").attr("srcType");
	console.log(currentSrcType);
	if(currentSrcType=="videoSrc"){
		var videoInput='<li class="image_list_box_video clearfix"><em class="image_list_videosrc fl">本地视频：</em><input type="text" class="fl image_list_input" /><img src="images/icon_close_blue.png" class="array_close" dataType="image_list" /></li>';
		$(".valuetype_array_video").append(videoInput);
	}else{
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
	    	$("#logList li").each(function(){
	    		if($(this).css("display")!="none"){
	    			addImgArray.push($(this).find("span.progressValue").attr("backUrl"));
	    		}
	    	})
	    	$(".valuetype_array").append(arrayFormatPreview(addImgArray,"image_list",'').arrayValue);
	    	layer.close(layerIndex);
	    })
	    $("#swfUploadCancle").click(function(){
	    	layer.close(layerIndex);
	    })
	}
	
}



//切换机器人
function changeRobots(url,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:url,
		success:function(result){
			var subResult=result;
			data=result.data;
			layer.closeAll();
			if(subResult.code==0){
				if(data!=undefined){
					createPage($("#table"),data,pagination,createPageContent);
					if(callback){
						callback();
					}
				}else{
					$("#table").html("");
					$(".counts_page").text(0);
					$(".counts_num").text(0);
					$(".pageNum").html('');
				}				
			}else if(subResult.code==82){
				layer.closeAll()
				layer.alert(subResult.message,{
					yes:function(index){
						$(".user_quit").trigger("click");
					}
				});
			}else{
				layer.closeAll()
				layer.alert(subResult.message);
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

//搜索
function searchProperty(searchHost,groupUrl,callback){	
	var searchKey = $("#search_ipt").val();
	if(searchKey.length > 0){
		var searchUrl=searchHost+"/"+searchKey;
		changeRobots(searchUrl,callback);
	}else {
		groupUrl=searchHost+"/null";
		changeRobots(groupUrl,callback);
	}
}

function searchDown(level,callback){
	var ownerId=whichRobotCommon().ownerId;
	var priority=whichRobotCommon().priority;
	var searchHost='';
	if(priority==7){
		searchHost="https://"+host+"/signalmaster/rest/config/industry/"+ownerId+"/255";
	}else{
		searchHost="https://"+host+"/signalmaster/rest/config/industry/"+ownerId+"/"+priority;
	}
	searchProperty(searchHost,groupUrl,callback);
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