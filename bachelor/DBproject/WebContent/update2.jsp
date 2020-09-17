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
	
	
	String certinum ="";
	String name ="";
	String job = "";
	String jinryo = "";
	
	
	// 자격증 획득일 스트링
	
	String certiday1 ="";
	String certiday2 ="";
	String certiday3 ="";
	
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
		
		String sql = "select * from doctor where certinum = '" + arr[0] + "'";
		st = conn.createStatement();
		rs = st.executeQuery(sql);
		
		
		
		
		if(rs.next())
		{
			certinum = rs.getString("certinum");
			name = rs.getString("name");
			job = rs.getString("job");
			jinryo = rs.getString("jinryo");
			
				
		}
		//주민번호 추출
		String sql1 = "select substr(certiday,1,4) cer1,substr(certiday,8,2) cer2, substr(certiday,13,2) cer3 from doctor where certinum = '" + arr[0] + "'";
		rs = st.executeQuery(sql1);
		
		if(rs.next())
		{
			certiday1 = rs.getString("cer1");
			certiday2 = rs.getString("cer2");
			certiday3 = rs.getString("cer3");
		}
		

		
	}
	
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>약 빤 프로그램</title>
	<link href="css/update2.css" rel="stylesheet">

</head>
<body>
<div class = "header">
	<div class ="toprap">
			<div class ="topsort">
				<div class ="toplogo"><img class = "topimage" src="img/h1.png"/></div>
				<div class ="toptext"><h4>의사/간호사 수정</h4></div>
			</div>	
	</div>
</div>

<div class = "container">

<form method = "post" action = "complete2.jsp">
<div id="sign-container">
			<div class ="sign-nav">
				<div class = "sort">
				<h3>자격증등록번호</h3>
				</div>
				<div class = "sort2">
				<input id = "i-text"class = "text-box" type = "hidden" name = "certinum" value ='<%=certinum%>'><%=certinum%>
				<h3>(의사는 1, 간호사 2로 시작 4자리)</h3>
				</div>
			</div>
			<div class ="sign-nav">
				<div class = "sort">
				<h3>이름</h3>
				</div>
				<div class = "sort2">
				<input id = "name-text"class = "text-box" type="text" name = "name" value ='<%=name%>'>
				</div>
			</div>
			
			<div class ="sign-nav">
				<div class = "sort">
				<h3>직업</h3>
				</div>
					<div class = "sort3">
						<input class = "receive" type = "radio"  name = "job" value ="의사">의사
						<input class = "receive" type = "radio"  name = "job" value ="간호사">간호사
						
					</div>
				
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>진료과</h3>
				</div>
					<div class = "sort3">
						<input class = "receive" type = "radio"  name = "receive" value ="내과">내과
						<input class = "receive" type = "radio"  name = "receive" value ="정형외과">정형외과
						<input class = "receive" type = "radio"  name = "receive" value ="치과">치과
						<input class = "receive" type = "radio"  name = "receive" value ="이비인후과">이비인후과
						<input class = "receive" type = "radio"  name = "receive" value ="안과">안과
					</div>
				
			</div>

			<div class ="sign-nav">
				<div class = "sort">
				<h3>자격증취득일</h3>
				</div>
				<div class = "sort2">
				<input class ="phone-box"  type = "text" name = "certiday1" value = '<%=certiday1%>'>
				<h3>년</h3>
				<input class ="phone-box"  type = "text" name = "certiday2" value = '<%=certiday2%>'>
				<h3>월</h3>
				<input class ="phone-box"  type = "text" name = "certiday3" value = '<%=certiday3%>'>
				<h3>일</h3>
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