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
	String certinum = request.getParameter("certinum")==null?"":request.getParameter("certinum");
	String name = request.getParameter("name")==null?"":request.getParameter("name");
	String job = request.getParameter("job")==null?"":request.getParameter("job");
	
   String filePath = "";
   BufferedWriter bfw = null;
   File fp=new File("");
   int cnt=0;
   Statement st = conn.createStatement();
   ResultSet rs = null;
   String dnum ="", dname = "", djob = "", certiday= "", jinryo = "";
   String sql ="";
   
   
   String fileName ="의료진 목록 ("+ today.substring(0,12) +").txt"; //생성할 파일명
   String fileDir = "txt"; //파일을 생성할 디렉토리
   filePath = "C:\\work\\project\\DBproject\\" +fileDir+ "\\";  //파일을 생성할 전체경로
   filePath += fileName; //생성할 파일명을 전체경로에 결합
   try{
   fp = new File(filePath); // 파일객체생성
    //파일생성
   // 파일쓰기
   bfw = new BufferedWriter(new FileWriter(filePath,false));
  
   
   if(cnt==0){
	      bfw.write("자격증번호");bfw.write("\t");
	      bfw.write("이   름");bfw.write("\t\t");
	      bfw.write("직   업");bfw.write("\t\t\t");
	      bfw.write("자격증 취득일");bfw.write("\t\t\t");
	      bfw.write("진료과");bfw.write("\t\t");
	      bfw.newLine();
	      cnt=1;
	   }
   
   
  
   if(certinum.equals("") && name.equals("") && job.equals(""))
   {
	   sql = "select * from doctor order by 1";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
		   bfw.newLine();
	   }
   }
   
   if(!certinum.equals("") && name.equals("") && job.equals(""))
   {
	   sql = "select * from doctor where certinum = '" + certinum +"' order by certinum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
		   bfw.newLine();
	   }
   }
   
   if(!certinum.equals("") && !name.equals("") && job.equals(""))
   {
	   sql = "select * from doctor where certinum = '" + certinum +"' and name = '" + name + "' order by certinum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
		   bfw.newLine();
	   }
   }
   
   if(!certinum.equals("") && name.equals("") && !job.equals(""))
   {
	   sql = "select * from doctor where certinum = '" + certinum +"' and job = '" + job +"' order by certinum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
		   bfw.newLine();
	   }
   }
   
  
   
   if(certinum.equals("") && !name.equals("") && job.equals(""))
   {
	   sql = "select * from doctor where name = '" + name +"' order by certinum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
		   bfw.newLine();
	   }
   }
   
   if(certinum.equals("") && !name.equals("") && !job.equals(""))
   {
	   sql = "select * from doctor where name = '" + name +"' and job = '" + job +"' order by certinum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
		   bfw.newLine();
	   }
   }
   
   if(certinum.equals("") && name.equals("") && !job.equals(""))
   {
	   sql = "select * from doctor where job = '" + job + "' order by certinum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
		   bfw.newLine();
	   }
   }
   
   
   
   if(!certinum.equals("") && !name.equals("") && !job.equals(""))
   {
	   sql = "select * from doctor where certinum = '" + certinum + "' and name = '" + name + "' and job = '" + job + "' order by certinum";
	   rs = st.executeQuery(sql);
	   
	   while(rs.next())
	   {
		   dnum = rs.getString(1);
		   dname = rs.getString(2);
		   djob = rs.getString(3);
		   certiday = rs.getString(4);
		   jinryo = rs.getString(5);
		   
		   bfw.write(dnum);bfw.write("\t\t"); 
		   bfw.write(dname);bfw.write("\t\t");
		   bfw.write(djob);bfw.write("\t\t\t");
		   bfw.write(certiday);bfw.write("\t\t\t");
		   bfw.write(jinryo);bfw.write("\t\t");
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
location.href = "dsearch.jsp";
</script>