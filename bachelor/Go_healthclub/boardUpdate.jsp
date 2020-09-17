<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<%

	String name = "", title="", boardContent="", password="";
	name = (String)session.getAttribute("userid");
	title = request.getParameter("title");
	boardContent = request.getParameter("content");
	password = request.getParameter("ps");
	String key = (String)session.getAttribute("no");

	Class.forName("com.mysql.jdbc.Driver").newInstance(); // newInstance() 생략 가능
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");// 시험 문제 후보
	PreparedStatement pstmt = con.prepareStatement("update board set title = ?, centent = ? where userid = ?");
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("select * from board where contentNo = '" + key +"'");
	if(rs.next())
	{
		if(rs.getString("pass").equals(password))
		{
			pstmt.setString(1,title);
			pstmt.setString(2,boardContent);
			pstmt.setString(3,name);
			pstmt.executeUpdate();
			out.println("<script>alert('수정이 완료되었습니다');window.location='board.jsp'</script>");
			
		}
		else
			out.println("<script> alert('비밀번호가 틀렸습니다.'); history.back();</script>");
	}
	
	rs.close();
	st.close();
	pstmt.close();
	con.close();
%>
</body>
</html>