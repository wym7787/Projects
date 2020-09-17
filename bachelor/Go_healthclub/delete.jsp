<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>

<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
	String[] id = request.getParameterValues("check");
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/gohealth","root","5258dnjs");
	
	Statement st = conn.createStatement();
	
	for(int i = 0 ; i < id.length; i++)
	{
		String sql = "delete from user where id = '" + id[i] + "'";
		st.executeUpdate(sql);
	}
	
	st.close();
	conn.close();
	
	response.sendRedirect("member.jsp");
	

	
%>
</body>
</html>