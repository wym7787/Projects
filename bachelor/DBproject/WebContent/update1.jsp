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
	String [] arr = request.getParameterValues("chk");
	Statement st = null;
	ResultSet rs = null;
	
	
	String pnum ="";
	String name ="";
	String height ="";
	String weight ="";
	String blood ="";
	//주민번호 스트링
	String jumin1 ="";
	String jumin2 ="";
	
	// 폰번호 스트링
	
	String phone1 ="";
	String phone2 ="";
	String phone3 ="";
	
	if(arr == null)
	{
		out.println("<script>alert('수정할 인원을 선택하세요.');close();</script>");
	}
	else
	{
		if(arr.length > 1)
		{
			out.println("<script>alert('한명만 수정 가능합니다.');close();</script>");
		}
		
		String sql = "select * from patient where pnum = '" + arr[0] + "'";
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		
		
		
		
		if(rs.next())
		{
			pnum = rs.getString("pnum");
			name = rs.getString("name");
			height = rs.getString("height");
			weight = rs.getString("weight");
			blood = rs.getString("blood");
			
		}
		//주민번호 추출
		String sql1 = "select substr(jumin,1,6) jumin1,substr(jumin,10,7) jumin2 from patient where pnum = '" + arr[0] + "'";
		
		rs = st.executeQuery(sql1);
		if(rs.next())
		{
			jumin1 = rs.getString(1);
			jumin2 = rs.getString(2);
		}
		
		
		//폰번호 추출
		
		String sql2 = "select substr(phone,1,3) phone1, substr(phone,7,4) phone2, substr(phone,14,4) phone3 from patient where pnum = '" + arr[0] + "'";
		rs = st.executeQuery(sql2);
		if(rs.next())
		{
			phone1 = rs.getString("phone1");
			phone2 = rs.getString("phone2");
			phone3 = rs.getString("phone3");
		}
		
		
	}
	
	
	
%>
<html>
<head>
	<meta charset="utf-8">
	<title>약 빤 프로그램</title>
	<link href="css/update1.css" rel="stylesheet">
	
</head>
<body>
<div class = "header">
	<div class ="toprap">
			<div class ="topsort">
				<div class ="toplogo"><img class = "topimage" src="img/h1.png"/></div>
				<div class ="toptext"><h4>환자 수정</h4></div>
			</div>	
	</div>
</div>

<div class = "container">

<form method = "post" action = "complete1.jsp">
<div id="sign-container">

			<div class ="sign-nav">
				<div class = "sort">
				<h3>환자번호</h3>
				</div>
				<div class = "sort2">
				<input id = "name-text"class = "text-box" type = "hidden" name = "pnumber" value = '<%=pnum%>'><%=pnum%>
				</div>
			</div>
			<div class ="sign-nav">
				<div class = "sort">
				<h3>이름</h3>
				</div>
				<div class = "sort2">
				<input id = "name-text"class = "text-box" type = "text" name = "name" value ='<%=name%>'>
				</div>
			</div>
			
			<div class ="sign-nav">
				<div class = "sort">
				<h3>주민번호</h3>
				</div>
				<input class ="jumin-box"  type = "text" name = "jumin1" value = '<%=jumin1%>'>
				<h3>-</h3>
				<input class ="jumin-box"  type = "text" name = "jumin2" value = '<%=jumin2%>'>
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>핸드폰 번호</h3>
				</div>
				<input class ="phone-box"  type = "text" name = "phone1" value ='<%=phone1%>'>
				<h3>-</h3>
				<input class ="phone-box"  type = "text" name = "phone2" value ='<%=phone2%>'>
				<h3>-</h3>
				<input class ="phone-box"  type = "text" name = "phone3" value ='<%=phone3%>'>
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>키</h3>
				</div>
				<div class = "sort2">
				<input id = "name-text"class = "text-box" type = "text" name = "height" value ='<%=height%>'>
				<h3>Cm</h3>
				</div>
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>체중</h3>
				</div>
				<div class = "sort2">
				<input id = "name-text"class = "text-box" type = "text" name = "weight" value ='<%=weight%>'>
				<h3>Kg</h3>
				</div>
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>혈액형</h3>
				</div>
					<div class = "sort3">
						<input class = "receive" type = "radio"  name = "receive" value ="A형">A형
						<input class = "receive" type = "radio"  name = "receive" value ="B형">B형
						<input class = "receive" type = "radio"  name = "receive" value ="O형">O형
						<input class = "receive" type = "radio"  name = "receive" value ="AB형">AB형
					</div>
				
			</div>


</div>
			
	
	<div id = "hr"></div>
			<div id="button">
					<input id = "button-sub" type = "submit" value = "수정">
					<a class = "button" href="javascript:self.close()">취소</a>
			</div>
</form>

</div>

</body>
</html>
