<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"

   import="java.sql.*"
   
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>������ ���</title>
</head>
<body>
<%
   Connection conn = null;                                        // null�� �ʱ�ȭ �Ѵ�.
   Statement stmt = null;
   ResultSet rs = null;

   try {
      Class.forName("org.postgresql.Driver");                       // �����ͺ��̽��� �����ϱ� ���� DriverManager�� ����Ѵ�.
      String url = "jdbc:postgresql://127.0.0.1:5432/RobotDB";        // ����Ϸ��� �����ͺ��̽����� ������ URL ���
      String id = "postgres";                                                    // ����� ����
      String pw = "postgres";                                                // ����� ������ �н�����
      conn=DriverManager.getConnection(url,id,pw);              // DriverManager ��ü�κ��� Connection ��ü�� ���´�.

      stmt = conn.createStatement();
      String query = "select x, y, nalja, sigan from accident";
      rs = stmt.executeQuery(query);
   } catch(Exception e){                                                    // ���ܰ� �߻��ϸ� ���� ��Ȳ�� ó���Ѵ�.
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