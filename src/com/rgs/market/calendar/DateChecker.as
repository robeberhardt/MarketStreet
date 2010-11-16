package com.rgs.market.calendar
{
	import com.rgs.utils.monster.Monster;
	
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.osflash.signals.Signal;
	
	public class DateChecker extends Sprite
	{
		
		private var checkTimer : Timer;
		public var dateChangedSignal : Signal;
		
		private var startDate : Date;
		public var nowDate : Date;
		private var testDate : Date;
		
		public function DateChecker()
		{	
			
			dateChangedSignal = new Signal(Date);
			
			checkTimer = new Timer(10000);
			checkTimer.addEventListener(TimerEvent.TIMER, onTimer);
//			checkTimer.addEventListener(TimerEvent.TIMER, onTimerFake);
		}
		
		public function start(startDate:Date):void
		{
			Monster.info(this, "start()");
			this.startDate = startDate;
			nowDate = startDate;
			dateChangedSignal.dispatch(startDate);
			checkTimer.start();
		}
		
		public function stop():void
		{
			checkTimer.stop();
		}
		
		private function onTimer(e:TimerEvent):void
		{
			Monster.debug(this, "checking date...");
			testDate = new Date();
			if (testDate.date != nowDate.date)
			{
				Monster.debug(this, "DATE HAS CHANGED!!!");
				nowDate = testDate;
				dateChangedSignal.dispatch(nowDate);
			}
		}
		
		private function onTimerFake(e:TimerEvent):void
		{
			nowDate.date ++;
			dateChangedSignal.dispatch(nowDate);
		}
		
		public function incrementFakeDate():void
		{
			nowDate.date ++;
			dateChangedSignal.dispatch(nowDate);
		}
		
		public function decrementFakeDate():void
		{
			nowDate.date --;
			dateChangedSignal.dispatch(nowDate);
		}
		
		public function sendTodayAgain():void
		{
			dateChangedSignal.dispatch(nowDate);
		}
	}
}