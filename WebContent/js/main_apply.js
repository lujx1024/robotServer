//应用管理
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
var uploadFileUrl ="https://"+host+"/signalmaster/upload";


/**
 * 创建应用管理列表
 * @param parent
 * @param data
 * @param num
 * @param pagination
 */
function creatApplyContent(parent,data,num,pagination){
	parent.html('');
	var pageCount=Math.ceil(data.length/pagination);
	var dataTrTitle=$('<tr class="table_title">\
					<td width="9%">应用名</td>\
					<td width="13%">描述</td>\
					<td>包名</td>\
					<td width="7%">所属</td>\
					<td width="11%">最新版本</td>\
					<td width="10%">最新版本描述</td>\
					<td width="10%">最新版本发布时间</td>\
					<td width="60">可用</td>\
					<td width="95">操作</td>\
				</tr>');
	dataTrTitle.appendTo(parent);

	//判断是不是最后一页
	if(num==pageCount){
		for(var i=((num-1)*pagination);i<(data.length);i++){
			var dataTr=$('<tr>\
				<td keyName="appName" appId='+data[i].appId+' appName='+data[i].appName+'>'+data[i].appName+'</td>\
				<td keyName="description">'+data[i].description+'</td>\
				<td keyName="packageName" appId='+data[i].appId+' appName='+data[i].appName+'>'+data[i].appPackageName+'</td>\
				<td keyName="ownerName">'+data[i].appOwner+'</td>\
				<td keyName="versionName"><a href='+data[i].downloadUrl+' class="download_file">'+data[i].lastestVersionName+'</a></td>\
				<td keyName="releaseNote"><a href='+data[i].downloadUrl+' class="download_file">'+data[i].releaseNote+'</a></td>\
				<td keyName="datetime">'+data[i].publishDatetime+'</td>\
				<td keyName="enable">'+data[i].enable+'</td>\
				<td>\
					<input type="button" class="editBtn" title="编辑" name="编辑" appId='+data[i].appId+'>\
					<input type="button" class="deleteBtn appUploadVersion" title="上传新版本" name="上传新版本" appId='+data[i].appId+'>\
					<input type="button" class="expansion appHistory" title="版本历史" name='+data[i].appName+' appId='+data[i].appId+' name="版本历史">\
				</td>\
			</tr>');
			dataTr.appendTo(parent);

		}
	}else{
		for(var i=((num-1)*pagination);i<(num*pagination);i++){
			var dataTr=$('<tr>\
				<td keyName="appName" appId='+data[i].appId+' appName='+data[i].appName+'>'+data[i].appName+'</td>\
				<td keyName="description">'+data[i].description+'</td>\
				<td keyName="packageName" appId='+data[i].appId+' appName='+data[i].appName+'>'+data[i].appPackageName+'</td>\
				<td keyName="ownerName">'+data[i].appOwner+'</td>\
				<td keyName="versionName"><a href='+data[i].downloadUrl+' class="download_file">'+data[i].lastestVersionName+'</a></td>\
				<td keyName="releaseNote"><a href='+data[i].downloadUrl+' class="download_file">'+data[i].releaseNote+'</a></td>\
				<td keyName="datetime">'+data[i].publishDatetime+'</td>\
				<td keyName="enable">'+data[i].enable+'</td>\
				<td>\
					<input type="button" class="editBtn" title="编辑" name="编辑" appId='+data[i].appId+'>\
					<input type="button" class="deleteBtn appUploadVersion" title="上传新版本" name="上传新版本" appId='+data[i].appId+'>\
					<input type="button" class="expansion appHistory" title="版本历史" name='+data[i].appName+' appId='+data[i].appId+' name="版本历史">\
				</td>\
			</tr>');
			dataTr.appendTo(parent);
		}
	}
	$("#table tr,#table td").css({"height":"65px"});


	$("#table td[keyName='enable']").each(function(){
		var checkedOr=eval($(this).text());
		$(this).text('');
		$(this).append("<input type='checkbox' disabled='disabled' style='width:18px;height:18px;'/>");
		$(this).children('input').get(0).checked=checkedOr;

	})

	$("#table .download_file").each(function(){
		if($(this).text()=="N/A"){
			$(this).attr("href","javascript:;")
		}
	})


	//编辑
	$(".editBtn").click(function(){
		var _this=$(this);
		var editList=_this.parent().siblings();
		var appId=_this.attr('appId');
		findAppKeyName(editList);
		keyenable.children('input').addClass("apply_enable");
		keyenable.children('.apply_enable').get(0).disabled=false;

		$("#table td[keyname='appName']").unbind("click");
		appEdit(appId);

	})

	//上传新版本
	$(".appUploadVersion").click(function(){
		var _this=$(this);
		var versionList=_this.parent().siblings();
		var appId=_this.attr('appId');
		findAppKeyName(versionList);
		appUploadVersion(appId);
	})

	//查看历史版本
	$(".appHistory").click(function(){
		window.location.href="apply_history.html";
		var appId=$(this).attr('appId');
		var appName=$(this).attr('name');
		window.localStorage.appId=appId;
		window.localStorage.appName=appName;
	})

	appNameHistory($("#table td[keyname='appName']"));
	appNameHistory($("#table td[keyname='packageName']"));
}

/**
 * 应用名查看版本
 * @param obj
 */
function appNameHistory(obj){
	obj.css("cursor",'pointer');
	obj.click(function(){
		window.location.href="apply_history.html";
		var appId=$(this).attr('appId');
		var appName=$(this).attr('appName');
		window.localStorage.appId=appId;
		window.localStorage.appName=appName;
	})
}	


/**
 * 获取应用列表
 * @param sn
 * @param keyword
 * @param callback
 */
function getApplyList(sn,keyword,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:"https://"+host+"/signalmaster/rest/app/list/"+sn+'/'+keyword,
		success:function(result){
			var applyResult=result;
			console.log(result)
			data=applyResult.data;
			if(applyResult.code==0){
				createPage($("#table"),data,pagination,creatApplyContent);
				if(callback){
					callback();
				}
			}else if(applyResult.code==82){
				layer.closeAll()
				layer.alert(applyResult.message,{
					yes:function(index){
						$(".user_quit").trigger("click");
					}
				});
			}else{
				layer.closeAll()
				layer.alert(applyResult.message);
			}
			
		},
		error:function(result){
			alert('服务器异常！')
		}
	})
}

/**
 * 应用搜索
 * @param appSn
 */
function searchApp(appSn){
	var searchKey = $("#search_ipt").val();
	if(searchKey.length > 0){
		var searchUrl="https://"+host+"/signalmaster/rest/app/list/"+appSn+"/"+searchKey;
		multiSubmit(searchUrl,function(){
			if(data!=undefined){
				createPage($("#table"),data,pagination,creatApplyContent);
			}else{
				$("#table").html("");
				$(".pageNum").html('');
				$(".counts_page").text(0);
				$(".counts_num").text(0);
			}		
		})
	}else {
		getApplyList(appSn,'null');
	}
}


/**
 * 编辑函数
 * @param appId
 */
function appEdit(appId){
	var keynameOld=keyname.text();
	var keydesOld=keydes.text();
	var keyenableOld=keyenable.children('.apply_enable')[0].checked;
	var appEditInsertData={"keyname":keyname,"keydes":keydes};
	//编辑插入
	insertInput(appEditInsertData,function(){
		$(".appedit_keyname").focus();
	});


	$(".appedit_keyname").blur(function(){
		appEditSubmit(appId,keynameOld,keydesOld,keyenableOld)
	})

	$(".appedit_keydes").blur(function(){
		appEditSubmit(appId,keynameOld,keydesOld,keyenableOld)
	})

	$(".apply_enable").blur(function(){
		appEditSubmit(appId,keynameOld,keydesOld,keyenableOld)
	})

}

/**
 * 编辑提交
 * @param appId
 * @param keynameOld
 * @param keydesOld
 * @param keyenableOld
 */
function appEditSubmit(appId,keynameOld,keydesOld,keyenableOld){
	var editData={};
	var keynameNew=$(".appedit_keyname").val();
	var keydesNew=$(".appedit_keydes").val();
	var keyenableNew=$(".apply_enable").is(":checked");
	var appBlurFlag;
	getCurrentPage();
	var keyWords='';
	if($("#search_ipt").val()==''){
		keyWords='null';
	}else{
		keyWords=$("#search_ipt").val();
	}
	setTimeout(function(){
		if($(".appedit_keyname").is(":focus") || $(".appedit_keydes").is(":focus") || $(".apply_enable").is(":focus")){
			appBlurFlag=false;
		}else if(keynameNew!=keynameOld || keydesNew!=keydesOld || keyenableNew!=keyenableOld){
			editData={
				id:appId,
				packageName:keypackage.text(),
				appName:keynameNew,
				groupId:groupId,
				enable:keyenableNew,
				description:keydesNew
			}
			subForm("https://"+host+"/signalmaster/rest/app/save",editData,function(){
				getApplyList(applySn,keyWords,function(){
					$(".page_skip input").val(editCurrentpage);
					$(".page_skip a").trigger('click');
				})
			});
		}else{
			$(".appedit_keyname").remove();
			keyname.text(keynameOld);
			$(".appedit_keydes").remove();
			keydes.text(keydesOld);
			$(".apply_enable")[0].checked=keyenableOld;
			$(".apply_enable")[0].disabled=true;
			$(".apply_enable").removeClass("apply_enable");
		}
	},10)
}

/**
 * 上传包
 * @param appId
 */
function appUploadVersion(appId){
	var versionData={};
	var downloadUrl='';
	var versionFormHtml='\
	<div id="appAdd" class="infoLayer">\
	    <div class="infoLayerList"><label>应用名：</label><input type="text" value='+keyname.text()+' name="appName" disabled="disabled"/></div>\
	    <div class="infoLayerList"><label>版本号：</label><input type="text" value="" name="versionCode"/></div>\
	    <div class="infoLayerList"><label>版本名：</label><input type="text" value="" name="versionName"/></div>\
	    <div class="infoLayerList"><label>版本描述：</label><textarea name="releaseNote"></textarea></div>\
	    <form role="form" id="fileForm" method="post" enctype="multipart/form-data">\
	    	<div class="infoLayerList">\
		    	<label>上传文件：</label>\
			    	<a href="#" class="loadfile">选择文件<input type="file" name="file"></a>\
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

	var keyWords='';
	if($("#search_ipt").val()==''){
		keyWords='null';
	}else{
		keyWords=$("#search_ipt").val();
	}

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
			$('.upload_fileOk').text(fileUrl)
		})
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
				getApplyList(applySn,keyWords,function(){
					$(".page_skip input").val(editCurrentpage);
					$(".page_skip a").trigger('click');
				})
				layer.close(layerIndex);
			});
		}

		
	})

	$("#versionCancle").click(function(){
		layer.close(layerIndex);
	})
}


