<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
		String id = (String) session.getAttribute("userid");
		if(id == null)
		{
			out.println("<script>alert('로그인 후 이용가능 합니다.');window.location = 'login.html';</script>");
		}
%>
<html>
<head>
	<meta charset="utf-8">
	<title>Health Club</title>
	<link href="css/signup.css" rel="stylesheet">
	<link href="css/resignup.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<style>
		#id-text
		{
			background-color:white;
		}
	</style>
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
			<h3>&nbsp마이페이지&nbsp>&nbsp나의정보수정</h3>
		</div>
	</div>
	<form method = "post" action = "myupdate2.jsp">
	<div id="sign-container">
			
			<div class ="sign-nav">
				<div class = "sort">
				<h3>아이디</h3>
				</div>
				<div class = "sort2">
				<input id = "id-text" class = "text-box" type = "hidden" name = "id" value = '<%=id%>'><%=id%>
				</div>
			</div>
			
			<div class ="sign-nav">
				<div class = "sort">
				<h3>변경 비밀번호</h3>
				</div>
				<div class = "sort2">
				<input id = "ps-text" class = "text-box" type = "password" name = "ps">
				<h4 id = "con-text">&nbsp&nbsp&nbsp&nbsp(영문, 숫자, 특수문자를 포함한 10자리 이하)
				</div>
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>비밀번호 확인</h3>
				</div>
				<div class = "sort2">
				<input id = "psc-text" class = "text-box" type = "password" name = "pscon">
				</div>
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>닉네임변경</h3>
				</div>
				<div class = "sort2">
				<input id = "nick-text" class = "text-box" type = "text" name = "nicname">
				</div>
			</div>
			<div class ="sign-nav">
				<div class = "sort">
				<h3>이메일변경</h3>
				</div>
				<div class = "sort2">
				<input id = "email-text" class = "text-box" type = "text" name = "email">
				<h3>@</h3>
				<input id = "email-text-sub" class = "text-box" type = "text" name = "email2">

					<div class = "sort3">
						<input class = "receive" type = "radio"  name = "receive" value ="수신">수신
						<input class = "receive" type = "radio"  name = "receive" value ="수신거부">수신거부
					</div>
				</div>
			</div>
			
	</div>
	<div id = "hr">
	</div>
			<div id="button">
					<input id = "button-sub" type = "submit" value = "정보수정">
					<input id = "button-reset" type = "button" onclick = "history.back();" value = "정보취소">
			</div>
	</form>
</div>