package com.rgs.market.calendar
{
	import com.rgs.utils.monster.Monster;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.osflash.signals.Signal;
	
	public class DataRetriever extends Sprite
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
		private var eventServ : GoogleCalendarEventsService;
		private var calName : String;
		private var eventDate : Date;
		
		public var loadedSignal : Signal;
		public var errorSignal : Signal;
		
		public var timeoutTimer : Timer;
		
		public var dateMode		: Boolean = true;
		
		private var data		: XMLList;
		private var poemData	: PoemData;
		private var errorData	: ErrorData;
		
		public function DataRetriever(data:XMLList)
		{
			this.data = data;
			
			loadedSignal = new Signal(PoemData);
			errorSignal = new Signal(ErrorData);
			
			user = new GoogleCalendarUserVO();
			user.userName = data.username;
			user.userPassword = data.password;
			calName = data.calendarName;
			
			auth = new GoogleCalendarAuthenticator();
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_RESPONSE, onAuthResponse);
			auth.addEventListener(GoogleCalendarAuthenticatorEvent.AUTHENTICATION_FAULT, onAuthFault);
			
			serv = new GoogleCalendarService();
			serv.addEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_RESPONSE, onGetAllCalendarsResponse);
			serv.addEventListener(GoogleCalendarServiceEvent.GET_ALL_CALENDARS_FAULT, onGetAllCalendarsFault);
			
			eventServ = new GoogleCalendarEventsService();
			eventServ.addEventListener(GoogleCalendarEventsServiceEvent.GET_EVENTS_FOR_DATE_RANGE_RESPONSE, onGetEventsForDateRangeResponse);
			eventServ.addEventListener(GoogleCalendarEventsServiceEvent.GET_EVENTS_FOR_DATE_RANGE_FAULT, onGetEventsForDateRangeFault);
			
			poemData = new PoemData();
			errorData = new ErrorData();
			
			timeoutTimer = new Timer(20000);
			timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeout);
		}
		
		public function getDataForRemoteDate(date:Date):void
		{
			errorData.type = ErrorData.REMOTE_TYPE;
			getDataForDate(date);
		}
		
		public function getDataForLocalDate(date:Date):void
		{
			errorData.type = ErrorData.LOCAL_TYPE;
			getDataForDate(date);
		}
		
		public function getDataForDate(date:Date):void
		{
			eventDate = date;
			auth.authenticateUser(user.userName, user.userPassword);
			timeoutTimer.start();
		}
		
		private function onAuthFault(e:GoogleCalendarAuthenticatorEvent):void
		{
			timeoutTimer.stop();
			errorData.message = "authorization fault";
			errorSignal.dispatch(errorData);
		}
		
		private function onAuthResponse(e:GoogleCalendarAuthenticatorEvent):void
		{
			timeoutTimer.stop();
			
			MonsterDebugger.trace(this, "Authorization success!");
			authUser = e.authenticatedUser;

			serv.getAllCalendars(authUser);
			timeoutTimer.start();
		}
		
		private function onGetAllCalendarsFault(e:GoogleCalendarServiceEvent):void
		{
			timeoutTimer.stop();
			errorData.message = "couldn't get all the calendars...";
			errorSignal.dispatch(errorData);
		}
		
		private function onGetAllCalendarsResponse(e:GoogleCalendarServiceEvent):void
		{
			timeoutTimer.stop();
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
				errorData.message = "couldn't find calendar.";
				errorSignal.dispatch(errorData);
			}
			else
			{
//				var startDate:Date = eventDate;
//				var endDate:Date = eventDate
				timeoutTimer.start();
				eventServ.getEventsForDateRange(myCal, authUser, eventDate, eventDate);
			}			
		}
		
		private function onGetEventsForDateRangeFault(e:GoogleCalendarEventsServiceEvent):void
		{
			timeoutTimer.stop();
			errorData.message = "couldn't get any events for that date.";
			errorSignal.dispatch(errorData);
		}
		
		private function onGetEventsForDateRangeResponse(e:GoogleCalendarEventsServiceEvent):void
		{
			timeoutTimer.stop();
//			MonsterDebugger.trace(this, "there are " + e.calendarEvents.length + " events for " + eventDate);
			
			if (e.calendarEvents.length > 0)
			{
				var ev:GoogleCalendarEventVO = e.calendarEvents[0];
				MonsterDebugger.trace(this, e);
				if (dateMode)
				{
					poemData.poem = ev.content.content;
					dateMode = false;
				}
				else
				{
					poemData.poem = data.prefix + ev.content.content + data.suffix;
					poemData.author = ev.where[0].valueString;
				}
				
				loadedSignal.dispatch(poemData);
			}
			else
			{
				errorData.message = "no events for that date.";
				errorSignal.dispatch(errorData);
			}			
			
		}
		
		public function onTimeout(e:TimerEvent):void
		{
			timeoutTimer.stop();
			errorData.message = "timeout.";
			errorSignal.dispatch(errorData);
		}
	}
}