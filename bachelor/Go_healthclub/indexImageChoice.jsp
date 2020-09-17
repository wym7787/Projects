<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="css/subpage.css" rel="stylesheet">
<title>Insert title here</title>
<style>
	body
	{
		margin : 0;
	}
	.img
	{
		width : 18%;
		float : left;
		margin : 10px;
		
	}
	.img a
	{
		width : 100%;
	}
	.img a img
	{
		width : 100%;		
	}
	#ibox
	{
		width : 100%;
		position : relative;
		overflow : hidden;
	}
</style>
</head>
<body>
		<div id="ibox">
			<div class="img">
				<a href ="index.jsp?no=1"><img src = "view.jsp?no=1"></a>
			</div>
			<div class = "img">
				<a href ="index.jsp?no=2"><img src ="view.jsp?no=2"></a>
			</div>
			<div class = "img">
				<a href ="index.jsp?no=3"><img src = "view.jsp?no=3"></a>
			</div>
			<div class = "img">
				<a href ="index.jsp?no=4"><img src = "view.jsp?no=4"></a>
			</div>
			<div class = "img" id = "last">
				<a href ="index.jsp?no=5"><img src = "view.jsp?no=5"></a>
			</div>
		</div>
</body>
</html>