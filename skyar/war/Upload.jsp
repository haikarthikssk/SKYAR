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
	 <script type="text/javascript" src="https://www.google.com/jsapi"></script>
	<script type="text/javascript" src="js/messenger.js"></script>
    <meta http-equiv="Content-type" content="text/html;charset=UTF-8">
    <style>
    #drop_zone {
      border: 2px dashed #bbb;
      -moz-border-radius: 5px;
      -webkit-border-radius: 5px;
      border-radius: 5px;
      padding: 25px;
      text-align: center;
      font: 20pt bold 'Helvetica';
      color: #bbb;
    }
    </style>
  </head>
  <body>
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
      <li class="active"><a href="#">Backup</a></li>
      <li><a href="skyarena-how-to.jsp">How-to</a></li>
      </ul>
      <%UserService userService = UserServiceFactory.getUserService();%>
       <ul class="nav pull-right"><li><a href="<%=userService.createLogoutURL("../index.html")%>">Logout</a></li></ul>
    
  </div>
</div>
<div class="muted"><span class="text-success">*Upload your files Directly to Google Drive.</span></div>
     <button class="btn" onclick="go()"><span class="icon-download-alt"></span> Backup My Feeds</button>

      <span id="signin">
        <button 
          class="btn g-signin"
          data-callback="signinCallback"
          data-clientid="1034053278413.apps.googleusercontent.com"
          data-cookiepolicy="single_host_origin"
          data-scope="https://www.googleapis.com/auth/drive.file"><span class="icon-arrow-up"></span> Upload My File To Google Drive
        </button>
      </span>

      <div id="drop_zone" style="display:none;">Drop files here to upload to Google Drive</div>
     
     <script src="js/upload.js"></script>
     <script type="text/javascript">
     
       var accessToken = null;
       
       /**
        * Callback for G+ Sign-in. Swaps views if login successful.
        */
       function signinCallback(result) {
           if(result.access_token) {
               accessToken = result.access_token;
               document.getElementById('signin').style.display = 'none';
               document.getElementById('drop_zone').style.display = null;
           }
       }
 
       /**
        * Called when files are dropped on to the drop target. For each file,
        * uploads the content to Drive & displays the results when complete.
        */
       function handleFileSelect(evt) {
         evt.stopPropagation();
         evt.preventDefault();

         var files = evt.dataTransfer.files; // FileList object.
         
         var output = [];
          reportUser("Preapring to Upload!","info","single");
         for (var i = 0, f; f = files[i]; i++) {
             var uploader = new MediaUploader({
                 file: f,
                 token: accessToken,
                 onComplete: function(data) {
                     var obj = jQuery.parseJSON( data);                     
                     reportUser("File "+obj.title+" Uploaded Successfully!!","success","single");
                 },
                 onError:function(data){
                 reportUser("Upload Encountered an Error!!","error","25");}
             });
             uploader.upload();
         }
       }

       /**
        * Dragover handler to set the drop effect.
        */
       function handleDragOver(evt) {
         evt.stopPropagation();
         evt.preventDefault();
         evt.dataTransfer.dropEffect = 'copy'; 
       }

       /**
        * Wire up drag & drop listeners once page loads
        */
       document.addEventListener('DOMContentLoaded', function () {
           var dropZone = document.getElementById('drop_zone');
           dropZone.addEventListener('dragover', handleDragOver, false);
           dropZone.addEventListener('drop', handleFileSelect, false);
       });

     </script>
     <script src="https://apis.google.com/js/client:plusone.js"></script>
     <script type="text/javascript">
function reportUser(data,stype,single)
{
var hide=5;
if(single!='single')
hide=single;
Messenger.options = {
  'extraClasses': 'messenger-fixed messenger-on-bottom messenger-on-left',theme: 'air'
};
Messenger().post({
  message: data,
  hideAfter: hide,
  type:stype,
   id: single,
  showCloseButton: true
});
}
function go()
{
	$.get("setData.jsp?Action=GETALLRSS",null,function(data){download("SKYARENA.opml",data.trim());reportUser("Backup File Generated!","success","single");});
}
function download(filename, text) {
    var pom = document.createElement('a');
    pom.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
    pom.setAttribute('download', filename);
    document.body.appendChild(pom);
    pom.click();
	document.body.removeChild(pom)

}
</script>

  </body>
</html>