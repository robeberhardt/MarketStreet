package com.rgs.market.debug
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.osflash.signals.Signal;
	
	public class KeyboardManager extends Sprite
	{
		private static var instance						: KeyboardManager;
		private static var allowInstantiation			: Boolean;
		
		public var restartSignal						: Signal;
		public var loadSignal							: Signal;
		public var nextSignal							: Signal;
		public var previousSignal						: Signal;
		public var wtfSignal							: Signal;
		
		private var _enabled							: Boolean;
		
		public function KeyboardManager(name:String="KeyboardManager")
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use KeyboardManager.getInstance()");
			} else {
				this.name = name;
				restartSignal = new Signal();
				nextSignal = new Signal();
				loadSignal = new Signal();
				previousSignal = new Signal();
				wtfSignal = new Signal();
				
				_enabled = true;
				
				if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
			}
		}
		
		public static function getInstance(name:String = "KeyboardManager"):KeyboardManager {
			if (instance == null) {
				allowInstantiation = true;
				instance = new KeyboardManager(name);
				allowInstantiation = false;
			}
			return instance;
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
		}
		
		private function handleKeyDown(e:KeyboardEvent):void
		{
			if (_enabled)
			{
				switch (e.keyCode)
				{
					
					
					case 82  : // R - RESTART CURRENT POEM FROM BEGINNING
						restartSignal.dispatch();
						break;
					
					case 76  : // L - LOAD DATA FROM CALENDAR
						loadSignal.dispatch();
						break;
					
					case 78  : // N - NEXT POEM
						nextSignal.dispatch();
						break;
					
					case 80  : // P - PREVIOUS POEM
						previousSignal.dispatch();
						break;
					
					case 87  : // W - WTF
						wtfSignal.dispatch();
						break;
					
					default :
						//
						break;
				}
			}
		}
		
		public function set enabled(val:Boolean):void
		{
			_enabled = val;
		}
	}
}