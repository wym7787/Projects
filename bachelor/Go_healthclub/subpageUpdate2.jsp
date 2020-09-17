<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import = "java.sql.*" %>
<%@ page import = "java.text.SimpleDateFormat" %>
<%@ page import = "java.util.Date" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="java.util.*" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<center>
<%

String r1="",r2="",r3="",r4="",r5="",p1="",p2="";
byte[] boardImage1 = null, boardImage2 = null, boardImage3 = null, boardImage4 = null, boardImage5 = null;

Class.forName("com.mysql.jdbc.Driver").newInstance(); // newInstance() 생략 가능
Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/wym7787","wym7787", "dnjs5258!@");
/*
Statement st = con.createStatement();
String sql = "insert into board values('";
sql += request.getParameter("id") + "','";
sql += request.getParameter("content") + "','";
sql += (new SimpleDateFormat("yyyy-MM-dd")).format(new Date()) + "');";
*/
Statement st = con.createStatement();
ResultSet rs = st.executeQuery("select * from subpage");
boolean choice;
choice = rs.next();

ServletFileUpload sfu = new ServletFileUpload(new DiskFileItemFactory());
sfu.setSizeMax(64 * 1024 * 1024);
sfu.setHeaderEncoding("UTF-8"); 

List items = sfu.parseRequest(request);
Iterator iter = items.iterator();


while(iter.hasNext()) {

   FileItem item = (FileItem) iter.next();
   if (!item.isFormField()) {
      if(item.getFieldName().equals("img1"))
      {
         if(item.getString().equals(""))
         {
            if(choice)
            {
               boardImage1 = rs.getBytes("no1");
            }
            else
            {
               boardImage1 = item.get();
            }
         }
         else
         {
            boardImage1 = item.get();
         }
      }
      else if(item.getFieldName().equals("img2"))
      {
         if(item.getString().equals(""))
         {
            if(choice)
            {
               boardImage2 = rs.getBytes("no2");
            }
            else
            {
               boardImage2 = item.get();
            }
         }
         else
         {
            boardImage2 = item.get();
         }
      }
      else if(item.getFieldName().equals("img3"))
      {
         if(item.getString().equals(""))
         {
            if(choice)
            {
               boardImage3 = rs.getBytes("no3");
            }
            else
            {
               boardImage3 = item.get();
            }
         }
         else
         {
            boardImage3 = item.get();
         }
      }
      else if(item.getFieldName().equals("img4"))
      {
         if(item.getString().equals(""))
         {
            if(choice)
            {
               boardImage4 = rs.getBytes("no4");
            }
            else
            {
               boardImage4 = item.get();
            }
         }
         else
         {
            boardImage4 = item.get();
         }
      }
      else if(item.getFieldName().equals("img5"))
      {
         if(item.getString().equals(""))
         {
            if(choice)
            {
               boardImage5 = rs.getBytes("no5");
            }
            else
            {
               boardImage5 = item.get();
            }
         }
         else
         {
            boardImage5 = item.get();
         }
      }
   }
   else {
      if(item.getFieldName().equals("program1"))
      {
         if(item.getString().equals(""))
         {
            if(choice)
            {
               p1 = rs.getString("program");
            }
            else
            {
               p1 = item.getString("UTF-8");      
            }
         }
         else
         {
            p1 = item.getString("UTF-8");
         }
      }
      else if(item.getFieldName().equals("program2"))
      {
         if(item.getString().equals(""))
         {
            if(choice)
            {
               p2 = rs.getString("muchine");
            }
            else
            {
               p2 = item.getString("UTF-8");
            }
         }
         else
         {
            p2 = item.getString("UTF-8");
         }
      }
      else if(item.getFieldName().equals("receive1"))
      {
            r1 = item.getString("UTF-8");
      }
      else if(item.getFieldName().equals("receive2"))
      {
            r2 = item.getString("UTF-8");
      }
      else if(item.getFieldName().equals("receive3"))
      {
            r3 = item.getString("UTF-8");
      }
      else if(item.getFieldName().equals("receive4"))
      {
            r4 = item.getString("UTF-8");
      }
      else if(item.getFieldName().equals("receive5"))
      {
            r5 = item.getString("UTF-8");
      }
   }
   out.println("<br>");
}



   
   st.executeUpdate("delete from subpage");
   PreparedStatement pstmt = con.prepareStatement("insert into subpage values(?,?,?,?,?,?,?,?,?,?,?,?)");
   pstmt.setString(1, p1);
   pstmt.setString(2, p2);
   pstmt.setString(3, r1);
   pstmt.setString(4, r2);
   pstmt.setString(5, r3);
   pstmt.setString(6, r4);
   pstmt.setString(7, r5);
   pstmt.setBytes(8, boardImage1);
   pstmt.setBytes(9, boardImage2);
   pstmt.setBytes(10, boardImage3);
   pstmt.setBytes(11, boardImage4);
   pstmt.setBytes(12, boardImage5);
   int count = pstmt.executeUpdate();
   if(count > 0)
      response.sendRedirect("subpage.jsp");
   else
      out.println("<script> alert('요청하신 작업이 처리되지 않았습니다.'); history.back();</script>");

   
   st.close();
   rs.close();
   pstmt.close();
   con.close();
%>

</center>
</body>
</html>