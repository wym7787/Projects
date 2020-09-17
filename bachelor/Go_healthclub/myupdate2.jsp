<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%
	String id = request.getParameter("id");
	String pass = request.getParameter("ps");
	String pass2 = request.getParameter("pscon");
	String nicname = request.getParameter("nicname");
	String receive = request.getParameter("receive");
	String email = request.getParameter("email") + "@" + request.getParameter("email2");
	String sql = "update user set password = ?, nicname = ?, email = ?, receive = ? where id = '" + id + "'";
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	int count = 0;
	
	if(count == 0)
	{
		if((pass.equals("") || pass2.equals("") || nicname.equals("") || email.equals("")) == true)
		{
			out.println("<script>alert('정보를 입력하세요.');history.back();</script>");
		}
		else
		{
			if(pass.equals(pass2) == false)
			{
				out.println("<script>alert('비밀번호가 틀렸습니다.');history.back();</script>");
			}
			
			else
			{
				pstmt.setString(1,pass2);
				pstmt.setString(2,nicname);
				pstmt.setString(3,email);
				pstmt.setString(4,receive);
				pstmt.executeUpdate();
				out.println("<script>alert('정보가 수정되었습니다.');window.location = 'mypage.jsp';</script>");
				
			}
		}
	}
	
%>