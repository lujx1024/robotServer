//add by qidh

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
	
	var getRobotUrl="https://"+host+"/signalmaster/rest/config/robots/0/0/0/null";
	//转换前机器人
	createSelect(getRobotUrl,$("#configConvert_type1"));

	//转换后机器人
	createSelect(getRobotUrl,$("#configConvert_type2"));

	$(document).on("click","#configConvert_OKBtn",function(){
		//转换前的配置
  		var configConvert_old = $("#configConvert_type1").val();
  		var configConvert_new = $("#configConvert_type2").val();
  		var copyUrl="https://"+host+"/signalmaster/rest/copyconfig";
  		var configData = {
  				"robotId1":configConvert_old,
		  		"robotId2":configConvert_new
		};
  		
  		if(configConvert_old !== "0" && configConvert_new !== "null"){
  			var layerIndex=layer.alert("确定将机器人配置进行复制?",{
  			  	icon:3,
  			  	btn:['确定'],
  			  	yes:function(index, layero){
  			  			$.ajax({
  							cache:false,
  							type:"POST",
  							url:copyUrl,
  							data:configData,
  							success:function(result){
  								subResult=result;
  								layer.close(layerIndex);
  								sucessTip();
  							},
  							error:function(){
  								alert('服务器异常！');
  							}
  						});
  			  	}
  			})
  		}else{
  			var layerIndex1=layer.alert("选择内容不能为空。",{
  			  	icon:3,
  			  	btn:['确定'],
  			  	yes:function(index, layero){
  			  		layer.close(layerIndex1);
  			  	}	
  			});		
  		}
		
	});
	
	function sucessTip(callback){
		var layerIndex=layer.alert("机器人配置复制成功",{
	  	icon:1,
	  	btn:['确定'],
	  	yes:function(index, layero){
	  		layer.close(layerIndex);
			if(callback){
				callback();
			}
	  	}
	  	});
	}

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
	

})

