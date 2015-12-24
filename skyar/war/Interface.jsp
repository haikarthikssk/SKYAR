<!DOCTYPE html>
<%@ page import="com.google.appengine.api.users.*,java.net.URL"%>
<%
UserService userService = UserServiceFactory.getUserService();
if(!userService.isUserLoggedIn())
{
	response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
}
%>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Skyar</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta name="description" content="">
  <meta name="author" content="Karthik">

	<!--link rel="stylesheet/less" href="less/bootstrap.less" type="text/css" /-->
	<!--link rel="stylesheet/less" href="less/responsive.less" type="text/css" /-->
	<!--script src="js/less-1.3.3.min.js"></script-->
	
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
	<link href="css/style.css" rel="stylesheet">
	<link href="css/elusive-webfont.css" rel="stylesheet">
	<link href="css/datepicker.css" rel="stylesheet">
  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
  <![endif]-->

  <!-- Fav and touch icons -->
  <link rel="apple-touch-icon-precomposed" sizes="144x144" href="img/apple-touch-icon-144-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="114x114" href="img/apple-touch-icon-114-precomposed.png">
  <link rel="apple-touch-icon-precomposed" sizes="72x72" href="img/apple-touch-icon-72-precomposed.png">
  <link rel="apple-touch-icon-precomposed" href="img/apple-touch-icon-57-precomposed.png">
  <link rel="shortcut icon" href="img/favicon.png">
  
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/scripts.js"></script>
	<script type="text/javascript" src="js/Wot.js"></script>
	<script type="text/javascript" src="js/bootstrap-datepicker.js"></script>
	<script src="https://apis.google.com/js/client.js?onload=handleClientLoad"></script>
	<script type="text/javascript">
		$(window).load(function(){
 		 $('#dvLoading').fadeOut(2000);
		});
	var lat=0,lon=0;
	function getPosition(position)
	{
	lat=position.coords.latitude;
	lon=position.coords.longitude;
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
      msg="Position unavailable."
      break;
    case error.TIMEOUT:
      msg="Timed out."
      break;
    case error.UNKNOWN_ERROR:
      msg="An unknown error occurred."
      break;
    }
  }
	function initGeo()
	{
	if (navigator.geolocation)
    {
    	navigator.geolocation.getCurrentPosition(getPosition,showError);
    }
  		else
  		{
  		x.innerHTML="Geolocation is not supported by this browser.";
  		}
  	
	}
	$(document).ready(function(){initGeo();});
	
	function forwardStat(x)
	{
	window.open("Stat.jsp?URL="+$(x).parent().parent().parent().parent().parent().children('.url').text());
	}
	function sendInvitation(x)
	{
	var url="";
	var append_url="http://www.gcdc2013-skyar.appspot.com/download.jsp?InvitationKey="+$(x).parent().parent().parent().text().trim();
	if($(x).attr("title")=="gplus")
	{
	url="https://plus.google.com/share?url="+encodeURIComponent(append_url);
	}
	else if($(x).attr("title")=="facebook")
	{
	url="https://www.facebook.com/dialog/send?app_id=440314132746000&link="+encodeURIComponent(append_url)+"&redirect_uri=http://www.gcdc2013-skyar.appspot.com";
	}
	else  if($(x).attr("title")=="gmail")
	{
	url="https://mail.google.com/mail/?view=cm&fs=1&su=SKYAR Invitation Key&body=Your Invitation Key is "+$(x).parent().parent().parent().text().trim()+" Click on the below url to download the file "+append_url+"&tf=1&shva=1";
	}
	else if($(x).attr("title")=="twitter")
	{
	url="http://twitter.com/share?url="+append_url+"&text=You have an Invitation Key";
	}
	window.open(url,"_blank","width=500, height=700");
	
	$(x).parent().parent().parent().addClass("info").css("font-weight","Bold");
	}
	function tableUpdate(x)
	{
	if($(x).text()=="Get Access Code")
	{
	var urlx=$(x).parent().parent().children('.url').text();
	$.get('getInfo.jsp?Action=ACCESSCODE&URL='+urlx,null,function(data){
	var d=data.split("<br>");
	var str="";
	for(var x=0;x<d.length;x++)
	{
	str+="<div id=\""+x+"\" ondblClick=\"window.open('download.jsp?InvitationKey="+d[x].trim()+"')\" onMouseenter=\"processCode(this)\" onMouseLeave=\"clearArea(this)\"><div class=\"processArea pull-right\" style=\"display:none\" ></div>"+d[x]+"</div>";
	}
	$('#accessmodalbody').html(str);
	$('#accessModal').modal('show');
	});
	}
	else if($(x).text()=="Delete")
	{
	var urlx=$(x).parent().parent().children('.url').text();
	$.get("getInfo.jsp?Action=Delete&URL="+urlx,null,function(data){
	});
	getInfo();
	}
	}
	function getInfo()
	{
	$('#bartable').fadeIn();
	$('#bartable').children('div').attr("style","width:25%");
		$.get("getInfo.jsp?Action=Info",null,function(data){
		var content='<table class="table table-striped table-hover"><tr class="success"><th>#</th><th>URL</th><th>Size</th><th>Action</th><th>Sky Arena</th></tr>';
		var datas=data.split("}");
		$('#bartable').children('div').attr("style","width:50%");
		for(var x=0;x<datas.length-1;x++)
		{
		content+="<tr>";
			var f=datas[x].split("{");
			content+="<td>"+(x+1)+"</td>";
			content+="<td class='url'>"+f[0]+"</td>";
			content+="<td>"+f[1]+"</td>";
			content+='<td width="25%"><button class="btn btn-info" onclick="tableUpdate(this)">Get Access Code</button>    ';
			content+='<button class="btn btn-inverse" onclick="tableUpdate(this)">Delete</button></td>';
			content+='<td><div class="btn-group"><button class="btn">More</button> <button data-toggle="dropdown" class="btn dropdown-toggle"><span class="caret"></span></button><ul class="dropdown-menu"><li><a href="#" onclick="forwardStat(this)">Live  Statitics</a></li><li class="divider"></li><li><a href="SkyArena.jsp?sel=Apps" target="_blank">SKY ARENA</a></li></ul></div></div></td>';
			content+="</tr>";
			
		}
		content+="</table>";
		$('#spantable').html(content).show(500);
		$('#bartable').children('div').attr("style","width:100%");
		$('#bartable').fadeOut();
		});
	}
	function processCode(x)
	{
	$(x).children('div').html('<div style="color:#0000ff;font-size:16px"><a class="el-icon-envelope" data-toggle="tooltip" onclick="sendInvitation(this)" title="gmail"></a>     <a class="el-icon-googleplus" data-toggle="tooltip" onclick="sendInvitation(this)" title="gplus"></a>     <a class="el-icon-facebook" data-toggle="tooltip" onClick="sendInvitation(this)" title="facebook"></a>     <a class="el-icon-twitter" data-toggle="tooltip" onClick="sendInvitation(this)" title="twitter"></a></div>').show();
	}
	function clearArea(x)
	{
	$(x).children('div').hide('');
	}
	function sendMail()
	{
		var url="test.jsp?url="+$('#urlid').val()+"&nearby="+document.getElementById('nearbycheck').checked+"&Notify=true"+"&Lat="+lat+"&Lon="+lon;
		$.get(url,null,function(data){alert("An Invitation has been sent to Nearby Downloaders.   They will Contact You ,if they are willing to share their downloading with you!!");$('#myModal').modal('hide');});
	}
	function checkurl()
	{
		
				$('#checkbar').children('.bar').text('');
		$('#checkbar').children('.bar').attr("style","width:"+10+"%");
		if($('#urlid').val()=="")
		{
		alert("Please Input URL ");
		$('#checkbar').children('.bar').attr("style","width:"+0+"%");
		return;
		}
		if($('#nousersid').val()=="" || $('#nousersid').val()>10)
		{
		$('#checkbar').children('.bar').attr("style","width:"+0+"%");
			alert("Segment Field Not Correct!! 0 - 10 are allowed!!");
			}
		else
		{
		var url="test.jsp?url="+$('#urlid').val()+"&Lat="+lat+"&Lon="+lon;
		if(document.getElementById('nearbycheck').checked)
		{
			url+="&nearby="+document.getElementById('nearbycheck').checked;
			
		}
		$.get(url,null,function(data){
				$('#checkbar').children('.bar').attr("style","width:"+25+"%");
				if(data.indexOf("Error")>-1)
				{
					alert(data.trim());
					$('#checkbar').children('.bar').attr("style","width:"+0+"%");
					return;
				}
				$('#checkbar').fadeIn();
				var s=data.split("^");
				var dat=s[0].split(";");
				var str="";
				for(var y=0;y<dat.length-1;y++)
				{
					var temp=dat[y].split(":");
					for(var z=0;z<temp.length;z++)
					{
							if(temp[z+1]=="Found")
							{
								str+=temp[z]+": <font color=\"#0000ff\">"+temp[z+1]+"</font><a href='#' onclick='sendMail()'> Send Invitation</a><br>";
							}
							else
							{
							str+=temp[z]+": <font color=\"#0000ff\">"+temp[z+1]+"</font><br>";
							}
							z+=2;
						
					}
				}
				$('#checkbar').children('.bar').attr("style","width:"+80+"%");
				var maldata="";
				$('#checkbar').children('.bar').text('Checking URL for Malware..');
				scanURL($('#urlid').val(),function(data){
				if(data==-1)
				{
					$('#checkbar').removeClass('progress-info').removeClass('progress-success').addClass('progress-warning');
					maldata='Unknown Site..';
				}
				else if(data>0)
				{
				$('#checkbar').removeClass('progress-info').removeClass('progress-success').addClass('progress-danger');				
				maldata='Site Not Safe ! <a target="_blank" style="color:#ffffff" href="https://www.mywot.com/en/scorecard/'+$('#urlid').val().replace("http://","")+'"><u> more info!</u></a>';
				}
				else
				{
					$('#checkbar').removeClass('progress-info').removeClass('progress-danger').addClass('progress-success');
					maldata='No Malware Found';
				
				}
				
				});
				
				
				$('#checkbar').children('.bar').attr("style","width:"+100+"%");
				$('#checkbar').children('.bar').html(maldata);
				str+='<div id="Control" class="pull-right"><button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button><button type="button" class="btn btn-success" id="submitit" onclick="submitData()">Register It</button></div>';
			$('#msg').html(str);
			$('#msg').fadeIn();});
			}
			$('#checkbar').children('.bar').attr("style","width:"+00+"%");
	}
	function submitData()
	{
	if($('#nousersid').val()=="" || $('#nousersid').val()>10||$('#nousersid').val()<1)
	{
			alert("Segment Field Not Correct 0-10 are allowed!!");
			return;
	}
	var url="test.jsp?url=";
	url+=$('#urlid').val();
	url+="&Split="+$('#nousersid').val();
	url+="&Register=true";
	url+="&Private="+document.getElementById('pricheck').checked;
	url+="&Lat="+lat+"&Lon="+lon;
	if(document.getElementById('selectcookie').checked)
	{
		if($('#cookid').val()=="")
		{
			alert("Cookie Field Empty!!");
			return;
		}
		url+="&Cookie="+$('#cookid').val();
	}
	$.get(url,null,function(data){
	if(data.indexOf("Error")>-1)
	alert(data.trim());
	else
	{
	$('#msg').html('');
	data=data.trim();
		var splitdt=data.split("<br>");
		var setdt="";
		splitdt[0];
		for(var g=0;g<splitdt.length-1;g++)
		{
			setdt+="<div id=\""+g+"\" ondblClick=\"window.open('download.jsp?InvitationKey="+splitdt[g].trim()+"')\" onMouseenter=\"processCode(this)\" onMouseLeave=\"clearArea(this)\"><div class=\"processArea pull-right\" style=\"display:none\" ></div>"+splitdt[g]+"</div>";
		}
		$('#msg').html("Your Access Codes Are :<br>"+setdt.trim());
		alert("Use This Access Code to Download the file");
		getInfo();
	}
	
	});
	}
	</script>
</head>

<body>
<div class="container-fluid">
	<div class="row-fluid">
		<div class="span12">
			<div class="row-fluid">
				<div class="span12">
					<h3 class="text-info text-center">
						<div>
							<!--<span>SKYAR</span>--><img style="height:80px"src="/img/logo.png">	<span class="pull-right" style="position:absolute;left:87%;">
							<!-- Place this tag where you want the widget to render. -->
<a class="pull-right g-follow" data-annotation="bubble" data-height=30" data-href="//plus.google.com/108129711937744990069" data-rel="publisher"></a>
</span>
<!-- Place this tag after the last widget tag. -->
<script type="text/javascript">
  (function() {
    var po = document.createElement('script'); po.type = 'text/javascript'; po.async = true;
    po.src = 'https://apis.google.com/js/platform.js';
    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(po, s);
  })();
</script>						
						</div>
					</h3>
					
				</div>
				<div class=" text-info pull-right">
		Welcome <% if(userService.isUserLoggedIn()) out.println(request.getUserPrincipal().getName());%>
		</div>
			</div>
			<div class="navbar">
				<div class="navbar-inner">
					<div class="container-fluid">
						 <a data-target=".navbar-responsive-collapse" data-toggle="collapse" class="btn btn-navbar"><span class="icon-bar"></span><span class="icon-bar"></span><span class="icon-bar"></span></a> <a href="#" class="brand">Skyar</a>
						<div class="nav-collapse collapse navbar-responsive-collapse">
							<ul class="nav">
								<li class="active">
									<a href="#">Home</a>
								</li>
								<li>
									<a href="how-to.jsp">How-To</a>
								</li>
								<li>
									<a href="SkyArena.jsp?sel=Apps" target="_blank">SKY ARENA</a>
								</li>
							</ul>
							<ul class="nav pull-right">
								<li class="dropdown">
									 <a data-toggle="dropdown" class="dropdown-toggle" href="#">Contact<strong class="caret"></strong></a>
									<ul class="dropdown-menu">
										<li class="dropdown-submenu">
											<a>Developer</a>
												<ul class="dropdown-menu" style="color:#0000ff">
                      <li><a tabindex="-1" target="_blank" href="mailto:haikarthissk@gmail.com"><i class="el-icon-envelope"  style="color:#ccddcc"></i>  gmail</a></li>
                      <li><a tabindex="-1" target="_blank" href="https://plus.google.com/106999624692143293708/"><i class="el-icon-googleplus" style="color:#ccddcc"></i>  google plus</a></li>
                      <li><a tabindex="-1" target="_blank" href="http://www.facebook.com/karthik.ninja"><i class="el-icon-facebook" style="color:#ccddcc"></i>  facebook</a></li>
                      <li><a tabindex="-1" target="_blank" href="http://www.twitter.com/haikarthikssk"><i class="el-icon-twitter" style="color:#ccddcc"></i>  twitter</a></li>
                    </ul>
										</li>
									
										<li>
											<a href="#creditModal" data-toggle="modal" data-target="#creditModal">Credits</a>
										</li>
									</ul>
								</li>
								<li class="divider-vertical">
								</li>
								<li>
									<a href="<%=userService.createLogoutURL("../index.html")%>">Logout</a>
								</li>
							</ul>
						</div>
						
					</div>
				</div>
				
			</div>
			<div class="row-fluid">
				<div class="span2">
				</div>
				<div class="span6">
					<button class="btn" type="button" data-toggle="modal" data-target="#myModal"><i class=" icon-plus"></i> Add New Download</button>
					<button class="btn" type="button" data-toggle="modal" data-target="#remModal"><i class="icon-calendar"></i> Set Reminder</button>		
			
				</div>
				<div class="span4">
				</div>
			</div>
		</div>
	</div>
	<div class="row-fluid">
		<div class="span2">
			 
		</div>
		<div class="span6">
			<h3 class="text-success">
				Your Previous Downloads : 
			</h3>
			<p>
				<a class="btn" href="#" onclick="getInfo()"><i class="icon-th-list"></i> View downloads</a>
			</p>
			<div class="span12">
			<div id="bartable"class="progress progress-success progress-striped active"  aria-valuenow="50" aria-valuemin="0" aria-valuemax="100" style="width:50%;display:none">
				<div class="bar" style="width:0%">
				</div>
			</div>
			</div>
		</div>
		<div class="span4">
			<div class="btn-group">
				 <button class="btn">Navigate To </button> <button data-toggle="dropdown" class="btn dropdown-toggle"><span class="caret"></span></button>
				<ul class="dropdown-menu">
					<li>
						<a href="download.jsp" target="_blank">SKYAR Downloader</a>
					</li>
					<li>
						<a href="Joiner.jsp" target="_blank">SKYAR Joiner</a>
					</li>
					<li>
						<a href="FAQ.jsp" target="_blank">FAQ</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
	<div class="span12">
<div class="span2">
</div>
<div class="row-fluid">
<div class="span10" id="spantable" style="display:none">
<table class="table table-striped table-hover">
<tr>
<th>#</th><th>URL</th>
</tr>
<tr>
<td>1</td><td>data1</td>
</tr>
<tr>
<td>2</td><td>data2</td>
</tr>
<tr>
<td>3</td><td>data3</td>
</tr>
</table>
</div>
</div>
</div>
<!--Modal-->
<div class="modal fade" id="myModal" tabindex="-1"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close"  data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">Add Your Download Here</h4>
      </div>
      <div class="modal-body">
        <p>URL(prefix with http://):<input type="text" style="width:70%" placeholder ="Paste Your URL Here" id="urlid"/ required></p>
        <P>No of Segments : <input type="text" id="nousersid" class="pull-right" value="10" style="width:70%" required></P>
        <br><p>Private Mode : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox"  id="pricheck" onclick="$('#pritxt').toggle();">    <span id="pritxt">(Off) URL will be listed on <a href="SkyArena.jsp?sel=Apps" target="_blank">SKYARENA</a></span></p>
       <p> Nearby Downloaders :&nbsp;&nbsp;<input type="checkbox"  id="nearbycheck" onclick="$('#nearbytxt').toggle();">    <span id="nearbytxt" style="display:none">Search for users downloading same file in your locality </span></p>
          <P>Cookies : &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;   <input type="checkbox" id="selectcookie" onclick="$('#cookid').toggle();"> </p><p>     <input type="text" id="cookid" class="pull-right" style="display:none;width:70%"></P><br>
        
		
        
        
       <div class="progress progress-info progress-striped active" id="checkbar" aria-valuemin="0" aria-valuemax="100" style="width:100%;display:none">
				<div class="bar" style="width:50%">
				</div>
			</div>
<div id="msg">
</div>
      </div>
      <div class="modal-footer" >
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <button type="button" class="btn btn-primary" onclick="checkurl()">Check</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div>
</div>
<!--Modal Ends-->
<div id="accessModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <h3 id="myModalLabel"> Your Access Codes : </h3>
  </div>
  <div class="modal-body" id="accessmodalbody">
    <p>One fine body</p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>
<!--Modal Ends-->
<!-- Reminder Modal-->
<div id="remModal" class="modal hide fade" data-backdrop="true" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <h4 id="myModalLabel"> Set Reminder :  </h4>
  </div>
  <div class="modal-body" id="remBody">
  You will be Notified By Mail..
    <p>
    <textarea style="width:70%" placeholder ="Paste Your URL And Reminder Text Here" id="Remid" required></textarea>
    <br>
    <div class="input-append date" id="dp3" data-date="2014-01-01" data-date-format="yyyy-mm-dd">
  <input class="span2" size="16" type="text" value="2014-01-01" id="remdate">
  <span class="add-on"><i class="icon-th"></i></span>
</div>
    </p>
  </div>
  <div class="modal-footer">
  
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
        <button type="button" class="btn btn-primary" onclick="setReminder()">Set Reminder</button>
  </div>
</div>
<!--Modal Ends-->

<!--Credit Modal-->
<div id="creditModal" class="modal hide fade" data-backdrop="true" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
   <button type="button" class="close"  data-dismiss="modal" aria-hidden="true">&times;</button>
    <h4 id="myModalLabel"> Credits :  </h4>
    
  </div>
  <div class="modal-body" id="remBody">
  
    <p class="text-center muted">
    <img src="img/logo.png"><br><br>
    developed by :
    <div class="text-center lead">
    Karthik K
    </div><center>
    <small class="text-center"><a href="http://pec.edu/" target="_blank">Pondicherry Engineering College</a></small></center><br><br>
    <div class="text-center lead muted">
    Special Thanks to :
    </div>
    <div class="text-center">
    <a href="http://jquery.com/" target="_blank">JQuery</a>
    </div>
    <div class="text-center">
    <a href="http://getbootstrap.com/" target="_blank">Twitter BootStrap</a>
    </div>
    <div class="text-center">
    <a href="http://IconArchive.com/" target="_blank">IconArchive.com</a>
    </div>
    <div class="text-center">
    <a href="https://github.com/HubSpot/messenger" target="_blank">Messenger</a>
    </div>
     <div class="text-center">
    <a href="https://www.mywot.com" target="_blank">MyWot</a>
    </div>
    <div class="text-center">
    <a href="  https://github.com/googledrive/cors-upload-sample" target="_blank">Cors Uploader</a>
    </div>
  
    </p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
  </div>
</div>
<!--Modal Ends-->
<!-- Reminder Calendar-->
<script type="text/javascript">
var d = new Date();
 var today=d.getFullYear()+"-"+(d.getMonth()+1)+"-"+d.getDate();
 $('#remdate').val(today);
  $('#dp3').attr("data-date",today);
  $('#dp3').datepicker();
  function setReminder()
  {
  	if($('#Remid').val()!="")
  	{
  	handleAuthClick();
  	}
  	else
  	{
  	alert('Reminder Field is Empty!!');
  	}
  }
</script>
<!--Calendar ends-->
<div id="dvLoading" style="height:100%;width:100%;background-color:#ffffff;position:absolute;top:0%;left:0%"></div>

</body>
</html>
