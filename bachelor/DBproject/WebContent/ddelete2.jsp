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
	String [] arr = request.getParameterValues("chk");
	String sql ="";
	Statement st = conn.createStatement();
	
	
	if(arr == null)
	{
		st.close();
		conn.close();
		out.println("<script>alert('삭제할 인원을 선택하세요.');location.href='drollback.jsp';</script>");
	}
	else
	{
		for(int i = 0; i < arr.length ; i++)
		{
			sql = "delete from disdoctor where certinum = '" + arr[i] + "'";
			st.executeQuery(sql);
		}
		
		st.close();
		conn.close();
		out.println("<script>alert('영구 삭제 되었습니다.');location.href='drollback.jsp';</script>");
		
	}

%>