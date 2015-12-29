<%@ page language="java" contentType="text/html; charset=EUC-KR"
   pageEncoding="EUC-KR"

   import="java.sql.*"
   import="java.util.*, java.text.*"
   
%>
<%
	   Connection conn = null;                                        // null로 초기화 한다.
	   Statement stmt = null;
	   ResultSet rs = null;
%>

<%
 java.text.SimpleDateFormat formatter1 = new java.text.SimpleDateFormat("yyyy");
 String year = formatter1.format(new java.util.Date());
 out.println(year);
 
 java.text.SimpleDateFormat formatter2 = new java.text.SimpleDateFormat("MM");
 String month = formatter2.format(new java.util.Date());
 out.println(month);
 
 java.text.SimpleDateFormat formatter3 = new java.text.SimpleDateFormat("dd");
 String date = formatter3.format(new java.util.Date());
 out.println(date);
%>
 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
  <meta charset="utf-8">
      <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
	  <script src="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
<link rel="stylesheet" type="text/css" href="Main_css.css">
<title>교통사고 HeatMap</title>
</head>
<body>
    <div id="container">
		<div id="map"></div>
		<div id="menu">
		<br><label>기간 선택</label><br>
 			<button type="button" class="btn" onclick="dateSearch()">&nbsp&nbsp&nbsp일 &nbsp&nbsp간&nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn">&nbsp&nbsp&nbsp주 &nbsp&nbsp간&nbsp&nbsp&nbsp</button><br><br>
 			<button type="button" class="btn" onclick="monthSearch()">&nbsp&nbsp&nbsp월 &nbsp&nbsp간&nbsp&nbsp&nbsp</button>
  			<button type="button" class="btn" onclick="yearSearch()">&nbsp&nbsp&nbsp연 &nbsp&nbsp간&nbsp&nbsp&nbsp</button><br><br>		
		<label>지역 선택</label><br>
 			<button type="button" class="btn" onclick="seoulMove()">&nbsp&nbsp&nbsp서 &nbsp&nbsp울 &nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="seongnamMove()">&nbsp&nbsp&nbsp성 &nbsp&nbsp남 &nbsp&nbsp&nbsp</button><br><br>
 			<button type="button" class="btn" onclick="busanMove()">&nbsp&nbsp&nbsp부 &nbsp&nbsp산 &nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="daeguMove()">&nbsp&nbsp&nbsp대 &nbsp&nbsp구 &nbsp&nbsp&nbsp</button><br><br>
 			<button type="button" class="btn" onclick="daechunMove()">&nbsp&nbsp&nbsp대 &nbsp&nbsp전 &nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="gwangjuMove()">&nbsp&nbsp&nbsp광 &nbsp&nbsp주 &nbsp&nbsp&nbsp</button><br><br>		
 			<button type="button" class="btn" onclick="ulsanMove()">&nbsp&nbsp&nbsp울 &nbsp&nbsp산 &nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="chunanMove()">&nbsp&nbsp&nbsp천 &nbsp&nbsp안 &nbsp&nbsp&nbsp</button><br><br>		
 			<button type="button" class="btn" onclick="chungjuMove()">&nbsp&nbsp&nbsp청 &nbsp&nbsp주 &nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="suwonMove()">&nbsp&nbsp&nbsp수 &nbsp&nbsp원 &nbsp&nbsp&nbsp</button><br><br>		
 			<button type="button" class="btn" onclick="jeonjuMove()">&nbsp&nbsp&nbsp전 &nbsp&nbsp주 &nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="buchunMove()">&nbsp&nbsp&nbsp부 &nbsp&nbsp천 &nbsp&nbsp&nbsp</button><br><br>		
 			<button type="button" class="btn" onclick="pohangMove()">&nbsp&nbsp&nbsp포 &nbsp&nbsp항 &nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="jejuMove()">&nbsp&nbsp&nbsp제 &nbsp&nbsp주 &nbsp&nbsp&nbsp</button><br><br>
		<label>히트맵 on/off</label><br>
 			<button type="button" class="btn" onclick="heatmapOn()">&nbsp&nbsp&nbsp&nbspo &nbsp&nbsp&nbsp&nbspn&nbsp&nbsp&nbsp&nbsp</button>
 			<button type="button" class="btn" onclick="heatmapOff()">&nbsp&nbsp&nbsp&nbsp&nbspo&nbsp f&nbsp&nbspf&nbsp&nbsp&nbsp&nbsp&nbsp</button><br><br>
 		<label>새로고침 / 종료</label><br>
 			<button type="button" class="btn" onclick="refreshMap()">새 로 고 침</button>
 			<button type="button" class="btn" onclick="browserExit()">&nbsp&nbsp&nbsp종&nbsp&nbsp&nbsp&nbsp료&nbsp&nbsp&nbsp</button><br><br>				
		</div>
	</div>
    <script>

var map, heatmap;
var arrayPoint= [];

function initMap() {
  map = new google.maps.Map(document.getElementById('map'), {
    zoom: 13,
    center: new google.maps.LatLng(37.5249754,126.9782639),
  });
}

function heatmapOn() {
	  heatmap.setMap(map);
	}

	function heatmapOff() {
		  heatmap.setMap(null);
	}

function dateSearch() {
	var x;
	var y;
	var nalja;
	var sigan;
	
	<%
	   try {
	      Class.forName("org.postgresql.Driver");                       // 데이터베이스와 연동하기 위해 DriverManager에 등록한다.
	      String url = "jdbc:postgresql://127.0.0.1:5432/RobotDB";        // 사용하려는 데이터베이스명을 포함한 URL 기술
	      String id = "postgres";                                                    // 사용자 계정
	      String pw = "postgres";                                                // 사용자 계정의 패스워드
	      conn=DriverManager.getConnection(url,id,pw);              // DriverManager 객체로부터 Connection 객체를 얻어온다.

	      stmt = conn.createStatement();
	      String query = "select x, y, nalja, sigan from accident where nalja like " +"'" + year + month + date + "%" + "'"; 
	      rs = stmt.executeQuery(query);
	   } catch(Exception e){                                                    // 예외가 발생하면 예외 상황을 처리한다.
	      e.printStackTrace();
	   }
	    while(rs.next()) { %>
	    	var	x=<%=rs.getFloat("y") %>;
	    	var y=<%=rs.getFloat("x") %>;
	    	//x=37.782551;
	    	//y=-122.445368;
	    	console.log(x + "," + y);
	    	arrayPoint.push(new google.maps.LatLng(x, y));

		<% } %>
		  heatmap = new google.maps.visualization.HeatmapLayer({
			    data: arrayPoint,
			    map: map
			  });
}	

function monthSearch() {
	var x;
	var y;
	var nalja;
	var sigan;
	
	<%
	   try {
	      Class.forName("org.postgresql.Driver");
	      String url = "jdbc:postgresql://127.0.0.1:5432/RobotDB";
	      String id = "postgres";
	      String pw = "postgres";
	      conn=DriverManager.getConnection(url,id,pw);

	      stmt = conn.createStatement();
	      String query = "select x, y, nalja, sigan from accident where nalja like " +"'" + year + month + "%" + "'"; 
	      rs = stmt.executeQuery(query);
	   } catch(Exception e){
	      e.printStackTrace();
	   }
	    while(rs.next()) { %>
	    	var	x=<%=rs.getFloat("y") %>;
	    	var y=<%=rs.getFloat("x") %>;
	    	console.log(x + "," + y);
	    	arrayPoint.push(new google.maps.LatLng(x, y));

		<% } %>
		  heatmap = new google.maps.visualization.HeatmapLayer({
			    data: arrayPoint,
			    map: map
			  });
}

function yearSearch() {
	var x;
	var y;
	var nalja;
	var sigan;
	
	<%
	   try {
	      Class.forName("org.postgresql.Driver");
	      String url = "jdbc:postgresql://127.0.0.1:5432/RobotDB";
	      String id = "postgres";
	      String pw = "postgres";
	      conn=DriverManager.getConnection(url,id,pw);

	      stmt = conn.createStatement();
	      String query = "select x, y, nalja, sigan from accident where nalja like " +"'" + year + "%" + "'"; 
	      rs = stmt.executeQuery(query);
	   } catch(Exception e){
	      e.printStackTrace();
	   }
	    while(rs.next()) { %>
	    	var	x=<%=rs.getFloat("y") %>;
	    	var y=<%=rs.getFloat("x") %>;
	    	console.log(x + "," + y);
	    	arrayPoint.push(new google.maps.LatLng(x, y));

		<% } %>
		  heatmap = new google.maps.visualization.HeatmapLayer({
			    data: arrayPoint,
			    map: map
			  });
}

function browserExit() {
	//alert("d1")
	//alert("dd");
	//window.close();	// IE에서만 먹힘
	window.open('','_self').close();
	//window.open('about:blank', '_self').close();
/* 			window.close();
	self.close();
	window.opener = window.location.href; self.close();
	window.open('about:blank', '_self').close(); */
/* 			top.window.opener = top;
	top.window.open('','_parent', '');
	top.window.close(); */
/* 			window.opener='Self';
	window.open('','_parent', '');
	window.close(); */
	
}

function refreshMap() {
	location.reload();
}

function seoulMove() {
	var location = new google.maps.LatLng(37.5249754,126.9782639);
    map.setCenter(location);
    map.setZoom(13);
}

function seongnamMove() {
	var location = new google.maps.LatLng(37.3747560, 127.1371260);
    map.setCenter(location);
    map.setZoom(12);
}

function busanMove() {
	var location = new google.maps.LatLng(35.1599157,129.0471268);
    map.setCenter(location);
    map.setZoom(13);
}

function daeguMove() {
	var location = new google.maps.LatLng(35.8473175,128.5546303);
    map.setCenter(location);
    map.setZoom(13);
}

function daechunMove() {
	var location = new google.maps.LatLng(36.3393274,127.3931694);
    map.setCenter(location);
    map.setZoom(13);
}

function gwangjuMove() {
	var location = new google.maps.LatLng(35.1604771,126.8483162);
    map.setCenter(location);
    map.setZoom(12);
}

function ulsanMove() {
	var location = new google.maps.LatLng(35.5450772,129.3451309);
    map.setCenter(location);
    map.setZoom(12);
}

function chunanMove() {
	var location = new google.maps.LatLng(36.8020001,127.1471786);
    map.setCenter(location);
    map.setZoom(14);
}

function chungjuMove() {
	var location = new google.maps.LatLng(36.6348151,127.4752235);
    map.setCenter(location);
    map.setZoom(13);
}

function suwonMove() {
	var location = new google.maps.LatLng(37.2786970,127.0074463);
    map.setCenter(location);
    map.setZoom(13);
}

function jeonjuMove() {
	var location = new google.maps.LatLng(35.8242160,127.1222878);
    map.setCenter(location);
    map.setZoom(14);
}

function buchunMove() {
	var location = new google.maps.LatLng(37.5029170,126.7738152);
    map.setCenter(location);
    map.setZoom(13);
}

function pohangMove() {
	var location = new google.maps.LatLng(36.0046735,129.3626404);
    map.setCenter(location);
    map.setZoom(13);
}

function jejuMove() {
	var location = new google.maps.LatLng(33.3580616,126.5350342);
    map.setCenter(location);
    map.setZoom(11);
}

function changeGradient() {
  var gradient = [
    'rgba(0, 255, 255, 0)',
    'rgba(0, 255, 255, 1)',
    'rgba(0, 191, 255, 1)',
    'rgba(0, 127, 255, 1)',
    'rgba(0, 63, 255, 1)',
    'rgba(0, 0, 255, 1)',
    'rgba(0, 0, 223, 1)',
    'rgba(0, 0, 191, 1)',
    'rgba(0, 0, 159, 1)',
    'rgba(0, 0, 127, 1)',
    'rgba(63, 0, 91, 1)',
    'rgba(127, 0, 63, 1)',
    'rgba(191, 0, 31, 1)',
    'rgba(255, 0, 0, 1)'
  ]
  heatmap.set('gradient', heatmap.get('gradient') ? null : gradient);
}

function changeRadius() {
  heatmap.set('radius', heatmap.get('radius') ? null : 20);
}

function changeOpacity() {
  heatmap.set('opacity', heatmap.get('opacity') ? null : 0.2);
}

    </script>
    <!--  <script src="http://maps.google.com/maps/api/js?v=3&amp;sensor=false"></script> -->
    <script async defer
        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyAc7hSOtAxXMNzNHlCBjO0eHCd_iyDN46Y&signed_in=true&libraries=visualization&callback=initMap">
    </script>
  </body>
</html>