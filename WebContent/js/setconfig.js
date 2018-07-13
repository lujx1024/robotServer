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
	var allRobots=robotList[0].userGroupName;
	var groupId=robotList[0].userGroupId;
	var userId=robotList[0].userId;
	var groupName=robotList[0].userGroupName;

	$(".all_robots").val(allRobots);

	createRobots(robotList);

	//加载完成显示全部
	//var groupUrl="/signalmaster/rest/config/search/"+groupId+"/null";
	var groupUrl="https://"+host+"/signalmaster/rest/config/all/"+groupId+"/3/null";
	layerLoad();
	changeRobots(groupUrl);
	$(".all_robots").addClass("all_robots_current");
	$(".all_robots").click(function(){
		layerLoad();
		$(".all_robots").addClass("all_robots_current");
		$("#robots input").removeClass('robotCurrent');
		searchDown();
	})

	/*切换机器人*/

	$("#robots input").click(function(){
		layerLoad();
		$(this).addClass('robotCurrent').siblings().removeClass('robotCurrent');
		$(".all_robots").removeClass("all_robots_current");
		searchDown();
	})

	//搜索关键字
	$("#search_ipt").keyup(function(event){
		searchDown();
	})
	$("#search_text").click(function(){
		searchDown();
	})
	

	/*新增*/
	$("#addBtn").click(function(){
		whichRobot();
		var addData={};
		var addSn=getInfo();
		var addFormHtml='\
		<div id="addInfo" class="infoLayer">\
		    <div class="infoLayerList"><label>配置名：</label><input type="text" value="" name="config_key"/></div>\
		    <div class="infoLayerList"><label>配置值：</label><textarea name="config_value"></textarea></div>\
		    <form role="form" id="fileForm" method="post" enctype="multipart/form-data">\
		    	<div class="infoLayerList">\
			    	<label>上传文件：</label>\
			    	<a href="#" class="loadfile">选择文件<input type="file" name="file"></a>\
			    	<div class="upload_fileOk"><i class="icon-check"></i>上传成功！</div>\
			    	<div style="margin:5px 0 0 82px;"><input type="button" id="upload_btn" value="开始上传"/>\
			    	<input type="button" value="重置" id="reset_value"/></div>\
		    	</div>\
		    </form>\
		    <div class="infoLayerList"><label>配置描述：</label><textarea name="description" ></textarea></div>\
		    <div class="group_tip">请选择应用范围</div>\
		    <div class="exRange">\
		    	<label>应用范围：</label>\
		    	<input type="checkbox" id="groupName" name='+groupName+' groupId='+groupId+'>\
		    	<span>'+groupName+'</span></div>\
		    <div id="robotCheck" class="clearfix"></div>\
		    <div class="error_tip">输入值不能有空值，请输入！</div>\
		    <div class="formsub_box clearfix">\
			    <input id="addSubmit" type="button" value="确定" class="submit_btn fl"/>\
			    <input id="addCancle" type="button" value="取消" class="cancle_btn fr"/>\
		    </div>\
		</div>';


		if(groupFlag){
			checkInfo(robotList,addFormHtml);
			$("#groupName").get(0).checked=true;
			$("#groupName").get(0).disabled=true;
			$("#robotCheck input[type='checkbox']").each(function(){
				$(this).get(0).disabled=true;
			})
			$("#addSubmit").click(function(){
				layerLoad();
				addData={
					user_id:userId,
					group_id:groupId,
					config_key:$("#addInfo input[name='config_key']").val(),
					config_value:$("#addInfo textarea[name='config_value']").val(),
					description:$("#addInfo textarea[name='description']").val()
				}
				checkNull(addData);
				if(nullFlag){
					$(".error_tip").show();
				}else{
					$(".error_tip").hide();
					subForm("https://"+host+"/signalmaster/rest/set_config",addData,function(){
						changeRobots(groupUrl);	
					})
				}
			})
		}else{
			checkInfo(robotList,addFormHtml);
			var robotId='';
			$("#robotCheck input[type='checkbox']").each(function(){
				if($(this).attr('name')==searchId){
					$(this).get(0).checked=true;
					robotId=$(this).attr('name');
				}
				$(this).get(0).disabled=true;
			})
			$("#groupName").get(0).disabled=true;

			$("#addSubmit").click(function(){
				layerLoad();
				var robotUrl="https://"+host+"/signalmaster/rest/config/"+addSn.sn;
				addData={
					user_id:addSn.userId,
					robot_id:robotId,
					config_key:$("#addInfo input[name='config_key']").val(),
					config_value:$("#addInfo textarea[name='config_value']").val(),
					description:$("#addInfo textarea[name='description']").val(),
				}
				checkNull(addData);
				if(nullFlag){
					$(".error_tip").show();
				}else{
					$(".error_tip").hide();
					subForm("https://"+host+"/signalmaster/rest/set_config",addData,function(){
						changeRobots(robotUrl);	
					})	
				}						
			})
		}
		
	})

	
	
})

