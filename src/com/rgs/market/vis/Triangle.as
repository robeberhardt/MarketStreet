package com.rgs.market.vis
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Triangle extends Sprite
	{
		private var vars					: Object;
		
		//		private var _anchorPoint			: Point;
		//		private var _cornerPoint			: Point;
		
		private var _width					: Number;
		private var _height					: Number;
		private var _strokeWidth			: Number;
		private var _strokeColor			: Number;
		private var _strokeAlpha			: Number;
		private var _fillColor				: Number;
		private var _fillAlpha				: Number;
		
		private var _side					: String;
		
		public static const TOP				: String = "top";
		public static const RIGHT			: String = "right";
		public static const BOTTOM			: String = "bottom";
		public static const LEFT			: String = "left";
		
		public function Triangle(vars:Object=null)
		{
			this.vars = (vars != null) ? vars : {};
			x = (this.vars.x) ? Number(this.vars.x) : 0;
			y = (this.vars.y) ? Number(this.vars.y) : 0;
			_width = (this.vars.width) ? Number(this.vars.width) : 200;
			_height = (this.vars.height) ? Number(this.vars.height) : 60;
			_strokeWidth = (this.vars.strokeWidth != null) ? Number(this.vars.strokeWidth) : 2;
			_strokeColor = (this.vars.strokeColor != null) ? Number(this.vars.strokeColor) : 0x333333;
			_strokeAlpha = (this.vars.strokeAlpha != null) ? Number(this.vars.strokeAlpha) : 1;
			_fillColor = (this.vars.fillColor != null) ? Number(this.vars.fillColor) : 0x999999;
			_fillAlpha = (this.vars.fillAlpha) ? Number(this.vars.fillAlpha) : 1;
			_side = (this.vars.side) ? this.vars.side : BOTTOM;
			
			trace("this.vars.side: " + this.vars.side + "  --  _side: " + _side);
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		public function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			draw();
		}
		
		public function draw():void
		{
			switch (_side)
			{
				
				case TOP :
					
					break;
				
				case RIGHT :
					
					break;
				
				case BOTTOM :
					with (this.graphics) 
					{
						clear();
						lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
						beginFill(_fillColor, _fillAlpha);
						
						moveTo(-(_width*.5), 0);
						lineTo(_width*.5, 0);
						lineTo(0, _height);
						lineTo(-(_width*.5), 0);
						endFill();
						
					}
					break;
				
				case LEFT :
					
					break;
				
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
		
		
	}
}