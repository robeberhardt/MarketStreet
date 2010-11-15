package com.rgs.market
{
	import flash.display.Sprite;
	
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
		
		public function PoemRetriever(name:String, pw:String, cal:String)
		{
			gotPoemSignal = new Signal(String);
			gotPoemFallback = new Signal(String);
			
			user = new GoogleCalendarUserVO();
			user.userName = name;
			user.userPassword = pw;
			
			calName = cal;
			//eventDate = date;
			
			MonsterDebugger.trace(this, "trying to authenticate...");
			MonsterDebugger.trace(this, user);
			
			
		}
		
		public function getPoem(date:Date):void
		{
			eventDate = date;
			
			auth = new GoogleCalendarAuthenticator();
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_RESPONSE, onAuthResponse);
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_FAULT, onAuthFault);
			auth.authenticateUser(user.userName, user.userPassword);
			
			serv = new GoogleCalendarService();
			//			serv.addEventListener(GoogleCalendarServiceEvent.ADD_CALENDAR_RESPONSE, onServiceResponse);
			//			serv.addEventListener(GoogleCalendarServiceEvent.ADD_CALENDAR_FAULT, onServiceResponse);
		}
		
		private function onAuthFault(e:GoogleCalendarAuthenticatorEvent):void
		{
			MonsterDebugger.trace(this, "Authorization fault");
			MonsterDebugger.trace(this, e);
			fallback();
		}
		
		private function onAuthResponse(e:GoogleCalendarAuthenticatorEvent):void
		{
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
				gotPoemSignal.dispatch(ev.content.content);
			}
			else
			{
				fallback();
			}
			
			//			trace(e);
			//			trace("Event for date range: ");
			//			trace("there are " + e.calendarEvents.length);
			
			
			
			/*
			for (var i:int=0; i<e.calendarEvents.length; i++)
			{
			var theEvent:GoogleCalendarEventVO = e.calendarEvents[i] as GoogleCalendarEventVO;
			var theWhere:WhereVO = theEvent.where[0];
			MonsterDebugger.trace(this, theEvent.title.title + " -- " + theWhere.valueString);
			}
			
			
			var ev:GoogleCalendarEventVO = e.calendarEvents[0];
			trace(ev);
			trace(ev.title);
			trace(ev.content.content);
			gotPoemSignal.dispatch(ev.content.content);
			*/
			
			
			
			
		}
		
		private function fallback():void
		{
			gotPoemFallback.dispatch("There was a young rustic named Mallory,\nwho drew but a very small salary.\nWhen he went to the show,\nhis purse made him go\nto a seat in the uppermost gallery.");
		}
		
		
		
		private function onServiceResponse(e:GoogleCalendarServiceEvent):void
		{
			
		}
	}
}