
<%@ page import="com.google.appengine.api.users.*"%>
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
  <meta name="author" content="">

	<!--link rel="stylesheet/less" href="less/bootstrap.less" type="text/css" /-->
	<!--link rel="stylesheet/less" href="less/responsive.less" type="text/css" /-->
	<!--script src="js/less-1.3.3.min.js"></script-->
	
	<link href="css/bootstrap.min.css" rel="stylesheet">
	<link href="css/bootstrap-responsive.min.css" rel="stylesheet">
	<link href="css/elusive-webfont.css" rel="stylesheet">	
	<link rel="shortcut icon" href="img/favicon.png">
  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
  <![endif]-->
  <link rel="shortcut icon" href="img/favicon.png">
  
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	</head>

<body>
<div class="container-fluid">
	<div class="row-fluid">
		<div class="span12">
			<div class="row-fluid">
				<div class="span12">
					<h3 class="text-info text-center">
						<div>
							  <!--<span>SKYAR</span>--><img style="height:80px"src="/img/logo.png">
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
								<li>
									<a href="Interface.jsp">Home</a>
								</li>
								<li  class="active">
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
											<a href="#">Feedback Form</a>
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
			<!-- navbar ends-->
			<div class="span12">
			<h3 class="text-info">Steps:
			</h3><blockquote>
			<p class="lead text-left text-info">
			Register:</p>
			<p>
			1.Copy the url you wish to download.<br>
			2.Login to <a href="Interface.jsp" target="_blank">SKYAR.</a><br>			
			3.Click the "add new download" button.<br>
			4.A new Dialog box will appear.<br>
			5.Paste your URL in the URL box.<br>
			6.Enter how many users are going to download the file in the "No Of Segments" Box.<br>
			7.Check "Private Mode" ,if you don't want other Skyarers to find you.<br>
			8.Check "Search For Nearby Downloader" , if you want to Join with Other Skyarers.<br>
			9.If you download requires login information ,check the Cookies checkbox and paste the cookie in the cookie box.<br>
			10.Press the "Check" button.<br>
			11.SKYAR will report you with the download info.<br>
			12.Click the "Register" button.<br>
			13.SKYAR will register your download and access code will be shown to you.<br>
			14.Distribute these access code to your friends.<br>
			15.You can also distribute it with SKYAR itself by hover your mouse over the access code.<br>
			
			</p>
			</blockquote>
			<blockquote>
			<p class="lead text-left text-info">
			Download:</p><p class="text-left text-warning">Make sure you have Java installed.</p>
			<p>
			1.Navigate to download <a href="download.jsp" target="_blank">Page</a><br>
			2.Paste the Invitation Key you received in the text box.<br>
			3.Press the "Download" button.<br>
			4.An Java applet will load.<br>
			5.Allow it to Run.<br>
			6.Press "Download" button.<br>
			7.Choose the Directory you wish to save the file.<br>
			8.Wait till the download Completes.<br>
			9.A file with the ".KAR" extension will be saved on the Directory
			</p>
			</blockquote>
			<blockquote>
			<p class="lead text-left text-info">
			Merge:</p><p class="text-left text-warning">Make sure you have Java installed.</p>
			<p>
			1.Gather all the download ".Kar" files into single directory.<br>
			2.Navigate to Joiner <a href="Joiner.jsp" target="_blank">Page</a><br>
			3.Allow the applet to run.<br>
			4.Press "Join" button.<br>
			5.Choose the Directory where the gathered files are.<br>
			6.Enter the output filename with extension.<br>
			7.Wait until you get "Write Complete" message.<br>
			8.Done.
			</p>
			</blockquote>
			</div>
</body>
</html>
	