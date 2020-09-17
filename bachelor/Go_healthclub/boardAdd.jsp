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
<center>
<h2>회원 정보</h2>
<%

	String userid = "", title="", boardContent="", password="";
	userid = (String)session.getAttribute("userid");
	title = request.getParameter("title");
	boardContent = request.getParameter("content");
	password = request.getParameter("ps");
	

	Class.forName("com.mysql.jdbc.Driver").newInstance(); // newInstance() 생략 가능
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");// 시험 문제 후보
	/*PreparedStatement pstmt = con.prepareStatement("insert into board values(?,?,?,?,?)");
	pstmt.setString(1,title);
	pstmt.setString(2,userid);
	pstmt.setString(3,(new SimpleDateFormat("yyyy-MM-dd")).format(new Date()));
	pstmt.setString(4,boardContent);
	pstmt.setInt(5, 0);
	System.out.println(userid);
	System.out.println(title);
	System.out.println(boardContent);
	System.out.println((new SimpleDateFormat("yyyy-MM-dd")).format(new Date()));
	int count = pstmt.executeUpdate();*/
	Statement st = con.createStatement();
	String sql = "insert into board(title,userid,writeDay,centent,readNo, pass) values('"+title+"','"+userid+"','"
	+(new SimpleDateFormat("yyyy-MM-dd")).format(new Date()) +"','" +boardContent +"','" + 0 +"','" +password+"')";
	
	int count =	st.executeUpdate(sql);
	if(count > 0)
	{
		out.println("<script>alert('게시물이 등록 되었습니다.');window.location='board.jsp'</script>");
		
	}
	else
		out.println("<script> alert('요청하신 작업이 처리되지 않았습니다.'); history.back();</script>");

	st.close();
	con.close();
%>

</center>
</body>
</html>