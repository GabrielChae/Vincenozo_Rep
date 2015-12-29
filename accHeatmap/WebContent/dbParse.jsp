<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"

   import="java.sql.*"
   
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>데이터 목록</title>
</head>
<body>
<%
   Connection conn = null;                                        // null로 초기화 한다.
   Statement stmt = null;
   ResultSet rs = null;

   try {
      Class.forName("org.postgresql.Driver");                       // 데이터베이스와 연동하기 위해 DriverManager에 등록한다.
      String url = "jdbc:postgresql://127.0.0.1:5432/RobotDB";        // 사용하려는 데이터베이스명을 포함한 URL 기술
      String id = "postgres";                                                    // 사용자 계정
      String pw = "postgres";                                                // 사용자 계정의 패스워드
      conn=DriverManager.getConnection(url,id,pw);              // DriverManager 객체로부터 Connection 객체를 얻어온다.

      stmt = conn.createStatement();
      String query = "select x, y, nalja, sigan from accident";
      rs = stmt.executeQuery(query);
   } catch(Exception e){                                                    // 예외가 발생하면 예외 상황을 처리한다.
      e.printStackTrace();
   }
%>

<table border="1" cellspacing="0">
   <tr>
      <td> x </td>
      <td> y </td>
      <td> nalja </td>
      <td> sigan </td>
   </tr>

   <% while(rs.next()) { %>

   <tr>
      <td> <%=rs.getFloat("x") %></td>
      <td> <%=rs.getFloat("y") %></td>
      <td> <%=rs.getString("nalja") %></td>
      <td> <%=rs.getString("sigan") %></td>
   </tr>

<% } %>

</table>

<%
   rs.close();
   stmt.close();
   conn.close();
%>

</body>
</html>