
<%@ page import="com.google.appengine.api.users.*"%>
<html lang="en">
<head>
<%@ page import="com.google.appengine.api.datastore.*,com.google.appengine.api.users.*" %>
  <meta charset="utf-8">
  <title>Sky Arena Uploader</title>
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
	<link href="css/slides.css" rel="stylesheet">
	<link href="css/messenger.css" rel="stylesheet">
	<link href="css/messenger-theme-air.css" rel="stylesheet">
	<link rel="shortcut icon" href="img/favicon.png">
  <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
  <!--[if lt IE 9]>
    <script src="js/html5shiv.js"></script>
  <![endif]-->
  <link rel="shortcut icon" href="img/favicon.png">
  
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<script type="text/javascript" src="js/bootstrap.min.js"></script>
	<script type="text/javascript" src="js/messenger.js"></script>
	</head>

<body>
<div class="container-fluid">
<div class="span.5">
</div>
<div class="span12">
			<div class="row-fluid">
				<div class="span12">
					<h3 class="text-info text-center">
						<div>
							<!--<span>SKYAR</span>--><img style="height:120px"src="/img/skyarena.png">
						</div>
					</h3>
				</div>
				
			</div>
<div class="navbar" style="width:100%">
  <div class="navbar-inner">
    <a class="brand" href="#">SKYARENA</a>
    <ul class="nav">
      <li><a href="SkyArena.jsp?sel=Apps">Home</a></li>
      <li><a href="Upload.jsp">Backup</a></li>
      <li class="active"><a href="#">How-to</a></li>
      </ul>
      <% UserService userService = UserServiceFactory.getUserService();%>
       <ul class="nav pull-right"><li><a href="<%=userService.createLogoutURL("../index.html")%>">Logout</a></li></ul>
    
  </div>
</div>
			<div class="span12">
			<h3 class="text-info">SkyArena:
			</h3><blockquote>
			<p class="lead text-left text-info">
			Add:</p>
			<p>
			1.Copy the RSS Feed url you wish to Add.<br>
			2.Login to <a href="SkyArena.jsp" target="_blank">SKYARENA.</a><br>			
			3.Click the "Add" button.<br>
			4.A new Dialog box will appear.<br>
			5.Paste your URL in the URL box.<br>
			6.Give title for the feed.<br>
			7.Select the Category and click Save Rss.<br>
			8.A notification will appear after SKYAR registers your Feed. <br>
			9.Reload your page to see the Feed.<br>
			10.Click on the Feed to load the Feed's contents.
			</p>
			</blockquote>
			<blockquote>
			<p class="lead text-left text-info">
			Search:</p><p class="text-left muted">Google's Search Operators will also work.</p>
			<p>
			1.Login to <a href="SkyArena.jsp" target="_blank">SKYARENA.</a><br>
			2.Click the "Search" button.<br>
			3.A new text box will appear.<br>
			4.Enter the search query.<br>
			5.The results will be displayed.<br>
			6.Move the mouse over the results. An icon will be displayed at the left of the results.<br>
			7.Click to invoke the Add Dialog Box.<br>
			8.Follow steps as in ADD Section.<br>
			9.You can also click the result to see its contents.
			</p>
			</blockquote>
			<blockquote>
			<p class="lead text-left text-info">
			Upload:</p><p class="text-left muted">Upload Files directly to your Google Drive.</p>
			<p>
			1.Navigate to Uploader <a href="Upload.jsp" target="_blank">Page</a><br>
			2.Click Sign-in button.<br>
			3.Give Access To SKYAR.<br>
			4.Now a Drag & Drop Area Will be Shown.<br>
			5.You can Directly Drag and Drop Files from Your Desktop.<br>
			6.These dropped files will be automatically uploaded to Google Drive.<br>
			8.A Notification Will Appear after Upload Completes.
			</p>
			</blockquote>
			</div>
</body>
</html>
	