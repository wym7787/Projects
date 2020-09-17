<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%request.setCharacterEncoding("UTF-8"); %>
<%if(session.getAttribute("userid") == null)
	{
		out.println("<script>alert('로그인 후 이용 가능합니다');history.back();</script>");
	}
	%>
<html>
<head>
	<meta charset="utf-8">
	<title>Health club</title>
	<link href="css/board.css" rel="stylesheet">
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
              %>
            </ul>
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
                <li><a href="#">웨이트</a></li>
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
				<div id = "top-text">현재위치 : Home  >  커뮤니티  >  자유 게시판</div>
				<div id = "top-button"><a href="boardWrite.jsp">글쓰기</a></div>
			</div>

			<div id = "main-bottom">


		
<form method='post' action='boardShow.jsp'>
	<table class ="con-sub" id = "container-table">
					<tr class = "col">
						<td>번&nbsp호</td>
						<td>제&nbsp목</td>
						<td>작성자</td>
						<td>등록일</td>
						<td>조회</td>
					</tr>
<%
	String number = "", title="", writer="", writeDay="", readNo="";
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery("select * from board order by contentNo");
	int count =0;
	int num=0;
	while(rs.next())
	{
		num++;
		number =rs.getString("contentNo");
		title = rs.getString("title");
		writer = rs.getString("userid");
		writeDay = rs.getString("writeDay");
		readNo = rs.getString("readNo");
		out.println("<tr class = 'col-sub'>");
		out.println("<td>"+num+"</td>");
		out.println("<td><a href ='boardShow.jsp?key=" + number + "'>"+title+"</a></td>");
		out.println("<td>" + writer + "</td>");
		out.println("<td>" + writeDay + "</td>");
		out.println("<td>" + readNo + "</td>");
		out.println("</tr>");
	}

%>
	</table>
	</form>
</div>


			</div>
		</div>
	
</div>	

</div>
</body>
</html>