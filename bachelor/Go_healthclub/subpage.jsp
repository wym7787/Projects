<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%request.setCharacterEncoding("UTF-8"); %>
<html>
<head>
   <title>health club</title>
   <meta charset="utf-8">
   <link href="css/subpage.css" rel="stylesheet">
   <link href="css/resubpage.css" rel="stylesheet">
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
   <style>
      .tt
      {
         border : 0;
         background-color : white;
      }
   </style>
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
                    String id = "manager";
                    out.println("<li><a href ='index.jsp'>" + id + "</a></li>");
                   out.println("<li><a href ='logout.jsp'>로그아웃</a></li>");
                   out.println("<li><a href ='userInfo.jsp'>회원정보보기</a></li>");

                 }
                 else
                 {
                 String id = (String) session.getAttribute("userid");
                    out.println("<li><a href ='index.jsp'>" + id + "</a></li>");
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
   <div id = "rap">
   <div id = "container-text">서울온천 더블에스 피트니스</div>
   <%
      if(session.getAttribute("userid") != null && session.getAttribute("userid").equals("manager"))
      {
         out.println("<div id = 'container-button'><a href='subpageUpdate.jsp'>편집</a></div>");
      }
   %>
   </div>
   <div id = "container-main">
      <div id = "container-top">
         <div id = "top-left">
            <a href ="#"><img src = "view.jsp?no=1"></a>
         </div>
         <div id = "top-right">
         
         <%
            Class.forName("com.mysql.jdbc.Driver").newInstance();
         Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("select * from subpage");
            String a1="", a2="";
            String b1="", b2="", b3="", b4="", b5="";
            if(rs.next())
            {
            a1=rs.getString("program");
            a2=rs.getString("muchine");
            b1=rs.getString("radio1");
            b2=rs.getString("radio2");
            b3=rs.getString("radio3");
            b4=rs.getString("radio4");
            b5=rs.getString("radio5");
            }
         %>
         
            <table id = "image_table">
            <tr>
               <td colspan="2">프로그램 : <input type="text" name="program" class="tt" value="<%=a1 %>" disabled></td>
            </tr>
            <tr>
               <td>웨이트 기구</td>
            </tr>
            <tr>
            	<td colspan="2"><textarea id="content-text" name="muchine" class="tt" disabled><%=a2 %></textarea></td>
            </tr>
         </table>
         <table id = "image_table2" border = "0">
            <tr>
               <th>웨이트</th>
               <th>GX</th>
               <th>스피닝</th>
               <th>유산소</th>
               <th>사우나</th>
            </tr>
            <tr>
               <td><%=b1 %></td>
               <td><%=b2 %></td>
               <td><%=b3 %></td>
               <td><%=b4 %></td>
               <td><%=b5 %></td>
            </tr>
         </table>
         </div>
      </div>
      <div id = "container-bottom">
         <div class = "bottom-image">
            <img src ="view.jsp?no=2">
               <p>웨이트 존</p>
         </div>
         <div class = "bottom-image">
            <img src = "view.jsp?no=3">
               <p>유산소 존</p>
         </div>
         <div class = "bottom-image">
            <img src = "view.jsp?no=4">
               <p>GX 존</p>
         </div>
         <div class = "bottom-image" id = "last">
            <img src = "view.jsp?no=5">
               <p>사우나</p>
         </div>
      </div>
   </div>
</div>
</body>
</html>