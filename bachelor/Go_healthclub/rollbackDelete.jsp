<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String sql="";
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	Statement st1 = con.createStatement();
	
	String arr[] = request.getParameterValues("check");
	if(request.getParameterValues("check") == null)
	{
		response.sendRedirect("userInfo.jsp");
		
	}
	else
	{
		for(int i=0 ; i<arr.length ; i++)
		{
			ResultSet rs1 = st1.executeQuery("select * from disuser where id = '" + arr[i] + "'");
			if(rs1.next())
			{
				if(rs1.getString("id").equals(arr[i]))
				{
					
					sql = "delete from disuser where id='"+rs1.getString("id")+"'";
					st1.executeUpdate(sql);
					
				}
			}
		}
		out.println("<script>alert('영구 삭제 되었습니다');window.location='userInfo.jsp';</script>");
	}
%>
</body>
</html>