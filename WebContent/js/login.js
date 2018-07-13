var socket = null;  
var robotList = null;   
var loginDialog = null;
var loginTip = null;
var tipIndex = 0;

(function( $ ) {
   	// constants
   	var SHOW_CLASS = 'show',
      	HIDE_CLASS = 'hide',
      	ACTIVE_CLASS = 'active';
  
  	$( '.tabs' ).on( 'click', 'li a', function(e){
    	e.preventDefault();
    	var $tab = $( this ),
        href = $tab.attr( 'href' );
  
     	$( '.active' ).removeClass( ACTIVE_CLASS );
     	$tab.addClass( ACTIVE_CLASS );
  
     	$( '.show' )
        .removeClass( SHOW_CLASS )
        .addClass( HIDE_CLASS )
        .hide();
    
     	$(href)
        .removeClass( HIDE_CLASS )
        .addClass( SHOW_CLASS )
        .hide()
        .fadeIn( 550 );
  	});
})( jQuery );

$(function(){
	var localHost=window.location.href;
	console.log(localHost);
	var regHost=/\/\/(.*?)\//;
	var host=localHost.match(regHost)[1];
	//var host="www.robotcheers.com";
	function initWebSocket(userName, password) {
		var loginData={
			username:userName,
			password:password
		};
		var loginUrl="https://"+host+"/signalmaster/rest/admin/login";
		$.ajax({
			cache:false,
			type:"POST",
			url:loginUrl,
			data:loginData,
			success:function(result){
				console.log(result);
				if(result.code==0){
					robotList=result.data;
					window.localStorage.data=JSON.stringify(robotList);
					window.localStorage.sessionId=robotList[0].userLastestStatusWssSessionId;
					var developer=false;
					var userGroupFirst=robotList[0].userGroupId;
					/**
					 * 判断是否为开发者账号登录
					 */
					for(var i=1;i<robotList.length;i++){
						if(robotList[i].userGroupId!=userGroupFirst){
							developer=true;
							break;
						}
					}
					
					if(developer){
						window.location.href="setConfig_all.html";
						window.localStorage.bookPos=JSON.stringify({"hy":0,"qy":0,"cj":0,"robot":0});
					}else{
						window.location.href="setConfig_common.html" ;
						window.localStorage.bookPos="all";
					}
				}else if(result.code=="S0005"){
					var loginDataHijack={
						username:userName,
						password:password,
						hijack:true
					};
					layer.alert(result.message,{
		    		    skin: 'layui-layer-demo' ,//样式类名
		    		  	closeBtn: 0,
		    		  	btn:['确定','强行登录'],
		    		  	yes:function(index){
		    		  		layer.close(tipIndex);
		    		  		layer.close(index);
		    		  	},
		    		  	/**
		    		  	 * 
		    		  	 * 绑定"强行登录"按钮的回调函数
		    		  	 * @param index
		    		  	 */
		    		  	btn2:function(index){
		    		  		$.ajax({
		    		  			cache:false,
								type:"POST",
								url:loginUrl,
								data:loginDataHijack,
								success:function(resultTwo){
									var reLogin=resultTwo;
									if(reLogin.code==0){
										reRobotList=reLogin.data;
										window.localStorage.data=JSON.stringify(reRobotList);
										window.localStorage.sessionId=reRobotList[0].userLastestStatusWssSessionId;
										var developer=false;
										var userGroupFirst=reRobotList[0].userGroupId;
										for(var i=1;i<reRobotList.length;i++){
											if(reRobotList[i].userGroupId!=userGroupFirst){
												developer=true;
												break;
											}
										}
										if(developer){
											window.location.href="setConfig_all.html" ;
											window.localStorage.bookPos=JSON.stringify({"hy":0,"qy":0,"cj":0,"robot":0});
										}else{
											window.location.href="setConfig_common.html" ;
											window.localStorage.bookPos="all";
										}
									}
								}
		    		  		});
		    		  	},
		    		  	error:function(){
							//alert('服务器异常！');
		    		  		layer.msg("服务器异常",{time:2000});
						}
		    		});
				}else if(result.code=="S0001"){
					layer.close(tipIndex);
					layer.tips("登陆失败："+result.message,"#password");
				}else{
					layer.alert(result.message,{
						skin: 'layui-layer-demo' ,//样式类名
			    		closeBtn: 0,
			    		yes:function(index){
			    			layer.close(tipIndex);
			    		  	layer.close(index);
			    		}
					});
				}	
			},
			error:function(){
				alert('服务器异常！');
			}
		});
	}	
		
	function login()  {
		// alert(0);
		
		if ($("#userName").val() == '') {
			layer.tips('用户名不能为空', '#userName');
			$('#userName').select();
			return;
		}
		
		if ($("#password").val() == '') {
			layer.tips('密码不能为空', '#password');
			$("#password").select();
			return;
		}

		window.localStorage.user=$("#userName").val();
		window.localStorage.pwd=$("#password").val();
		
		tipIndex = layer.load(0, {shade: false});
		//初始化登录请求数据，ajax异步请求时作为data值
		initWebSocket($("#userName").val(), $("#password").val());
	}
	//
	/**
	 * 
	 * 定义登陆框的内容
	 * filter:alpha(Opacity=70); opacity: 0.8;
	 * rgba(0,0,0,0.8) ;
	 */
//	var loginDialogHtml = '<div class="top_div"></div><div	style="background-color:#000; filter:alpha(Opacity=70); opacity: 0.7; margin: -280px auto auto; border: 0px solid rgb(231, 231, 231); border-image: none; width: 400px; height: 230px; text-align: center;"><p style="padding: 30px 0px 10px; position: relative;"><span class="u_logo"></span> <input class="ipt"  id = "userName" type="text" placeholder="输入用户名" value=""></p><p style="position: relative; margin-top:10px;"><span class="p_logo"></span> <input class="ipt" id="password" type="password"  id = "password" placeholder="输入密码" value=""></p><div	style="height: 50px; line-height: 50px; margin-top: 30px; border-top-color: rgb(231, 231, 231); border-top-width: 1px; border-top-style: solid;"><p style="margin: 0px 35px 20px 45px;"><span style="float: left;"></span><span style=" width:290px"> <a style="background: rgb(0, 142, 173); display:block; width:270px; height:20px; line-height:20px; margin-top:5px; margin-left:10px; padding: 7px 10px; border-radius: 4px; border: 1px solid rgb(26, 117, 152); border-image: none; color: rgb(255, 255, 255); font-weight: bold;"	href="#" id="login" >登&nbsp;录</a></span></p></div></div><div style="text-align: center;"></div>';
//	var loginDialogHtml='<div class="top_div"></div><div class="login_inputDiv"></div>';
//	var loginDialogHtml='<div class="top_div"></div><div class="login_inputDiv"><form><div><p class="p_userName"><span class="u_logo"></span><input class="ipt" id="userName" type="text" placeholder="输入用户名" value=""></p><p class="p_password"><span class="p_logo"></span><input class="ipt" id="password" type="password" id="password" placeholder="输入密码" value=""> </p> </div> </form></div>';
	
	//var loginDialogHtml='<div class="top_div"></div><div class="login_inputDiv"><form><div><p class="p_userName"><span class="u_logo"></span><input class="ipt" id="userName" type="text" placeholder="输入用户名" value=""></p><p class="p_password"><span class="p_logo"></span><input class="ipt" type="password" id="password" placeholder="输入密码" value=""></p></div><div class="login_button"><p><span></span><span><a href="#" id="login">登&nbsp;录</a></span></p></div></form></div>';
	/**
	 * 登录表单，用于填充layer窗口的content内容
	 * 智&nbsp;能&nbsp;机&nbsp;器&nbsp;人&nbsp;管&nbsp;理&nbsp;系&nbsp;统
	 */
	var loginDialogHtml=
		'<div>\
			<p class="hint">智能机器人管理系统</p>\
		</div>\
	 	<div class="login_inputDiv">\
	    	<form>\
	      		<div>\
	        		<p class="p_userName">\
	          			<span class="u_logo"><i class="fa fa-user fa-2x" aria-hidden="true"></i></span>\
						<input class="ipt" id="userName" type="text" placeholder="输入用户名" value="">\
					</p>\
					<p class="p_password">\
			 			<span class="p_logo"><i class="fa fa-key fa-2x" aria-hidden="true"></i></span>\
						<input class="ipt" type="password" id="password" placeholder="输入密码" value="">\
					</p>\
				</div>\
				<div class="login_button">\
					<p>\
						<span></span>\
						<span style="margin-top:10px">\
							<a  id="login"><span style="font-size:16px;">登&nbsp;录</span></a>\
						</span>\
					</p>\
				</div>\
			</form>\
		</div>';
/*
 <p style="margin: 0px 35px 20px 45px;">\
					<span style="float: left;">\
						<a	style="color: rgb(204, 204, 204); margin-right: 10px;" href="#注册"></a>\
					</span>\
					<span style="float: right; width:100%">\
		 				<a	style="color: rgb(204, 204, 204);" href="#">忘记密码</a>\
						<a\	style="background: rgb(0, 142, 173); padding: 7px 10px; border-radius: 4px; border: 1px solid rgb(26, 117, 152); border-image: none; color: rgb(255, 255, 255); font-weight: bold;"\
						href="#" id="login"">登&nbsp;录</a> \
					</span>\
				</p>\

 *
 */
	if (robotList == null) {
		//页面层
		//alert(0);
		loginDialog = 
//		layer.open({
//		  title : '登录小螺机器人管理系统',
//		  type: 0,
//		  skin: 'layui-layer-rim', //加上边框
//		  area: ['600px', '450px'], //宽高
//		  content: loginDialogHtml
//		 
//		});
			/**
			 * 
			 * 弹出layer弹窗
			 */
		layer.open({
			type: 1,
			title: '南京奥拓电子科技有限公司',  //标题
			skin: 'layui-layer-molv', //加上边框
			closeBtn:0,
			moveType:0,
			area: ['600px', '460px'], //宽高
			content: loginDialogHtml //弹窗内容
			});
		//加载完成后自动获取输入框焦点
		$("#userName").focus();  
	}
	var fKeyToLogin =
		function(event){
		if (event.keyCode == 13) {
			login();
		}
	};
	$("#login").click(function(){
		login();
	});


	$("#userName").keypress(fKeyToLogin);
	$("#password").keypress(fKeyToLogin);
});