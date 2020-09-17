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
	String id="", name="", nicname="", password="", email="", receive="", date="";
	String sql="";
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	Statement st1 = con.createStatement();
	
	String[] arr = request.getParameterValues("check");
	Statement st2 = con.createStatement();
	if(request.getParameterValues("check") == null)
	{
		response.sendRedirect("userInfo.jsp");//원래대로
	}
	else
	{
		for(int i=0 ; i<arr.length ; i++)
		{
			ResultSet rs1 = st1.executeQuery("select * from user where id = '" + arr[i] +"'");
			if(rs1.next())
			{
				
					id=arr[i];
					name = rs1.getString("name");
					nicname = rs1.getString("nicname");
					password = rs1.getString("password");
					email = rs1.getString("email");
					receive = rs1.getString("receive");
					date = rs1.getString("date");
					sql = "insert into disuser values('"+ id +"','" + name+"','" +nicname+ "','" +password +"','" + email+ "','"+receive +"','" +date+"')";
					st2.executeUpdate(sql);
					sql = "delete from user where id='"+id+"'";
					st1.executeUpdate(sql);
					
				
			}
		}
		out.println("<script>alert('임시 삭제 되었습니다');window.location = 'userInfo.jsp';</script>");
	}
%>
</body>
</html>