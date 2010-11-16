package com.rgs.market
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.osflash.signals.Signal;
	
	public class RemoteSettings extends Sprite
	{
		import com.adobe.googlecalendar.events.GoogleCalendarAuthenticatorEvent;
		import com.adobe.googlecalendar.events.GoogleCalendarEventsServiceEvent;
		import com.adobe.googlecalendar.events.GoogleCalendarServiceEvent;
		import com.adobe.googlecalendar.services.GoogleCalendarAuthenticator;
		import com.adobe.googlecalendar.services.GoogleCalendarEventsService;
		import com.adobe.googlecalendar.services.GoogleCalendarService;
		import com.adobe.googlecalendar.valueobjects.GoogleCalendarEventVO;
		import com.adobe.googlecalendar.valueobjects.GoogleCalendarUserVO;
		import com.adobe.googlecalendar.valueobjects.GoogleCalendarVO;
		import com.adobe.googlecalendar.valueobjects.TitleVO;
		import com.adobe.googlecalendar.valueobjects.WhereVO;
		
		private var user:GoogleCalendarUserVO;
		private var authUser:GoogleCalendarUserVO;
		private var auth:GoogleCalendarAuthenticator;
		private var serv:GoogleCalendarService;
		private var calName : String;
		
		private var remoteSettingsDate : Date;
		
		private var settings		: XML;
		
		public var remoteDateSignal : Signal;
		
		public function RemoteSettings(settings:XML)
		{
			
			this.settings = settings;
			
			remoteSettingsDate = new Date(settings.account.remoteSettingsDate.toString());
			MonsterDebugger.trace(this, 'remote Settings Date = ' + remoteSettingsDate);
			
			user = new GoogleCalendarUserVO();
			
			user.userName = settings.account.username;
			user.userPassword = settings.account.password;
			calName = settings.account.calendarName;
			
			MonsterDebugger.trace(this, "trying to authenticate...");
			MonsterDebugger.trace(this, user);
			
			remoteDateSignal = new Signal(String);
			
			getRemoteSettings();
		
		}
		
		public function getRemoteSettings():void
		{
			
			auth = new GoogleCalendarAuthenticator();
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_RESPONSE, onAuthResponse);
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_FAULT, onAuthFault);
			auth.authenticateUser(user.userName, user.userPassword);
			
			serv = new GoogleCalendarService();
			
//			timeout.start();
		}
		
		private function onAuthFault(e:GoogleCalendarAuthenticatorEvent):void
		{
			MonsterDebugger.trace(this, "Authorization fault");
			MonsterDebugger.trace(this, e);
			fallback();
		}
		
		private function onAuthResponse(e:GoogleCalendarAuthenticatorEvent):void
		{
//			timeout.stop();
			MonsterDebugger.trace(this, "Authorization success!");
			
			authUser = e.authenticatedUser;
			MonsterDebugger.trace(this, authUser);
			serv = new GoogleCalendarService();
			serv.addEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_RESPONSE, onGetAllCalendarsResponse);
			serv.addEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_FAULT, onGetAllCalendarsFault);
			serv.getAllCalendars(authUser);
		}
//		
		private function onGetAllCalendarsFault(e:GoogleCalendarServiceEvent):void
		{
			MonsterDebugger.trace(this, "couldn't get all the calendars...");
			fallback();
		}
		
		private function onGetAllCalendarsResponse(e:GoogleCalendarServiceEvent):void
		{
			MonsterDebugger.trace(this, "Got all calendars");
			
			
			
			for each (var c:GoogleCalendarVO in e.allCalendars)
			{
				if (c.title.title == calName)
				{
					MonsterDebugger.trace(this, "matching with " + c.title.title);
					var myCal:GoogleCalendarVO = c;
				}
			}
			
			if (!myCal)
			{
				MonsterDebugger.trace(this, "couldn't find calendar");
			}
			else
			{
				var startDate:Date = remoteSettingsDate;
				var endDate:Date = remoteSettingsDate;
				var eventServ:GoogleCalendarEventsService = new GoogleCalendarEventsService();
				eventServ.addEventListener(GoogleCalendarEventsServiceEvent.GET_EVENTS_FOR_DATE_RANGE_RESPONSE, onGetEventsForDateRangeResponse);
				eventServ.addEventListener(GoogleCalendarEventsServiceEvent.GET_EVENTS_FOR_DATE_RANGE_FAULT, onGetEventsForDateRangeFault);
				eventServ.getEventsForDateRange(myCal, authUser, startDate, endDate);
				MonsterDebugger.trace(this, "trying to get events for " + remoteSettingsDate);
			}			
		}
//		
//		
//		
		private function onGetEventsForDateRangeFault(e:GoogleCalendarEventsServiceEvent):void
		{
			MonsterDebugger.trace(this, "couldn't events any events for that date");
			fallback();
		}
		
		private function onGetEventsForDateRangeResponse(e:GoogleCalendarEventsServiceEvent):void
		{
			MonsterDebugger.trace(this, "there are " + e.calendarEvents.length + " events for " + remoteSettingsDate);
			
			if (e.calendarEvents.length > 0)
			{
				var ev:GoogleCalendarEventVO = e.calendarEvents[0];
				if (ev.content != null )
				{
					var remoteDateXML:XML = new XML(ev.content.content.toString());
					remoteDateSignal.dispatch(remoteDateXML.toString());
				}
				else
				{
					fallback();
				}
				
			}
			else
			{
				fallback();
			}			
			
		}
	
		private function fallback():void
		{
			remoteDateSignal.dispatch("FAIL");
		}
		
	}
}