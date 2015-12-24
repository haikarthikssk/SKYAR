function scanURL(url,callme)
{
	var l = document.createElement("a");
    l.href = url;
 $.ajax({dataType: "json",async: false,url:'http://api.mywot.com/0.4/public_link_json2?hosts='+l.hostname+'/&key=YOUR_KEY',data:null, success : function(data) {
 var malicious=0;
	try
	{
$.each(data,function(i,item){$.each(data[i],function(x,items){if(items[0]<40){malicious++;}});});
	}
	catch(err)
	{
		callme(-1);
	}
	callme(malicious);
}});
}