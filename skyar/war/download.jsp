<html>
<head>
<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
	<link href="css/style.css" rel="stylesheet">
	
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/scripts.js"></script>
	<link rel="shortcut icon" href="img/favicon.png">
	</head>
<body>
<div class="span12">
					<h3 class="text-info text-center">
						<div>
							<!--<span>SKYAR</span>--><img style="height:80px"src="/img/logo.png">
						</div>
					</h3>
				<div class="span12">
<center><div class="alert fade in alert-info" style="display:none;width:100%">
            <button type="button" class="close" data-dismiss="alert">×</button>
           <div id="alerttxt" Access Denied for Geo-Locator.</div>
          </div></center></div>
<%@ page import="com.google.appengine.api.datastore.*" %>
<%
String Code=request.getParameter("InvitationKey");
int segmentid=0;
String DownloadUrl="";
int NoOfSplits=0;
String Cookie="";
Long Size=0L,Start=0L,End=0L;
if((Code!=null)&&(!Code.equals("")))
{
	try
	{
		Info info=getInfo(Code);
		if(info!=null)
		{
		DownloadUrl=info.url;
		Size=Long.parseLong(info.size);
		if(Size>0)
		{
		NoOfSplits=Integer.parseInt(info.splits);
		Cookie=info.cookie;
		segmentid=Integer.parseInt(info.segment);
		int k=NoOfSplits;
				Long sindex=Size/k;
				Long index=0L,cache=0L;
				int temp=0;
				while(index<=Size)
				{
					if(index>0)
					{
					
					if(temp==segmentid+1)
					{
					if(index+sindex>Size)
					{
					Start=cache;
					End=Size;
					}
					else
					{
					Start=cache;
					End=index;
					}
					break;
					}
					}
					cache=index;
					temp++;
					index+=sindex;
				}
		}
		}
		else
		out.println("<h3><center class=\"text-warning text-center\">Invitation Key Not found!!</center></h3>");
		
	}
	catch(Exception e)
	{
	out.println(e.getMessage());
	}
}
else
{
out.println("<div span=\"12\"><h4><center class=\"muted text-center\">Welcome to SKYAR Downloader </center></h4></div>");
	
}

%>

<%
if(!DownloadUrl.equals("")&&Size>0)
{
	out.println("<applet code=\"SkyarDownloader.class\" archive=\"new.jar\"  width=\"100%\" height=\"100%\">");
out.println("<param name=\"URLTODOWNLOAD\" value=\""+DownloadUrl+"\"></param>");
out.println("<param name=\"START\" value=\""+Start+"\"></param>");
out.println("<param name=\"END\" value=\""+End+"\"></param>");
out.println("<param name=\"key\" value=\""+Code+"\"></param>");
out.println("<param name=\"SEGMENT\" value=\""+(segmentid+1)+"\"></param>");
out.println("</applet>");
}
else if(!DownloadUrl.equals("")&&Size<0)
{
out.println("<applet code=\"SkyarDownloader.class\" archive=\"new.jar\"  width=\"100%\" height=\"100%\">");
out.println("<param name=\"URLTODOWNLOAD\" value=\""+DownloadUrl+"\"></param>");
out.println("<param name=\"START\" value=\""+0+"\"></param>");
out.println("<param name=\"END\" value=\"-1\"></param>");
out.println("<param name=\"key\" value=\""+Code+"\"></param>");
out.println("<param name=\"NOF\" value=\""+NoOfSplits+"\"></param>");
out.println("<param name=\"SEGMENT\" value=\""+(segmentid+1)+"\"></param>");
out.println("</applet>");
}
%>
<%!
public Info getInfo(String AccessCode)
	{
	Info I=null;
	try
	{
		Query q=new Query("AccessCode");
		I=new Info();
		q.addFilter("code",Query.FilterOperator.EQUAL,AccessCode);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="NO",Size="";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("downloadid");
			 I.segment=(String)result.getProperty("segment");
			}
			if(x.equals("NO"))
			{
			return null;
			}
			//System.out.println(x);
			q=new Query("download");
		q.addFilter("idno",Query.FilterOperator.EQUAL,x);
		datastore = DatastoreServiceFactory.getDatastoreService();
		pq = datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
		x=(String)result.getProperty("urlid");
			 I.size=(String)result.getProperty("size");
			 I.splits=(String)result.getProperty("splits");
			 I.cookie=(String)result.getProperty("cookie");
			}
			q=new Query("urlids");
		q.addFilter("Id",Query.FilterOperator.EQUAL,x);
		datastore = DatastoreServiceFactory.getDatastoreService();
		pq = datastore.prepare(q);
		//System.out.println(x);
		for (Entity result : pq.asIterable()) {
		//x=(String)result.getProperty("urlid");
			 I.url=(String)result.getProperty("url");
			}
		
		}
		catch(Exception e)
		{
		}
		return I;
	}
%>
<%!
class Info
{
public String size,splits,url,cookie,segment;
}%>
<center>
<form name="f" action="download.jsp" method="GET">
<div class="control-group">
<div class="controls"">
<input type="text" name="InvitationKey" placeholder="Paste Invitation Key Here" style="height:35px"><br>
<button class="btn" style="position:center" type="submit"  value="Download">Download</button></center><small class="muted" style="position:absolute;top:2%;left:87%;"> * use JRE Version above 7.</small>
</div>
</div>
</form>
<script type="text/javascript">
var key=null;
<%
		if(Code!=null){out.println("key=\""+Code+"\";");}
%>
	function getPosition(position)
	{
	var lat=0,lon=0;
	lat=position.coords.latitude;
	lon=position.coords.longitude;
	
	
	if(key!=null&&key!="")
	{
		$.get("setData.jsp?Action=GStatus&Key="+key+"&Lat="+lat+"&Lon="+lon,null,function(data){});
	}
	}
	function showError(error)
  {
  var msg="";
  switch(error.code) 
    {
    case error.PERMISSION_DENIED:
      msg="Access denied for Geo-locator"
      break;
    case error.POSITION_UNAVAILABLE:
      msg="Geo-Position unavailable."
      break;
    case error.TIMEOUT:
      msg="Geo-Locator Timed out."
      break;
    case error.UNKNOWN_ERROR:
      msg="Geo-Locator - An unknown error occurred."
      break;
    }
    $('#alerttxt').text(msg);;
    $('.alert').show();
    $.get("setData.jsp?Action=GStatus&Key="+key+"&Lat=0&Lon=0",null,function(data){});
	
  }
	function initGeo()
	{
	if (navigator.geolocation)
    {
    	navigator.geolocation.getCurrentPosition(getPosition,showError);
    }
  		else
  		{
  		alert("Geolocation is not supported by this browser.");
  		}
  	
	}
	$(window).ready(function(){initGeo();});
</script>
</body>
</html>