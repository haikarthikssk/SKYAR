<%@ page import="com.google.appengine.api.users.*,com.google.appengine.api.datastore.*"%>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Skyar</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="Skyar Downloader">
  <meta name="author" content="karthik">

	<!--link rel="stylesheet/less" href="less/bootstrap.less" type="text/css" /-->
	<!--link rel="stylesheet/less" href="less/responsive.less" type="text/css" /-->
	<!--script src="js/less-1.3.3.min.js"></script-->
	
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
	<link href="css/elusive-webfont.css" rel="stylesheet">
	<link href="css/style.css" rel="stylesheet">

	<link rel="shortcut icon" href="img/favicon.png">
  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
  <![endif]-->
  <link rel="shortcut icon" href="img/favicon.png">
  
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script src="js/jquery-ui.js"></script>
	</head>
<body style="background-image: -webkit-linear-gradient(top, rgb(11, 30, 49) 0%, #FFFFFF 100%);">



<%
UserService userService = UserServiceFactory.getUserService();
if(!userService.isUserLoggedIn())
{
	response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
}
%>


<%
String url=request.getParameter("URL");
String Username=null;
String Status[]={"Key Not Used","Downloading","Paused","Finished","Error"};
String Color_Codes[]={"#ff9900","#109618","#990099","#3366cc","#dc3912"};
Info info=null;
if(userService.isUserLoggedIn())
{
 Username=request.getUserPrincipal().getName();
 }
if(url!=null&&!url.equals("")&&Username!=null)
{
info=getAllInfo(url,Username);
}
%>
<div class="span12">
					<h3 class="text-info text-center">
						<div>
							<!--<span>SKYAR</span>--><img style="height:80px"src="/img/logo.png">
						</div>
					</h3>
				</div>
<div class="row">
<div class="span2">
</div>			
<div class="span10">
<form name="f" method="GET" action="Stat.jsp">
<select name ="URL" class="span10" onchange="document.forms[0].submit()">
<%
URLList ulist=getUrls(Username);
for(int i=0;i<ulist.count;i++)
{
if(request.getParameter("URL")!=null&&request.getParameter("URL").equals(ulist.url[i]))
out.print("<option selected>"+ulist.url[i]+"</option>"); 
else
out.print("<option>"+ulist.url[i]+"</option>");
}
%>
</select><b>No Of Hits (Globally) : <%if((request.getParameter("URL")!=null)&&(!request.getParameter("URL").equals(""))){out.println(noOfHits(request.getParameter("URL")));}%></b></form></div>
</div>
<div class="row">
<div class="span2"></div>
		<div class="span1"><span class="label label-inverse">Codes : </span></div>
      <div class="span2"><span class="label label-warning">Not Used</span></div>
      <div class="span2"><span class="label label-success">Downloading</div>
      <div class="span2"><span class="label label-info">Finished</span></div>
      <div class="span2"><span class="label label-info" style="background-color:#990099">Paused</span></div>
      <div class="span2"><span class="label label-important">Error</span></div>
    </div>
<div class="container-fluid">
<div class="row-fluid">
<div class="span2">
</div>			
<div class="span6">
<div class="text-left text-success statborder span8">
<%
try
{
 if(info!=null)
{
out.println("<p><span class=\"text-error\">URL : </span>"+ info.url+"</p>");
out.println("<p><span class=\"text-error\">No of Segments : </span>"+ info.splits+"</p>");
if(info.size.equals("-1"))
info.size="Size Undermined!";
out.println("<p><span class=\"text-error\">Size : "+ info.size+"</p>");
out.println("<span class=\"text-error\">Access Codes </span>: ");
for(int z=0;z<Integer.parseInt(info.splits);z++)
{
out.println("<br><span class=\"span5\">Code : <span class=\"text-info\">"+ info.ACD[z].Code+"</span></span>");
if((Integer.parseInt(info.ACD[z].Status)-1)>5||(Integer.parseInt(info.ACD[z].Status)-1)<0)
info.ACD[z].Status="5";
out.println("<span class=\" pull-left span6\">Status : <span class=\"text-info\">"+ Status[Integer.parseInt(info.ACD[z].Status)-1]+" </span></span>  ");
}
}
}
catch(Exception e)
{

}%>
 </div>
</div>
<div id="Chart" class="span12 graphborder" style="z-index:99;left:50%;position:absolute;width:500px;height:250px">

</div>
</div>
<div class="row-fluid">
<div class="span1">
</div>
<div class="span11 mapborder">

<br>
<ul class="thumbnails">
  <li class="span12">
     <div id="map_div" style="width: 100%; height: 100%"></div>
  </li>
</ul>
</div>
</div>
<script type="text/javascript">
var map,chart;
	google.load("visualization", "1", {packages:["corechart"]});
    google.setOnLoadCallback(drawChart);
    function drawChart() {
        var data = google.visualization.arrayToDataTable([
        <%
        out.println("['Download', 'Percentage']");
 		if(info!=null)
 		{
 		for(int z=0;z<Integer.parseInt(info.splits);z++)
			{
			out.println(","+"['"+info.ACD[z].Code+"',1]");
			}
 		}
        %>
        ]);

        var options = {
          title: 'Access Codes : ',
          pieHole: 0.4,
          chartArea:{left:20,top:10,width:"100%",height:"100%"},
          <%
          out.println("colors:[");
          if(info!=null)
 		{
 		for(int z=0;z<Integer.parseInt(info.splits);z++)
			{
			out.println("'"+Color_Codes[Integer.parseInt(info.ACD[z].Status)-1]+"',");
			}
			out.println("],");
 		}
          %>
        };

        chart = new google.visualization.PieChart(document.getElementById('Chart'));
        chart.draw(data, options);
        google.visualization.events.addListener(chart, 'select', selectChartHandler);
        function selectChartHandler(e) {
  map.setSelection(chart.getSelection());
}
      }
	</script>
	<script type="text/javascript">
	$( "#Chart" ).draggable({cursor: "crosshair","opacity": 0.35 });
	$(window).scroll(function(){
    var st = $(this).scrollTop();
    if( st <= 40){
        $('.graphborder').css({position:'absolute', top:'200px',left:'50%',cursor:'default',width:'500px'});
        drawChart();
          
    }else{
        $('.graphborder').css({position:'fixed', top:'100px',cursor:'move',width:'300px'});
        drawChart();  
    }       
});
	</script>
	<!-- Map -->
	<script type="text/javascript">
	 google.load("visualization", "1", {packages:["map"]});
      google.setOnLoadCallback(drawMap);
      function drawMap() {
        var data = google.visualization.arrayToDataTable([
          ['Lat', 'Lon', 'Name'],
          <%
          if(info!=null)
          {
          	if(!info.Lat.equals("0"))
          	{
          		out.println("["+info.Lat+","+info.Lon+",'Initiator'],");
          	}
          	for(int z=0;z<Integer.parseInt(info.splits);z++)
			{
			if(!info.ACD[z].Lat.equals("0"))
			out.println("["+info.ACD[z].Lat+","+info.ACD[z].Lon+",'"+info.ACD[z].Code+"'],");
			}
          }
          %>
        ]);

        map = new google.visualization.Map(document.getElementById('map_div'));
        map.draw(data, {showTip: true,showLine:true,enableScrollWheel:true,showTip:true,mapType:'normal',useMapTypeControl:true,lineWidth:3,lineColor:'#3366cc'});
 		google.visualization.events.addListener(map, 'select', selectMapHandler);
        function selectMapHandler(e) {
  chart.setSelection(map.getSelection());
}       
      }
	</script>
</body>
</html>
<%!
public Info getAllInfo(String url,String User)
	{
	Info I=null;
	try
	{
		Query q=new Query("urlids");
		I=new Info();
		q.addFilter("url",Query.FilterOperator.EQUAL,url);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="NO";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("Id");
			 I.url=url;
			}
			if(x.equals("NO"))
			{
			return null;
			}
			//System.out.println(x);
			q=new Query("download");
		q.addFilter("urlid",Query.FilterOperator.EQUAL,x);
		q.addFilter("userid",Query.FilterOperator.EQUAL,User);
		datastore = DatastoreServiceFactory.getDatastoreService();
		pq = datastore.prepare(q);
		x="NO";
		for (Entity result : pq.asIterable()) {
		x=(String)result.getProperty("idno");
			 I.size=(String)result.getProperty("size");
			 I.splits=(String)result.getProperty("splits");
			 I.Lat=(String)result.getProperty("lat");
			 I.Lon=(String)result.getProperty("lon");
			}
			if(x.equals("NO"))
			{
			return null;
			}
			I.ACD=new AccessCode[Integer.parseInt(I.splits)];
			for(int z=0;z<Integer.parseInt(I.splits);z++)
			{
			I.ACD[z]=new AccessCode();
			}
			q=new Query("AccessCode");
		q.addFilter("downloadid",Query.FilterOperator.EQUAL,x);
		datastore = DatastoreServiceFactory.getDatastoreService();
		pq = datastore.prepare(q);
		//System.out.println(x);
		int y=0;
		for (Entity result : pq.asIterable()) {
		//x=(String)result.getProperty("urlid");
		
			I.ACD[y].Code=(String)result.getProperty("code");
			  I.ACD[y].Status=(String)result.getProperty("status");
			   I.ACD[y].Lat=(String)result.getProperty("lat");
			    I.ACD[y].Lon=(String)result.getProperty("lon");
			     I.ACD[y].Part=(String)result.getProperty("segment");
			    
			     y++;
			}
		
		}
		catch(Exception e)
		{
		}
		return I;
	}
	public URLList getUrls(String User)
	{
		Query q=new Query("download");
		URLList ulist=new URLList();
		q.addFilter("userid",Query.FilterOperator.EQUAL,User);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="";
		int y=0;
		ulist.url=new String[pq.countEntities()];
		ulist.count=pq.countEntities();
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("urlid");
			 Query d=new Query("urlids");
			 d.addFilter("Id",Query.FilterOperator.EQUAL,x);
			 datastore = DatastoreServiceFactory.getDatastoreService();
			PreparedQuery p = datastore.prepare(d);
			for (Entity result2 : p.asIterable()) {
			ulist.url[y]=(String)result2.getProperty("url");
			y++;
			}
			}
			return ulist;
	}
	public int noOfHits(String Url)
	{
		Query q=new Query("urlids");
		q.addFilter("url",Query.FilterOperator.EQUAL,Url);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String urlid="";
		for (Entity result : pq.asIterable()) {
		urlid=(String)result.getProperty("Id");
		}
		if(urlid!=null)
		{
			q=new Query("download");
			q.addFilter("urlid",Query.FilterOperator.EQUAL,urlid);
		datastore = DatastoreServiceFactory.getDatastoreService();
		pq = datastore.prepare(q);
		return pq.countEntities();
		}
		return 0;
	}
%>
<%!
class Info
{
public String size,splits,url,segment;
public String Lat,Lon;
public AccessCode ACD[];
}
class AccessCode
{
	public String Code,Status,Lat,Lon,Part;
}
class URLList
{
int count;
String url[];
}
%>