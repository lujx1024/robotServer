//var host="https://192.168.1.71"
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
		var bookPos=window.localStorage.bookPos;
	}
	
	var all='';
	var groupId=robotList[0].userGroupId;
	var userId=robotList[0].userId;
	var groupName=robotList[0].userGroupName;

	//加载完成显示全部
	var groupUrl="https://"+host+"/signalmaster/rest/config/advance/"+groupId+"/3/null";

	$(".all_robots").click(function(){
		window.localStorage.bookPos="all";
		layerLoad();
		$(".all_robots").addClass("all_robots_current");
		$("#robot_group ul li").removeClass('robotCurrent');
		$(".robot_group_box").removeClass("robot_group_box_current");
		searchDown("advance");	
	})

	createRobotsUser(robotList,function(){
		/*切换机器人*/
		$("#robot_group ul li").click(function(){
			window.localStorage.bookPos=$(this).attr("sn");
			layerLoad();
			$(".all_robots").removeClass("all_robots_current");
			$("#robot_group").find("li").removeClass("robotCurrent");
			$(".robot_group_box").removeClass("robot_group_box_current");
			$(this).addClass('robotCurrent');
			searchDown("advance");
		})
		/*切换组*/
		$("#robot_group").on("click",".robot_group_title",function(){
			window.localStorage.bookPos=$(this).attr("sceneId");
			layerLoad();
			$(this).parent().addClass("robot_group_box_current").siblings().removeClass("robot_group_box_current");
			$("#robot_group").find("li").removeClass("robotCurrent");
			$(".all_robots").removeClass("all_robots_current");
			searchDown("advance");	
		})

		//加载记录位置
		bookPosBackAll(bookPos);

		var sortableList=[];
		//进入编辑状态
		$(".robot_edit_model").click(function(){
			$("#add_scene_box").removeClass("displayNone");
			$(".robot_group_box ul").each(function(){
				if($(this).children().length==0){
					$(this).siblings(".delete_scene").removeClass('displayNone');
				}
			})
			$("#robot_group").on("click",".delete_scene",function(){
				deleteScene($(this));
			})
			$(this).addClass("displayNone");
			$(".robot_edit_model_save").removeClass("displayNone");

			//新建场景
			$(".add_scene").on("click",function(){
				var oldNewScene='';
				var oldScene='';
				$("#add_scene_box").addClass("displayNone");
				$(".robot_edit_model_save").attr("disabled",true);
				var addScene='<div class="robot_group_box">\
						<div class="delete_scene"></div>\
						<div class="robot_group_title displayNone"></div>\
						<input type="text" value="" placeholder="请输入新建组名" class="scene_new"/>\
						<ul class="clearfix">\
						</ul>\
					</div>';
				$("#not_grouped").before(addScene);
				$(".scene_new").focus();
				$(".scene_new").focus(function(){
					oldNewScene=$(this).val();
				})
				$(".scene_new").keyup(function(event){
					if(event.which==13){
						$(this).trigger('blur');
					}
				})
				$(".scene_new").on("blur",function(){
					var _this=$(this);
					if(_this.val()==''){
						 _this.attr("placeholder","组名不能为空,请输入");
						_this.focus();
						$(".robot_edit_model_save").attr("disabled",true);
					}else{
						if(trim(_this.val())!=oldNewScene){
							_this.removeClass("scene_new");
							_this.siblings(".robot_group_title").text(_this.val());
							$(".robot_edit_model_save").attr("disabled",false);
							var newSceneSort=_this.siblings("ul").get(0);
							sortableList.push(new Sortable(newSceneSort, {
								group: "words",
								animation: 180,
								onAdd: function (evt){
									robotToScene(evt);
								},
								onRemove: function (evt){
								 	if($(evt.target).children().length==0){
										$(evt.target).siblings(".delete_scene").removeClass("displayNone");
									}
								}
							}));
							var addSceneData={
								user_group_id:groupId,
								name:_this.val()
							}
							subNewScene("https://"+host+"/signalmaster/rest/set_config/saveScene",addSceneData,function(){	
								if(subNewSceneResult.message=="OK"){
									layer.alert("新建场景成功！");
									sceneData=subNewSceneResult.data[0].id.id;
									_this.siblings(".delete_scene").attr("sceneId",sceneData);
									_this.siblings("ul").attr("sceneId",sceneData);
									_this.siblings(".robot_group_title").attr("sceneId",sceneData);
									$("#add_scene_box").removeClass("displayNone");
									_this.removeClass("scene_new");
									_this.unbind("blur");
									_this.addClass('scene_title_edit');
								}else{
									layer.alert(subNewSceneResult.message);
									_this.val();
									_this.focus();
								}
							})
						}
					}		
				})
			})

			//机器人拖动
			$(".robot_group_box ul").each(function(){
				sortableList.push(new Sortable($(this).get(0), {
					group: "words",
					animation: 180,
					onAdd: function (evt){ 
						robotToScene(evt);
					},
					onRemove: function (evt){
						if($(evt.target).children().length==0){
							$(evt.target).siblings(".delete_scene").removeClass("displayNone");
						}
					}
				}));
			})
			$(".robot_group_title").addClass("displayNone");
			$(".scene_title_edit").removeClass("displayNone");
			$("#robot_group ul li").css("cursor","move");
			
			$("#robot_group").on("focus",".scene_title_edit",function(){
				oldScene=$(this).val();
			})

			$("#robot_group").on("keyup",".scene_title_edit",function(event){
				if(event.which==13){
					$(this).trigger('blur');
				}
			})

			//编辑场景
			$("#robot_group").on("blur",".scene_title_edit",function(){
				var _this=$(this);
				if(_this.val()==''){
					$("#add_scene_box").addClass("displayNone");
					_this.attr("placeholder","组名不能为空,请输入");
					_this.focus();
					$(".robot_edit_model_save").attr("disabled",true);
				}else{
					$("#add_scene_box").removeClass("displayNone");
					$(".robot_edit_model_save").attr("disabled",false);
					if(trim(_this.val())!=oldScene){
						_this.siblings(".robot_group_title").text(_this.val());
						var currentSceneId=parseFloat(_this.siblings("ul").attr("sceneId"));
						var addSceneData={
							id:currentSceneId,
							user_group_id:groupId,
							name:_this.val()
						}
						subNewScene("https://"+host+"/signalmaster/rest/set_config/saveScene",addSceneData,function(){
							if(subNewSceneResult.message=="OK"){
								layer.alert("编辑场景成功！");
							}else{
								layer.alert(subNewSceneResult.message);
								_this.focus();
							}
						})
					}	
				}
			})

			//删除场景
			function deleteScene(_this){
				var deleteSceneId=_this.attr("sceneId");
				var deleTip='确认删除吗？';
				$("#add_scene_box").removeClass("displayNone");
				var layerIndex=layer.alert(deleTip,{
				  	icon:0,
				  	btn:['确定','取消'],
				  	yes:function(index, layero){
				  		if(deleteSceneId!=undefined){
				  			multiSubmit("https://"+host+"/signalmaster/rest/set_config/deleteScene/"+deleteSceneId,function(){
					  			if(message=="OK"){
					  				_this.parent().remove();
					  				layer.alert("删除成功！");
					  			}else{
					  				layer.alert(message);
					  			}
					  		});
				  		}else{
				  			_this.parent().remove();
				  		}
				  		$(".robot_edit_model_save").attr("disabled",false);
				  		layer.close(layerIndex);
				  	},btn2:function(index, layero){
				  		layer.close(layerIndex);
				  	}
				})
			}

			//拖拽到其他组
			function robotToScene(evt){
				var dragUrl="https://"+host+"/signalmaster/rest/set_config/robotToScene";
				var sceneIdDragTo=parseFloat($(evt.target).attr("sceneId"));
				var dragEleRobotId=parseFloat($(evt.item).attr("robotId"));
				if(sceneIdDragTo==0){
					var dragData={
						robot_id:dragEleRobotId
					}
				}else{
					var dragData={
						group_scene_id:sceneIdDragTo,
						robot_id:dragEleRobotId
					}
				}
				subNewScene(dragUrl,dragData,function(){
					if(subNewSceneResult.message!="OK"){
						$(evt.from).append(evt.item);
						if($(evt.target).children().length==0){
							$(evt.target).siblings(".delete_scene").removeClass("displayNone");
						}
						layer.alert(subNewSceneResult.message);	
					}else{
						$(evt.item).attr("sceneId",sceneIdDragTo);
						var newRobotList=$("#robot_group ul li");
						newRobotList.each(function(){
							var newRobotId=parseFloat($(this).attr("robotId"));
							var newSceneId=parseFloat($(this).attr("sceneId"));
							var newSceneName=$(this).parent().siblings(".robot_group_title").text();
							for(var i=0;i<robotList.length;i++){
								if(newRobotId==robotList[i].robotId){
									robotList[i].userGroupSceneId=newSceneId;
									robotList[i].userGroupSceneName=newSceneName;
								}
							}							
						})
						window.localStorage.data=JSON.stringify(robotList);
					}
				})
				$(evt.target).siblings(".delete_scene").addClass("displayNone");
			}
		})
		
		$(".robot_edit_model_save").click(function(){
			location.reload();
		})
	});
	

	//搜索关键字
	$("#search_ipt").keyup(function(event){
		searchDown("advance");
	})
	$("#search_text").click(function(){
		searchDown("advance");
	})

})

