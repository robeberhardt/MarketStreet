package com.rgs.market
{
	import com.rgs.market.fonts.FontLibrary;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import nl.demonsters.debugger.MonsterDebugger;
	

	public class WordBubble extends Bubble
	{
		private var format : TextFormat;
		private var field : TextField;
		
		public function WordBubble(vars:Object=null)
		{
			super(vars);
		}
		
		override public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			format = new TextFormat();
			format.letterSpacing = 1;
			format.size = 128;
			format.leftMargin = 10;
			format.rightMargin = 10;
			format.color = 0x333333;
			format.align = TextFormatAlign.CENTER;
			format.font = FontLibrary.FUTURA_BOLD;
			
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.CENTER;
			field.wordWrap = true;
			field.multiline = true;
			field.embedFonts = true;
			field.selectable = false;
			field.width = 500;
			field.alpha = 1;
			field.border = false;
			field.borderColor = 0xFF0000;
			addChild(field);

			draw();
		}
		
		override public function postDraw():void
		{
			field.x = textCorner.x;
			field.y = textCorner.y;
		}
		
		public function get text():String
		{
			return field.text;
		}
		
		public function set text(value:String):void
		{
			
			field.text = value;
			field.setTextFormat(format);
			
			while(field.textHeight > 100)
			{
				format.size = Number(format.size) - 1;
				field.setTextFormat(format);
			}
			
			field.height = field.textHeight + 6;
			
			field.x = textCorner.x;
			field.y = textCorner.y;
			
		}
		
		
		public function get textCorner():Point
		{
			var cornerX:Number;
			var cornerY:Number;
			
			(field.numLines == 1) ? cornerY = offsetY + 40 : cornerY = offsetY + 20;
			(offsetX > 0) ? cornerX = offsetX : cornerX = offsetX - width - 20;
			
			return new Point(cornerX, cornerY);
		}
	}
}