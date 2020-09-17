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
	Statement st = null;
	
	int tot = 0;
	int imsi = 0;
	String sql = "";
	
	
	String pnum = request.getParameter("patient"); //널이 안됨
	String [] arr = request.getParameterValues("medicine");
	String tday = request.getParameter("choice")==null?"":request.getParameter("choice");
	String [] tcount = request.getParameterValues("day");
	
	String tday2 = tday + "일"; // 투약 일 수
	String precont = ""; //투약 내용
	String tcount2 = ""; // 투약 횟수
	if(arr == null || tcount == null)
	{
		
	}
	
	else
	{
		
		//계산
			for(int i = 0 ; i < arr.length ; i++)
			{
				st = conn.createStatement();
				sql = "select * from price where name = '" + arr[i] + "'";
				ResultSet rs = st.executeQuery(sql);
				System.out.println(sql);
				if(rs.next())
				{
					imsi = rs.getInt("won");
					tot += imsi;
					System.out.println("tot = " + tot);
					
				}
				if(i < arr.length - 1)
				{
					precont += arr[i] + ", ";
				}
				else
					precont += arr[i];
				
			
			}
		
			for(int j = 0 ; j < tcount.length; j++)
			{
				if(j < tcount.length - 1)
				{
					tcount2 += tcount[j] + ", ";
				}
				else
					tcount2 += tcount[j];
			}
		
		System.out.println(precont);
		System.out.println(tcount2);
		System.out.println(tday2);
		
		
		String sql2 ="";
		sql2 = "update medicine set precont =?,tday = ?, tcount =? where pnum = ?";
		
		PreparedStatement pstmt = conn.prepareStatement(sql2);
		pstmt.setString(1,precont);
		pstmt.setString(2,tday2);
		pstmt.setString(3,tcount2);
		pstmt.setString(4,pnum);
		
		
		pstmt.executeUpdate();
		
		
		
		
	}
	
	
	
%>