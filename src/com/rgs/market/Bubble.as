package com.rgs.market
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Bubble extends Sprite
	{
		private var vars					: Object;
		
		private var _anchorPoint			: Point;
		private var _cornerPoint			: Point;

//		private var _x						: Number;
//		private var _y						: Number;
		private var _offsetX				: Number;
		private var _offsetY				: Number;
		private var _width					: Number;
		private var _height					: Number;
		private var _cornerRadius			: Number;
		private var _strokeWidth			: Number;
		private var _strokeColor			: Number;
		private var _strokeAlpha			: Number;
		private var _fillColor				: Number;
		private var _fillAlpha				: Number;
		private var _neck					: Number;
		
		public function Bubble(vars:Object=null)
		{
			this.vars = (vars != null) ? vars : {};
//			_x = (this.vars.x) ? Number(this.vars.x) : 0;
//			_y = (this.vars.y) ? Number(this.vars.y) : 0;
			x = (this.vars.x) ? Number(this.vars.x) : 0;
			y = (this.vars.y) ? Number(this.vars.y) : 0;
			_offsetX = (this.vars.offsetX) ? Number(this.vars.offsetX) : 50;
			_offsetY = (this.vars.offsetY) ? Number(this.vars.offsetY) : 30;
			_neck = (this.vars.neck) ? Number(this.vars.neck) : 1;
			_width = (this.vars.width) ? Number(this.vars.width) : 200;
			_height = (this.vars.height) ? Number(this.vars.height) : 60;
			_cornerRadius = (this.vars.cornerRadius) ? Number(this.vars.cornerRadius) : 10;
			_strokeWidth = (this.vars.strokeWidth) ? Number(this.vars.strokeWidth) : 2;
			_strokeColor = (this.vars.strokeColor) ? Number(this.vars.strokeColor) : 0x333333;
			_strokeAlpha = (this.vars.strokeAlpha) ? Number(this.vars.strokeAlpha) : 1;
			_fillColor = (this.vars.fillColor) ? Number(this.vars.fillColor) : 0x999999;
			_fillAlpha = (this.vars.fillAlpha) ? Number(this.vars.fillAlpha) : 1;
			
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		

		override public function set y(value:Number):void
		{
			super.y = value;
		}
		
 		override public function set x(value:Number):void
		{
			super.x = value;
		}

		private function init(e:Event=null):void
		{
			draw();
		}
		
		private function draw():void
		{
			with (this.graphics) 
			{
				clear();
				lineStyle(_strokeWidth, _strokeColor, _strokeAlpha);
				beginFill(_fillColor, _fillAlpha);
				
				if (_offsetX > 0)
				{
					moveTo(0,0);
					lineTo(_offsetX + (_cornerRadius * _neck), _offsetY);
					lineTo(_offsetX + _width, _offsetY);
					curveTo(_offsetX + _width + _cornerRadius, _offsetY, _offsetX + _width + _cornerRadius, _offsetY + _cornerRadius);
					lineTo(_offsetX + _width + _cornerRadius, _offsetY + _height);
					curveTo(_offsetX + _width + _cornerRadius, _offsetY + _height + _cornerRadius, _offsetX + _width, _offsetY + _height + _cornerRadius);
					lineTo(_offsetX + _cornerRadius, _offsetY + _height + _cornerRadius);
					curveTo(_offsetX, _offsetY + _height + _cornerRadius, _offsetX, _offsetY + _height);
					lineTo(_offsetX, _offsetY + (_cornerRadius * _neck));
					lineTo(0, 0);
					endFill();
				}
				else
				{
					moveTo(0,0);
					lineTo(_offsetX - (_cornerRadius * _neck), _offsetY);
					lineTo(_offsetX - _width, _offsetY);
					curveTo(_offsetX - _width - _cornerRadius, _offsetY, _offsetX - _width - _cornerRadius, _offsetY + _cornerRadius);
					lineTo(_offsetX - _width - _cornerRadius, _offsetY + _height);
					curveTo(_offsetX - _width - _cornerRadius, _offsetY + _height + _cornerRadius, _offsetX - _width, _offsetY + _height + _cornerRadius);
					lineTo(_offsetX - _cornerRadius, _offsetY + _height + _cornerRadius);
					curveTo(_offsetX, _offsetY + _height + _cornerRadius, _offsetX, _offsetY + _height);
					lineTo(_offsetX, _offsetY + (_cornerRadius * _neck));
					lineTo(0, 0);
					endFill();
				}
			}
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

		public function get neck():Number
		{
			return _neck;
		}

		public function set neck(value:Number):void
		{
			_neck = value;
		}


	}
}