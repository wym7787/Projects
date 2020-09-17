<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>


<%
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	String sql = "select * from user where id = '" + request.getParameter("id") +"'";
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	String id = request.getParameter("id");
	String pass = request.getParameter("ps");
	boolean flag = false;
	
	if(rs.next())
	{
		if(rs.getString("password").equals(pass))
		{
			flag = true;
		}
		else if((pass.equals("")) == true)
		{
			out.println("<script>alert('비밀번호를 입력하세요.');history.back()</script>");
		}
		else
		{
			out.println("<script>alert('비밀번호가 틀렸습니다');history.back()</script>");
		}
	}
	else if((id.equals("")) == true)
	{
		out.println("<script>alert('정보를 입력하세요.');history.back()</script>");
	}
	else
	{
		out.println("<script>alert('아이디가 존재하지 않습니다.');history.back()</script>");
	}
	
	if(flag)
	{
		session.setAttribute("userid",request.getParameter("id"));
		response.sendRedirect("index.jsp");
	}
	rs.close();
	st.close();
	conn.close();
%>