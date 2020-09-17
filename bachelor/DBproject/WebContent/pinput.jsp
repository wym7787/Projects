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


		String sql = "insert into patient (pnum,name,jumin,phone,height,weight,blood) values (?,?,?,?,?,?,?)";
		
			Class.forName("oracle.jdbc.driver.OracleDriver"); 
	    	String user = "hospital"; 
	    	String pw = "1234";
	    	String url = "jdbc:oracle:thin:@localhost:1521:DBSERVER";
	    	Connection conn = DriverManager.getConnection(url, user, pw);
	    	PreparedStatement pstmt = conn.prepareStatement(sql);
			
		
		
		String pnum = request.getParameter("pnumber");
		String name = request.getParameter("name");
		String jumin = request.getParameter("jumin1") + " - " + request.getParameter("jumin2");
		String phone = request.getParameter("phone1") + " - " + request.getParameter("phone2") + " - " + request.getParameter("phone3");
		String height = request.getParameter("height");
		String weight = request.getParameter("weight");
		String blood = request.getParameter("receive");
    	
		String check = "select * from patient where pnum = '" + pnum +"'";
		Statement st = conn.createStatement();
		ResultSet rs = st.executeQuery(check);
		
		
		
		if(pnum.equals("") || name.equals("") || jumin.equals("") || phone.equals("") || height.equals("") || weight.equals("") || blood.equals(""))
		{
			out.println("<script>alert('빈칸을 입력하세요.');history.back();</script>");
		}
		
		else
		{
			if(rs.next())
			{
				out.println("<script>alert('환자 번호가 중복됩니다 다시 입력하세요.');history.back();</script>");
			}
			else
			{
		
		
				pstmt.setString(1,pnum);
				pstmt.setString(2,name);
				pstmt.setString(3,jumin);
				pstmt.setString(4,phone);
				pstmt.setString(5, height);
				pstmt.setString(6, weight);
				pstmt.setString(7, blood);
				
				
				
				pstmt.executeUpdate();
		
				pstmt.close();
				conn.close();
				
				out.println("<script>alert('입력이 완료되었습니다.');location.href='pinput.html';</script>");
			}
		}

%>