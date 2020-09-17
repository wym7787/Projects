<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ page import = "java.sql.*" %>
    <%@ page import = "java.io.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("select * from subpage");
	int num = Integer.parseInt(request.getParameter("no"));
	byte[] a=null;
	Blob image=null;
	if(rs.next())
	{			
		image = rs.getBlob("no"+num);
	}
	Statement st2 = con.createStatement();
	String sql = "insert into indexPageImage(no1) values('" +image +"')";
	st2.executeUpdate("delete from indexPageImage");
	st2.executeUpdate(sql);
	response.sendRedirect("index.jsp");
	
	
	%>
</body>
</html>