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
	String pnum ="" , name ="", jumin ="", phone ="", height ="", weight ="", blood ="";
	String sql ="", sql2 ="";
	
	Class.forName("oracle.jdbc.driver.OracleDriver"); 
	String user = "hospital"; 
	String pw = "1234";
	String url = "jdbc:oracle:thin:@localhost:1521:DBSERVER";
	Connection conn = DriverManager.getConnection(url, user, pw);
	String [] arr = request.getParameterValues("chk");
	Statement st = conn.createStatement();
	Statement st1 = conn.createStatement();
	
	
	if(arr == null)
	{
		st.close();
		conn.close();
		out.println("<script>alert('삭제할 인원을 선택하세요.');location.href='psearch.jsp';</script>");
	}
	else
	{
		for(int i = 0 ; i < arr.length ; i++)
		{
			ResultSet rs = st.executeQuery("select * from patient where pnum = '" + arr[i] +"'");
			if(rs.next())
			{
				pnum = rs.getString(1);
				name = rs.getString(2);
				jumin = rs.getString(3);
				phone = rs.getString(4);
				height = rs.getString(5);
				weight = rs.getString(6);
				blood = rs.getString(7);
				sql = "insert into dispatient (pnum,name,jumin,phone,height,weight,blood) values('"+ pnum +"','" + name +"','" +jumin+ "','" +phone +"','" + height+ "','"+weight +"','" +blood+"')";
				st.executeUpdate(sql);
				sql2 = "delete from patient where pnum = '" + pnum + "'";
				st1.executeUpdate(sql2);
			}
		}
		
		out.println("<script>alert('임시 삭제 되었습니다.');location.href='psearch.jsp';</script>");
	}
%>