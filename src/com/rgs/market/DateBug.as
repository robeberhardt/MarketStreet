package com.rgs.market
{
	import com.greensock.TweenMax;
	import com.rgs.market.fonts.FontLibrary;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class DateBug extends Sprite
	{
		private var format : TextFormat;
		private var field : TextField;
		
		public function DateBug()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			format = new TextFormat();
			format.letterSpacing = 1;
			format.size = 18;
			format.leftMargin = 10;
			format.rightMargin = 10;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.RIGHT;
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
			
			x = stage.stageWidth - 350;
			y = stage.stageHeight - 50;

		}
		
		public function set text(d:Date):void
		{
			field.text = textForDate(d);
			field.setTextFormat(format);
			show();
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
			TweenMax.to(this, 1, { autoAlpha: 1 } );
			TweenMax.delayedCall(3, hide);
		}
		
		public function hide():void
		{
			TweenMax.to(this, 1, { autoAlpha: 0 });
		}
		
		public function resize():void
		{
			x = stage.stageWidth - 350;
			y = stage.stageHeight - 50;
		}
	}
}