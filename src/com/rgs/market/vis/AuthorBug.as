package com.rgs.market.vis
{
	import com.greensock.TweenMax;
	import com.rgs.market.fonts.FontLibrary;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.DropShadowFilter;
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
			format.size = 24;
//			format.leftMargin = 10;
//			format.rightMargin = 10;
			format.color = 0xFFFFFF;
			format.align = TextFormatAlign.LEFT;
			format.font = FontLibrary.ACME_SECRET_AGENT;
			
			field = new TextField();
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.autoSize = TextFieldAutoSize.LEFT;
			field.wordWrap = false;
			field.multiline = false;
			field.embedFonts = true;
			field.selectable = false;
			field.width = 500;
			field.alpha = 1;
			addChild(field);
			
			y = stage.stageHeight - 50;
			
			this.filters = [new DropShadowFilter(0, 0, 0x000000, 1, 4, 4, 5, 5)];
			
		}
		
		public function set text(s:String):void
		{
			field.text = s;
			field.setTextFormat(format);
			x = stage.stageWidth - field.textWidth - 50;
			show();
			
//			bg.graphics.clear();
//			bg.graphics.beginFill(0x000000, .5);
//			bg.graphics.drawRect(field.textWidth, -5, field.textWidth + 20, field.textHeight + 10);
//			bg.graphics.endFill();
			
		}
	
		
		public function show():void
		{
			TweenMax.to(this, 1, { autoAlpha: 1 });
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