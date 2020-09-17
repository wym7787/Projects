<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%request.setCharacterEncoding("UTF-8"); %>
<%String uid = (String) session.getAttribute("userid"); %>
<html>
<head>
	<title>Health club</title>
	<meta charset="utf-8">
	<link href="css/boardWrite.css" rel="stylesheet">
	<link href="css/reboard.css" rel="stylesheet">
	<link href="css/main.css" rel="stylesheet">
    <link href="css/remain.css" rel="stylesheet">	
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/bootstrap-responsive.css" rel="stylesheet">
    <link href="css/customized-main.css" rel="stylesheet">
    <link href="css/navbar.css" rel="stylesheet">
	<!--link href="css/relogin.css" rel="stylesheet"-->
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
</head>
<body>
<div id = "header">
	<div id = "header-row">
		<div class ="menu">
           	<ul class = "nav-menu">
            <%
                 if(session.getAttribute("userid") == null)
                 {
                    out.println("<li><a href ='login.html'>로그인</a></li>");
                   out.println("<li><a href ='signup.html'>회원가입</a></li>");
                   out.println("<li><a href ='#'>마이페이지</a></li>");
                 }
                 else if (session.getAttribute("userid").equals("manager"))
                 {
                    out.println("<li><a href ='index.jsp'>" + "manager" + "</a></li>");
                   out.println("<li><a href ='logout.jsp'>로그아웃</a></li>");
                   out.println("<li><a href ='userInfo.jsp'>회원정보보기</a></li>");

                 }
                 else
                 {
                 String id2 = (String) session.getAttribute("userid");
                    out.println("<li><a href ='index.jsp'>" + id2 + "</a></li>");
                   out.println("<li><a href ='logout.jsp'>로그아웃</a></li>");
                   out.println("<li><a href ='mypage.jsp?'>마이페이지</a></li>");
                 }
              %>            </ul>
        </div>
        <div class ="logo">
        	
        	<div id = "logo-img">
        	<a class="brand" href="index.jsp">
                <img class = "img-title" id="logoimage" src="imgs/logo.png"/>
            </a>
        	</div>

            <div id = "search-box">
            <span id = "search-text"><input type = "text"></span>
            <span id = "search-button"><input type = "submit" value = "검 색"></span>
        	</div>

		</div>	
    </div>
</div>
<!-- contents -->

<div id = "content">
	<div id = "content-row">
            <ul id = "content-menu">
                <li><a href="">웨이트</a></li>
                <li><a href="#">GX</a></li>
                <li><a href="#">스피닝</a></li>
                <li><a href="#">유산소</a></li>
                <li><a href="board.jsp">커뮤니티</a></li>
                <li><a href="#">&nbsp&nbsp&nbsp추천 트레이너</a></li>
            </ul>
	</div>

	<div id = "container">
		<div id = "container-menu">
				<div id ="menu-text">커뮤니티</div>
				<div id ="menu-rap">
				<div id = "free" class ="sub-menu"><a href="board.jsp">자유&nbsp게시판</a></div>
				<div class ="sub-menu"><a href="#">벼룩시장</a></div>
				</div>
		</div>

		<div id = "container-main">
			<div id = "main-top">
				<div id = "top-text">현재위치 : Home  >  커뮤니티  >  자유게시판  >  글쓰기</div>
			</div>

<%
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	Statement st = con.createStatement();
	ResultSet rs = st.executeQuery("select * from board");
	String title="";
	String content="";
	String id ="";
	int no=0;
	String key="";
	key = request.getParameter("key");
	while(rs.next())
	{
		if(rs.getString("contentNo").equals(key))
		{
			title = rs.getString("title");
			content = rs.getString("centent");
			id = rs.getString("userid");
			no = rs.getInt("readNo");
		}
	}
	no++;
	st.executeUpdate("update board set readNo='"+no+"' where contentNo='"+key+"'");
	con.close();
	st.close();
	rs.close();
%>
	<form method='post' action='boardDelete.jsp'>
	
	<%
		if(session.getAttribute("userid").equals(id))
	{%>
	<div id ='main-bottom'>
			
				<table id = 'container-table' >
					<tr class = 'col'>
						<td id = 'title'>제목</td>
						<td><input id ='title-text' type = 'text' name = 'title' value = '<%=title%>'></td>
					</tr>
					<tr class = "col">
						<td>작성자</td>
						<td><input id = 'name-text' type = 'text' name = 'name' disabled value = '<%=id%>' ></td>
					</tr>
					<tr>
						<td colspan = '2'><textarea id ='content-text' name ='content'><%=content%></textarea></td>
					</tr>
					<tr class = "col">
						<td>비밀번호</td>
						
						<td><input id = 'pass-text' type = 'password' name = 'ps'></td>
					</tr>
				</table>
				<div id = "confirm">
						<%session.setAttribute("no",key);%>
						<input id = 'submit' type='submit' value='수정' formaction = 'boardUpdate.jsp'></td>
						<input id = 'submit' type='submit' value='삭제' id='b1'></td>	
						<input id = 'reset'  type = 'button' onclick = "location.href='board.jsp';" value = '취 소'>
				</div>
	</div>
	<%} %>
	<%if(session.getAttribute("userid") == null || (session.getAttribute("userid").equals(id) == false))
	{%>
	<div id ='main-bottom'>
			
				<table id = 'container-table' >
					<tr class = 'col'>
						<td id = 'title'>제목</td>
						<td><input id ='title-text' type = 'text' name = 'title' value = '<%=title%>' disabled></td>
					</tr>
					<tr class = "col">
						<td>작성자</td>
						<td><input id = 'name-text' type = 'text' name = 'name' value = '<%=id%>' disabled></td>
					</tr>
					<tr>
						<td colspan = '2'><textarea id ='content-text' name ='content' disabled><%=content%></textarea></td>
					</tr>
					<tr class = "col">
						<td>비밀번호</td>
						
						<td><input id = 'pass-text' type = 'password' name = 'ps' disabled></td>
					</tr>
				</table>
				<div id = "confirm">
						<%session.setAttribute("no",key);%>	
						<input id = 'submit' type='submit' value='삭제' id='b1'></td>	
						<input id = 'reset'  type = 'button' onclick = "location.href='board.jsp';" value = '이전으로'>
				</div>
	</div>
	<%} %>
	</form>
</div>
</div>
</div>
</body>
</html>
