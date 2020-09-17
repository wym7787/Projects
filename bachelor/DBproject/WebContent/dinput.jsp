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


		String sql = "insert into doctor (certinum,name,job,certiday,jinryo) values (?,?,?,?,?)";
		
			Class.forName("oracle.jdbc.driver.OracleDriver"); 
	    	String user = "hospital"; 
	    	String pw = "1234";
	    	String url = "jdbc:oracle:thin:@localhost:1521:DBSERVER";
	    	Connection conn = DriverManager.getConnection(url, user, pw);
	    	PreparedStatement pstmt = conn.prepareStatement(sql);
		
	   
		
		
		String certinum = request.getParameter("certinum");
		String name = request.getParameter("name");
		String job = request.getParameter("job");
		String jinryo = request.getParameter("receive");
		String certiday = request.getParameter("year") + " - " + request.getParameter("month") + " - " + request.getParameter("day");
		
		
		 String check = "select * from doctor where certinum = '" + certinum + "'";
		 Statement st = conn.createStatement();
		 ResultSet rs = st.executeQuery(check);
		
		 if(certinum.equals("") || name.equals("") || job.equals("") || jinryo.equals("") || certiday.equals(""))
		 {
			 out.println("<script>alert('빈칸을 입력하세요.');history.back();</script>");
		 }
		 else
		 {
			 
			 if(rs.next())
			 {
				 out.println("<script>alert('자격증번호가 중복됩니다 다시 입력하세요.');history.back();</script>");
			 }
			 else
			 {
		 
		
				pstmt.setString(1,certinum);
				pstmt.setString(2,name);
				pstmt.setString(3,job);
				pstmt.setString(4,certiday);
				pstmt.setString(5,jinryo);
				
				
				
				
				
				pstmt.executeUpdate();
		
				pstmt.close();
				conn.close();
				
				out.println("<script>alert('입력이 완료되었습니다.');location.href='dinput.html';</script>");
			 }
		 }

%>