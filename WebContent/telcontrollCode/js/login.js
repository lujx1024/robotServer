
$(function(){ 
	var localHost=window.location.href;
	var regHost=/\/\/(.*?)\//;
	var host=localHost.match(regHost)[1];

	/**
        禁止浏览器后退
    */
	if (window.history && window.history.pushState){
		$(window).on('popstate', function (){
			window.history.pushState('forward',null,'#');
			window.history.forward(1);
		});
	}
　　window.history.pushState('forward',null,'#'); //在IE中必须得有这两行
　　window.history.forward(1);
	
	/*
		登录
	*/

	function initLogin(userName, password) {
		var loginData={
			userName:userName,
			password:password,
			sessionId:""
		};
		var loginUrl="https://"+host+"/signalmaster/rest/remote/login";
		$.ajax({
			cache:false,
			type:"POST",
			url:loginUrl,
			data:loginData,
			success:function(result){
				var jsonData = result.data;
				if(result.code == 0){
					window.localStorage.controllerUser=$("#userName").val();
					window.localStorage.controllerPwd=$("#password").val();
					window.localStorage.controllerUserId = result.userId;
					window.localStorage.controllerSessionId = result.sessionId;
					window.location.href = "session.html";
				}else{
					layer.close(tipIndex);
					layer.tips("登陆失败："+result.message,"#password");
				}
			},
			error:function(){
				alert('服务器异常！');
			}
		});
	}	
	/*
		登录进行校验
	*/

	function login()  {
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
		
		tipIndex = layer.load(0, {shade: false});
		//初始化登录请求数据，ajax异步请求时作为data值
		initLogin($("#userName").val(), $("#password").val());
	}
	

	//enter键触发事件
	var fKeyToLogin = function(event){
		if (event.keyCode == 13) {
			login();
		}
	};
	$(document).on("click","#login",function(){
		login();
	});

	$("#userName").keypress(fKeyToLogin);
	$("#password").keypress(fKeyToLogin);

});