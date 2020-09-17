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
	String pnumber = request.getParameter("pnumber")==null?"":request.getParameter("pnumber");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	//String check = request.getParameter("check")==null?"":request.getParameter("check");
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>약 빤 프로그램</title>
	<link href="css/psearch.css" rel="stylesheet">

<script type="text/javascript">
function showPopup() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	var pop_title = "popupOpener" ;
    
    window.open("", pop_title, "width=400, height=500, left=550, top=0");
     
    var frmData = document.input_form ;
    frmData.target = pop_title ;
    frmData.action = "update1.jsp" ;
     
    frmData.submit() ;
	}

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

function pdelete() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	//var pop_title = "popupOpener" ;
    
    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
     
    var frmData = document.input_form ;
   	//frmData.target = pop_title ;
    frmData.action = "pdelete.jsp" ;
     
    frmData.submit() ;
	}
	
function prollback() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	//var pop_title = "popupOpener" ;
    
    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
     
    var frmData = document.input_form ;
   	//frmData.target = pop_title ;
    frmData.action = "prollback.jsp" ;
     
    frmData.submit() ;
	}
	
	
function ptext() { 
	//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
	
	//var pop_title = "popupOpener" ;
    
    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
     
    var frmData = document.input_form2 ;
   	//frmData.target = pop_title ;
    frmData.action = "ptext.jsp" ;
     
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
				<div class ="toptext"><h4>환자 조회</h4></div>
			</div>	
		</div>
	</div>

<form method = "post" action ="psearch.jsp" name = "input_form2">
<div id="sign-container">
			<div class ="sign-nav">
				
				<div class = "sort2">
				<h3>환자번호&nbsp</h3>
				<input id = "name-text"class = "text-box" type = "text" name = "pnumber">
				<h3>이름</h3>
				<input id = "name-text"class = "text-box" type = "text" name = "name">
				<input class = "button" type = "submit" value = "조회">
				<a class ="button" href = "psearch.jsp">전체조회</a>
				<a class = "button" onclick = "ptext();">텍스트</a>
				</div>
			</div>

</div>

</form>

<div id ="button-sort">
	
	<a class = "button" onclick = "showPopup();">수정</a>
	<a class = "button" onclick = "pdelete();">삭제</a>
	<a class = "button" onclick = "prollback();">복구</a>
</div>
<form name="input_form" method="post">
<table id = "container-table">
			<tr class = "col">
				<td><input type = "checkbox" name = "all" onclick = "check();"></td>
				<td>환자번호</td>
				<td>이&nbsp름</td>
				<td>주민번호</td>
				<td>핸드폰 번호</td>
				<td>키(Cm)</td>
				<td>체중(Kg)</td>
				<td>혈액형</td>
			</tr>
			<%
			
				
				String sql = "select * from patient order by pnum"; // default
				Statement st = conn.createStatement();
				ResultSet rs = st.executeQuery(sql);
				String pnum;
				
				if(request.getParameter("pnumber") == null && request.getParameter("name") == null)
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
						out.println("<td>" + rs.getString(6) +"</td>");
						out.println("<td>" + rs.getString(7) +"</td>");
						out.println("</tr>");
							
					}
				}
				if(pnumber.equals("") && name.equals(""))
				{
					
				}
				
				
				if(!pnumber.equals("") && name.equals(""))
				{
					
					sql = "select * from patient where pnum = '" + pnumber + "'";
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
						out.println("<td>" + rs.getString(6) +"</td>");
						out.println("<td>" + rs.getString(7) +"</td>");
						out.println("</tr>");
							
					}
				}
				
				if(pnumber.equals("") && !name.equals(""))
				{
					
					sql = "select * from patient where name = '" + name + "'";
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
						out.println("<td>" + rs.getString(6) +"</td>");
						out.println("<td>" + rs.getString(7) +"</td>");
						out.println("</tr>");
							
					}
				}
				
				
				if(!pnumber.equals("") && !name.equals(""))
				{
					
					sql = "select * from patient where pnum = '" + pnumber +"' and name = '" + name + "'";
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
						out.println("<td>" + rs.getString(6) +"</td>");
						out.println("<td>" + rs.getString(7) +"</td>");
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