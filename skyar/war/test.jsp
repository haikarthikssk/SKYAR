<%@page import="java.net.*,java.io.*,java.util.*,java.security.*"%>
<%@ page import="com.google.appengine.api.datastore.*,com.google.appengine.api.users.*" %>
<%@page import="java.util.Properties,javax.mail.*,javax.mail.Transport,javax.mail.internet.*"%>
<%
try
{
String url=request.getParameter("url");
String Split=request.getParameter("Split");
String Register=request.getParameter("Register");
String Cookie=request.getParameter("Cookie");
String Application_Type="";
boolean Resumable=false;
String Lat=request.getParameter("Lat");
String Lon=request.getParameter("Lon");
String Nearby=request.getParameter("nearby");
String Notify=request.getParameter("Notify");
int Private_mode=0;
Long Size=0L;
String urlid="";
Random rnd;
int Downloadid=0;
String User=null;
UserService userService = UserServiceFactory.getUserService();
if(request.getParameter("Private")!=null&&request.getParameter("Private").equals("true"))
{
Private_mode=1;
}
if(userService.isUserLoggedIn())
{
User=request.getUserPrincipal().getName();
}

// User Service Check


try
{
if(User==null)
{
out.println("Error: Please Login In");
}
else if(url!=null)
{
URL oracle = new URL(url);
        HttpURLConnection yc =(HttpURLConnection) oracle.openConnection();
		//yc.setFollowRedirects(true);
		yc.setRequestMethod("HEAD");
        BufferedReader in = new BufferedReader(new InputStreamReader(
                                    yc.getInputStream()));
		//out.println(URLConnection.guessContentTypeFromStream(yc.getInputStream()));
		Application_Type=yc.getContentType();
		Size=new Long(yc.getContentLength());
		
		/*FetchOptions options = FetchOptions.Builder
				.doNotFollowRedirects()
				.allowTruncate();
				HTTPRequest reques = new HTTPRequest(new URL("http://localhost/KS/foxit.exe"), HTTPMethod.GET, options);
				URLFetchService service = URLFetchServiceFactory.getURLFetchService();
				HTTPResponse respons = service.fetch(reques);
				List<HTTPHeader> h=respons.getHeaders();
				for(HTTPHeader g:h)
				{
					if(g.getName().equals("Content-Length"))
					Size=Long.parseLong(g.getValue());
					if(g.getName().equals("Content-Type"))
					Application_Type=g.getValue();
				}*/
		
		Resumable=in.markSupported();
		//Latitude Check
		if(Lat==null||Lat.equals("")||Lon==null||Lon.equals("")||Lat.equals("0"))
		{
		
		String temp=request.getHeader("X-AppEngine-CityLatLong");
		String x[]=temp.split(",");
			Lat=x[0];
			Lon=x[1];
			/*
			Random r=new Random(100);
			Lat=(r.nextFloat()*100)+"";
			Lon=(r.nextFloat()*100)+"";*/
		}
		if(Register==null)
		{
		out.println("Application-TYPE:"+Application_Type+";");
		out.println("Size:"+((Size/1024)/1024)+" MB;");
		out.println("Resumable:"+Resumable+";");
		if(Nearby!=null&&Nearby.equals("true"))
		{
			if(nearbyUsers(url,User,Lat,Lon,Notify)==1)
			{
				out.println("Nearby Downloaders:Found;^");
			}
			else
			out.println("Nearby Downloaders:None;^");
		}
		}
		if(!Resumable)
		{
				out.println("Error: Resume Not Supported By the Server");
		}
		if(Split!=null&&(Integer.parseInt(Split)>10))
		{	
				out.println("Error: Split can't be More than 10");
				Resumable=false;
		}
		if(Size<0&&Register==null)
		{
			out.println("Application-TYPE:"+Application_Type+";");
			out.println("Size: Can't determine Length;");
			out.println("Resumable:"+Resumable+";^");
			//Resumable=false;
		}
		if(Register!=null&&Register.equals("true")&&Split!=null&&Resumable)
		{
			urlid=addURLId(url);
			String idno=addDownload(User,urlid,"NONE",Split,Size+"",Private_mode+"",Lat,Lon);
			if(!idno.equals("Download Already Exists!!"))
	{
	AccessCode ds=generateCodes(idno,Split);
	for(int g=0;g<Integer.parseInt(Split);g++)
	{
		out.println(ds.Codes[g]+"<br>");
	}
	}
	else
	{
		out.println("Error !! Download already Exists");
	}
			
		}
       
       /*  String inputLine;
	   while ((inputLine = in.readLine()) != null) 
        out.println(inputLine);
        in.close();*/
}
}
catch(Exception e)
{
	out.println("Error: "+e.getMessage());
}
}
catch(Exception e)
{
out.println("Error: "+e.getMessage());
}
%>
<%!

public String isAvailable(String url)
	{
		try
		{
		Query q=new Query("urlids");
		q.addFilter("url",Query.FilterOperator.EQUAL,url);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="NO";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("Id");
			}
		return x;
		}
		catch(Exception e)
		{
			return "NO";
		}
		
	}
	public int generateNum()
	{
		Random r=new Random();
		int temp1;
		while(true)
		{
		Query q=new Query("urlids");
		temp1=r.nextInt(10000);
		q.addFilter("Id",Query.FilterOperator.EQUAL,temp1+"");
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="NO";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("Id");
			}
			if(x.equals("NO"))
			{
			return temp1;
			//break;
			}
		
			}
	}
	public String addURLId(String URL)
	{
	String id=isAvailable(URL);
	if(!id.equals("NO"))
	{
		return id;
	}
	DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
	Entity down=new Entity("urlids");
  	down.setProperty("url",URL);
  	String Ids=generateNum()+"";
  	down.setProperty("Id",Ids+"");
  	datastore.put(down);
  	return Ids;
	}
	public String isDownloadAvailable(String user,String urlid)
	{
		try
		{
		Query q=new Query("download");
		q.addFilter("userid",Query.FilterOperator.EQUAL,user);
		q.addFilter("urlid",Query.FilterOperator.EQUAL,urlid);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="NO";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("urlid");
			 return "YES";
			}
		return x;
		}
		catch(Exception e)
		{
			return "NO";
		}
	}
	public int generateDownloadNumber()
	{
	Random r=new Random();
		int temp2;
		while(true)
		{
		Query q=new Query("download");
		temp2=r.nextInt(10000);
		q.addFilter("idno",Query.FilterOperator.EQUAL,temp2);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="NO";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("idno");
			}
			if(x.equals("NO"))
			{
			return temp2;
			}
		
			}
	}
	public String addDownload(String userid,String urlid,String Cookie,String splits,String size,String private_mode,String Lat,String Lon)
	{
	try
	{
		if(!isDownloadAvailable(userid,urlid).equals("NO"))
		{
			return "Download Already Exists!!";
		}
		
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Entity down=new Entity("download");
		int temp3=generateDownloadNumber();
  		down.setProperty("idno",temp3+"");
  		down.setProperty("userid",userid);
  		down.setProperty("urlid",urlid);
  		down.setProperty("cookie",Cookie);
  		down.setProperty("splits",splits);
  		down.setProperty("size",size);
  		down.setProperty("lat",Lat);
  		down.setProperty("lon",Lon);
  		down.setProperty("private",private_mode);
  		datastore.put(down);
  		return temp3+"";
  		}
  		catch(Exception e)
  		{
  			return "Error";
  		}
	}
	public String isAccessAvailable(String code)
	{
	try
		{
		Query q=new Query("AccessCode");
		q.addFilter("code",Query.FilterOperator.EQUAL,code);
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		PreparedQuery pq = datastore.prepare(q);
		String x="NO";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("code");
			 return "YES";
			}
		return x;
		}
		catch(Exception e)
		{
			return "NO";
		}
	
	}
	public AccessCode generateCodes(String downloadid,String Length)
	{
		int iteration=0;
		int length=Integer.parseInt(Length);
		String pool="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
		StringBuilder sb;
		Random rnd=new SecureRandom();
		AccessCode ac=new AccessCode(length);
		while(iteration<length)
		{
			sb=new StringBuilder(10);
				for(int j=0;j<8;j++)
				{
					sb.append( pool.charAt( rnd.nextInt(pool.length()) ) );
				}
				if(isAccessAvailable(sb.toString()).equals("NO"))
				{
					DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
					Entity down=new Entity("AccessCode");
  					down.setProperty("code",sb.toString());
  					down.setProperty("segment",iteration+"");
  					down.setProperty("downloadid",downloadid);
  					down.setProperty("status","1");
  					down.setProperty("lat","0");
  					down.setProperty("lon","0");		
  					datastore.put(down);
					ac.Codes[iteration]=sb.toString();
					iteration++;
				}
		}
		return ac;
	}
	public int nearbyUsers(String url,String user,String slat,String slon,String Notify)
{
try
{
		int res=0;
		DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
		Query q;
		PreparedQuery pq;
		 q=new Query("urlids");
		q.addFilter("url",Query.FilterOperator.EQUAL,url);
		 pq = datastore.prepare(q);
		String x="0";
		for (Entity result : pq.asIterable()) {
			 x=(String)result.getProperty("Id");
			 }
			q=new Query("download");
			q.addFilter("urlid",Query.FilterOperator.EQUAL,x);
		q.addFilter("userid",Query.FilterOperator.NOT_EQUAL,user);
		q.addFilter("private",Query.FilterOperator.EQUAL,"0");
		pq = datastore.prepare(q);
		String Lat="",Lon="";
		for(Entity result:pq.asIterable())
		{
			 x=(String)result.getProperty("userid");
			 Lat=(String)result.getProperty("lat");
			 Lon=(String)result.getProperty("lon");
			 System.out.println(distFrom(Double.parseDouble(slat),Double.parseDouble(slon),Double.parseDouble(Lat),Double.parseDouble(Lon)));
			if(distFrom(Double.parseDouble(slat),Double.parseDouble(slon),Double.parseDouble(Lat),Double.parseDouble(Lon))<20)
			{
			res=1;
			if(Notify==null||Notify.equals(""))
			return 1;
			else
			{
				sendMail(x,user,url);
			}
			}
			}
		return res;
		
			 }
			 catch(Exception e)
			 {
			 return -1;
			 }
}	
public double distFrom(double lat1, double lon1, double lat2, double lon2) {
  double a = 6378137, b = 6356752.314245, f = 1 / 298.257223563; // WGS-84 ellipsoid params
    double L = Math.toRadians(lon2 - lon1);
    double U1 = Math.atan((1 - f) * Math.tan(Math.toRadians(lat1)));
    double U2 = Math.atan((1 - f) * Math.tan(Math.toRadians(lat2)));
    double sinU1 = Math.sin(U1), cosU1 = Math.cos(U1);
    double sinU2 = Math.sin(U2), cosU2 = Math.cos(U2);

    double sinLambda, cosLambda, sinSigma, cosSigma, sigma, sinAlpha, cosSqAlpha, cos2SigmaM;
    double lambda = L, lambdaP, iterLimit = 100;
    do {
        sinLambda = Math.sin(lambda);
        cosLambda = Math.cos(lambda);
        sinSigma = Math.sqrt((cosU2 * sinLambda) * (cosU2 * sinLambda)
                + (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) * (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda));
        if (sinSigma == 0)
            return 0; // co-incident points
        cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
        sigma = Math.atan2(sinSigma, cosSigma);
        sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
        cosSqAlpha = 1 - sinAlpha * sinAlpha;
        cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
        if (Double.isNaN(cos2SigmaM))
            cos2SigmaM = 0; // equatorial line: cosSqAlpha=0 (§6)
        double C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
        lambdaP = lambda;
        lambda = L + (1 - C) * f * sinAlpha
                * (sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM)));
    } while (Math.abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);

    if (iterLimit == 0)
        return Double.NaN; // formula failed to converge

    double uSq = cosSqAlpha * (a * a - b * b) / (b * b);
    double A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
    double B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
    double deltaSigma = B
            * sinSigma
            * (cos2SigmaM + B
                    / 4
                    * (cosSigma * (-1 + 2 * cos2SigmaM * cos2SigmaM) - B / 6 * cos2SigmaM
                            * (-3 + 4 * sinSigma * sinSigma) * (-3 + 4 * cos2SigmaM * cos2SigmaM)));
    double dist = b * A * (sigma - deltaSigma);

    return dist/1000;
    }

public void sendMail(String toMailId,String fromMailId,String Url)
{
if(!toMailId.equals(fromMailId))
{
Properties props = new Properties();
        //session = Session.getDefaultInstance(props, null);

        String msgBody = fromMailId+" is also downloading the file from url : "+Url+"  .He wish to share the downloading with you. If you wish to do so ,you can reply him via "+fromMailId;

        try {
            Message msg = new MimeMessage(Session.getDefaultInstance(props, null));
            msg.setFrom(new InternetAddress("InviteSkyar@gmail.com", "Download Request"));
            msg.addRecipient(Message.RecipientType.TO,
                             new InternetAddress(toMailId, "Dear Skyar User"));
            msg.setSubject("Request for Sharing Your Download");
            msg.setText(msgBody);
            Transport.send(msg);

        } catch (Exception e) {
        
         // System.out.println(e.getMessage());
        }
        }
}
%>
<%!
class AccessCode
{
	public String Codes[];
	public AccessCode(int x)
	{
		Codes=new String[x];
	}
}

%>