public with sharing class MyFitbitProfileController {
	
	public String serviceName = 'Fitforce';
	
	public String groupName = 'Fitbit Owners';
	
	public Boolean currentUserAuthed {get;set;}
	
	public String message { get; set; }
	
	public String bodyActivities { get; set; }
	
	public String bodySleep { get; set; }
	
	public Device device {get;set;}
	
	private OAuth_Token__c token;
	
	public string profileImageUrl { get; set; }
	
	public Sleep sleepToday {get; set;}
	
	public Map<String, Object> activitiesMap {get; set;}

	public Map<String, Object> profileMap {get; set;}

	public Map<String, Object> badgesMap {get; set;}
		
	public List<TimeSeriesEvent> mySleepingList {get; set;}
	
	public String fitbitGroupId {get; set;}
	
	public String calloutDate;

	public String profile {get; set;}

	public String badges {get; set;}
		
	public MyFitbitProfileController() {
		String userId = ApexPages.currentPage().getParameters().get('id');
		if(userId == null) {
			userId = UserInfo.getUserId();
		}
		calloutDate = ApexPages.currentPage().getParameters().get('date');
		if(calloutDate == null) {
			calloutDate = String.valueOf(Date.today());
		}			
		List<OAuth_Token__c> listTokens = [select Id, Fitbit_User_Id__c from OAuth_Token__c where owner__c =: userId limit 1];
		if(listTokens != null && listTokens.size() > 0) {
			token = listTokens.get(0);
			currentUserAuthed = true;
		} else {
			currentUserAuthed = false;
		}
		sleepToday = new Sleep();
		activitiesMap = new Map<String, Object>();
		mySleepingList = new List<TimeSeriesEvent>();
		profileImageUrl = [select FullPhotoUrl from User where Id =:userId].FullPhotoUrl;
		if([Select count() From CollaborationGroup where Name =: groupName] > 0)
		{
			fitbitGroupId = [Select Name, Id From CollaborationGroup where Name =: groupName limit 1].Id;	
		}		
	}

    public PageReference loadUserData() {
    	executeProfileGET();
    	executeDeviceGET();
    	executeBadgesGET();
    	executeActivitiesGET();
    	executeSleepGET();
    	executeMinutesAsleepOverTimeGET();
    	return null;
    }
    
    public PageReference writeToChatterStatus() {
    	User u = new User(Id = UserInfo.getUserId());
    	String status = 'Looks like ' + UserInfo.getName() + ' has just synced with the Fitbit. Check out the results!';
    	u.CurrentStatus = status;
    	update u;
    	
    	if(fitbitGroupId != null) {
			FeedItem post = new FeedItem();
			post.ParentId = fitbitGroupId;
			post.Body = status;
			post.Title = 'Click here to see!!';
			post.LinkUrl = URL.getSalesforceBaseUrl().toExternalForm() + Page.MyFitbitProfilePage.getUrl() + '?id=' + UserInfo.getUserId() + '&date=' + calloutDate;
			insert post; 
    	}
		return null;   	
    }

    public void executeProfileGET() {
    	if(currentUserAuthed) {
    		String url = 'http://api.fitbit.com/1/user/-/profile.json';
	    	String method = 'GET';
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        req.setTimeout(60000);
	        req.setMethod(method);
	        req.setEndpoint(url);
	        OAuth oa = new OAuth();
	        if(!oa.setService(serviceName)) {
	        	System.debug(oa.message);
	        	message=oa.message;
	        }
	        oa.sign(req);
	        HttpResponse res = h.send(req);
	        profile = res.getBody();	 
	        profileMap = (Map<String, Object>)JSON.deserializeUntyped(profile);
    	}
    }

    public void executeBadgesGET() {
    	if(currentUserAuthed) {
    		String url = 'http://api.fitbit.com/1/user/-/badges.json';
	    	String method = 'GET';
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        req.setTimeout(60000);
	        req.setMethod(method);
	        req.setEndpoint(url);
	        OAuth oa = new OAuth();
	        if(!oa.setService(serviceName)) {
	        	System.debug(oa.message);
	        	message=oa.message;
	        }
	        oa.sign(req);
	        HttpResponse res = h.send(req);
	        badges = res.getBody();	 
	        badgesMap = (Map<String, Object>)JSON.deserializeUntyped(badges);
    	}
    }
	
    public void executeDeviceGET() {
    	if(currentUserAuthed) {
	    	String url = 'https://api.fitbit.com/1/user/-/devices.json';
	    	String method = 'GET';
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        req.setTimeout(60000);
	        req.setMethod(method);
	        req.setEndpoint(url);
	        OAuth oa = new OAuth();
	        if(!oa.setService(serviceName)) {
	        	System.debug(oa.message);
	        	message=oa.message;
	        }
	        oa.sign(req);
	        HttpResponse res = h.send(req);
	        device = new Device(JSON.createParser(res.getBody()));	        
    	}
    }
    
    public void executeActivitiesGET() {
    	if(currentUserAuthed) {
	    	String url = 'http://api.fitbit.com/1/user/'+token.Fitbit_User_Id__c+'/activities/date/'+calloutDate+'.json';
	    	String method = 'GET';
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        req.setTimeout(60000);
	        req.setMethod(method);
	        req.setEndpoint(url);
	        OAuth oa = new OAuth();
	        if(!oa.setService(serviceName)) {
	        	System.debug(oa.message);
	        	message=oa.message;
	        }
	        oa.sign(req);
	        HttpResponse res = h.send(req);
	        bodyActivities = res.getBody();
			activitiesMap = (Map<String, Object>)JSON.deserializeUntyped(bodyActivities);
    	}
    } 
    
    public void executeSleepGET() {
    	if(currentUserAuthed) {
	    	String url = 'http://api.fitbit.com/1/user/'+token.Fitbit_User_Id__c+'/sleep/date/'+calloutDate+'.json';
	    	String method = 'GET';
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        req.setTimeout(60000);
	        req.setMethod(method);
	        req.setEndpoint(url);
	        OAuth oa = new OAuth();
	        if(!oa.setService(serviceName)) {
	        	System.debug(oa.message);
	        	message=oa.message;
	        }
	        oa.sign(req);
	        HttpResponse res = h.send(req);
	        try {
	        	sleepToday = (Sleep)JSON.deserializeStrict(res.getBody(),Sleep.class);
    	    } catch(Exception e) {
    	    	ApexPages.addMessages(e);
    		}
    	}
    } 
    
    public void executeMinutesAsleepOverTimeGET() {
    	if(currentUserAuthed) {
	    	String url = 'http://api.fitbit.com/1/user/'+token.Fitbit_User_Id__c+'/sleep/minutesAsleep/date/'+calloutDate+'/1w.json';
	    	String method = 'GET';
	        Http h = new Http();
	        HttpRequest req = new HttpRequest();
	        req.setTimeout(60000);
	        req.setMethod(method);
	        req.setEndpoint(url);
	        OAuth oa = new OAuth();
	        if(!oa.setService(serviceName)) {
	        	System.debug(oa.message);
	        	message=oa.message;
	        }
	        oa.sign(req);
	        HttpResponse res = h.send(req);
	        JSONParser parser = JSON.createParser(res.getBody());
			while (parser.nextToken() != null) {
	            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&  (parser.getText() == 'dateTime')) {
	                TimeSeriesEvent newSleep = new TimeSeriesEvent();
	                parser.nextToken();	    
	                newSleep.eventDate = parser.getDatetimeValue().formatLong();
	                parser.nextToken();
	                parser.nextToken();
	                newSleep.eventValue = parser.getText();
	                mySleepingList.add(newSleep);
	            }
        	}
    	}
    }
    
    public class TimeSeriesEvent {
    	public String eventDate {get;set;}
    	public String eventValue {get; set;}
    }          
    
    public class Device {	
    	public String batteryStatus {get; set;}
    	public String deviceVersion {get; set;}
    	public String id {get; set;}
    	public String lastSyncTime {get; set;}
    	public String deviceType {get; set;}
    	
    	public Device(JSONParser parser) {
    		parser.nextToken();
    		parser.nextValue();
    		parser.nextToken();
    		parser.nextValue();    		
    		this.batteryStatus = parser.getText();// Get the value.
    		parser.nextToken();
    		parser.nextValue();
    		this.deviceVersion = parser.getText();// Get the value.     		
    		parser.nextToken();
    		parser.nextValue();
    		this.id = parser.getText();// Get the value. 
    		parser.nextToken();
    		parser.nextValue();
    		this.lastSyncTime = parser.getDatetimeValue().format('MM/dd/yyyy hh:mm:ss a', 'PST');// Get the value.\
    		parser.nextToken();
    		parser.nextValue();    		
    		this.deviceType = parser.getText();// Get the value.
    	}
    }
    
    public class SleepTimes {
    	public String awakeningsCount {get; set;}
    	public String duration {get; set;}
    	public String efficiency {get; set;}
    	public String isMainSleep {get; set;}
    	public String logId {get; set;}
    	public String minutesAfterWakeup {get; set;}
    	public String minutesAsleep {get; set;}
    	public String minutesAwake {get; set;}
    	public String minutesToFallAsleep {get; set;}
    	public DateTime startTime {get; set;}
    	public String timeInBed {get; set;}
    }
    
    public class SleepSummary {
    	public String totalMinutesAsleep {get; set;}
    	public String totalSleepRecords {get; set;}
    	public String totalTimeInBed {get; set;}
    }
    
    public class Sleep {
    	public List<SleepTimes> sleep {get; set;}
    	public SleepSummary summary {get; set;}
    }
}
