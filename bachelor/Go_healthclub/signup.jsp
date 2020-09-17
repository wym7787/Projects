<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
    
<%
	String sql = "insert into user values(?,?,?,?,?,?,?)";
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	PreparedStatement pstmt = conn.prepareStatement(sql);
	
	
	
	String id = request.getParameter("id");
	String name = request.getParameter("name");
	String pass = request.getParameter("ps");
	String pass2 = request.getParameter("pscon");
	String nicname = request.getParameter("nicname");
	String email = request.getParameter("email") + "@" + request.getParameter("email2");
	String receive = request.getParameter("receive");
	
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery("select * from user where id = '" + id + "'");
	
	
	if(rs.next())
	{
		if(rs.getString("id").equals(id))
		{
			out.println("<script>alert('중복되는 아이디가 존재합니다.');history.back();</script>");
		}
	}
	else
	{
		if((id.equals("") || name.equals("")|| pass.equals("") || pass2.equals("") || nicname.equals("") || email.equals("")) == true)
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
				pstmt.setString(1,id);
				pstmt.setString(2,name);
				pstmt.setString(3,nicname);
				pstmt.setString(4,pass);
				pstmt.setString(5,email);
				pstmt.setString(6,receive);
				pstmt.setString(7,(new SimpleDateFormat("yyyy-MM-dd")).format(new Date()));
				pstmt.executeUpdate();
				out.println("<script>alert('회원가입이 완료되었습니다.');window.location = 'login.html';</script>");
			}
		}
	}
	
	
	
%>