<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>

<%
	
	Class.forName("oracle.jdbc.driver.OracleDriver"); 
	String user = "hospital"; 
	String pw = "1234";
	String url = "jdbc:oracle:thin:@localhost:1521:DBSERVER";
	Connection conn = DriverManager.getConnection(url, user, pw);
	
	
	String certinum = request.getParameter("certinum");
	String name = request.getParameter("name");
	String job = request.getParameter("job");
	String certiday = request.getParameter("certiday1") + " - " + request.getParameter("certiday2") + " - " + request.getParameter("certiday3");
	String jinryo = request.getParameter("receive");
	
	
	
	String sql2 = "update doctor set certinum = ?,name = ?, job = ?, certiday = ?, jinryo = ? where certinum = '" + certinum + "'";
	
	Statement st = conn.createStatement();
	PreparedStatement pstmt = conn.prepareStatement(sql2);
	
	pstmt.setString(1,certinum);
	pstmt.setString(2,name);
	pstmt.setString(3,job);
	pstmt.setString(4,certiday);
	pstmt.setString(5,jinryo);
	System.out.println(certinum);
	
	
	pstmt.executeUpdate();
	pstmt.close();
	conn.close();
	out.println("<script>alert('수정이 완료 되었습니다.');close();</script>");
	
	
%>
	