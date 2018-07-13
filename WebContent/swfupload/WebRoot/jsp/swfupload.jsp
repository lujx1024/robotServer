<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>
    <base href="<%=basePath%>">
    
    <title>SWFUpload组件文件上传</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<link type="text/css" rel="stylesheet" href="<%=path %>/css/upload.css" />
	<link href="<%=path %>/js/ligerUI/skins/Aqua/css/ligerui-all.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="<%=path %>/js/jquery-1.7.2.min.js"></script>
	<script type="text/javascript" src="<%=path %>/js/ligerUI/js/core/base.js"></script>
   	<script type="text/javascript" src="<%=path %>/js/ligerUI/js/plugins/ligerDrag.js"></script>
   	<script type="text/javascript" src="<%=path %>/js/ligerUI/js/plugins/ligerDialog.js"></script>
	<script type="text/javascript" src="<%=path %>/js/swfupload/swfupload.js"></script>
	<script type="text/javascript" src="<%=path %>/js/swfupload/plugins/swfupload.queue.js"></script>
	<script type="text/javascript" src="<%=path %>/jsp/swfupload.js"></script>
  </head>
  
  <body>
  	<input type="hidden" id="contextPath" value="<%=request.getContextPath() %>" />
    <div id="swfupload">
    	<span id="spanButtonPlaceholder"></span>
		<p id="queueStatus"></p>
		<ol id="logList"></ol>
    </div>
  </body>
</html>
