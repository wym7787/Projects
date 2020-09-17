<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ page import = "java.sql.*" %>
<%@ page import = "java.io.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>

<%

	java.text.SimpleDateFormat formatter = new java.text.SimpleDateFormat("yyyyMMddHHmmss");
	String today = formatter.format(new java.util.Date());
	
	Class.forName("oracle.jdbc.driver.OracleDriver"); 
	String user = "hospital"; 
	String pw = "1234";
	String url = "jdbc:oracle:thin:@localhost:1521:DBSERVER";
	Connection conn = DriverManager.getConnection(url, user, pw);
	String pnum = (String) session.getAttribute("patient");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	Statement st = conn.createStatement();
	
   String filePath = "";
   BufferedWriter bfw = null;
   File fp=new File("");
   int cnt=0;
   ResultSet rs = null;
  
   String sql ="";
   
   
   String fileName ="진료 조회 결과 입니다. ("+ today.substring(0,12) +").txt"; //생성할 파일명
   String fileDir = "txt"; //파일을 생성할 디렉토리
   filePath = "C:\\work\\project\\DBproject\\" +fileDir+ "\\";  //파일을 생성할 전체경로
   filePath += fileName; //생성할 파일명을 전체경로에 결합
   try{
   fp = new File(filePath); // 파일객체생성
    //파일생성
   // 파일쓰기
   bfw = new BufferedWriter(new FileWriter(filePath,false));
  
   
  
   
   
	
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
		out.println("<script>alert('정보를 입력하세요.');location.href='rsearch.jsp';</script>");
		session.setAttribute("patient",null);
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
			session.setAttribute("patient",null);
		}
		else
		{
			int com1 = Integer.parseInt(jinprice);
			int com2 = Integer.parseInt(suprice);
			int com3 = Integer.parseInt(joprice);
			result = com1 + com2 + com3;
		}
		
		
		bfw.write("--- 환자 정보 입니다. ---");bfw.newLine();
		bfw.write("환자 번호 : " + pnumber);bfw.newLine(); 
		bfw.write("환자 이름 : " + pname);bfw.newLine();
		bfw.write("생년월일  : " + jumin1);bfw.newLine();;
		bfw.write("핸드폰 번호 : " + phone);bfw.newLine();
		bfw.write("키 : " + height);bfw.newLine();
		bfw.write("체중  : " + weight);bfw.newLine();
		bfw.write("혈액형  : " + blood);bfw.newLine();bfw.newLine();
		bfw.write("--- 의료진 정보 입니다 ---");bfw.newLine();
		bfw.write("의사 자격번호  : " + dnum1);bfw.newLine();
		bfw.write("담당 의사  : " + dname1);bfw.newLine();
		bfw.write("간호사 자격번호  : " + dnum2);bfw.newLine();
		bfw.write("담당 간호사 : " + dname2);bfw.newLine();
		bfw.write("혈 압  : " + pressure);bfw.newLine();
		bfw.write("증 상  : " + disease);bfw.newLine();
		bfw.write("수술 여부  : " + operation);bfw.newLine();
		bfw.write("진찰 비용  : " + jinprice + "원");bfw.newLine();
		bfw.write("수술 비용  : " + suprice + "원");bfw.newLine();
		bfw.write("처방 내용  : " + precont);bfw.newLine();
		bfw.write("총 금액  : " + result + "원");bfw.newLine();
		
		
		session.setAttribute("patient",null);
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
			session.setAttribute("patient",null);
		}
		else
		{
			int com1 = Integer.parseInt(jinprice);
			int com2 = Integer.parseInt(suprice);
			int com3 = Integer.parseInt(joprice);
			result = com1 + com2 + com3;
		}
		
		bfw.write("--- 환자 정보 입니다. ---");bfw.newLine();
		bfw.write("환자 번호 : " + pnumber);bfw.newLine(); 
		bfw.write("환자 이름 : " + pname);bfw.newLine();
		bfw.write("생년월일  : " + jumin1);bfw.newLine();;
		bfw.write("핸드폰 번호 : " + phone);bfw.newLine();
		bfw.write("키 : " + height);bfw.newLine();
		bfw.write("체중  : " + weight);bfw.newLine();
		bfw.write("혈액형  : " + blood);bfw.newLine();bfw.newLine();
		bfw.write("--- 의료진 정보 입니다 ---");bfw.newLine();
		bfw.write("의사 자격번호  : " + dnum1);bfw.newLine();
		bfw.write("담당 의사  : " + dname1);bfw.newLine();
		bfw.write("간호사 자격번호  : " + dnum2);bfw.newLine();
		bfw.write("담당 간호사 : " + dname2);bfw.newLine();
		bfw.write("혈 압  : " + pressure);bfw.newLine();
		bfw.write("증 상  : " + disease);bfw.newLine();
		bfw.write("수술 여부  : " + operation);bfw.newLine();
		bfw.write("진찰 비용  : " + jinprice +"원");bfw.newLine();
		bfw.write("수술 비용  : " + suprice +"원");bfw.newLine();
		bfw.write("처방 내용  : " + precont);bfw.newLine();
		bfw.write("총 금액  : " + result + "원");bfw.newLine();
		
		
		session.setAttribute("patient",null);
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
		session.setAttribute("patient",null);
	}
	
	
	   bfw.newLine();
	   bfw.close();
	   
	   // 파일읽기
	   FileReader fr = new FileReader(filePath); //파일읽기객체생성
	   BufferedReader br = new BufferedReader(fr); //버퍼리더객체생성
	   String line = null; 
	   while((line=br.readLine())!=null){ //라인단위 읽기
	     
	   }
   }
   
	catch (IOException ee) { 
    System.out.println(ee.toString()); //에러 발생시 메시지 출력
  }
   session.setAttribute("patient",null);	   
%>

<script>
self.window.alert("txt 파일 생성 완료!");
location.href = "rsearch.jsp";
</script>