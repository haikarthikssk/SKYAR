<html lang="en">
<head>
<%@ page import="com.google.appengine.api.datastore.*,com.google.appengine.api.users.*" %>
  <meta charset="utf-8">
  <title>Sky Arena</title>
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
	<script type="text/javascript">
	var currentRss="";
	$(window).load(function(){
 		 $('#skyarenaloader').fadeOut(2000);
		});
	var canExecute=false;
	google.load("feeds", "1");
	function searchrss()
	{
	reportUser('Searching...','info',25);
	google.feeds.findFeeds($('#searchtxt').val(), findDone);
	}
	function findDone(result) {
  if (!result.error) {

    $('#feedArea').html('');
    var content = document.getElementById('feedArea');
    var html = '';
    for (var i = 0; i < result.entries.length; i++) {
      var entry = result.entries[i];
      html += '<p><a url="'+ entry.url + '" target="_blank" onclick="openUrl(this)" onmouseenter="showme(this)" onmouseleave="showme(this)">' + entry.title + '  <span class="el-icon-screenshot" onclick="editme(this)" style="display:none;"></span></a></p>';
    }
    content.innerHTML = html;
    Messenger().hideAll();
  }
}
var iter=0;
	function showme(x)
	{
		$(x).children("span").toggle();
	}
	function openUrl(x)
	{
	if(iter==1)
	{
	iter=0;}
	else
	window.open($(x).attr("url"));
	}
	function editme(x)
	{
		$('#rssurl').val($(x).parent().attr("url"));
		$('#rsstitle').val('');
		$('#rssModal').modal();
		iter=1;
	}
	function startup()
	{
		canExecute=true;
	}
	function delRSS()
	{
		$.get("setData.jsp?Action=DELRSS&URL="+currentRss+"&Category="+document.getElementById('rsssel').value,null,function(data){if(data!="")reportUser("Rss Deleted Successfully!!","success","single");location.reload();});
	}
	function loadFeeds(url)
	{
		currentRss=url;
		if(!canExecute)
		return false;
		reportUser('Loading Feeds....','info','single');
		var feed = new google.feeds.Feed(url);
		$('#feedArea').html('<div class="span4" style="width:97%;"><span>Showing Rss Feeds for <%if(request.getParameter("sel")!=null){out.print(request.getParameter("sel"));}%>    <span id="delbutton"></span></span></div>');
		
		$('#delbutton').html('<button class="btn" onclick="delRSS()">Delete this Feed</button>');
		feed.setNumEntries(15);
      feed.load(function(result) {
      if(result.error){Messenger().hideAll();reportUser('Error Loading Feeds....','error','25');}
        if (!result.error) {
          var container = document.getElementById("feedArea");
          for (var i = 0; i < result.feed.entries.length; i++) {
            var entry = result.feed.entries[i];
            var div = document.createElement("div");
            $(div).addClass("span4 offer offer-primary").css("width","97%");
            var div2=document.createElement("div");
             $(div2).addClass("shape");
            var div3=document.createElement("div");
             $(div3).addClass("shape-text");
              div3.innerHTML="<a href='#' style='color:#ffffff' onclick='$(this).parent().parent().parent().fadeOut();'>close </a>";
            var div5=document.createElement("div");
             $(div5).addClass("offer-content");
             var div6=document.createElement("h3");
             $(div6).addClass("lead");
            var div4=document.createElement("div");
             $(div4).addClass("span12");
             div6.appendChild(document.createTextNode(entry.title));
             div5.appendChild(div6);
              div5.innerHTML=div5.innerHTML+entry.contentSnippet.trim()+"<a href='"+entry.link+"' target='_blank'>Read More..</a>";
              div2.appendChild(div3);
              div.appendChild(div2);
              div.appendChild(div5);
              
              div.appendChild(div4);
            container.appendChild(div);
          }
        }
      });
	}
	google.setOnLoadCallback(startup);
	function saveRss()
	{
		var url="setData.jsp?Action=RSS&URL="+$('#rssurl').val()+"&Title="+$('#rsstitle').val()+"&Category="+document.getElementById('rsssel').value;
	$.get(url,null,function(data){if(data.trim()==""){alert('Error:Please Check All the Inputs');}else{reportUser(data.trim()+"  Reload to See the feed",'success','single');$('#rssModal').modal('toggle');}});
	}
	function effecton(x)
	{
		$(x).addClass("acchover");
	}
	function effectoff(x)
	{
		$(x).removeClass("acchover");
	}
	</script>
	</head>
<%
String selection=request.getParameter("sel");
RssList rss=null;
String category[]={"Apps","Games","Music","Videos","Ebooks","Other"};
UserService userService = UserServiceFactory.getUserService();
if(!userService.isUserLoggedIn())
{
	response.sendRedirect(userService.createLoginURL(request.getRequestURI()));
}
else if(selection!=null&&!selection.equals(""))
{
rss=getRssList(request.getUserPrincipal().getName(),selection);
}
%>
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
      <li class="active"><a href="#">Home</a></li>
      <li><a href="Upload.jsp">Backup</a></li>
      <li><a href="skyarena-how-to.jsp">How-to</a></li>
    </ul>
    <ul class="nav pull-right"><li><a href="<%=userService.createLogoutURL("../index.html")%>">Logout</a></li></ul>
  </div>
</div>
<div class="row-fluid">
<div class="span3">

<form name="f">
    <select class="accbor" style="width:100%" name="sel" onChange="document.forms[0].submit()">
   <%
   	for(int x=0;x<category.length;x++)
   	{
   		if(selection!=null&&selection.equals(category[x]))
   		out.println("<option selected>"+category[x]+"</option>");
   		else
   		out.println("<option>"+category[x]+"</option>");
   	}
   %>
    </select>
    <a class="btn btn-info" data-toggle="modal" href="#rssModal">Add <span class="el-icon-rss"></span></a>
    <a class="btn btn-danger" onclick="$('#searchForm').toggle()">Search <span class="el-icon-rss"></span></a>
      </form>
      <form class="form-search" style="display:none" id="searchForm">
      <div class="input-append">
    <input type="text" id="searchtxt" class="search-query span11 ">
    <a class="btn" onClick="searchrss()">Search</a>
  </div>
  </form>
<div class="accordion">
  <div class="accordion-group">
    <div class="accordion-heading">
    <%
    if(rss!=null)
    {
    	for(int x=0;x<rss.Url.length;x++)
    	{
    		out.println("<div class=\"accordion-toggle accbor\" onclick=\"loadFeeds($(this).attr('src'));$('.accordion-toggle').children().removeClass('icon-ok').addClass('icon-chevron-right');$(this).children().removeClass('icon-chevron-right').addClass('icon-ok');\" onmouseenter=\"effecton(this)\" onmouseleave=\"effectoff(this)\" src=\""+rss.Url[x]+"\"><span class='icon-chevron-right pull-right'></span>");
    		out.println(rss.Title[x]);
    		out.println("</div>");
    	}
    }
    %>


    </div>
    </div>
    </div>
</div>
<div class="span9" id="feedArea">
<div class="span4" style="width:97%;">
<span>Showing Rss Feeds for <%if(selection!=null){out.println(selection);}%>
<span id="delbutton"></span>
</div>
</div>
</div>
</div>
<!-- Modal-->
<div id="rssModal" class="modal hide fade" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
  <div class="modal-header">
    <button type="button" class="close" data-dismiss="modal" aria-hidden="true">x</button>
    <h3 id="myModalLabel">Add RSS Feed</h3>
  </div>
  <div class="modal-body">
  	<p>Title : <input type="text" id="rsstitle"style="width:90%;height:30px;" placeholder ="Input Title Here.." required></p>
    <p>URL : <input type="text" id="rssurl" style="width:90%;height:30px;" placeholder ="Input Url Here.." required></p>
    <p>Category : <Select id="rsssel" style="width:84%;">
    <%
    for(int x=0;x<category.length;x++)
   	{
   		if(selection!=null&&selection.equals(category[x]))
   		out.println("<option selected>"+category[x]+"</option>");
   		else
   		out.println("<option>"+category[x]+"</option>");
   	}%>
   	<select></p>
  </div>
  <div class="modal-footer">
    <button class="btn" data-dismiss="modal" aria-hidden="true">Close</button>
    <button class="btn btn-primary" onclick="saveRss()">Save RSS</button>
  </div>
</div>
<!--Modal Ends-->
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
</script>
<div id="skyarenaloader" style="height:100%;width:100%;background-color:#ffffff;position:absolute;top:0%;left:0%"></div>

</body>
</html>
<%!
public RssList getRssList(String User,String Category)
{
		Query q=new Query("UserRss");
		RssList rlist=new RssList();
		q.addFilter("userid",Query.FilterOperator.EQUAL,User);
		q.addFilter("category",Query.FilterOperator.EQUAL,Category);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="";
		int y=0;
		rlist.Url=new String[pq.countEntities()];
		rlist.Title=new String[pq.countEntities()];
		for (Entity result : pq.asIterable()) {
			 rlist.Url[y]=(String)result.getProperty("url");
			 rlist.Title[y]=(String)result.getProperty("title");
			 y++;
			}
			if(y==0)
			return null;
			return rlist;
}
class RssList
{
String Url[];
String Title[];
}
%>