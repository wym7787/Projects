<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	

	String id = (String) session.getAttribute("userid");
	String sql = "select * from user where id = '" + id + "'";
	String name = "";
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	if(rs.next())
	{
		name = rs.getString("name");
	}
	
%>
<<html>
<head>
	<meta charset="utf-8">
	<title>Health Club</title>
	<link href="css/mypage.css" rel="stylesheet">
	<link href="css/remypage.css" rel="stylesheet">
	<link href="css/resignup.css" rel="stylesheet">
	<link href="css/remypage.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<!-- header -->
<div class = "header">
	<div class ="container">
		<div class ="logo">
			<a class="brand" href="index.jsp">
               <img id="logoimage" src="imgs/logo.png"/>
            </a>
		</div>
		<div class ="menu">
           	<ul class = "nav">
           		<%
                 if(session.getAttribute("userid") == null)
                 {
                    out.println("<li><a href ='login.html'>로그인</a></li>");
                   out.println("<li><a href ='signup.html'>회원가입</a></li>");
                   out.println("<li><a href ='#'>마이페이지</a></li>");
                 }
                 else if (session.getAttribute("userid").equals("manager"))
                 {
                    out.println("<li><a href ='index.jsp'>" + "manager" + "</a></li>");
                   out.println("<li><a href ='logout.jsp'>로그아웃</a></li>");
                   out.println("<li><a href ='userInfo.jsp'>회원정보보기</a></li>");

                 }
                 else
                 {
                 String id2 = (String) session.getAttribute("userid");
                    out.println("<li><a href ='index.jsp'>" + id2 + "</a></li>");
                   out.println("<li><a href ='logout.jsp'>로그아웃</a></li>");
                   out.println("<li><a href ='mypage.jsp?'>마이페이지</a></li>");
                 }
              %>

            	
            </ul>
        </div>
	</div>
	
</div>
<!-- header-end -->

<!-- signup-box -->
<div id ="login-container">
	<div id = "login-text-wrap">
		<div id = "login-text">
			<img id ="login-logo" src="imgs/login-logo.png"/> 
			<% 
				out.println("<h3>&nbsp'" + name + "'&nbsp님의&nbsp마이페이지</h3>");
			%>
		</div>
	</div>

	<div id ="mypage-logo">
		<div id ="mypage-sub">
			<span><a href="#"><img class="my-button" src="imgs/mypage1.png"/></a>
			<h3>내가본영상</h3></span>
			<span><a href="#"><img class="my-button" src="imgs/mypage2.png"/></a>
			<h3>내가찜한헬스장</h3></span>
			<span><a href="myupdate.jsp"><img class="my-button" src="imgs/mypage3.png"/></a>
			<h3>나의정보수정</h3></span>
		</div>
	</div>
</div>

