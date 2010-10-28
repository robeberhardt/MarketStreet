package com.rgs.market
{
	import com.greensock.TweenMax;
	import com.greensock.text.SplitTextField;
	import com.rgs.market.fonts.FontLibrary;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class BubbleManager extends Sprite
	{
		private var poem : String;
		private var poemField : TextField;
		private var poemFormat : TextFormat;
		private var leftField : TextField;
		private var rightField : TextField;
		private var lineFormat : TextFormat;
		private var currentLine : int;

		private var linesArray : Array;

		private var timing : XMLList;
		private var ticks : Number;
		private var timeIn : int;
		private var timeOut : int;
		
		private var origin : Point;
		private var leftBubble : WordBubble;
		private var rightBubble : WordBubble;
		private var currentSide : WordBubble;
				
		public function BubbleManager(theSettings:XMLList)
		{
			timing = theSettings;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			leftBubble = new WordBubble( { x:stage.stageWidth * .5 - 50, y:30, 
				offsetX:-50, offsetY:300, width:480, height:125, cornerRadius:20,
				strokeWidth:6, strokeColor:0x333333, fillColor:0xFFFFFF, fillAlpha: .8, neck:2	} );
			
			rightBubble = new WordBubble( { x:stage.stageWidth * .5 + 50, y:30, 
				offsetX:50, offsetY:400, width:480, height:125, cornerRadius:20,
				strokeWidth:6, strokeColor:0x333333, fillColor:0xFFFFFF, fillAlpha: .8, neck:2	} );
			
			
			addChild(leftBubble);
			addChild(rightBubble);
			
			leftBubble.alpha = 0;
			rightBubble.alpha = 0;
			
			FontLibrary.getInstance();
						
			poemField = new TextField();
			poemField.antiAliasType = AntiAliasType.ADVANCED;
			poemField.autoSize = TextFieldAutoSize.LEFT;
			poemField.wordWrap = true;
			poemField.embedFonts = true;
			poemField.selectable = false;
			poemField.width = 800;
			poemField.multiline = true;
			poemField.wordWrap = true;
			poemField.alpha = .2;
			
			linesArray = new Array();
						
			
		}
		
		private function showNextLine():void
		{
			if (currentLine % 2 == 0)
			{
				currentSide = leftBubble;
				
			}
			else
			{
				currentSide = rightBubble;
			}
			
			currentSide.text = linesArray[currentLine];
			
			currentSide.offsetY = Math.random()*350 + 100;
			
			ticks = 1 + Number(timing.speed)*currentSide.text.length / 10;
			timeIn = Number(timing.lineIn);
			timeOut = Number(timing.lineOut);
			
			TweenMax.to(currentSide, timeIn, { alpha: 1 } );
			TweenMax.to(currentSide, timeOut, { alpha: 0, delay: ticks });
			TweenMax.delayedCall(ticks, increment);
		}
		
		private function increment():void
		{
			currentLine ++;
			if (currentLine < linesArray.length)
			{
				showNextLine();
			}
			else
			{
				currentLine = 0;
				TweenMax.delayedCall(Number(timing.pauseAfterLastLine), showNextLine);
			}
		}
		
		public function startShow():void
		{
			currentLine = 0;
			showNextLine();
		}
		
		public function endShow():void
		{
			TweenMax.killAll(false, false, true);
			TweenMax.to(leftBubble, 1, { alpha: 0 });
			TweenMax.to(rightBubble, 1, { alpha: 0 });
			TweenMax.delayedCall(2, startShow);
		}
		
		public function set poemText(value:String):void
		{
			poem = value;
			poem = poem.split("\n\n").join("\n");
			poem = poem.split("\\n").join("");
			poem = poem.split("'").join("’");
			
			poemField.text = poem;
			
			linesArray = poemField.text.split("\r");
			
		}
	}
}