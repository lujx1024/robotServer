<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Config</title>
</head>
<body>

<form action="/signalmaster/rest/set_config" method="post">

UserId: <input name="user_id" value="<%=request.getParameter("uid")%>" type="text" readonly="readonly" > <br/>
RobotId: <input name="robot_id" value="<%=request.getParameter("robot")%>" type="text" readonly="readonly"><br/>
Config Key: <input name="config_key" value="" type="text" maxlength="40"><br/>
Config Value: <input name="config_value" value="" type="text" maxlength="65535"><br/>
Description: <input name="description" value="" type="text" maxlength="120"> 
<br/>
<input value="确定" type="submit">
</body>
</html>