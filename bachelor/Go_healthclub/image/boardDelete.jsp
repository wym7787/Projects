<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>

<%
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("select * from board");
	
	String password = request.getParameter("ps");
	String key = (String)session.getAttribute("no");
	
	
	if(session.getAttribute("userid").equals("manager"))
	{
		String sql = "delete from board where contentNo="+key;
		Statement st1 = con.createStatement();
		st1.executeUpdate(sql);
		out.println("<script>alert('삭제가 완료 되었습니다.'); window.loaction = 'board.jsp';</script>");
		
	}
	
	
	

	
	while(rs.next())
	{
		
		if(rs.getString("contentNo").equals(key) && rs.getString("pass").equals(password))
		{
			Statement st2 = con.createStatement();
			st2.executeUpdate("delete from board where contentNo="+key);
			out.println("<script>alert('삭제가 완료 되었습니다.'); window.location='board.jsp';</script>");
		}
		else
		{
				out.println("<script>alert('삭제가 불가능합니다.'); window.loaction = 'board.jsp';</script>");
		}
		
	}
		
	

	con.close();
	rs.close();
	st.close();
	
	
	
%>
</body>
</html>