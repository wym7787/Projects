<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
<%
	session.setMaxInactiveInterval(48*60*60);
      Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787","dnjs5258!@");
      String sql = "select * from user where id = 'manager'";
      String Mid = "";
      Statement st = conn.createStatement();
      ResultSet rs = st.executeQuery(sql);
      
      if(rs.next())
      {
         Mid = rs.getString("id");
      }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
   <meta charset="utf-8">
   <title>Health Club</title>
   <link href="css/main.css" rel="stylesheet">
    <link href="css/remain.css" rel="stylesheet">   
    <link href="css/bootstrap.css" rel="stylesheet">
    <link href="css/bootstrap-responsive.css" rel="stylesheet">
    <link href="css/customized-main.css" rel="stylesheet">
    <link href="css/navbar.css" rel="stylesheet">
   <!--link href="css/relogin.css" rel="stylesheet"-->
   <meta name="viewport" content="width=device-width, initial-scale=1">
   <style>
  #container-button1
{
	float: right;
	margin-top: 10px;
	margin-bottom: 5px;
}
#container-button1 a
{
	text-decoration: none;
	color: white;
	padding-top: 5px;
	padding-bottom: 5px;
	padding-left: 30px;
	padding-right: 30px;
	background-color: #7f7f7f;
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
                 else if (session.getAttribute("userid").equals(Mid))
                 {
                    String id = Mid;
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
    <div class="col-xs-4">
            <div class="thumbnail">
                <div id="weekBest">WEEK BEST</div>
                <div class="weekBestGym">더블에스 피트니스</div>
                <a href="subpage.jsp">
                <%
                String imageNum= "";
                if(request.getParameter("no") == null)
                {
                	if(session.getAttribute("no") == null)
                	{
    	                imageNum = "1";
                	}
                	else
                	{
                    	imageNum = (String)session.getAttribute("no");
                	}
                }
                else if(request.getParameter("no") != null)
                {
                	 session.setAttribute("no", request.getParameter("no"));
                	imageNum = (String)session.getAttribute("no");
                }
     			out.println("<img src='view.jsp?no="+imageNum+ "' alt='...'>");
                %>
                    
                </a>
            </div>
            <%
		if(session.getAttribute("userid") != null && session.getAttribute("userid").equals("manager"))
		{
			out.println("<div id = 'container-button1'><a href='indexImageChoice.jsp'>편집</a></div>");
		}
	%>
        </div>
        <div class="col-xs-8">
            <div>
                <div class="col-xs-6">
                    <div class="thumbnail">
                        <div class="weekBestGym">노원 고릴라 멀티짐</div>
                       <a href = "#">    
                        <img src="imgs/gym2.png" alt="...">
                       </a>
                        <div class="caption">
                            <div class="starRating">
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star-empty"/>
                                <span>평점 4.7/5.0</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="thumbnail">
                        <div class="weekBestGym">노원 아이언 휘트니스</div>
                        <img src="imgs/gym3.png" alt="...">
                        <div class="caption">
                            <div class="starRating">
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star-empty"/>
                                <span>평점 4.7/5.0</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div>
                <div class="col-xs-6">
                    <div class="thumbnail">
                        <div class="weekBestGym">노원 블랙짐 스튜디오</div>
                        <img src="imgs/gym4.png" alt="...">
                        <div class="caption">
                            <div class="starRating">
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star-empty"/>
                                <span>평점 4.7/5.0</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-xs-6">
                    <div class="thumbnail">
                        <div class="weekBestGym">노원 바디디자인</div>
                        <img src="imgs/gym5.png" alt="...">
                        <div class="caption">
                            <div class="starRating">
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star"/>
                                <span class="glyphicon glyphicon-star-empty"/>
                                <span>평점 4.7/5.0</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</div>
</body>
</html>