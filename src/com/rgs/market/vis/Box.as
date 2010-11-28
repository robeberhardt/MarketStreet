package com.rgs.market.vis
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Box extends Sprite
	{
		private var vars					: Object;
		
		//		private var _anchorPoint			: Point;
		//		private var _cornerPoint			: Point;
		
		private var _offsetX				: Number;
		private var _offsetY				: Number;
		private var _width					: Number;
		private var _height					: Number;
		private var _maxHeight				: Number;
		private var _maxWidth				: Number;
		private var _cornerRadius			: Number;
		private var _strokeWidth			: Number;
		private var _strokeColor			: Number;
		private var _strokeAlpha			: Number;
		private var _fillColor				: Number;
		private var _fillAlpha				: Number;
		
		
		
		public function Box(vars:Object=null)
		{
			this.vars = (vars != null) ? vars : {};
			x = (this.vars.x) ? Number(this.vars.x) : 0;
			y = (this.vars.y) ? Number(this.vars.y) : 0;
			_offsetX = (this.vars.offsetX) ? Number(this.vars.offsetX) : 50;
			_offsetY = (this.vars.offsetY) ? Number(this.vars.offsetY) : 30;
			_width = (this.vars.width) ? Number(this.vars.width) : 200;
			_height = (this.vars.height) ? Number(this.vars.height) : 60;
			_maxWidth = (this.vars.maxWidth) ? Number(this.vars.maxWidth) : 650;
			_maxHeight = (this.vars.maxHeight) ? Number(this.vars.maxHeight) : 160;
			_cornerRadius = (this.vars.cornerRadius) ? Number(this.vars.cornerRadius) : 10;
			_strokeWidth = (this.vars.strokeWidth != null) ? Number(this.vars.strokeWidth) : 2;
			_strokeColor = (this.vars.strokeColor != null) ? Number(this.vars.strokeColor) : 0x333333;
			_strokeAlpha = (this.vars.strokeAlpha != null) ? Number(this.vars.strokeAlpha) : 1;
			_fillColor = (this.vars.fillColor != null) ? Number(this.vars.fillColor) : 0x999999;
			_fillAlpha = (this.vars.fillAlpha) ? Number(this.vars.fillAlpha) : 1;
			
			
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			draw();
		}
		
//		public function draw():void
//		{
//			with (this.graphics) 
//			{
//				clear();
//				lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
//				beginFill(_fillColor, _fillAlpha);
//				
//				moveTo(0, 0);
//				lineTo(_width, 0);
//				lineTo(_width, _height);
//				lineTo(0, _height);
//				lineTo(0, 0);
//				endFill();
//
//			}
//			postDraw();
//		}
		
		public function draw():void
		{
			with (this.graphics) 
			{
				clear();
				lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
				beginFill(_fillColor, _fillAlpha);
				
				drawRoundRect(0, 0, _width, _height, _cornerRadius, _cornerRadius);
				endFill();
				
			}
			postDraw();
		}
		
		public function postDraw():void
		{
			// for override
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
		}
		
		override public function set x(value:Number):void
		{
			super.x = value;
		}
		
		public function get strokeColor():Number
		{
			return _strokeColor;
		}
		
		public function set strokeColor(value:Number):void
		{
			_strokeColor = value;
			draw();
		}
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function set offsetX(value:Number):void
		{
			_offsetX = value;
			draw();
		}
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		public function set offsetY(value:Number):void
		{
			_offsetY = value;
			draw();
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			draw();
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			draw();
		}
		
		public function get strokeWidth():Number
		{
			return _strokeWidth;
		}
		
		public function set strokeWidth(value:Number):void
		{
			_strokeWidth = value;
			draw();
		}
		
		public function get cornerRadius():Number
		{
			return _cornerRadius;
		}
		
		public function set cornerRadius(value:Number):void
		{
			_cornerRadius = value;
			draw();
		}
		
		public function get strokeAlpha():Number
		{
			return _strokeAlpha;
		}
		
		public function set strokeAlpha(value:Number):void
		{
			_strokeAlpha = value;
			draw();
		}
		
		public function get fillColor():Number
		{
			return _fillColor;
		}
		
		public function set fillColor(value:Number):void
		{
			_fillColor = value;
			draw();
		}
		
		public function get fillAlpha():Number
		{
			return _fillAlpha;
		}
		
		public function set fillAlpha(value:Number):void
		{
			_fillAlpha = value;
			draw();
		}

		public function get maxWidth():Number
		{
			return _maxWidth;
		}

		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
		}

		public function get maxHeight():Number
		{
			return _maxHeight;
		}

		public function set maxHeight(value:Number):void
		{
			_maxHeight = value;
		}
		
		
	}
}