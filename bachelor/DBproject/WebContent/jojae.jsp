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
	Statement st = null;
	
	
	
	int tot = 0;
	int imsi = 0;
	String sql = "";
	
	
	String pnum = (String) session.getAttribute("patient");
	
	String check = "select * from medicine where pnum = '" + pnum +"'";
	Statement st1 = conn.createStatement();
	ResultSet rschk = st1.executeQuery(check);
	
	if(!rschk.next())
	{
		out.println("<script>alert('의료진을 먼저 입력하세요.');close();</script>");
	}
	String [] arr = request.getParameterValues("medicine");
	String tday = request.getParameter("choice")==null?"":request.getParameter("choice");
	String [] tcount = request.getParameterValues("day");
	
	String tday2 = tday + "일"; // 투약 일 수
	String precont = ""; //투약 내용
	String tcount2 = ""; // 투약 횟수
	if(arr == null || tcount == null)
	{
		
	}
	
	else
	{
		
		//계산
			for(int i = 0 ; i < arr.length ; i++)
			{
				st = conn.createStatement();
				sql = "select * from price where name = '" + arr[i] + "'";
				ResultSet rs = st.executeQuery(sql);
				
				if(rs.next())
				{
					imsi = rs.getInt("won");
					tot += imsi;
					
					
				}
				if(i < arr.length - 1)
				{
					precont += arr[i] + ", ";
				}
				else
					precont += arr[i];
				
			
			}
		
			for(int j = 0 ; j < tcount.length; j++)
			{
				if(j < tcount.length - 1)
				{
					tcount2 += tcount[j] + ", ";
				}
				else
					tcount2 += tcount[j];
			}
		
		
		
		
		String sql2 ="";
		int gasan = Integer.parseInt(tday); // 일 수 곱하기
		int result = tot * gasan;
		
		String joprice = String.valueOf(result);
		sql2 = "update medicine set precont =?, tday = ?, tcount =?, joprice = ? where pnum = ?";
		
		PreparedStatement pstmt = conn.prepareStatement(sql2);
		pstmt.setString(1,precont);
		pstmt.setString(2,tday2);
		pstmt.setString(3,tcount2);
		pstmt.setString(4,joprice);
		pstmt.setString(5,pnum);
		
		
		String answer1 = "처방  내역 : " + precont +"\\n";
		String answer2 = "투약 일 수 : " + tday2 +"\\n";
		String answer3 = "투약 횟 수 : " + tcount2+"\\n";
		String answer4 = "가        격 : " + result + " 원";
		
		
		pstmt.executeUpdate();
		pstmt.close();
		rschk.close();
		st.close();
		st1.close();
		conn.close();
		session.setAttribute("patient",null);
		pnum = null;
		out.println("<script>alert('" + answer1 + answer2 + answer3 + answer4 + "'); close();</script>");
		
		
		
	}
	
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta charset="utf-8">
	<title>약 빤 프로그램</title>
	<link href="css/medicine.css" rel="stylesheet">
	<script>
	function fail() { 
		//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
		
		//var pop_title = "popupOpener" ;
	    
	    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
	     
	    close();
	}
	function jojae() { 
		//window.open("update1.jsp", "a", "width=400, height=500, left=550, top=0"); 
		
		//var pop_title = "popupOpener" ;
	    
	    //window.open("", pop_title, "width=400, height=500, left=550, top=0");
	     
	    var frmData = document.input_form ;
	   	//frmData.target = pop_title ;
	    frmData.action = "jojae.jsp" ;
	     
	    frmData.submit() ;
		}
	
	</script>
</head>
<body>
<form name="input_form" method="post">
	
	<div class ="mid-content">
		<h1 align=center><i> 환자의 병명에 맞는 약을 처방해주세요</i></h1>
		
	    <div class="midrap">
			<fieldset><legend><b>약의 종류</b></legend>
			<table border="0" width="100%" cellpadding="5%">
				<tr>
					<td><input type="checkbox" name="medicine" value="디스텍정">디스텍정</td>
					<td><input type="checkbox" name="medicine" value="로바펜정">로바펜정</td>
					<td><input type="checkbox" name="medicine" value="뮤코라정">뮤코라정</td>
					<td><input type="checkbox" name="medicine" value="미오날정">미오날정</td>
					<td><input type="checkbox" name="medicine" value="바메딘정">바메딘정</td>
					<td><input type="checkbox" name="medicine" value="베포린정">베포린정</td>
					<td><input type="checkbox" name="medicine" value="베포탄정">베포탄정</td>
					<td><input type="checkbox" name="medicine" value="세카론정">세카론정</td>
					<td><input type="checkbox" name="medicine" value="소론도정">소론도정</td>
					<td><input type="checkbox" name="medicine" value="스토가정">스토가정</td>
				</tr>
				<tr>
					<td><input type="checkbox" name="medicine" value="스티렌정">스티렌정</td>
					<td><input type="checkbox" name="medicine" value="알비스정">알비스정</td>
					<td><input type="checkbox" name="medicine" value="에어탈정">에어탈정</td>
					<td><input type="checkbox" name="medicine" value="코대원정">코대원정</td>
					<td><input type="checkbox" name="medicine" value="코데농정">코데농정</td>
					<td><input type="checkbox" name="medicine" value="티리온정">타리온정</td>
					<td><input type="checkbox" name="medicine" value="펜세타정">펜세타정</td>
					<td><input type="checkbox" name="medicine" value="펠루비정">펠루비정</td>
					<td><input type="checkbox" name="medicine" value="푸리콩정">푸라콩정</td>
					<td><input type="checkbox" name="medicine" value="헤라신정">헤라신정</td>
				</tr>
			</table></fieldset>
		</div>

		<div class="midsoft">
			<table border="0" width="100%" cellpadding="10%" cellspacing="15%" align="center">
				<tr>
					<td>
						<fieldset style="width:100%;"><legend><b>투여일수</b></legend>
							<select id="choice" name="choice">
								<option value="1">1일</option>
								<option value="2">2일</option> 
								<option value="3">3일</option>
								<option value="4">4일</option>
								<option value="5">5일</option>
								<option value="6">6일</option>
								<option value="7">7일</option>
								<option value="8">8일</option>
								<option value="9">9일</option>
								<option value="10">10일</option>
								<option value="11">11일</option>
								<option value="12">12일</option>
								<option value="13">13일</option>
								<option value="14">14일</option>
								<option value="15">15일</option>
								<option value="16">16일</option>
								<option value="17">17일</option>
								<option value="18">18일</option>
								<option value="19">19일</option>
								<option value="20">20일</option>
								<option value="21">21일</option>
								<option value="22">22일</option>
								<option value="23">23일</option>
								<option value="24">24일</option>
								<option value="25">25일</option>
								<option value="26">26일</option>
								<option value="27">27일</option>
								<option value="28">28일</option>
								<option value="29">29일</option>
								<option value="30">30일</option>
								<option value="31">31일</option>
							</select>
						</fieldset>
					</td>

					<td>
						<fieldset style="width:100%;"><legend><b>투여횟수</b></legend>
							<table border="0" width="100%" cellpadding="20%">
								<td><input type="checkbox" name="day" value="아침">아침</td>
								<td><input type="checkbox" name="day" value="점심">점심</td>
								<td><input type="checkbox" name="day" value="저녁">저녁</td>
							</table>
						</fieldset>
					</td>

					<td>
						<span style="margin: 2px">
							<a id="button-reset"  onclick = "jojae();">계산</a>
							<a id="button-reset"  onclick = "fail();">취소</a>
						</span>
					</td>
				</tr>
			</table>

		</div>
    </div>
    </form>
</body>
</html>