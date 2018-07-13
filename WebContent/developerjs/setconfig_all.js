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
		var bookPos=JSON.parse(window.localStorage.bookPos);
	}
	
	var all='';
	var groupId=robotList[0].userGroupId;
	var userId=robotList[0].userId;
	var groupName=robotList[0].userGroupName;

	createRobotsDeveloper(robotList,bookPos);

	$("#setconfig_hangye").click(function(){
		var _this=$(this);
		if(_this.val()!=bookPos.hy){
			bookPos.hy=_this.val();
			bookPos.qy=0;
			bookPos.cj=0;
			bookPos.robot=0;
			window.localStorage.bookPos=JSON.stringify(bookPos);	
		}
	})
	$("#setconfig_qiye").click(function(){
		var _this=$(this);
		if(_this.val()!=bookPos.qy){
			bookPos.qy=_this.val();
			bookPos.cj=0;
			bookPos.robot=0;
			window.localStorage.bookPos=JSON.stringify(bookPos);
		}
	})
	$("#setconfig_changjing").click(function(){
		var _this=$(this);
		if(_this.val()!=bookPos.cj){
			bookPos.cj=_this.val();
			bookPos.robot=0;
			window.localStorage.bookPos=JSON.stringify(bookPos);
		}
	})
	$("#setconfig_robots").click(function(){
		var _this=$(this);
		if(_this.val()!=bookPos.robot){
			bookPos.robot=_this.val();
			window.localStorage.bookPos=JSON.stringify(bookPos);
		}	
	})

	$("#setconfig_hangye").change(function(){
		layerLoad();
		var _this=$(this);
		if(_this.val()==0){
			var priority=0;
		}else{
			var priority=1;
		}
		var getConfigUrl="https://"+host+"/signalmaster/rest/config/all/"+_this.val()+"/"+priority+"/"+getKeyword();
		var getQiyeUrl="https://"+host+"/signalmaster/rest/config/userGroups/"+_this.val()+"/null";
		var getChangjingUrl="https://"+host+"/signalmaster/rest/config/userGroupsScenes/0/null";
		var getRobotUrl="https://"+host+"/signalmaster/rest/config/robots/"+_this.val()+"/0/0/null";
		$("#setconfig_qiye").html("<option value='0'>所有企业</option>");
		$("#setconfig_changjing").html("<option value='0'>所有场景</option>");
		$("#setconfig_robots").html("<option value='0'>所有机器人</option>");
		changeRobots(getConfigUrl);
		//企业更新
		createSelect(getQiyeUrl,$("#setconfig_qiye"));
		//场景更新
		createSelect(getChangjingUrl,$("#setconfig_changjing"));
		//机器人更新
		createSelect(getRobotUrl,$("#setconfig_robots"));	
	})
	$("#setconfig_qiye").change(function(){
		layerLoad();
		var _this=$(this);
		var hangye=$("#setconfig_hangye").val();
		if(_this.val()!=0){
			var priority=3;
			var ownerId=_this.val();
		}else{
			var priority=1;
			var ownerId=$("#setconfig_hangye").val();
		}
		var getConfigUrl="https://"+host+"/signalmaster/rest/config/all/"+ownerId+"/"+priority+"/"+getKeyword();
		var getChangjingUrl="https://"+host+"/signalmaster/rest/config/userGroupsScenes/"+_this.val()+"/null";
		var getRobotUrl="https://"+host+"/signalmaster/rest/config/robots/"+hangye+"/"+_this.val()+"/0/null";
		$("#setconfig_changjing").html("<option value='0'>所有场景</option>");
		$("#setconfig_robots").html("<option value='0'>所有机器人</option>");
		changeRobots(getConfigUrl);
		//场景更新
		createSelect(getChangjingUrl,$("#setconfig_changjing"));
		//机器人更新
		createSelect(getRobotUrl,$("#setconfig_robots"));	
	})
	$("#setconfig_changjing").change(function(){
		layerLoad();
		var _this=$(this);
		var hangye=$("#setconfig_hangye").val();
		var qiye=$("#setconfig_qiye").val();
		if(_this.val()!=0){
			var priority=5;
			var ownerId=_this.val();
		}else if(qiye!=0){
			var priority=3;
			var ownerId=qiye;
		}else if(hangye!=0){
			var priority=1;
			var ownerId=hangye;
		}else{
			var priority=1;
			var ownerId=0;
		}
		var getConfigUrl="https://"+host+"/signalmaster/rest/config/all/"+ownerId+"/"+priority+"/"+getKeyword();
		var getRobotUrl="https://"+host+"/signalmaster/rest/config/robots/"+hangye+"/"+qiye+"/"+_this.val()+"/null";
		$("#setconfig_robots").html("<option value='0'>所有机器人</option>");
		changeRobots(getConfigUrl);

		//机器人更新
		createSelect(getRobotUrl,$("#setconfig_robots"));	
	})

	$("#setconfig_robots").change(function(){
		layerLoad();
		var _this=$(this);
		var hangye=$("#setconfig_hangye").val();
		var qiye=$("#setconfig_qiye").val();
		var changjing=$("#setconfig_changjing").val();
		if(_this.val()!=0){
			var priority=255;
			var ownerId=_this.val();
		}else if(changjing!=0){
			var priority=5;
			var ownerId=changjing;
		}else if(qiye!=0){
			var priority=3;
			var ownerId=qiye;
		}else if(hangye!=0){
			var priority=1;
			var ownerId=hangye;
		}else{
			var priority=1;
			var ownerId=0;
		}
		var getConfigUrl="https://"+host+"/signalmaster/rest/config/all/"+ownerId+"/"+priority+"/"+getKeyword();
		changeRobots(getConfigUrl);
	})


	function createSelect(url,parent,callback){
		var options='';
		multiSubmit(url,function(){
			if(message=="OK"){
				if(data!=undefined){
					for(var i=0;i<data.length;i++){
						options+='<option value='+data[i].value+'>'+data[i].name+'</option>';
					}
					parent.append(options);
					if(callback){
						callback()
					}
				}				
			}else{
				layer.alert(message);
			}
		})
	}
	
	//搜索关键字
	$("#search_ipt").keyup(function(event){
		searchDown();
	})
	$("#search_text").click(function(){
		searchDown();
	})

})

