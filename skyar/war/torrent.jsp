
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
								<li>
									<a href="how-to.jsp">How-To</a>
								</li>
								<li>
									<a href="future-work.jsp">Future Works</a>
								</li>
								<li  class="active">
									<a href="torrent.jsp">Torrent</a>
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
			<div class="span12"><blockquote>
			<p class="lead text-left text-warning">
			Currently SKYAR doesn't support Torrent!</p><small class="muted">Torrent version will be released soon</small></blockquote><br>But there is an <strong>alternative</strong>.
			<div id="zbigz" class="hero-unit">
			<h2 class="text-center text-success">Zbigz.com</h2>
			<p class="text-center muted">
			Zbigz.com allows the users to download torrent files via http.using SKYAR you can split the http download ..<a href="http://www.zbigz.com/page-how-it-works" target="_blank" >link to zbigz.com</a>
			</p>
			</div>
</body>
</html>
	