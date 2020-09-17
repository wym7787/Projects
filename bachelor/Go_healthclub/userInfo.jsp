<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>

<%
   
   Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
   String sql = "select * from user order by name";
   Statement st = conn.createStatement();
   ResultSet rs = st.executeQuery(sql);
   
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <title>health club</title>
   <meta charset="utf-8">
   <link href="css/member.css" rel="stylesheet">
   <link href="css/remember.css" rel="stylesheet">
   <meta name="viewport" content="width=device-width, initial-scale=1">
   
</head>
<body>
<div id = "header">
   <div id = "menu">
         <ul class = "nav-menu">
               
   </div>
   <div id ="logo">
      <a class="brand" href="index.jsp">
            <img class = "img-title" id="logoimage" src="imgs/logo.png"/>
        </a>
   </div>
</div>

<form  name = "check" method = "post" action = "userdelete.jsp">
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
            <td><input type = "checkbox" id = 'checkall' disabled></td>
            <td>번&nbsp호</td>
            <td>이&nbsp름</td>
            <td>I&nbspD</td>
            <td>닉네임</td>
            <td>전자우편</td>
            <td>가입일</td>
         </tr>      
         
         <%
         int c=0;
         	while(rs.next())
         	{
         		if(rs.getString("id").equals("manager"))
         		{
         			continue;
         		}
         		c++;
         		out.println("<tr class ='col-sub'>");
         		out.println("<td><input type = 'checkbox' name = 'check' value="+ rs.getString("id") + "></td>");
         		out.println("<td>" + c + "</td>");
         		out.println("<td>"+rs.getString("name")+"</td>");
         		out.println("<td>" + rs.getString("id") + "</td>");
         		out.println("<td>" + rs.getString("nicname") +"</td>");
         		out.println("<td>" + rs.getString("email") +"</td>");
         		out.println("<td>" + rs.getString("date") + "</td>");
         		out.println("</tr>");
         	}
         %>
      </table>
   </div>
</div>
</form>
</body>


</html>