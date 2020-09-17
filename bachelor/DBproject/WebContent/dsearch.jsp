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
	Class.forName("oracle.jdbc.driver.OracleDriver"); 
	String user = "hospital"; 
	String pw = "1234";
	String url = "jdbc:oracle:thin:@localhost:1521:DBSERVER";
	Connection conn = DriverManager.getConnection(url, user, pw);
	String certinum = request.getParameter("certinum")==null?"":request.getParameter("certinum");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String job = request.getParameter("job")==null?"":request.getParameter("job");
	//String check = request.getParameter("check")==null?"":request.getParameter("check");
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>약 빤 프로그램</title>
	<link href="css/dsearch.css" rel="stylesheet">

<script>
function check(){
    cbox = input_form.chk;
    if(cbox.length) {  // 여러 개일 경우
        for(var i = 0; i<cbox.length;i++) {
            cbox[i].checked=input_form.all.checked;
        }
    } else { // 한 개일 경우
        cbox.checked=input_form.all.checked;
    }
}

function showPopup() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	var pop_title = "popupOpener" ;
    
    window.open("", pop_title, "width=400, height=500, left=550, top=0","scrollbars=yes");
     
    var frmData = document.input_form ;
    frmData.target = pop_title ;
    frmData.action = "update2.jsp" ;
     
    frmData.submit() ;
} 

function ddelete() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	//var pop_title = "popupOpener" ;
    
    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
     
    var frmData = document.input_form ;
   	//frmData.target = pop_title ;
    frmData.action = "ddelete.jsp" ;
     
    frmData.submit() ;
	}
	
function drollback() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	//var pop_title = "popupOpener" ;
    
    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
     
    var frmData = document.input_form ;
   	//frmData.target = pop_title ;
    frmData.action = "drollback.jsp" ;
     
    frmData.submit() ;
	}
	
function dtext() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	//var pop_title = "popupOpener" ;
    
    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
     
    var frmData = document.input_form2 ;
   	//frmData.target = pop_title ;
    frmData.action = "dtext.jsp" ;
     
    frmData.submit() ;
	}
</script>
</head>
<body>
<div class = "header">
	<div class = "top">
		<div class ="main">
			<a href="index.html"><img class = "mainlogo" src="img/main.jpg"/></a>
		</div>
	</div>
</div>

<div class ="container">
	<div class ="top-content">
		<div class ="toprap">
			<div class ="topsort">
				<div class ="toplogo"><img class = "topimage" src="img/h1.png"/></div>
				<div class ="toptext"><h4>의사/간호사 조회</h4></div>
			</div>	
		</div>
	</div>

<form method = "post" action = "dsearch.jsp" name = "input_form2">
<div id="sign-container">
			<div class ="sign-nav">
				<div class = "sort2">
				<h3>자격증 번호&nbsp</h3>
				<input id = "name-text"class = "text-box" type = "text" name = "certinum">
				<h3>이름</h3>
				<input id = "name-text"class = "text-box" type = "text" name = "name">
				<input class = "receive" type = "radio"  name = "job" value = "의사">의사
				<input class = "receive" type = "radio"  name = "job" value = "간호사">간호사
				<input class = "button" type = "submit" value = "조회">
				<a class ="button" href="dsearch.jsp">전체조회</a>
				<a class ="button" onclick="dtext();">텍스트</a>
				</div>
			</div>

</div>
</form>
<form name="input_form" method="post">
<div id ="button-sort">
	<a class = "button" onclick = "showPopup();">수정</a>
	<a class = "button" onclick = "ddelete();">삭제</a>
	<a class = "button" onclick= "drollback();">복구</a>
</div>

<table id = "container-table">
			<tr class = "col">
				<td><input type = "checkbox" name="all" onclick="check();"></td>
				<td>자격증번호</td>
				<td>이&nbsp름</td>
				<td>직업</td>
				<td>자격증 취득일</td>
				<td>진료과</td>
				
			</tr>
			<%
			
				
				String sql = "select * from doctor order by certinum"; // default
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				String pnum;
				
				if(request.getParameter("certinum") == null && request.getParameter("name") == null && request.getParameter("job") == null)
				{
					while(rs.next())
					{
						
						pnum = rs.getString(1);
						out.println("<tr class = 'col-sub'>");
						out.println("<td><input type = 'checkbox' name = 'chk' value = '"+pnum+"'></td>");
						out.println("<td>" + rs.getInt(1) + "</td>");
						out.println("<td>" + rs.getString(2) +"</td>");
						out.println("<td>" + rs.getString(3) +"</td>");
						out.println("<td>" + rs.getString(4) +"</td>");
						out.println("<td>" + rs.getString(5) +"</td>");
						
						out.println("</tr>");
							
					}
				}
				if(certinum.equals("") && name.equals("") && job.equals(""))
				{
					
				}
				
				
				if(!certinum.equals("") && name.equals("") && job.equals(""))
				{
					
					sql = "select * from doctor where certinum = '" + certinum + "'";
					rs = st.executeQuery(sql);
					while(rs.next())
					{
						
						pnum = rs.getString(1);
						out.println("<tr class = 'col-sub'>");
						out.println("<td><input type = 'checkbox' name = 'chk' value = '"+pnum+"'></td>");
						out.println("<td>" + rs.getInt(1) + "</td>");
						out.println("<td>" + rs.getString(2) +"</td>");
						out.println("<td>" + rs.getString(3) +"</td>");
						out.println("<td>" + rs.getString(4) +"</td>");
						out.println("<td>" + rs.getString(5) +"</td>");
						
						out.println("</tr>");
							
					}
				}
				if(!certinum.equals("") && !name.equals("") && job.equals(""))
				{
					
					sql = "select * from doctor where certinum = '" + certinum + "' and name = '" + name + "'";
					rs = st.executeQuery(sql);
					while(rs.next())
					{
						
						pnum = rs.getString(1);
						out.println("<tr class = 'col-sub'>");
						out.println("<td><input type = 'checkbox' name = 'chk' value = '"+pnum+"'></td>");
						out.println("<td>" + rs.getInt(1) + "</td>");
						out.println("<td>" + rs.getString(2) +"</td>");
						out.println("<td>" + rs.getString(3) +"</td>");
						out.println("<td>" + rs.getString(4) +"</td>");
						out.println("<td>" + rs.getString(5) +"</td>");
						
						out.println("</tr>");
							
					}
				}
				
				if(!certinum.equals("") && name.equals("") && !job.equals(""))
				{
					
					sql = "select * from doctor where certinum = '" + certinum + "' and job = '" + job +"'";
					rs = st.executeQuery(sql);
					while(rs.next())
					{
						
						pnum = rs.getString(1);
						out.println("<tr class = 'col-sub'>");
						out.println("<td><input type = 'checkbox' name = 'chk' value = '"+pnum+"'></td>");
						out.println("<td>" + rs.getInt(1) + "</td>");
						out.println("<td>" + rs.getString(2) +"</td>");
						out.println("<td>" + rs.getString(3) +"</td>");
						out.println("<td>" + rs.getString(4) +"</td>");
						out.println("<td>" + rs.getString(5) +"</td>");
						
						out.println("</tr>");
							
					}
				}
				if(certinum.equals("") && !name.equals("") && job.equals(""))
				{
					
					sql = "select * from doctor where name = '" + name + "'";
					rs = st.executeQuery(sql);
					while(rs.next())
					{
						
						pnum = rs.getString(1);
						out.println("<tr class = 'col-sub'>");
						out.println("<td><input type = 'checkbox' name = 'chk' value = '"+pnum+"'></td>");
						out.println("<td>" + rs.getInt(1) + "</td>");
						out.println("<td>" + rs.getString(2) +"</td>");
						out.println("<td>" + rs.getString(3) +"</td>");
						out.println("<td>" + rs.getString(4) +"</td>");
						out.println("<td>" + rs.getString(5) +"</td>");
						
						out.println("</tr>");
							
					}
				}
				
				
				if(!certinum.equals("") && !name.equals("") && !job.equals(""))
				{
					
					sql = "select * from doctor where name = '" + certinum + "' and job = '" + job +"'";
					rs = st.executeQuery(sql);
					while(rs.next())
					{
						
						pnum = rs.getString(1);
						out.println("<tr class = 'col-sub'>");
						out.println("<td><input type = 'checkbox' name = 'chk' value = '"+pnum+"'></td>");
						out.println("<td>" + rs.getInt(1) + "</td>");
						out.println("<td>" + rs.getString(2) +"</td>");
						out.println("<td>" + rs.getString(3) +"</td>");
						out.println("<td>" + rs.getString(4) +"</td>");
						out.println("<td>" + rs.getString(5) +"</td>");
						
						out.println("</tr>");
							
					}
				}
				if(certinum.equals("") && name.equals("") && !job.equals(""))
				{
					
					sql = "select * from doctor where job = '" + job + "'";
					rs = st.executeQuery(sql);
					while(rs.next())
					{
						
						pnum = rs.getString(1);
						out.println("<tr class = 'col-sub'>");
						out.println("<td><input type = 'checkbox' name = 'chk' value = '"+pnum+"'></td>");
						out.println("<td>" + rs.getInt(1) + "</td>");
						out.println("<td>" + rs.getString(2) +"</td>");
						out.println("<td>" + rs.getString(3) +"</td>");
						out.println("<td>" + rs.getString(4) +"</td>");
						out.println("<td>" + rs.getString(5) +"</td>");
						
						out.println("</tr>");
							
					}
				}
				
				
				st.close();
				rs.close();
				conn.close();
				
%>
			
				
		</table>
</form>

</div>
</body>
</html>