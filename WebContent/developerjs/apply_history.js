//版本历史查看
$(document).ready(function(){
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
		var appId=window.localStorage.appId;
		var appName=window.localStorage.appName;
	}

	$(".table_bar").text(appName+" 的版本历史");
	var uploadFileUrl = "https://"+host+"/signalmaster/upload";

	//日历插件
	var searchDate=new Date();
	var searchYear=searchDate.getFullYear();
	var searchMonth=zero(searchDate.getMonth()+1);
	var searchDay=zero(searchDate.getDate());	
	var startDay=searchYear+"-"+searchMonth+"-"+searchDay;
	$("#start_time").val(searchYear+"-01-01");
	$("#end_time").val(startDay);
	$("#start_time").focus(function(){
		laydate({
	        elem: '#start_time',
	        choose:function(dates){
	        	if(dates>$("#end_time").val()){
	        		$("#end_time").val(dates);
	        	}
	        }
	    })
	})  
    $("#end_time").focus(function(){
    	laydate({
	        elem:"#end_time",
	        min:$("#start_time").val()+' 00:00:00',
	        max:'2880-01-01 00:00:00'
	    })
    })

	getHistoryList(appId);

	//关键字搜索
	$("#search_text").click(function(){
		var searchKey=$("#search_ipt").val();
		if(searchKey==''){
			searchKey="null";
		}
		var fromTime=$("#start_time").val();
		var toTime=$("#end_time").val();
		searchHistory(appId,searchKey,fromTime,toTime);
	})

	$(".search_box input").keyup(function(){
		$("#search_text").trigger('click');
	})


	//新增版本
	$("#addBtn_history").click(function(){
		var versionData={};
		var downloadUrl='';
		var versionFormHtml='\
		<div id="appAdd" class="infoLayer">\
		    <div class="infoLayerList"><label>应用名：</label><input type="text" value='+appName+' name="appName" disabled="disabled"/></div>\
		    <div class="infoLayerList"><label>版本号：</label><input type="text" value="" name="versionCode"/></div>\
		    <div class="infoLayerList"><label>版本名：</label><input type="text" value="" name="versionName"/></div>\
		    <div class="infoLayerList"><label>版本描述：</label><textarea name="releaseNote"></textarea></div>\
		    <form role="form" id="fileForm" method="post" enctype="multipart/form-data">\
		    	<div class="infoLayerList">\
			    	<label>上传文件：</label>\
				    	<a href="#" class="loadfile">选择文件<input type="file" name="file" id="file_chose"></a>\
				    	<div class="upload_fileOk"><i class="icon-check"></i>上传成功！</div>\
				    	<div style="margin:5px 0 0 82px;"><input type="button" id="upload_btn" value="开始上传"/>\
		    	</div>\
		    </form>\
		    <div class="group_tip">输入值不能有空值，请输入！</div>\
		    <div class="infoLayerList"><label>可用：</label><input type="checkbox" class="appEnable" name="enable" checked="checked"/></div>\
		    <div class="formsub_box clearfix">\
			    <input id="versionSubmit" type="button" value="确定" class="submit_btn fl"/>\
			    <input id="versionCancle" type="button" value="取消" class="cancle_btn fr"/>\
		    </div>\
		</div>';

		layerIndex=layer.open({
			type:1,
			title:'上传新版本',
		  	skin: 'layui-layer-rim', //加上边框
		  	area: ['550px', '524px'], //宽高
		  	content:versionFormHtml
		})

		$(".loadfile").click(function(){
			$(".upload_fileOk").css("visibility",'hidden');
			$(this).children().val('');
			$(this).children().change(function(){
				var _this=$(this).val();
				$('.upload_fileOk').css({'visibility':'visible','font-size':'13px'});	
				var urlIndex=_this.lastIndexOf("\\")+1;
				var fileUrl=_this.substring(urlIndex);
				$('.upload_fileOk').text(fileUrl);
			});
		})

		$("#upload_btn").click(function(){
			if($(".upload_fileOk").css("visibility")=="visible"){
				$(".upload_fileOk").html("<i class='icon-spinner' style='color:#bbb'></i>上传中...");
				uploadByForm($("#fileForm")[0],uploadFileUrl,function(){
					$(".upload_fileOk").html("<i class='icon-check'></i>上传成功！");
					downloadUrl=uploadUrl;
				});
			}else{
				layer.alert("请选择要上传的文件！")
			}
		})

		$("#versionSubmit").click(function(){
			getCurrentPage();
			versionData={
				appId:appId,
				versionCode:$("#appAdd input[name='versionCode']").val(),
				versionName:$("#appAdd input[name='versionName']").val(),
				downloadUrl:downloadUrl,
				releaseNote:$("#appAdd textarea[name='releaseNote']").val(),
				enable:$("#appAdd input[name='enable']").is(":checked")
			}
			
			checkNull(versionData);
			if(nullFlag){
				$(".group_tip").css('display','block')
			}else{
				$(".group_tip").css('display','none');
				subForm("https://"+host+"/signalmaster/rest/app/version/save",versionData,function(){
					getHistoryList(appId)
					/*getApplyList(applySn,keyWords,function(){
						$(".page_skip input").val(editCurrentpage);
						$(".page_skip a").trigger('click');
					})*/
					layer.close(layerIndex);
				});
			}

			
		})

		$("#versionCancle").click(function(){
			layer.close(layerIndex);
		})
	})


})

//创建应用管理列表
function creatHistoryContent(parent,data,num,pagination){
	if(!data){
		parent.html('');
	}
	parent.html('');
	var pageCount=Math.ceil(data.length/pagination);
	var dataTrTitle=$('<tr class="table_title">\
					<td width="16%">版本名</td>\
					<td>版本描述</td>\
					<td width="100">发布时间</td>\
					<td width="50">可用</td>\
					<td width="80">操作</td>\
				</tr>');
	dataTrTitle.appendTo(parent);

	//判断是不是最后一页
	if(num==pageCount){
		for(var i=((num-1)*pagination);i<(data.length);i++){
			var dataTr=$('<tr>\
				<td keyName="versionName">'+data[i].versionName+'</td>\
				<td keyName="releaseNote">'+data[i].releaseNote+'</td>\
				<td keyName="datetime">'+data[i].publishDatetime+'</td>\
				<td keyName="enable">'+data[i].enabled+'</td>\
				<td>\
					<input type="button" class="editBtn" title="编辑" name="编辑" version='+data[i].versionCode+' appId='+data[i].robotAppId+' url='+data[i].downloadUrl+'>\
					<input type="button" class="deleteBtn" title="删除" name="删除" version='+data[i].versionCode+' appId='+data[i].robotAppId+'>\
				</td>\
			</tr>');
			dataTr.appendTo(parent);

		}
	}else{
		for(var i=((num-1)*pagination);i<(num*pagination);i++){
			var dataTr=$('<tr>\
				<td keyName="versionName">'+data[i].versionName+'</td>\
				<td keyName="releaseNote">'+data[i].releaseNote+'</td>\
				<td keyName="datetime">'+data[i].publishDatetime+'</td>\
				<td keyName="enable">'+data[i].enabled+'</td>\
				<td>\
					<input type="button" class="editBtn" title="编辑" name="编辑" version='+data[i].versionCode+' appId='+data[i].robotAppId+' url='+data[i].downloadUrl+'>\
					<input type="button" class="deleteBtn" title="删除" name="删除" version='+data[i].versionCode+' appId='+data[i].robotAppId+'>\
				</td>\
			</tr>');
			dataTr.appendTo(parent);
		}
	}

	$("#table td[keyName='enable']").each(function(){
		var checkedOr=eval($(this).text());
		$(this).text('');
		$(this).append("<input type='checkbox' disabled='disabled' style='width:18px;height:18px;'/>");
		$(this).children('input').get(0).checked=checkedOr;

	})

	//编辑
	$(".editBtn").click(function(){
		var _this=$(this);
		var editList=_this.parent().siblings();
		var appId=_this.attr("appId");
		var versionCode=_this.attr("version");
		var downloadUrl=_this.attr("url");

		findAppKeyName(editList);
		keyenable.children('input').addClass("apply_enable");
		keyenable.children('.apply_enable').get(0).disabled=false;
		appEdit(appId,versionCode,downloadUrl);
		$(".appedit_keyname,.appedit_keyversion,.appedit_keyrelease").css("height","35px")
	})

	//删除
	$(".deleteBtn").click(function(){
		var _this=$(this);
		deleteHistory(_this);
	})


}

//搜索
function searchHistory(appId,searchKey,fromTime,toTime)
{
	if(searchKey.length > 0){
		var searchUrl="https://"+host+"/signalmaster/rest/app/version/list/"+appId+"/"+searchKey+"/"+fromTime+"/"+toTime;
		multiSubmit(searchUrl,function(){
			console.log(data)
			if(data!=undefined){
				createPage($("#table"),data,pagination,creatHistoryContent);
			}else{
				$("#table").html("");
				$(".counts_page").text(0);
				$(".counts_num").text(0);
			}	
		})
	}else {
		getHistoryList(appId);
	}
}	


//获取版本历史列表
function getHistoryList(appId,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:"https://"+host+"/signalmaster/rest/app/version/list/"+appId,
		success:function(result){
			data=result.data;
			if(data!=undefined){
				console.log(data)
				createPage($("#table"),data,pagination,creatHistoryContent);
			}else{
				$("#table").html('暂无数据！');
				$(".counts_page").text(0);
				$(".counts_num").text(0);
			}
			
			if(callback){
				callback();
			}
		},
		error:function(result){
			alert('服务器异常！');
		}
	})
}



//编辑函数
function appEdit(appId,versionCode,downloadUrl){
	var keyversionOld=keyversion.text();
	var keyreleaseOld=keyrelease.text();
	var keyenableOld=keyenable.children('.apply_enable')[0].checked;
	var appEditInsertData={"keyversion":keyversion,"keyrelease":keyrelease};
	//编辑插入
	insertInput(appEditInsertData,function(){
		$(".appedit_keyversion").focus();
	});


	$(".appedit_keyversion").blur(function(){
		appEditSubmit(appId,versionCode,downloadUrl,keyversionOld,keyreleaseOld,keyenableOld)
	})

	$(".appedit_keyrelease").blur(function(){
		appEditSubmit(appId,versionCode,downloadUrl,keyversionOld,keyreleaseOld,keyenableOld)
	})

	$(".apply_enable").blur(function(){
		appEditSubmit(appId,versionCode,downloadUrl,keyversionOld,keyreleaseOld,keyenableOld)
	})

}

//编辑提交
function appEditSubmit(appId,versionCode,downloadUrl,keyversionOld,keyreleaseOld,keyenableOld){
	var keyversionNew=$(".appedit_keyversion").val();
	var keyreleaseNew=$(".appedit_keyrelease").val();
	var keyenableNew=$(".apply_enable").is(":checked");
	var historyEidtData={};
	var appBlurFlag;
	getCurrentPage();
	setTimeout(function(){
		if($(".appedit_keyversion").is(":focus") || $(".apply_enable").is(":focus") || $(".appedit_keyrelease").is(":focus")){
			appBlurFlag=false;
		}else if(keyversionNew!=keyversionOld || keyreleaseNew!=keyreleaseOld || keyenableNew!=keyenableOld){
			historyEidtData={
				appId:appId,
				versionCode:versionCode,
				versionName:keyversionNew,
				downloadUrl:downloadUrl,
				releaseNote:keyreleaseNew,
				enable:keyenableNew
			}
			subForm("https://"+host+"/signalmaster/rest/app/version/save",historyEidtData,function(){
				getHistoryList(appId,function(){
					$(".page_skip input").val(editCurrentpage);
					$(".page_skip a").trigger('click');
				})
			});
		}else{
			$(".appedit_keyversion").remove();
			keyversion.text(keyversionOld);
			$(".appedit_keyrelease").remove();
			keyrelease.text(keyreleaseOld);
			$(".apply_enable")[0].checked=keyenableOld;
			$(".apply_enable")[0].disabled=true;
			$(".apply_enable").removeClass("apply_enable");
		}
	},10)
}

//删除
function deleteHistory(_this){
	var appId=_this.attr('appId');
	var versionCode=_this.attr('version');
	var _thisSiblingNode=_this.parent().siblings();
	var appName=window.localStorage.appName;
	findAppKeyName(_thisSiblingNode)
	getCurrentPage();
	var deleTip='确认删除 '+appName+' 的 '+keyversion.text()+' 版本吗？'

	var layerIndex=layer.alert(deleTip,{
	  	icon:0,
	  	btn:['确定','取消'],
	  	yes:function(index, layero){
	  		multiSubmit("https://"+host+"/signalmaster/rest/app/version/delete/"+appId+"/"+versionCode,function(){
	  			getHistoryList(appId)
	  		});
	  		layer.close(layerIndex);
	  	},btn2:function(index, layero){
	  		layer.close(layerIndex);
	  	}
	})
}

//显示上传文件的url
function uploadUrl(_this){
	$('.upload_fileOk').css({'visibility':'visible','font-size':'13px'});	
	var urlIndex=_this.lastIndexOf("\\")+1;
	var fileUrl=_this.substring(urlIndex);
	$('.upload_fileOk').text(fileUrl);
}


