$(document).ready(function(){
	var layerIndex = "";
	var pagination=8;
	if(window.localStorage.data==undefined){
		var layerIndex=layer.alert("未登录，请先登陆！",{
		  	icon:5,
		  	btn:['确定'],
		  	yes:function(index, layero){
		  		window.location.href="login.html";
		  		layer.close(layerIndex);
		  	}
		})
	}

	getUserList();
	
	$(document).off("click","#setTokenBtn").on("click","#setTokenBtn",function(){
		getToken();
	});

	/*
		添加按钮点击弹出框
	*/

	$(document).off("click","#addUserBtn").on("click","#addUserBtn",function(){
	// $("#addUserBtn").click(function(){
		var addFormHtml='\
		<div id="appAdd" class="userAddLayer">\
			 <div class="infoLayerList"><label>用户名称：</label><input type="text" value="" id="userName"/></div>\
		    <div class="infoLayerList"><label>用户密码：</label><input type="password" value="" id="userPwd"/></div>\
		    <div class="infoLayerList"><label>用户权限：</label><select class="userLevel"><option value="0">0</option><option value="1">1</option></select></div>\
		    <div class="infoLayerList"><label>关联机器人：</label><textarea id="robotList" placeholder="填写要关联的机器人SN号"></textarea></div>\
		    <div class="formsub_box clearfix" style="">\
			    <input id="addUser_OK" type="button" value="确定" class="addUser_OK fl"/>\
			    <input id="addUser_Cancle" type="button" value="取消" class="addUser_Cancle fr"/>\
		    </div>\
		</div>';

		layerIndex=layer.open({
			type:1,
			title:'新增用户',
		  	skin: 'layui-layer-rim', //加上边框
		  	area: ['492px', '370px'], //宽高
		  	content:addFormHtml
		});

	});

	/*
		添加按钮弹出框确定
	*/
	$(document).off("click","#addUser_OK").on("click","#addUser_OK",function(){
		var currentUserName = $("#userName").val();
		var currentUserPwd = $("#userPwd").val();
		var currentUserLevel = $(".userLevel option:selected").val();
		var currentRobotList = $("#robotList").val();

		if(currentUserName == ""){
			layer.tips('用户名不能为空', '#userName');
			$('#userName').select();
			return;
		}
		if(currentUserPwd == ""){
			layer.tips('密码不能为空', '#userPwd');
			$("#userPwd").select();
			return;
		}

		var addUserJson = {
			"userName": currentUserName,
			"password": currentUserPwd,
			"userLevel": currentUserLevel,
			"userRelateRobot": currentRobotList
		};
		addUser(addUserJson);
	});

	/*
		新增取消按钮
	*/
	$(document).off("click","#addUser_Cancle").on("click","#addUser_Cancle",function(){
		layer.close(layerIndex);
	});


	/*
		用户修改
	*/
	$(document).off("click",".editBtn").on("click",".editBtn",function(){
		var _this=$(this);
		var editUserId = _this.parent().siblings(".userName").attr("userId");
		var editUserName = _this.parent().siblings(".userName").attr("value");
		var editUserPwd = _this.parent().siblings(".password").attr("value");
		var editUserLevel = _this.parent().siblings(".userLevel").attr("value");
		var editUserRelateRobot = _this.parent().siblings(".userRelateRobot").attr("value");


		var editFormHtml='\
		<div id="editUser" class="userAddLayer">\
			 <div class="infoLayerList"><label>用户名称：</label><input type="text" value="" userId="'+ editUserId +'" id="userName_edit" disabled="disabled"/></div>\
		    <div class="infoLayerList"><label>用户密码：</label><input type="password" value="" id="userPwd_edit"/></div>\
		    <div class="infoLayerList"><label>用户权限：</label><select class="userLevel_edit"><option value="0">0</option><option value="1">1</option></select></div>\
		    <div class="infoLayerList"><label>关联机器人：</label><textarea id="robotList_edit" placeholder="填写要关联的机器人SN号"></textarea></div>\
		    <div class="formsub_box clearfix" style="">\
			    <input id="editUser_OK" type="button" value="确定" class="addUser_OK fl"/>\
			    <input id="editUser_Cancle" type="button" value="取消" class="addUser_Cancle fr"/>\
		    </div>\
		</div>';



		layerIndex=layer.open({
			type:1,
			title:'用户修改',
		  	skin: 'layui-layer-rim', //加上边框
		  	area: ['492px', '370px'], //宽高
		  	content:editFormHtml
		});

		$("#userName_edit").val(editUserName);
		$("#userPwd_edit").val(editUserPwd);
		$(".userLevel_edit option[value='"+editUserLevel+"']").attr("selected", true);
		$("#robotList_edit").val(editUserRelateRobot);

	});

	/*
		编辑确定点击事件
	*/
	$(document).off("click","#editUser_OK").on("click","#editUser_OK",function(){
		var userName_edit = $("#userName_edit").val();
		var userId_edit = $("#userName_edit").attr("userId");
		var userPwd_edit = $("#userPwd_edit").val();
		var userLevel_edit = $(".userLevel_edit option:selected").val();
		var robotList_edit = $("#robotList_edit").val();

		if(userName_edit == ""){
			layer.tips('用户名不能为空', '#userName_edit');
			$('#userName_edit').select();
			return;
		}
		if(userPwd_edit == ""){
			layer.tips('密码不能为空', '#userPwd_edit');
			$("#userPwd_edit").select();
			return;
		}

		var editUserJson = {
			"userName": userName_edit,
			"password": userPwd_edit,
			"userLevel": userLevel_edit,
			"userRelateRobot": robotList_edit,
			"userId":userId_edit
		};
		eidtUserInformation(editUserJson);
	});

	/*
		用户删除点击事件
	*/
	$(document).off("click",".deleteBtn").on("click",".deleteBtn",function(){
		var _this=$(this);
		var deleteUserId = _this.parent().siblings(".userName").attr("userId");
		// var deleteUserName = _this.parent().siblings(".userName").attr("value");
		// var deleteUserPwd = _this.parent().siblings(".password").attr("value");
		// var deleteUserLevel = _this.parent().siblings(".userLevel").attr("value");
		// var deleteUserRelateRobot = _this.parent().siblings(".userRelateRobot").attr("value");

		var deleteUserJson = {
			"userId": deleteUserId
		};
		layerIndex=layer.alert("是否确定删除该用户?",{
	  		icon:3,
	  		btn:['确定'],
	  		yes:function(index, layero){
	  			layer.close(layerIndex);
                deleteUserInformation(deleteUserJson);
	  		}
	  	});
	});

	/*
		用户删除命令下发
	*/
	function deleteUserInformation(deleteUserJson){
		$.ajax({
			cache:false,
			type:'POST',
			data:deleteUserJson,
			url:"https://"+host+"/signalmaster/rest/remote/deleteuser",
			success:function(result){
				if(result.code==0){
					layerIndex=layer.alert("删除成功！",{
				  		icon:1,
				  		btn:['确定'],
				  		yes:function(index, layero){
				  			//刷新
							getUserList();
				  			layer.close(layerIndex);
				  		}
				  	});
				}else{
					layer.closeAll();
					layer.alert(result.message);
				}
			},
			error:function(result){
				alert('服务器异常！');
			}
		});
	}
	/*
		修改用户信息下发
	*/
	function eidtUserInformation(dataJson){
		$.ajax({
			cache:false,
			type:'POST',
			data:dataJson,
			url:"https://"+host+"/signalmaster/rest/remote/updateuser",
			success:function(result){
				if(result.code==0){
					//刷新
					getUserList();
					layer.close(layerIndex);
				}else{
					layer.closeAll();
					layer.alert(result.message);
				}
			},
			error:function(result){
				alert('服务器异常！');
			}
		});
	}

	/*
		新增用户
	*/
	function addUser(dataJson){
		$.ajax({
			cache:false,
			type:'POST',
			data:dataJson,
			url:"https://"+host+"/signalmaster/rest/remote/adduser",
			success:function(result){
				if(result.code==0){
					//刷新
					getUserList();
					layer.close(layerIndex);
				}else{
					layer.closeAll();
					layer.alert(result.message);
				}
			},
			error:function(result){
				alert('服务器异常！');
			}
		});
	}

	/**
		用户管理列表
	**/

	function creatUserListContent(parent,data,num,pagination){
		parent.html('');
		var pageCount=Math.ceil(data.length/pagination);
		var dataTrTitle=$('<tr class="table_title">\
						<td width="20%">用户名</td>\
						<td width="20%">用户密码</td>\
						<td width="20%">权限等级</td>\
						<td width="30%">关联机器人</td>\
						<td>操作</td>\
					</tr>');
		dataTrTitle.appendTo(parent);

		//判断是不是最后一页
		if(num==pageCount){
			for(var i=((num-1)*pagination);i<(data.length);i++){
				var dataTr=$('<tr>\
					<td class="userName" userId="'+data[i].userId+'" value="'+data[i].userName+'">'+data[i].userName+'</td>\
					<td class="password" value="'+data[i].password+'">'+data[i].password+'</td>\
					<td class="userLevel" value="'+data[i].userLevel+'">'+data[i].userLevel+'</td>\
					<td class="userRelateRobot" value="'+data[i].userRelateRobot+'">'+data[i].userRelateRobot+'</td>\
					<td>\
						<input type="button" class="editBtn" title="编辑" name="编辑">\
						<input type="button" class="deleteBtn" title="删除" name="删除">\
					</td>\
				</tr>');
				dataTr.appendTo(parent);

			}
		}else{
			for(var i=((num-1)*pagination);i<(num*pagination);i++){
				var dataTr=$('<tr>\
					<td class="userName" userId="'+data[i].userId+'" value="'+data[i].userName+'">'+data[i].userName+'</td>\
					<td class="password" value="'+data[i].password+'">'+data[i].password+'</td>\
					<td class="userLevel" value="'+data[i].userLevel+'">'+data[i].userLevel+'</td>\
					<td class="userRelateRobot" value="'+data[i].userRelateRobot+'">'+data[i].userRelateRobot+'</td>\
					<td>\
						<input type="button" class="editBtn" title="编辑" name="编辑">\
						<input type="button" class="deleteBtn" title="删除" name="删除">\
					</td>\
				</tr>');
				dataTr.appendTo(parent);
			}
		}
		$("#table tr,#table td").css({"height":"65px"});
	}

	 /**
		获取用户列表数据

	 **/
	function getUserList(callback){
		
		$.ajax({
			cache:false,
			type:'POST',
			url:"https://"+host+"/signalmaster/rest/remote/selectuser",
			success:function(result){
				var userList = result.data;
				if(result.code==0){
					createPage($("#table"),userList,pagination,creatUserListContent);
					if(callback){
						callback();
					}
				}else{
					layer.closeAll()
					layer.alert(result.message);
				}
				
			},
			error:function(result){
				alert('服务器异常！');
			}
		});
	}
	
	/**
	获取token

 **/
function getToken(){
	$.ajax({
		cache:false,
		type:'POST',
		url:"https://"+host+"/signalmaster/rest/remote/getAndSetAccessToken",
		success:function(result){
			var resutlMessage = result.data;
			if(result.code==200){
				layer.alert("当前获取最新token为:  "+result.data, {
                    skin: 'layui-layer-demo' //样式类名
                    ,closeBtn: 0
                  }, function(index){
                      layer.close(index);

                  }); 
			}else{
				layer.closeAll()
				layer.alert(result.message);
			}
			
		},
		error:function(result){
			alert('服务器异常！');
		}
	});
}

})