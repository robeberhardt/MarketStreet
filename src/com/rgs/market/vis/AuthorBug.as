package com.rgs.market.debug
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
	
	public class AuthorBug extends Sprite
	{
		private var format : TextFormat;
		private var field : TextField;
		private var bg	: Sprite;
		
		public function AuthorBug()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			alpha = 0;
			visible = false;
			
			bg = new Sprite();
			addChild(bg);
			
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
		
		public function set text(s:String):void
		{
			field.text = s;
			field.setTextFormat(format);
			bg.graphics.clear();
			bg.graphics.beginFill(0x000000, .5);
			bg.graphics.drawRect(field.textWidth, -5, field.textWidth + 20, field.textHeight + 10);
			bg.graphics.endFill();
			show();
		}
	
		
		public function show():void
		{
			TweenMax.to(this, 1, { autoAlpha: 1 } );
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