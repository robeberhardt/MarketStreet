package com.rgs.market.vis
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class DateBugTwo extends Sprite
	{
		private var myTimer:Timer;
		
		public function DateBugTwo()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			alpha = 0;
			visible = false;
			
			myTimer = new Timer(2000, 1);
			myTimer.addEventListener(TimerEvent.TIMER, hide);
			
			graphics.lineStyle(2, 0xFFFFFF, 1);
			graphics.beginFill(0x00FF00, 1);
			graphics.drawCircle(0, 0, 50);
			graphics.endFill();
		}
		
		public function show():void
		{
			TweenMax.killTweensOf(true);
			trace("this = " + this);
			TweenMax.to(this, 1, { autoAlpha: 1 });
			
			myTimer.start();
		}
		
		public function hide(e:Event=null):void
		{
			myTimer.stop();
			trace("hiding");
			TweenMax.to(this, 1, { autoAlpha: 0 });
		}
	}
	
	
}