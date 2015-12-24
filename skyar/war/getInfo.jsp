<%@ page import="com.google.appengine.api.datastore.*,com.google.appengine.api.users.*"%>

<%
String Action=request.getParameter("Action");
String url=request.getParameter("URL");
if(Action!=null&&!(Action.equals("")))
{
	if(Action.toUpperCase().equals("INFO"))
	{
	try
	{
		UserService userService = UserServiceFactory.getUserService();
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		Query q=new Query("download");
		q.addFilter("userid",Query.FilterOperator.EQUAL,request.getUserPrincipal().getName());
		PreparedQuery pq = datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
			 Query q2=new Query("urlids");
			 q2.addFilter("Id",Query.FilterOperator.EQUAL,result.getProperty("urlid"));
				PreparedQuery pq2 = datastore.prepare(q2);
			 for (Entity result2 : pq2.asIterable()) {
			 out.println((String)result2.getProperty("url")+"{");
			 out.println(Integer.parseInt((String)result.getProperty("size"))/1024/1024+" MB}");
			 }
			}
		
	}
	catch(Exception e)
	{
		out.println(e.getMessage());
	}
	}
	else if(Action.toUpperCase().equals("ACCESSCODE")&&(url!=null)&&(!url.equals("")))
	{
		try
		{
		UserService userService = UserServiceFactory.getUserService();
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		
		Query q=new Query("urlids");
		q.addFilter("url",Query.FilterOperator.EQUAL,url);
		PreparedQuery pq = datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
			 Query q2=new Query("download");
			 q2.addFilter("urlid",Query.FilterOperator.EQUAL,result.getProperty("Id"));
			 q2.addFilter("userid",Query.FilterOperator.EQUAL,request.getUserPrincipal().getName());
			 PreparedQuery pq2 = datastore.prepare(q2);
			 for (Entity result2 : pq2.asIterable()) {
			  Query q3=new Query("AccessCode");
			 q3.addFilter("downloadid",Query.FilterOperator.EQUAL,result2.getProperty("idno"));
			  PreparedQuery pq3 = datastore.prepare(q3);
			 for (Entity result3 : pq3.asIterable()) {
			 out.println((String)result3.getProperty("code")+"<br>");
			 
			 }
			 }
			}
		}
		catch(Exception e)
		{
		}
	}
else if(Action.toUpperCase().equals("DELETE")&&(url!=null)&&(!url.equals("")))
	{
	try
	{
	//PersistenceManager pm = PMF.get().getPersistenceManager();
	UserService userService = UserServiceFactory.getUserService();
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		String x="";
		Query q=new Query("urlids");
		q.addFilter("url",Query.FilterOperator.EQUAL,url);
		PreparedQuery pq = datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
		x=(String)result.getProperty("Id");
		}
		q=new Query("download");
		q.addFilter("urlid",Query.FilterOperator.EQUAL,x);
		q.addFilter("userid",Query.FilterOperator.EQUAL,request.getUserPrincipal().getName());
		pq=datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
		x=(String)result.getProperty("idno");
		datastore.delete(result.getKey());
		}
		q=new Query("AccessCode");
		q.addFilter("downloadid",Query.FilterOperator.EQUAL,x);
		pq=datastore.prepare(q);
		for (Entity result : pq.asIterable()) {
		datastore.delete(result.getKey());
		}
		out.println("Data deleted");
	}
	catch(Exception e)
	{
	}	
	}
}
%>
