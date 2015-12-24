# SKYAR
### Finalist of google Cloud Developer challenge 2013.


##### !Replace 'YOUR_API_KEY' with your api key.
This app SKYAR is developed to download large file in low bandwidth areas. This allows a group of users to download different parts of same file at different places and allow them to join it later. This app gives them an ability to download a file very quickly. A group of 10 members can download the same 1 Gb file in less than an hour and join it within a minute. 

To download a file in multiple parts, an invitation key is created for each and every part of file and sent to multiple users. This key is used to identify the offset of file and to download that part of the file. The download can also be suspended and resumed. The invitation key is stored and validated using the Google Datastore API and can be shared through Gmail, Google Plus, Facebook, Twitter from the application itself. 



A skyarer has the option to join other skyarers in the same locality(within a range of 20 km) when downloading the same file. By forming a cluster of local skyarers , he can also reduce the downloading time of the whole file. A skyarer can also to stay out of the cluster by enabling Private Mode. In Private mode, the skyarer will not be visible to other skyarers in same locality. 

The skyarer who initiates the multi-part downloads can view the status of each piece of the download and location of other skyarers in the cluster using Google Maps and Charts API. 



To keep track of the future downloads, a skyarer can also set a reminder to notify about the downloads through email. 



In SkyArena, a Skyarer can monitor the latest form feeds of their desired website to know about the new downloads and they can also customize the look and feel of SkyArena. 



For providing safer downloads,every URL is checked by SKYAR for malware free content. 



### Intended Users: 

People having low bandwidth. 

People having multiple internet connection but restricted to download the data from single connection. 

People with limited bandwidth. 


### APIs Used:

Google Datastore API. 

Google + API. 

Gmail API 

Google Calendar API 

Google Feed Reader API 

Google Maps API 

Google Charts API 

Facebook API. 

Twitter API. 

MYWOT URL Scanner API

###[Live Version](http://gcdc2013-skyar.appspot.com)
