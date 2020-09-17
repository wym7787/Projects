<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>

<%
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gohealth","root","5258dnjs");
	String sql = "select * from user order by name";
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	int count = 1;
	
	if(session.getAttribute("userid") == null)
	{
		response.sendRedirect("index.jsp");
	}
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<title>health club</title>
	<meta charset="utf-8">
	<link href="css/member.css" rel="stylesheet">
	<link href="css/remember.css" rel="stylesheet">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	
</head>
<body>
<div id = "header">
	<div id = "menu">
			<ul class = "nav-menu">
           	<%
           		if(session.getAttribute("userid").equals("manager"))
           		{
           			String id = (String) session.getAttribute("userid");
           			out.println("<li><a href ='#'>"+ id +"</a></li>");
                	out.println("<li><a href ='logout.jsp'>로그아웃</a></li>");
                	out.println("<li><a href ='member.jsp'>회원정보보기</a></li>");
           		}
           %>
	</div>
	<div id ="logo">
		<a class="brand" href="index.jsp">
            <img class = "img-title" id="logoimage" src="imgs/logo.png"/>
        </a>
	</div>
</div>

<form  name = "check" method = "post" action = "delete.jsp">
<div id = "content">
	<div id = "top-rap">
		<div id = "top-text">회원정보조회
		</div>
		<div id = "top-button">
			<input type = "submit" id = "delete-button"  value = "삭제">
			<input type = "button" id = "rollback-button" onclick = "location.href = 'rollback.jsp'" value = "복구">
		</div>
	</div>

	
	<div id ="container">
		<table id = "container-table">
			<tr class = "col">
				<td><input type = "checkbox" name = "check"></td>
				<td>번&nbsp호</td>
				<td>이&nbsp름</td>
				<td>I&nbspD</td>
				<td>닉네임</td>
				<td>전자우편</td>
				<td>가입일</td>
			</tr>
			<%
				while(rs.next())
				{
					
					if(rs.getString("id").equals("manager"))
					{
						continue;			
					}
					String id = rs.getString("id");
					out.println("<tr class = 'col-sub'>");
					out.println("<td><input type = 'checkbox' name = 'check' value = '"+id+"'></td>");
					out.println("<td>" + count + "</td>");
					out.println("<td>" + rs.getString("name") +"</td>");
					out.println("<td>" + id +"</td>");
					out.println("<td>" + rs.getString("nicname") +"</td>");
					out.println("<td>" + rs.getString("email") +"</td>");
					out.println("<td>" + rs.getString("date") +"</td>");
					out.println("</tr>");
					count++;
				}
				count = 1;
				
				st.close();
				rs.close();
				conn.close();
			%>
				
		</table>
	</div>
</div>
</form>
</body>
</html>