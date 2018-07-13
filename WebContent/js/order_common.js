$(document).ready(function(){
	//获取所有预约
	var allOrderUrl="/signalmaster/rest/custom_room_order/order/list";
	usableRoom(allOrderUrl,function(){
		creatAllOrder($("#table"),data);
	})
	//日历插件
	var searchDate=new Date();
	var searchYear=searchDate.getFullYear();
	var searchMonth=zero(searchDate.getMonth()+1);
	var searchDay=zero(searchDate.getDate());	
	var startDay=searchYear+"-"+searchMonth+"-"+searchDay;
	var startTime=searchDate.getHours();
	
	dateLimit();

	$("#order_time").val(startDay);
	//初始
	var night=$("#night_or").find("option:selected").attr('value');
	var loadUrl="/signalmaster/rest/custom_room_order/room/list/"+$("#order_time").val()+"/"+night;
	usableRoom(loadUrl,function(){
		insertRoom($("#useable_room"),data);
		dateLimit();
	})

	$("#night_or").change(function(){
		night=$("#night_or").find("option:selected").attr('value');
		loadUrl="/signalmaster/rest/custom_room_order/room/list/"+$("#order_time").val()+"/"+night;
		usableRoom(loadUrl,function(){
			insertRoom($("#useable_room"),data);
		})
	})
	$("#order_time").focus(function(){
		laydate({
	        elem: '#order_time',
	        min:startDay+' 00:00:00',
	        max:'3999-01-01 00:00:00',
	        choose:function(dates){
	        	var chooseDay=dates.substring(dates.length-2);
	        	var chooseMonth=dates.substring(5,7);
	        	var chooseYear=dates.substring(0,4);

	        	if(dates==startDay){
	        		dateLimit();
	        	}else{
	        		$("#night_or").html('');
	        		$("#night_or").attr("disabled",false);
					$("#night_or").append('<option value="false">白天</option>');
					$("#night_or").append('<option value="true">晚上</option>');
	        	}
	        	
	        	var night_date=$("#night_or").find("option:selected").attr('value');
	        	var url="/signalmaster/rest/custom_room_order/room/list/"+dates+"/"+night_date;
	        	usableRoom(url,function(){
	        		insertRoom($("#useable_room"),data);
	        		if(dates==startDay){
		        		dateLimit();
		        	}else{
		        		$("#night_or").html('');
		        		$("#night_or").attr("disabled",false);
						$("#night_or").append('<option value="false">白天</option>');
						$("#night_or").append('<option value="true">晚上</option>');
		        	}
	        	})
	        }
	    })
	})

	//提交
	$("#submit").click(function(){
		if(checkForm()){
			var formData={};
			formData={
				roomId:$("#useable_room").find("option:selected").attr('value'),
				orderDate:$("#order_time").val(),
				orderName:$("#name").val(),
				mobilePhone:$("#phone").val(),
				night:eval($("#night_or").find("option:selected").attr('value'))
			}
			$.ajax({
				cache:false,
				type:"POST",
				url:"/signalmaster/rest/custom_room_order/room/order",
				data:formData,
				success:function(result){
					if(result.code=="99"){
						layer.alert(result.message,{icon:5});
						dateLimit();
					}else{
						layer.alert('预约成功!',{icon:1});
						$("#name").val('');
						$("#phone").val('');
						$("#order_time").val(startDay);
						$("#night_or option:first").get(0).selected=true;

						var allOrderUrl="/signalmaster/rest/custom_room_order/order/list";
						usableRoom(allOrderUrl,function(){
							creatAllOrder($("#table"),data);
						})
						var night_date=$("#night_or").find("option:selected").attr('value');
			        	var url="/signalmaster/rest/custom_room_order/room/list/"+startDay+"/false";
			        	usableRoom(url,function(){
			        		insertRoom($("#useable_room"),data);
			        		dateLimit();
			        	})
					}
					
					
				},
				error:function(result){
					alert('服务器异常！');
				}
			})
		}


	})

	function dateLimit(){
		var searchDate=new Date();
		var searchYear=searchDate.getFullYear();
		var searchMonth=zero(searchDate.getMonth()+1);
		var searchDay=zero(searchDate.getDate());	
		var startDay=searchYear+"-"+searchMonth+"-"+searchDay;
		var startTime=searchDate.getHours();
		if(startTime<11){
			$("#submit").attr("disabled",false);
			$("#night_or").html('');
			$("#night_or").append('<option value="false">白天</option><option value="true">晚上</option>');
		}else if(startTime<17){
			$("#submit").attr("disabled",false);
			$("#night_or").html('');
			$("#night_or").append('<option value="true">晚上</option>');
		}else{
			$("#submit").attr("disabled","disabled")
			$("#night_or").html('');
			$("#night_or").attr("disabled","disabled");
			$("#night_or").append('<option value="true">请选择其他时间！</option>');		
		}
	}
})

function zero(obj){
	return obj<10 ? "0"+obj:obj; 
}

//获取可选包厢、获取所有预约
function usableRoom(url,callback){
	$.ajax({
		cache:false,
		type:'GET',
		url:url,
		success:function(result){
			data=result.data;
			if(callback){
				callback();//重新刷新页面
			}
		},
		error:function(result){
			alert('服务器异常！')
		}
	})
}

//插入可用标签
function insertRoom(obj,data){
	obj.html('');
	if(data.length==0){
		obj.append('<option value="无">无可用包厢</option>')
		$("#submit").attr("disabled","disabled");
	}else{
		$("#submit").attr("disabled",false);
		for(var i=0;i<data.length;i++){
			obj.append('<option value='+data[i].id+'>'+data[i].name+'</option>')
		}
	}
		
}

//创建所有预约订单
function creatAllOrder(parent,dataOrder){
	var allOrderUrl="/signalmaster/rest/custom_room_order/order/list";
	parent.html('');
	var dataTrTitle=$('<tr class="table_title">\
					<td width="21%">时间</td>\
					<td width="21%">包厢</td>\
					<td width="21%">称呼</td>\
					<td width="21%">电话</td>\
					<td>操作</td>\
				</tr>');
	dataTrTitle.appendTo(parent);
	if(dataOrder==undefined){
		var dataTr=$('<tr>\
			<td>---</td>\
			<td>---</td>\
			<td>---</td>\
			<td>---</td>\
			<td>---</td>\
		</tr>');
		dataTr.appendTo(parent);
	}else{
		for(var i=0;i<data.length;i++){
			var dataTr=$('<tr>\
				<td>'+dataOrder[i].orderDate+" "+dataOrder[i].period+'</td>\
				<td>'+dataOrder[i].roomName+'</td>\
				<td>'+dataOrder[i].orderName+'</td>\
				<td>'+dataOrder[i].mobilePhone+'</td>\
				<td><input type="button" value="删除" roomId='+dataOrder[i].roomId+' orderDate='+dataOrder[i].orderDate+' night='+dataOrder[i].night+' class="delete"></td>\
			</tr>');
			dataTr.appendTo(parent);
		}
	}
	
	$(".delete").click(function(){
		var _this=$(this);
		var _thisParent=_this.parent().siblings();
		var deleteTip="确认删除 "+_thisParent.eq(2).html()+" 在 "+_thisParent.eq(0).html()+" 的预约吗？";
		var deleteData={
			roomId:parseFloat(_this.attr("roomId")),
			orderDate:_this.attr("orderDate"),
			night:eval(_this.attr("night"))
		}
		var layerIndex=layer.alert(deleteTip,{
		  	icon:0,
		  	btn:['确定','取消'],
		  	yes:function(index, layero){
		  		$.ajax({
					cache:false,
					type:"POST",
					url:"/signalmaster/rest/custom_room_order/room/delete",
					data:deleteData,
					success:function(){
						usableRoom(allOrderUrl,function(){
							creatAllOrder($("#table"),data);
						})
						var night=$("#night_or").find("option:selected").attr('value');
						var loadUrl="/signalmaster/rest/custom_room_order/room/list/"+$("#order_time").val()+"/"+night;
						usableRoom(loadUrl,function(){
							insertRoom($("#useable_room"),data);
						})
					},
					error:function(){
						alert('服务器异常！');
					}
				})
		  		layer.close(layerIndex);
		  	},btn2:function(index, layero){
		  		layer.close(layerIndex);
		  	}
		})
	})
	
}

//表单检查
function checkForm(){
	var name=$("#name");
	var phone=$("#phone");
	var mPhoneReg=/^1\d{10}$/;
	//var phoneReg=/^0\d{2,3}\d{7,8}$/;
	name.next().hide();
	phone.next().hide();
	if(name.val()==""){
		name.next().show();
		name.next().text("称呼不能为空，请输入！")
		return false;
	}else{
		if(phone.val()==''){
			phone.next().show();
			phone.next().text("电话号码不能为空，请输入！");
			return false;
		}else if(!mPhoneReg.test(phone.val())){
			phone.next().show();
			phone.next().text("电话号码输入错误，请输入正确的电话号码！");
			return false
		}
		
	}

	return true;
}