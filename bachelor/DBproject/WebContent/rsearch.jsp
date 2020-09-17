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
	String pnum = request.getParameter("pnumber")==null?"":request.getParameter("pnumber");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	Statement st = conn.createStatement();
	
	session.setAttribute("patient",pnum);
	String sql1 =""; // 환자와 의사 조인
	String sql2 = ""; // 간호사 이름 추출
	String sql3 = ""; //환자 약테이블 조인
	String sql4 = "";
	
	
	//환자 스트링
	String pnumber ="";
	String pname = "";
	String jumin1 ="";
	String phone = "";
	String height = "";
	String weight ="";
	String blood ="";
	String pressure ="";
	String disease ="";
	String operation ="";
	
	// 의료진 스트링
	String dnum1 ="";
	String dnum2 ="";
	String dname1 = "";
	String dname2 = "";
	
	// 약 스트링
	
	String precont ="";
	String jinprice ="";
	String suprice ="";
	String joprice ="";
	int result = 0 ;
	
	if(pnum.equals("") && name.equals(""))
	{
		
	}
	
	if(!pnum.equals("") && name.equals(""))
	{
		sql1 = "select * from patient p , doctor d where p.pnum = '" + pnum + "' and p.dnum1 = d.certinum"; // 환자와 의사 조인
		sql2 = "select d.certinum, d.name from patient p, doctor d where p.pnum = '" + pnum +"' and p.dnum2 = d.certinum"; // 간호사 이름 추출
		sql3 = "select * from patient p, medicine m where p.pnum = '" + pnum +"' and p.pnum = m.pnum"; //환자 약테이블 조인
		sql4 = "select substr(jumin,1,6) from patient where pnum = '" + pnum +"'";
		
		ResultSet rs1 = st.executeQuery(sql1);
		if(rs1.next())
		{
			pnumber = rs1.getString(1);
			pname = rs1.getString(2);
			phone = rs1.getString(4);
			height = rs1.getString(5);
			weight = rs1.getString(6);
			blood = rs1.getString(7);
			pressure = rs1.getString(8);
			disease = rs1.getString(9);
			operation = rs1.getString(10);
			dnum1 = rs1.getString(13);
			dname1 = rs1.getString(14);
			
			
		}
		
		ResultSet rs2 = st.executeQuery(sql2);
		if(rs2.next())
		{
			dnum2 = rs2.getString(1);
			dname2 = rs2.getString(2);
		}
		ResultSet rs3 = st.executeQuery(sql3);
		if(rs3.next())
		{
			precont = rs3.getString(14);
			jinprice = rs3.getString(17);
			suprice = rs3.getString(18);
			joprice = rs3.getString(19);
			
		}
		ResultSet rs4 = st.executeQuery(sql4);
		if(rs4.next())
		{
			jumin1 = rs4.getString(1);
		}
		
		if(jinprice.equals("") || suprice.equals("") || joprice.equals(""))
		{
			out.println("<script>alert('처방되지 않은 환자입니다.');location.href='rsearch.jsp';</script>");
		}
		else
		{
			int com1 = Integer.parseInt(jinprice);
			int com2 = Integer.parseInt(suprice);
			int com3 = Integer.parseInt(joprice);
			result = com1 + com2 + com3;
		}
		
		rs1.close();
		rs2.close();
		rs3.close();
		rs4.close();
		st.close();
		conn.close();
		
	
		
	}
	
	if(!pnum.equals("") && !name.equals(""))
	{
		
		sql1 = "select * from patient p , doctor d where p.pnum = '" + pnum + "' and p.name = '" + name +"' and p.dnum1 = d.certinum"; // 환자와 의사 조인
		sql2 = "select d.certinum, d.name from patient p, doctor d where p.pnum = '" + pnum +"' and p.name = '" + name + "' and p.dnum2 = d.certinum"; // 간호사 이름 추출
		sql3 = "select * from patient p, medicine m where p.pnum = '" + pnum +"' and p.name = '" + name + "' and p.pnum = m.pnum"; //환자 약테이블 조인
		sql4 = "select substr(jumin,1,6) from patient where pnum = '" + pnum +"' and name = '" + name + "'";
		ResultSet rs1 = st.executeQuery(sql1);
		if(rs1.next())
		{
			pnumber = rs1.getString(1);
			pname = rs1.getString(2);
			phone = rs1.getString(4);
			height = rs1.getString(5);
			weight = rs1.getString(6);
			blood = rs1.getString(7);
			pressure = rs1.getString(8);
			disease = rs1.getString(9);
			operation = rs1.getString(10);
			dnum1 = rs1.getString(13);
			dname1 = rs1.getString(14);
			
			
		}
		
		ResultSet rs2 = st.executeQuery(sql2);
		if(rs2.next())
		{
			dnum2 = rs2.getString(1);
			dname2 = rs2.getString(2);
		}
		ResultSet rs3 = st.executeQuery(sql3);
		if(rs3.next())
		{
			precont = rs3.getString(14);
			jinprice = rs3.getString(17);
			suprice = rs3.getString(18);
			joprice = rs3.getString(19);
			
		}
		ResultSet rs4 = st.executeQuery(sql4);
		if(rs4.next())
		{
			jumin1 = rs4.getString(1);
		}
		
		if(jinprice.equals("") || suprice.equals("") || joprice.equals(""))
		{
			out.println("<script>alert('처방되지 않은 환자입니다.');location.href='rsearch.jsp';</script>");
		}
		else
		{
			int com1 = Integer.parseInt(jinprice);
			int com2 = Integer.parseInt(suprice);
			int com3 = Integer.parseInt(joprice);
			result = com1 + com2 + com3;
		}
		
		rs1.close();
		rs2.close();
		rs3.close();
		rs4.close();
		st.close();
		conn.close();
		
	}
	
	if(pnum.equals("") && !name.equals(""))
	{
		out.println("<script>alert('등록되지 않은 환자이거나 중복되는 이름이 있을 수 있습니다.');location.href ='rsearch.jsp'</script>");
	}
	
	
	
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>약 빤 프로그램</title>
	<link href="css/rsearch.css" rel="stylesheet">
	<script>
	function rtext() { 
		//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
		
		//var pop_title = "popupOpener" ;
	    
	    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
	     
	    var frmData = document.input_form ;
	   	//frmData.target = pop_title ;
	    frmData.action = "rtext.jsp" ;
	     
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
				<div class ="toptext"><h4>진료 조회</h4></div>
			</div>	
		</div>
	</div>

<form method = "post" action = "rsearch.jsp" name = "input_form">
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
</form>


<div class = "tablerap">
        <table id = "container-table">
			<tr class = "col">
				<th colspan = 2>환&nbsp;자</th>
			</tr>
			<tr class = "col-sub">
				<td>환자번호</td>
				<td><input type = "hidden" value ='<%=pnumber%>' name = "pnumber" style="border: none; background: transparent;"><%=pnum%></td>
			</tr>
			<tr class = "col-sub">
				<td>이&nbsp;&nbsp;름</td>
				<td><input type = "hidden" value = '<%=pname %>' name = "pname" style="border: none; background: transparent;"><%=pname %></td>
			</tr>
			<tr class = "col-sub">
				<td>생년월일</td>
				<td><input type = "hidden" value ='<%=jumin1 %>' name = "jumin1" style="border: none; background: transparent;"><%=jumin1 %></td>
			</tr>
			<tr class = "col-sub">
				<td>핸드폰 번호</td>
				<td><input type = "hidden" value ='<%=phone %>' name = "phone" style="border: none; background: transparent;"><%=phone %></td>
			</tr>
			<tr class = "col-sub">
				<td>키(Cm)</td>
				<td><input type = "hidden" value = '<%=height %>' name = "height" style="border: none; background: transparent;"><%=height %></td>
			</tr>
			<tr class = "col-sub">
				<td>체&nbsp;&nbsp;중(Kg)</td>
				<td><input type = "hidden" value = '<%=weight %>' name = "weight" style="border: none; background: transparent;"><%=weight %></td>
			</tr>
	        <tr class = "col-sub">
	 			<td>혈액형</td>
				<td><input type = "hidden" value ='<%=blood %>' name = "blood" style="border: none; background: transparent;"><%=blood %></td>
			</tr>
		</table>

        <table id = "container-table2">
			<tr class = "col">
				<th colspan = 2>의사 및 간호사</th>
			</tr>
			<tr class = "col-sub">
				<td>의사 자격번호</td>
				<td><input type = "hidden" value = '<%=dnum1 %>' name = "dnum1" style="border: none; background: transparent;"><%=dnum1 %></td>
			</tr>
			<tr class = "col-sub">
				<td>담당의사</td>
				<td><input type = "hidden" value = '<%=dname1 %>' name = "dname1" style="border: none; background: transparent;"><%=dname1 %></td>
			</tr>
			<tr class = "col-sub">
				<td>간호사 자격번호</td>
				<td><input type = "hidden" value ='<%=dnum2 %>' name = "dnum2" style="border: none; background: transparent;"><%=dnum2 %></td>
			</tr>
			<tr class = "col-sub">
				<td>담당간호사</td>
				<td><input type = "hidden" value ='<%=dname2 %>' name = "dname2" style="border: none; background: transparent;"><%=dname2 %></td>
			</tr>
			<tr class = "col-sub">
				<td>혈&nbsp;&nbsp;압</td>
				<td><input type = "hidden" value ='<%=pressure %>' name = "pressure" style="border: none; background: transparent;"><%=pressure %></td>
			</tr>
			<tr class = "col-sub">
				<td>증&nbsp;&nbsp;상</td>
				<td><input type = "hidden" value ='<%=disease %>' name = "disease" style="border: none; background: transparent;"><%=disease %></td>
			</tr>
	        <tr class = "col-sub">
	 			<td>수술여부</td>
				<td><input type = "hidden" value = '<%=operation %>' name = "operation" style="border: none; background: transparent;"><%=operation %></td>
			</tr>
			<tr class = "col-sub">
	 			<td>진찰비용</td>
				<td><input type = "hidden" value ='<%=jinprice %>' name = "jinprice" style="border: none; background: transparent;"><%=jinprice+"원" %></td>
			</tr>
			<tr class = "col-sub">
	 			<td>수술비용</td>
				<td><input type = "hidden" value = '<%=suprice %>'name = "suprice" style="border: none; background: transparent;"><%=suprice+"원" %></td>
			</tr>
		</table>
		
		
		
</div>
<div class = "bottom">
<div class ="sign-nav">
				<div class = "sort">
				<h3>처방내용 : &nbsp</h3>
				</div>
				<div class = "sort2">
				<input id = "name-text"class = "text-box" type = "hidden" value ='<%=precont %>' name = "pnumber"><%=precont %>
				</div>
</div>

<div class ="sign-nav">
				<div class = "sort">
				<h3>총 금액 : &nbsp</h3>
				</div>
				<div class = "sort2">
				<input id = "name-text"class = "text-box" type = "hidden" value ='<%=result %>' name = "pnumber"><%=result + "원" %>
				</div>
</div>
</div>


<div id ="button-sort">
	<a class = "button-last" href="index.html">뒤로</a>
	<a class = "button-last" onclick = "rtext();">텍스트</a>
</div>




</div>
</body>
</html>