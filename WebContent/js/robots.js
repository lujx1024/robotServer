$(document).ready(function(){
	var pagination=10;
	var logListUrl="https://"+host+"/signalmaster/rest/runtime/list";
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
		var sn=robotList[0].robotImei;
	}
	
	var allRobots=robotList[0].userGroupName;
	var groupId=robotList[0].userGroupId;
	var userId=robotList[0].userId;
	var groupName=robotList[0].userGroupName;

	createPage($("#table"),robotList,pagination,creatRobotsList);
	
});

//创建列表
function creatRobotsList(parent,data,num,pagination){
	if(data.length==0){
		parent.html('暂无数据!');
	}else{
		parent.html('');
		var pageCount=Math.ceil(data.length/pagination);
		var dataTrTitle=$('<tr class="table_title">\
						<td width="125">机器人ID</td>\
						<td>机器人名</td>\
						<td width="180">SN</td>\
						<td>款型</td>\
						<td>所属公司</td>\
						<td>所属行业</td>\
						<td>所属场景</td>\
						<td>激活时间</td>\
						<td>最后登录时间</td>\
						<td width="70">当前是否在线</td>\
					</tr>');
		dataTrTitle.appendTo(parent);

		//判断是不是最后一页
		var booleanBox='';
		if(num==pageCount){
			for(var i=((num-1)*pagination);i<(data.length);i++){
				if(data[i].robotLatestStatusOnline==false){
					booleanBox= '<input type="checkbox" disabled class="senior_edit_bool js-switch js-check-change" />';
					
				}else{
					booleanBox= '<input type="checkbox" disabled class="senior_edit_bool js-switch js-check-change" checked />';
				}
				var dataTr=$('<tr>\
					<td>'+data[i].robotId+'</td>\
					<td>'+data[i].robotName+'</td>\
					<td>'+data[i].robotImei+'</td>\
					<td>'+data[i].robotHwSpecName+'</td>\
					<td>'+data[i].userGroupName+'</td>\
					<td>'+data[i].userGroupIndustryName+'</td>\
					<td>'+data[i].userGroupSceneName+'</td>\
					<td>'+data[i].robotActivateDatetime+'</td>\
					<td>'+data[i].robotLatestStatusUpdateDatetime+'</td>\
					<td>'+booleanBox+'</td>\
				</tr>');
				dataTr.appendTo(parent);

			}
		}else{
			for(var i=((num-1)*pagination);i<(num*pagination);i++){
				if(data[i].robotLatestStatusOnline==false){
					booleanBox= '<input type="checkbox" disabled class="js-switch js-check-change" />';					
				}else{
					booleanBox= '<input type="checkbox" disabled class="js-switch js-check-change" checked />';
				}
				var dataTr=$('<tr>\
					<td>'+data[i].robotId+'</td>\
					<td>'+data[i].robotName+'</td>\
					<td>'+data[i].robotImei+'</td>\
					<td>'+data[i].robotHwSpecName+'</td>\
					<td>'+data[i].userGroupName+'</td>\
					<td>'+data[i].userGroupIndustryName+'</td>\
					<td>'+data[i].userGroupSceneName+'</td>\
					<td>'+data[i].robotActivateDatetime+'</td>\
					<td>'+data[i].robotLatestStatusUpdateDatetime+'</td>\
					<td>'+booleanBox+'</td>\
				</tr>');
				dataTr.appendTo(parent);
			}
		}
		var elems = Array.prototype.slice.call(document.querySelectorAll('.js-switch'));
			elems.forEach(function(html) {
		  	var switchery = new Switchery(html,{size:"small", color: '#008000', secondaryColor: '#2f4f4f', jackColor: '#F5FC03', jackSecondaryColor: '#fffafa' });
//			var switchery = new Switchery(html,{size:"small", color: '#008000', secondaryColor: '#008000', jackColor: '#F5FC03', jackSecondaryColor: '#F5FC03' });
		});

		$("#table td").css({"font-size":"14px","padding-left":"8px"});
		$("#table .table_title td").css({"font-size":"15px"});
	}
	
	
}




