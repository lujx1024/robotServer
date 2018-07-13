<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="utf-8"%>
    
    <!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>远程视频</title>
	<link rel="stylesheet" type="text/css" href="css/font-awesome/css/font-awesome.css">
	<link rel="stylesheet" type="text/css" href="css/font-awesome/css/font-awesome.min.css">
	<link rel="stylesheet" type="text/css" href="css/reset.css">
	<link rel="stylesheet" type="text/css" href="css/style.css">
	<link rel="stylesheet" type="text/css" href="js/video-js/video-js.css">
	<script type="text/javascript" src="js/jquery-2.2.1.min.js"></script>
	<script type="text/javascript" src="js/video-js/video.js"></script>
	
	<script type="text/javascript">
	$(function(){
		videojs.options.flash.swf = "js/video-js/video-js.swf";
	})	
	</script>
	
</head>
<body>
	<video id="example_video_1"  autoplay="autoplay" class="video-js vjs-default-skin" controls autoplay="autoplay" preload="none" width="580" height="370" data-setup='{}'>
		<source src='<%=request.getParameter("url")%>'  type="rtmp/flv" />
	</video>
</body>
</html>
