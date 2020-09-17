<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import = "java.sql.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <title>Health club</title>
  <meta charset="utf-8">
	<link href="css/subpage.css" rel="stylesheet">
	<link href="css/subpage2.css" rel="stylesheet">
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
<form method="post" action="subpageUpdate2.jsp" enctype="multipart/form-data">
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
   
   <div id = "container-button"><input type="submit" value="수정완료"></div>
   </div>
   
   <div id = "container-main">
      <div id = "container-top">
         <div id = "top-left">
            
            <a href ="#"><img src = "view.jsp?no=1"></a>
            <input class="change" type="file" name="img1">
         </div>
         <div id = "top-right">
            <table id = "image_table">
            <tr>
            <%
            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787", "dnjs5258!@");
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("select * from subpage");
            
            String pro1="", pro2="";
            boolean choice = rs.next();
            if(choice)
            {
               if(rs.getString("program") != null)
               {
                  pro1 = rs.getString("program");
               }
               if(rs.getString("muchine") != null)
               {
                  pro2 = rs.getString("muchine");
               }
            }
            %>
               <td>프로그램 : <input class="tt" type="text" name="program1" value="<%=pro1%>"></td>
            </tr>
            <tr>
               <td>웨이트 기구</td>
            </tr>  
            <tr>
            	<td colspan = "2"><textarea id ="content-text" name="program2" value="<%=pro2%>"></textarea></td>
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
            <%
            String r1="", r2="", r3="", r4="", r5="";
            if(choice)
            {
               if(rs.getString("radio1").equals("O"))
               {
                  out.println("<td><input class='receive' type='radio' name='receive1' value='O' checked='checked'>O<input class='receive' type='radio' name='receive1' value='X'>X</td>");
               }
               else
               {
                  out.println("<td><input class='receive' type='radio' name='receive1' value='O'>O<input class='receive' type='radio' name='receive1' value='X' checked='checked'>X</td>");
               }
               
               if(rs.getString("radio2").equals("O"))
               {
                  out.println("<td><input class='receive' type='radio' name='receive2' value='O' checked='checked'>O<input class='receive' type='radio' name='receive2' value='X'>X</td>");
               }
               else
               {
                  out.println("<td><input class='receive' type='radio' name='receive2' value='O'>O<input class='receive' type='radio' name='receive2' value='X' checked='checked'>X</td>");
               }
               
               if(rs.getString("radio3").equals("O"))
               {
                  out.println("<td><input class='receive' type='radio' name='receive3' value='O' checked='checked'>O<input class='receive' type='radio' name='receive3' value='X'>X</td>");
               }
               else
               {
                  out.println("<td><input class='receive' type='radio' name='receive3' value='O'>O<input class='receive' type='radio' name='receive3' value='X' checked='checked'>X</td>");
               }
               
               if(rs.getString("radio4").equals("O"))
               {
                  out.println("<td><input class='receive' type='radio' name='receive4' value='O' checked='checked'>O<input class='receive' type='radio' name='receive4' value='X'>X</td>");
               }
               else
               {
                  out.println("<td><input class='receive' type='radio' name='receive4' value='O'>O<input class='receive' type='radio' name='receive4' value='X' checked='checked'>X</td>");
               }
               
               if(rs.getString("radio5").equals("O"))
               {
                  out.println("<td><input class='receive' type='radio' name='receive5' value='O' checked='checked'>O<input class='receive' type='radio' name='receive5' value='X'>X</td>");
               }
               else
               {
                  out.println("<td><input class='receive' type='radio' name='receive5' value='O'>O<input class='receive' type='radio' name='receive5' value='X' checked='checked'>X</td>");
               }
            }
            
               %>
            </tr>
         </table>
         </div>
      </div>
      <div id = "container-bottom">
         <div class = "bottom-image">
            <img src = "view.jsp?no=2">
            <input class="change"  type="file" name="img2">
               <p>웨이트 존</p>
         </div>
         <div class = "bottom-image">
            <img src = "view.jsp?no=3">
            <input class="change"  type="file" name="img3">
               <p>유산소 존</p>
         </div>
         <div class = "bottom-image">
            <img src = "view.jsp?no=4">
            <input class="change"  type="file" name="img4">
               <p>GX 존</p>
         </div>
         <div class = "bottom-image" id = "last">
            <img src = "view.jsp?no=5">
            <input  class="change" type="file" name="img5">
               <p>사우나</p>
         </div>
      </div>
   </div>
   
</div>
</form>
</body>
</html>