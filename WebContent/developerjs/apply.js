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
		var applySn=JSON.parse(window.localStorage.data)[0].robotImei;
		var appGroup=JSON.parse(window.localStorage.data)[0].userGroupName;
		var groupId=JSON.parse(window.localStorage.data)[0].userGroupId;
	}
	$("#search_ipt").attr('placeholder','输入关键字');

	//获取应用列表
	getApplyList(applySn,'null');

	//搜索关键字
	$("#search_ipt").keyup(function(event){
		searchApp(applySn);
	})
	$("#search_text").click(function(){
		searchApp(applySn);
	})

	//新增
	$("#addBtn").click(function(){
		var addData={};
		var addFormHtml='\
		<div id="appAdd" class="infoLayer">\
			 <div class="infoLayerList"><label>包名：</label><textarea name="appPackageName" style="height:55px"></textarea></div>\
		    <div class="infoLayerList"><label>应用名：</label><input type="text" value="" name="appName"/></div>\
		    <div class="infoLayerList"><label>所属：</label><span class="appOwner">'+appGroup+'</span><input type="button" value="增加" class="appAddOwner" disabled="disabled"/></div>\
		    <div class="infoLayerList"><label>应用描述：</label><textarea name="description"></textarea></div>\
		    <div class="group_tip">输入值不能有空值，请输入！</div>\
		    <div class="infoLayerList"><label>可用：</label><input type="checkbox" name="enable" class="appEnable" checked="checked"/></div>\
		    <div class="formsub_box clearfix" style="">\
			    <input id="addAppSubmit" type="button" value="确定" class="submit_btn fl"/>\
			    <input id="addAppCancle" type="button" value="取消" class="cancle_btn fr"/>\
		    </div>\
		</div>';

		layerIndex=layer.open({
			type:1,
			title:'新增应用',
		  	skin: 'layui-layer-rim', //加上边框
		  	area: ['492px', '550px'], //宽高
		  	content:addFormHtml
		})

		$("#addAppSubmit").click(function(){
			addData={
				packageName:$("#appAdd textarea[name='appPackageName']").val(),
				appName:$("#appAdd input[name='appName']").val(),
				groupId:groupId,
				enable:$("#appAdd input[name='enable']").is(":checked"),
				description:$("#appAdd textarea[name='description']").val()
			}
			checkNull(addData);
			if(nullFlag){
				$(".group_tip").css('display','block')
			}else{
				$(".group_tip").css('display','none');
				subForm("https://"+host+"/signalmaster/rest/app/save",addData,function(){
					getApplyList(applySn,'null')
					layer.close(layerIndex);
				});
			}
			
		})

		$("#addAppCancle").click(function(){
			layer.close(layerIndex);
		})
	})

})