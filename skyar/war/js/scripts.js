  var clientId = '1034053278413.apps.googleusercontent.com';
      var apiKey = 'YOUR_API_KEY';
      var scopes = 'https://www.googleapis.com/auth/calendar';
    
      // Use a button to handle authentication the first time.
      function handleClientLoad() {
        gapi.client.setApiKey(apiKey);
        window.setTimeout(checkAuth,1);
      }

      function checkAuth() {
        gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: true}, handleAuthResult);
      }


      function handleAuthResult(authResult) {;
        if (authResult && !authResult.error) {
        	if($('#Remid').val()!="")
        	makeInsertApiCall();
        } else {
        }
      }

      function handleAuthClick(event) {
        gapi.auth.authorize({client_id: clientId, scope: scopes, immediate: false}, handleAuthResult);
        return false;
      }

      function makeInsertApiCall() {
       gapi.client.load('calendar', 'v3', function() {
         var request = gapi.client.calendar.events.insert({
           "calendarId": "primary","sendNotifications":true,
           resource:{
               "summary": $('#Remid').val(),
               "start": {
                 "date": $('#remdate').val()
               },
               "end": {
                 "date":  $('#remdate').val()
               }
             }
         });
              
         request.execute(function(resp) {
           if(resp.status=="confirmed")
        	   {
        	   alert("Reminder has been Set!");
        	   }
         });
       });
     }
    