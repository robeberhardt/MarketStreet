package com.rgs.market.debug
{
	import com.greensock.TweenMax;
	import com.rgs.market.fonts.FontLibrary;
	import com.rgs.utils.monster.Monster;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	public class DateBug extends Sprite
	{
		private var format : TextFormat;
		private var field : TextField;
		private var bg	: Sprite;
		private var holder : Sprite;
		
		private var hideTimer:Timer;
		
		public function DateBug()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			alpha = 1;
			
			hideTimer = new Timer(2000, 1);
			hideTimer.addEventListener(TimerEvent.TIMER, hide);
			
			bg = new Sprite();
			addChild(bg);
			
			format = new TextFormat();
			format.letterSpacing = 1;
			format.size = 18;
			format.leftMargin = 10;
			format.rightMargin = 10;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.LEFT;
			format.font = FontLibrary.FUTURA_MEDIUM;
			
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.wordWrap = true;
			field.multiline = true;
			field.embedFonts = true;
			field.selectable = false;
			field.width = 300;
			field.alpha = 1;
			addChild(field);
			
			x = 50;
			y = stage.stageHeight - 50;

		}
		
		public function set text(d:Date):void
		{
			Monster.info(this, "setting datebug date to " + d);
			field.text = textForDate(d);
			field.setTextFormat(format);
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000, .5);
			bg.graphics.drawRect(-5, -5, field.textWidth + 20, field.textHeight + 10);
			bg.graphics.endFill();
			
		}
		
		public function testThing():void
		{
			Monster.warning(this, "WTFWTFWTF");
		}
		
		public function textForDate(d:Date):String
		{
			var day:String = d.getDate().toString();
			var month : String = Number(d.getMonth() + 1).toString();
			var year : String = d.getFullYear().toString();
			return month + " : " + day + " : " + year;
		}
		
		public function showError(d:Date):void
		{
			field.text = "no data for " + textForDate(d);;
			field.setTextFormat(format);
			show();
		}
		
		public function show():void
		{
			Monster.debug(this, "showing, alpha = " + alpha);
			Monster.debug(this, "vis: " + visible);
			
			TweenMax.killAll(true);
			TweenMax.to(this, 1, { autoAlpha: 1 });
			hideTimer.start();
			
		}
		
		public function hide(e:Event=null):void
		{
			TweenMax.to(this, 1, { alpha: 0 });
		}
		
		public function resize():void
		{
			x = 50;
			y = stage.stageHeight - 50;
		}
	}
}