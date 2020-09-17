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
	String pnumber = request.getParameter("pnumber")==null?"":request.getParameter("pnumber");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	//String check = request.getParameter("check")==null?"":request.getParameter("check");
	
   String filePath = "";
   BufferedWriter bfw = null;
   File fp=new File("");
   int cnt=0;
   Statement st = conn.createStatement();
   ResultSet rs = null;
   String pnum ="", pname = "", jumin = "", phone ="", height ="", weight ="", blood ="";
   String sql ="";
   
   
   String fileName ="환자 목록 ("+ today.substring(0,12) +").txt"; //생성할 파일명
   String fileDir = "txt"; //파일을 생성할 디렉토리
   filePath = "C:\\work\\project\\DBproject\\" +fileDir+ "\\";  //파일을 생성할 전체경로
   filePath += fileName; //생성할 파일명을 전체경로에 결합
   try{
   fp = new File(filePath); // 파일객체생성
    //파일생성
   // 파일쓰기
   bfw = new BufferedWriter(new FileWriter(filePath,false));
  
   
   if(cnt==0){
	      bfw.write("환자번호");bfw.write("\t");
	      bfw.write("이름");bfw.write("\t\t");
	      bfw.write("주민번호");bfw.write("\t\t\t");
	      bfw.write("핸드폰번호");bfw.write("\t\t\t");
	      bfw.write("키(CM)");bfw.write("\t\t");
	      bfw.write("체중(KG)");bfw.write("\t\t");
	      bfw.write("혈액형");bfw.write("\t\t");
	      bfw.newLine();
	      cnt=1;
	   }
   
   if(pnumber.equals("") && name.equals(""))
   {
	   sql = "select pnum, name, jumin, phone, height, weight, blood from patient order by pnum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   pnum = rs.getString(1);
		   pname = rs.getString(2);
		   jumin = rs.getString(3);
		   phone = rs.getString(4);
		   height = rs.getString(5);
		   weight = rs.getString(6);
		   blood = rs.getString(7);
		   
		   
		   bfw.write(pnum);bfw.write("\t\t"); 
		   bfw.write(pname);bfw.write("\t\t");
		   bfw.write(jumin);bfw.write("\t\t");
		   bfw.write(phone);bfw.write("\t\t");
		   bfw.write(height);bfw.write("\t\t");
		   bfw.write(weight);bfw.write("\t\t\t"); 
		   bfw.write(blood);bfw.write("\t\t"); 
		   bfw.newLine();
		   
	   }
	   
	  
	   
   }
   
   if(!pnumber.equals("") && name.equals(""))
   {
	   sql = "select pnum, name, jumin, phone, height, weight, blood from patient where pnum = '" + pnumber + "' order by pnum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   pnum = rs.getString(1);
		   pname = rs.getString(2);
		   jumin = rs.getString(3);
		   phone = rs.getString(4);
		   height = rs.getString(5);
		   weight = rs.getString(6);
		   blood = rs.getString(7);
		   
		   bfw.write(pnum);bfw.write("\t\t"); 
		   bfw.write(pname);bfw.write("\t\t");
		   bfw.write(jumin);bfw.write("\t\t");
		   bfw.write(phone);bfw.write("\t\t");
		   bfw.write(height);bfw.write("\t\t");
		   bfw.write(weight);bfw.write("\t\t\t"); 
		   bfw.write(blood);bfw.write("\t\t"); 
		   bfw.newLine();
	   }
	   
	  
	   
   }
   if(pnumber.equals("") && !name.equals(""))
   {
	   sql = "select pnum, name, jumin, phone, height, weight, blood from patient where name = '" + name + "' order by pnum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   pnum = rs.getString(1);
		   pname = rs.getString(2);
		   jumin = rs.getString(3);
		   phone = rs.getString(4);
		   height = rs.getString(5);
		   weight = rs.getString(6);
		   blood = rs.getString(7);
		   
		   
		   bfw.write(pnum);bfw.write("\t\t"); 
		   bfw.write(pname);bfw.write("\t\t");
		   bfw.write(jumin);bfw.write("\t\t");
		   bfw.write(phone);bfw.write("\t\t");
		   bfw.write(height);bfw.write("\t\t");
		   bfw.write(weight);bfw.write("\t\t\t"); 
		   bfw.write(blood);bfw.write("\t\t"); 
		   bfw.newLine();
		   
	   }
	   
	  
	   
   }
   
   if(!pnumber.equals("") && !name.equals(""))
   {
	   sql = "select pnum, name, jumin, phone, height, weight, blood from patient where pnum = '" + pnumber + "' and  name = '" + name + "' order by pnum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   pnum = rs.getString(1);
		   pname = rs.getString(2);
		   jumin = rs.getString(3);
		   phone = rs.getString(4);
		   height = rs.getString(5);
		   weight = rs.getString(6);
		   blood = rs.getString(7);
		   
		   bfw.write(pnum);bfw.write("\t\t"); 
		   bfw.write(pname);bfw.write("\t\t");
		   bfw.write(jumin);bfw.write("\t\t");
		   bfw.write(phone);bfw.write("\t\t");
		   bfw.write(height);bfw.write("\t\t");
		   bfw.write(weight);bfw.write("\t\t\t"); 
		   bfw.write(blood);bfw.write("\t\t"); 
		   bfw.newLine();
	   }
	   
	   
	   
   }
   
  

   bfw.newLine();
   bfw.close();
   
   // 파일읽기
   FileReader fr = new FileReader(filePath); //파일읽기객체생성
   BufferedReader br = new BufferedReader(fr); //버퍼리더객체생성
   String line = null; 
   while((line=br.readLine())!=null){ //라인단위 읽기
      
   }
   
   }catch (IOException ee) { 
     System.out.println(ee.toString()); //에러 발생시 메시지 출력
   }
      
     
   fp.createNewFile();
   rs.close();
   st.close();
   conn.close();
  
     
	
%>


<script>
self.window.alert("txt 파일 생성 완료!");
location.href = "psearch.jsp";
</script>