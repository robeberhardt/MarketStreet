package com.rgs.market.calendar
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.osflash.signals.Signal;
	
	public class PoemRetriever extends Sprite
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
		private var eventDate : Date;
		
		public var gotPoemSignal : Signal;
		public var gotPoemFallback : Signal;
		
		private var timeout			: Timer;
		
		private var settings		: XML;
		
		public function PoemRetriever(settings:XML)
		{
			
			this.settings = settings;
			
			gotPoemSignal = new Signal(String);
			gotPoemFallback = new Signal(String);
			
			user = new GoogleCalendarUserVO();
			
			user.userName = settings.account.username;
			user.userPassword = settings.account.password;
			calName = settings.account.calendarName;
			
			MonsterDebugger.trace(this, "trying to authenticate...");
			MonsterDebugger.trace(this, user);
			
			timeout = new Timer(10000);
			timeout.addEventListener(TimerEvent.TIMER, onTimeout);
			
			
			
		}
		
		public function getPoem(date:Date):void
		{
			eventDate = date;
			
			auth = new GoogleCalendarAuthenticator();
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_RESPONSE, onAuthResponse);
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_FAULT, onAuthFault);
			auth.authenticateUser(user.userName, user.userPassword);
			
			serv = new GoogleCalendarService();
			
			timeout.start();
		}
		
		private function onAuthFault(e:GoogleCalendarAuthenticatorEvent):void
		{
			MonsterDebugger.trace(this, "Authorization fault");
			MonsterDebugger.trace(this, e);
			fallback();
		}
		
		private function onAuthResponse(e:GoogleCalendarAuthenticatorEvent):void
		{
			timeout.stop();
			MonsterDebugger.trace(this, "Authorization success!");
			
			authUser = e.authenticatedUser;
			MonsterDebugger.trace(this, authUser);
			serv = new GoogleCalendarService();
			serv.addEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_RESPONSE, onGetAllCalendarsResponse);
			serv.addEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_FAULT, onGetAllCalendarsFault);
			serv.getAllCalendars(authUser);
		}
		
		private function onGetAllCalendarsFault(e:GoogleCalendarServiceEvent):void
		{
			MonsterDebugger.trace(this, "couldn't get all the calendars...");
			fallback();
		}
		
		private function onGetAllCalendarsResponse(e:GoogleCalendarServiceEvent):void
		{
			MonsterDebugger.trace(this, "Got all calendars");
			
			//			for each (var c:GoogleCalendarVO in e.allCalendars)
			//			{
			//				trace(c + ", " + c.title.title);
			//				
			//			}
			
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
				fallback();
			}
			else
			{
				var startDate:Date = eventDate;
				var endDate:Date = eventDate
				var eventServ:GoogleCalendarEventsService = new GoogleCalendarEventsService();
				eventServ.addEventListener(GoogleCalendarEventsServiceEvent.GET_EVENTS_FOR_DATE_RANGE_RESPONSE, onGetEventsForDateRangeResponse);
				eventServ.getEventsForDateRange(myCal, authUser, startDate, endDate);
			}			
		}
		
		private function onTimeout(e:TimerEvent):void
		{
			auth.removeEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_RESPONSE, onAuthResponse);
			auth.removeEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_FAULT, onAuthFault);
			serv.removeEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_RESPONSE, onGetAllCalendarsResponse);
			serv.removeEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_FAULT, onGetAllCalendarsFault);
			fallback();
		}
		
		private function onGetEventsForDateRangeFault(e:GoogleCalendarEventsServiceEvent):void
		{
			MonsterDebugger.trace(this, "couldn't events any events for that date");
			fallback();
		}
		
		private function onGetEventsForDateRangeResponse(e:GoogleCalendarEventsServiceEvent):void
		{
			MonsterDebugger.trace(this, "there are " + e.calendarEvents.length + " events for " + eventDate);
			
			if (e.calendarEvents.length > 0)
			{
				var ev:GoogleCalendarEventVO = e.calendarEvents[0];
				MonsterDebugger.trace(this, e);
				gotPoemSignal.dispatch(settings.poem.prefix + ev.content.content);
			}
			else
			{
				fallback();
			}			
			
		}
		
		private function fallback():void
		{
			gotPoemFallback.dispatch(settings.fallback.local.toString());
		}

	}
}