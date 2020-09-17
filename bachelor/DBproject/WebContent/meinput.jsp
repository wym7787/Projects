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

String sql1 = "update patient set dnum1 = ?, dnum2 = ? where pnum = ?";
String sql3 = "update patient set pressure = ?, disease = ?, operation = ? where pnum = ?";
String sql4 = "insert into medicine (pnum,jinprice,suprice) values(?,?,?)";
String sql5 = "update medicine set pnum = ?, jinprice = ?, suprice =? where pnum = ?";

String pnum = request.getParameter("patient"); // 환자
String dnum1 = request.getParameter("dnum1"); // 의사
String dnum2 = request.getParameter("dnum2"); // 간호사
String pressure = request.getParameter("pressure");
String disease = request.getParameter("disease"); 
String operation = request.getParameter("operation"); // 혈압, 증상, 수술여부
String jinprice = request.getParameter("jinprice");
String suprice = request.getParameter("suprice");

Statement st = conn.createStatement();
String check = "select * from medicine where pnum = '" + pnum +"'";
ResultSet chk = st.executeQuery(check);


if(dnum1.equals("") || dnum2.equals("") || pressure.equals("") || disease.equals("") || operation.equals("") || jinprice.equals("") || suprice.equals(""))
{
	out.println("<script>alert('빈 칸을 입력하세요.'); history.back();</script>");
}

else
{
	

PreparedStatement pstmt1 = conn.prepareStatement(sql1);;
PreparedStatement pstmt3 = conn.prepareStatement(sql3);
PreparedStatement pstmt4 = conn.prepareStatement(sql4);
PreparedStatement pstmt5 = conn.prepareStatement(sql5);


pstmt1.setString(1, dnum1);
pstmt1.setString(2, dnum2);
pstmt1.setString(3,pnum);
pstmt1.executeUpdate();      //환자 의료진 연결


//증상 patient 업데이트
pstmt3.setString(1,pressure);
pstmt3.setString(2,disease);
pstmt3.setString(3,operation);
pstmt3.setString(4,pnum);
pstmt3.executeUpdate();


if(!chk.next())
{
	pstmt4.setString(1,pnum);
	pstmt4.setString(2,jinprice);
	pstmt4.setString(3,suprice);
	pstmt4.executeUpdate();
	pstmt1.close();
	pstmt3.close();
	pstmt4.close();
	pstmt5.close();

	conn.close();
	out.println("<script>alert('등록 완료되었습니다.');history.back();</script>");
}
else
{

	pstmt5.setString(1,pnum);
	pstmt5.setString(2,jinprice);
	pstmt5.setString(3, suprice);
	pstmt5.setString(4,pnum);
	pstmt5.executeUpdate();
	pstmt1.close();
	pstmt3.close();
	pstmt4.close();
	pstmt5.close();

	conn.close();
	out.println("<script>alert('등록 완료되었습니다.');history.back();</script>");
}


}

%>
