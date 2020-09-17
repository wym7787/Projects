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
	
	String pnum = request.getParameter("pnumber");
	
	String name = request.getParameter("name");
	String jumin = request.getParameter("jumin1") + " - " + request.getParameter("jumin2");
	String phone = request.getParameter("phone1") + " - " + request.getParameter("phone2") + " - " + request.getParameter("phone3");
	String height = request.getParameter("height");
	String weight = request.getParameter("weight");
	String blood = request.getParameter("receive");
	
	String sql = "update patient set pnum = ?,name = ?, jumin = ?, phone = ?, height = ?, weight = ?, blood = ? where pnum = '" + pnum + "'";
	
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	pstmt.setString(1,pnum);
	pstmt.setString(2,name);
	pstmt.setString(3,jumin);
	pstmt.setString(4,phone);
	pstmt.setString(5,height);
	pstmt.setString(6,weight);
	pstmt.setString(7,blood);
	
	
	
	pstmt.executeUpdate();
	pstmt.close();
	conn.close();
	out.println("<script>alert('수정이 완료 되었습니다.');close();</script>");
	
	
%>
	