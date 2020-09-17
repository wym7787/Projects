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
	String pname = request.getParameter("name")==null?"":request.getParameter("name");
	
	session.setAttribute("patient",pnumber);
	String sql = null;
	
	String pnum ="", name ="", jumin = "", phone ="", height ="", weight ="" , blood = "";
	
	
	
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>약 빤 프로그램</title>
	<link href="css/medicine.css" rel="stylesheet">
	
	<script>
	function meinput() { 
		//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
		
		//var pop_title = "popupOpener" ;
	    
	    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
	     
	    var frmData = document.input_form ;
	   	//frmData.target = pop_title ;
	    frmData.action = "meinput.jsp" ;
	     
	    frmData.submit() ;
		}
	function check() { 
		//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
		
		var pop_title = "popupOpener" ;
	    
	    window.open("", pop_title, "width=1300, height=500, left=0, top=0,scrollbars=yes");
	     
	    var frmData = document.input_form ;
	    frmData.target = pop_title ;
	    frmData.action = "check.jsp" ;
	     
	    frmData.submit() ;
	}
	
	function jojae() { 
		//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
		
		var pop_title = "popupOpener" ;
	    
	    window.open("", pop_title, "width=1000, height=300, left=100, top=0");
	     
	    var frmData = document.input_form ;
	    frmData.target = pop_title ;
	    frmData.action = "jojae.jsp" ;
	     
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
				<div class ="toptext"><h4>진료 및 처방</h4></div>
			</div>	
		</div>
	</div>

<form method = "post" action = "medicine.jsp">
<div id="sign-container">
			<div class ="sign-nav">
				<div class = "sort2">
				<h3>환자번호&nbsp</h3>
				<input class = "text-box" type = "text" name = "pnumber">
				<h3>이름</h3>
				<input class = "text-box" type = "text" name = "name">
				<input class = "button" type = "submit" value = "조회">
				</div>
			</div>

</div>
<%
	



if(pnumber.equals("") && pname.equals(""))
{
	
}


if(!pnumber.equals("") && pname.equals(""))
{
	sql = "select pnum, name, substr(jumin,1,6) jumin1, phone, height, weight, blood from patient where pnum = '" + pnumber +"'";
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	if(rs.next())
	{
		pnum = rs.getString(1);
		name = rs.getString(2);
		jumin = rs.getString(3);
		phone = rs.getString(4);
		height = rs.getString(5);
		weight = rs.getString(6);
		blood = rs.getString(7);
	}
	
	
}

if(!pnumber.equals("") && !pname.equals(""))
{
	sql = "select pnum, name, substr(jumin,1,6) jumin1, phone, height, weight, blood from patient where pnum = '" + pnumber +"' and name = '" + pname +"'";
	Statement st = conn.createStatement();
	ResultSet rs = st.executeQuery(sql);
	
	if(rs.next())
	{
		pnum = rs.getString(1);
		name = rs.getString(2);
		jumin = rs.getString(3);
		phone = rs.getString(4);
		height = rs.getString(5);
		weight = rs.getString(6);
		blood = rs.getString(7);
	}
	
	
}
if(pnumber.equals("") && !pname.equals(""))
{
	out.println("<script>alert('중복되는 정보가 있을 수 있습니다.');</script>");
}

%>
</form>
<form name="input_form" method="post">
<div class = "tablerap">
        <table id = "container-table">
			<tr class = "col">
				<th colspan = 2>환&nbsp;자</th>
			</tr>
			<tr class = "col-sub">
				<td>환자번호</td>
				<td><input type = "hidden" value = '<%= pnum %>' name ="patient"  style="border: none; background: transparent;" ><%= pnum %></td>
			</tr>
			<tr class = "col-sub">
				<td>이&nbsp;&nbsp;름</td>
				<td><input type = "hidden" value = '<%=name%>'  style="border: none; background: transparent;"><%=name%></td>
			</tr>
			<tr class = "col-sub">
				<td>생년월일</td>
				<td><input type = "hidden" value = '<%=jumin%>' style="border: none; background: transparent;"><%=jumin%></td>
			</tr>
			<tr class = "col-sub">
				<td>핸드폰 번호</td>
				<td><input type = "hidden" value ='<%=phone%>' style="border: none; background: transparent;"><%=phone%></td>
			</tr>
			<tr class = "col-sub">
				<td>키(Cm)</td>
				<td><input type = "hidden" value = '<%=height%>' style="border: none; background: transparent;"><%=height%></td>
			</tr>
			<tr class = "col-sub">
				<td>체&nbsp;&nbsp;중(Kg)</td>
				<td><input type = "hidden" value = '<%=weight %>' style="border: none; background: transparent;"><%=weight %></td>
			</tr>
	        <tr class = "col-sub">
	 			<td>혈액형</td>
				<td><input type = "hidden" value ='<%=blood%>' style="border: none; background: transparent;"><%=blood%></td>
			</tr>
			
			
		</table>

		
        <table id = "container-table2">
			<tr class = "col">
				<th colspan = 2>의사 및 간호사</th>
			</tr>
			<tr class = "col-sub">
				<td>의사 자격번호</td>
				<td><input type = "text" name = "dnum1" style="border: none; background: transparent;"></td>
			</tr>
			<tr class = "col-sub">
				<td>담당의사</td>
				<td><input type = "text" name = "dname1" style="border: none; background: transparent;"></td>
			</tr>
			<tr class = "col-sub">
				<td>간호사 자격번호</td>
				<td><input type = "text" name = "dnum2" style="border: none; background: transparent;"></td>
			</tr>
			<tr class = "col-sub">
				<td>담당간호사</td>
				<td><input type = "text" name = "dname2" style="border: none; background: transparent;"></td>
			</tr>
			<tr class = "col-sub">
				<td>혈&nbsp;&nbsp;압</td>
				<td><input type = "text" name = "pressure" style="border: none; background: transparent;"></td>
			</tr>
			<tr class = "col-sub">
				<td>증&nbsp;&nbsp;상</td>
				<td><input type = "text" name = "disease" style="border: none; background: transparent;"></td>
			</tr>
	        <tr class = "col-sub">
	 			<td>수술여부</td>
				<td><input type = "text" name = "operation" style="border: none; background: transparent;"></td>
			</tr>
			<tr class = "col-sub">
	 			<td>진찰비용</td>
				<td><input type = "text" name = "jinprice" style="border: none; background: transparent;"></td>
			</tr>
			 <tr class = "col-sub">
	 			<td>수술비용</td>
				<td><input type = "text" name = "suprice" style="border: none; background: transparent;"></td>
			</tr>
		</table>
		</form>
</div>
<div id ="button-sort">
	<a class = "button" onclick= "check();">의료진 목록</a>
	<a class = "button" onclick = "meinput();">등록</a>
</div>


<a class="folder" onclick="jojae();"> 
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&raquo;&nbsp;&raquo;&nbsp;&raquo;&nbsp;약&nbsp;&nbsp;처&nbsp;&nbsp;방&nbsp;&laquo;&nbsp;&laquo;&nbsp;&laquo;
</a><div class="fold">
</div>


</div>
</body>
</html>