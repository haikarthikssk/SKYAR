
<%@ page import="com.google.appengine.api.datastore.*,com.google.appengine.api.users.*" %>
<%
String Action=request.getParameter("Action");
String Key=request.getParameter("Key");
String lat=request.getParameter("Lat");
String lon=request.getParameter("Lon");
String Data=request.getParameter("Status");
String Url=request.getParameter("URL");
String Title=request.getParameter("Title");
String Category=request.getParameter("Category");
if(Action!=null&&Action.equals("DStatus")&&Key!=null&&Data!=null)
{
		try
		{
		int i=Integer.parseInt(Data);
		Query q=new Query("AccessCode");
		q.addFilter("code",Query.FilterOperator.EQUAL,Key);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
			result.setProperty("status",Data);
			datastore.put(result);
			out.println("Ok.");
			}
		}
		catch(Exception e)
		{
		out.println("Error in supplied Data!!");
		}
}
else if(Action!=null&&Action.equals("GStatus")&&Key!=null&&lat!=null&&lon!=null)
{
	
	try
		{
		Query q=new Query("AccessCode");
		q.addFilter("code",Query.FilterOperator.EQUAL,Key);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
			result.setProperty("lat",lat);
			result.setProperty("lon",lon);
			datastore.put(result);
			out.println("Ok.");
			}
		}
		catch(Exception e)
		{
		out.println("Error in supplied Data!!");
		}
}
else if(Action!=null&&Action.equals("RSS")&&Title!=null&&Category!=null&&Url!=null&&!Title.equals("")&&!Url.equals("")&&!Category.equals(""))
{
	UserService userService = UserServiceFactory.getUserService();
	if(userService.isUserLoggedIn())
	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Entity down=new Entity("UserRss");
  		down.setProperty("url",Url);
  		down.setProperty("category",Category);
  		down.setProperty("title",Title);
  		down.setProperty("userid",request.getUserPrincipal().getName());
  		datastore.put(down);
  		out.println("Rss Saved");
	}
	else
	{
		out.println("Please Login!!");
	}
}
else if(Action!=null&&Action.equals("DELRSS")&&Category!=null&&Url!=null&&!Url.equals("")&&!Category.equals(""))
{
	UserService userService = UserServiceFactory.getUserService();
	if(userService.isUserLoggedIn())
	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		String x="";
		Query q=new Query("UserRss");
		q.addFilter("url",Query.FilterOperator.EQUAL,Url);
		q.addFilter("category",Query.FilterOperator.EQUAL,Category);
		q.addFilter("userid",Query.FilterOperator.EQUAL,request.getUserPrincipal().getName());
		PreparedQuery pq = datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
		datastore.delete(result.getKey());
		out.println("OK");
		}
	}
	else
	{
		out.println("Please Login!!");
	}
}
else if(Action!=null&&Action.equals("GETALLRSS"))
{
	UserService userService = UserServiceFactory.getUserService();
	if(userService.isUserLoggedIn())
	{
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		String x="";
		Query q=new Query("UserRss");
		q.addFilter("userid",Query.FilterOperator.EQUAL,request.getUserPrincipal().getName());
		PreparedQuery pq = datastore.prepare(q);
		out.println("<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>\n<opml version=\"1.0\">\n<opml>");
		out.println("<head>\n<ownerEmail>"+request.getUserPrincipal().getName()+"</ownerEmail>\n</head><body>");
		for (Entity result : pq.asIterable()) {
		out.println("<outline text=\""+(String)result.getProperty("title")+"\" xmlUrl= \""+(String)result.getProperty("url")+"\"/>");
		}
		out.println("</body></opml>");
	}
	else
	{
		out.println("Please Login!!");
	}
}
%>