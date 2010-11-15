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
	
	import org.osflash.signals.Signal;
	
	public class BubbleManager extends Sprite
	{
		private var poem : String;
		private var poemField : TextField;
		private var poemFormat : TextFormat;
		private var leftField : TextField;
		private var rightField : TextField;
		private var lineFormat : TextFormat;
		

		private var chunksArray : Array;

		private var timing : XMLList;
		private var ticks : Number;
		private var timeIn : int;
		private var timeOut : int;
		
		private var origin : Point;
		
//		private var leftBubble : WordBubble;
//		private var rightBubble : WordBubble;
//		private var currentSide : WordBubble;
		
		private var box1 : WordBox;
		private var box2 : WordBox;
		private var currentBox : WordBox;
		private var currentChunkIndex : int;
		private var numChunks : int;
		
		public var showEnded : Signal;
				
		public function BubbleManager(theSettings:XMLList)
		{
			timing = theSettings;
			showEnded = new Signal();
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
//			leftBubble = new WordBubble( { x:stage.stageWidth * .5 - 50, y:30, 
//				offsetX:-50, offsetY:300, width:480, height:125, cornerRadius:20,
//				strokeWidth:6, strokeColor:0x333333, fillColor:0xFFFFFF, fillAlpha: .8, neck:2	} );
//			
//			rightBubble = new WordBubble( { x:stage.stageWidth * .5 + 50, y:30, 
//				offsetX:50, offsetY:400, width:480, height:125, cornerRadius:20,
//				strokeWidth:6, strokeColor:0x333333, fillColor:0xFFFFFF, fillAlpha: .8, neck:2	} );
			
			box1 = new WordBox( { x:stage.stageWidth * .5 - 50, y:30, 
				offsetX:-50, offsetY:0, width:500, height:135, cornerRadius:20,
				strokeWidth:2, strokeColor:0xffffff, fillColor:0x000000, fillAlpha: 1, neck:2	} );
			
			box2 = new WordBox( { x:stage.stageWidth * .5 + 50, y:30, 
				offsetX:50, offsetY:0, width:500, height:135, cornerRadius:20,
				strokeWidth:2, strokeColor:0xffffff, fillColor:0x000000, fillAlpha: 1, neck:2	} );
			
			
//			addChild(leftBubble);
//			addChild(rightBubble);
			
//			leftBubble.alpha = 0;
//			rightBubble.alpha = 0;
			
			addChild(box1);
			addChild(box2);
			box1.alpha = 0;
			box2.alpha = 0;
			
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
			
			chunksArray = new Array();
			
			timeIn = Number(timing.lineIn);
			timeOut = Number(timing.lineOut);
						
			
		}
		
		public function startShow():void
		{
			currentChunkIndex = 0;
			showNextChunk();
		}
		
		private function showNextChunk():void
		{

			trace("currentChunkIndex: " + currentChunkIndex + ", chunksArray.length: " + chunksArray.length);
			
			if (currentChunkIndex % 2 == 0)
			{
				TweenMax.to(box1, timeOut, { alpha: 0 });
				TweenMax.to(box2, timeOut, { alpha: 0 });
				
				TweenMax.delayedCall(timeOut, function():void { 
					box1.text = chunksArray[currentChunkIndex];
					ticks = 1 + Number(timing.speed)*box1.text.length / 10;
					
					box1.x = stage.stageWidth * .5 + 50;
					box1.y = Math.random() * 100 + 50;
					
					if (currentChunkIndex < chunksArray.length-1)
					{
						box1.showTriangle();
					}
					else
					{
						box1.hideTriangle();
					}
					
					
					TweenMax.to(box1, timeIn, { alpha: 1 } );
					TweenMax.delayedCall(ticks, increment);
				});
			}
			else
			{
				box2.text = chunksArray[currentChunkIndex];
				ticks = 1 + Number(timing.speed)*box2.text.length / 10;
				
				if (Math.random() < .5)
				{
					box2.x = box1.x - 50;
				}
				else
				{
					box2.x = box1.x + 50;
				}
				
				box2.y = box1.y + box1.height + 30;
				
				
				if (currentChunkIndex < chunksArray.length-1)
				{
					box2.showTriangle();
				}
				else
				{
					box2.hideTriangle();
				}
				
				
				TweenMax.to(box2, timeIn, { alpha: 1 } );
				TweenMax.delayedCall(ticks, increment);
			}
		}
		
		private function increment():void
		{
			currentChunkIndex ++;
			if (currentChunkIndex < chunksArray.length)
			{
				showNextChunk();
			}
			else
			{
				currentChunkIndex = 0;
				
				TweenMax.delayedCall(4, function():void {  
					TweenMax.to(box1, timeOut, { alpha: 0 });
					TweenMax.to(box2, timeOut, { alpha: 0 });
					TweenMax.delayedCall(Number(timing.pauseAfterLastLine), showNextChunk);
				});
			}
		}
		

		
		public function endShow():void
		{
			KeyboardManager.getInstance().enabled = false;
			TweenMax.killAll();
//			TweenMax.to(leftBubble, .5, { alpha: 0 });
//			TweenMax.to(rightBubble, .5, { alpha: 0 });
			TweenMax.to(box1, .5, { alpha: 0 });
			TweenMax.to(box2, .5, { alpha: 0 });
			TweenMax.delayedCall(.5, function():void 
			{ 
				showEnded.dispatch();
				KeyboardManager.getInstance().enabled = true;
			});
		}
		
		public function set poemText(value:String):void
		{
			poem = value;
			//poem = poem.split("\n\n").join("\n");
			poem = poem.split("\\n").join("");
			poem = poem.split("'").join("’");
			
			poemField.text = poem;
			
			chunksArray = poemField.text.split("\r\r");
			
		}
		
		public function resize():void
		{
			scaleX = stage.stageWidth / 1280;
			scaleY = stage.stageHeight / 800;
		}
	}
}