package com.rgs.market.vis
{
	import com.gskinner.StringUtils;
	import com.rgs.market.fonts.FontLibrary;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	
	public class WordBox extends Box
	{
		private var format : TextFormat;
		private var field : TextField;
		
		private var lineTestField : TextField;
		private var triangle				: Triangle;
		
		public function WordBox(vars:Object=null)
		{
			super(vars);	
		}
		
		override public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			format = new TextFormat();
			format.letterSpacing = 1;
			format.size = 128;
			format.leading = 0;
			format.leftMargin = 10;
			format.rightMargin = 10;
			format.color = 0xffffff;
			//			format.align = TextFormatAlign.CENTER;
			format.align = TextFormatAlign.LEFT;
			format.font = FontLibrary.ACME_SECRET_AGENT_BOLD;
			
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			//			field.autoSize = TextFieldAutoSize.CENTER;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.wordWrap = true;
			field.multiline = true;
			field.embedFonts = true;
			field.selectable = false;
			field.width = maxWidth;
			field.alpha = 1;
			field.border = false;
			field.borderColor = 0xFF0000;
			field.background = false;
			field.backgroundColor = 0x000000;
			addChild(field);
			
			lineTestField = new TextField();
			lineTestField.antiAliasType = AntiAliasType.ADVANCED;
			lineTestField.autoSize = TextFieldAutoSize.LEFT;
			lineTestField.wordWrap = false;
			lineTestField.multiline = true;
			lineTestField.embedFonts = true;
			lineTestField.selectable = false;
			lineTestField.width = maxWidth;
			lineTestField.alpha = 1;
			lineTestField.border = false;
			lineTestField.borderColor = 0xFF0000;
			lineTestField.background = false;
			lineTestField.backgroundColor = 0x000000;
			
			triangle = new Triangle( { width:30, height:15, strokeWidth: 0, strokeColor: 0xffffff, fillColor:0xffffff, fillAlpha: 1 } );
			addChild(triangle);
		
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
		
		public function get linecount():int
		{
			return field.numLines;
		}
		
		public function set text(value:String):void
		{
			format.size = 128;
			
			field.text = value;
			field.setTextFormat(format);
			
			lineTestField.text = value;
			lineTestField.setTextFormat(format);
			
			
			
			while(field.textHeight > (maxHeight + 15))
			{
				format.size = Number(format.size) - 1;
				field.setTextFormat(format);
			}
			
//			while (field.textWidth < (field.width - 30))
//			{
//				format.size = Number(format.size) + 1;
//				field.setTextFormat(format);
//			}
			
			var count:uint = StringUtils.countOf(field.text, "\r", false);
			if (count > 0)
			{
				while(field.numLines > lineTestField.numLines)
				{
					format.size = Number(format.size) - 1;
					field.setTextFormat(format);
				}
			}
			
			field.height = field.textHeight + 6;
			
			field.x = textCorner.x;
			field.y = textCorner.y;
			
			width = field.textWidth+ 24;
			height = field.textHeight + 14;
			draw();
			triangle.x = 50 + (Math.random()*(width-100));
			triangle.y = height;
		}
		
		public function showTriangle():void
		{
			triangle.alpha = 1;
		}
		
		public function hideTriangle():void
		{
			triangle.alpha = 0;
		}
		
		
		public function get textCorner():Point
		{	
			var cornerX:Number;
			var cornerY:Number;
			
			(field.numLines == 1) ? cornerY = offsetY + 40 : cornerY = offsetY + 20;
			(offsetX > 0) ? cornerX = offsetX : cornerX = offsetX - width - 20;
			
			return new Point(4, 4);
		}
	}
}