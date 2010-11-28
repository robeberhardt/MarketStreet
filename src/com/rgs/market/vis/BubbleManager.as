
package com.rgs.market.vis
{
	import com.greensock.TweenMax;
	import com.greensock.text.SplitTextField;
	import com.rgs.market.calendar.PoemData;
	import com.rgs.market.debug.KeyboardManager;
	import com.rgs.market.fonts.FontLibrary;
	import com.rgs.utils.monster.Monster;
	
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
		
		private var poemAuthor : String;
		
		private var _poemData : PoemData;
		
		private var chunksArray : Array;

		private var timingSettings : XMLList;
		private var boxesSettings : XMLList;
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
		
		public var showInProgress : Boolean = false;
		public var showEnded : Signal;
				
		public function BubbleManager(theSettings:XML)
		{
			timingSettings = theSettings.timing;
			boxesSettings = theSettings.boxes;
			showEnded = new Signal();
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
//			graphics.beginFill(0xFF0000, 1);
//			graphics.drawRect(0, 0, 50, 50);
//			graphics.endFill();
									
			box1 = new WordBox( { x:stage.stageWidth * .5 - 50, y:30, 
				offsetX:-50, offsetY:0,  maxWidth:Number(boxesSettings.maxWidth), maxHeight:Number(boxesSettings.maxHeight), cornerRadius:Number(boxesSettings.cornerRadius),
				strokeWidth:Number(boxesSettings.strokeWidth), strokeColor:0xffffff, fillColor:0x000000, fillAlpha: 1, neck:2	} );
			
			box2 = new WordBox( { x:stage.stageWidth * .5 + 50, y:30, 
				offsetX:50, offsetY:0, maxWidth:Number(boxesSettings.maxWidth), maxHeight:Number(boxesSettings.maxHeight), cornerRadius:Number(boxesSettings.cornerRadius),
				strokeWidth:Number(boxesSettings.strokeWidth), strokeColor:0xffffff, fillColor:0x000000, fillAlpha: 1, neck:2	} );
			
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
			
			timeIn = Number(timingSettings.lineIn);
			timeOut = Number(timingSettings.lineOut);
						
			
		}
		
		public function startShow():void
		{
			currentChunkIndex = 0;
			showNextChunk();
			showInProgress = true;
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
					ticks = 1 + Number(timingSettings.speed)*box1.text.length / 10;
					
//					box1.x = stage.stageWidth * .5 + 50;
//					box1.x = stage.stageWidth * .5 - 100;
//					box1.x = stage.stageWidth - 100 - box1.width;
					
					box1.x = (stage.stageWidth - (box1.width * scaleX) - (50 + (Math.random()*100) * scaleX)) / scaleX;
					box1.y = (Math.random() * 50 + 25) * scaleY;
					
//					box1.y = Math.random() * 100 + 50;
					
					Monster.warning(this, box1.x + " : " + box1.y);
					Monster.warning(this, box1.width + " : " + box1.height);
					Monster.warning(this, stage.stageWidth + ", " + stage.stageHeight);
					Monster.warning(this, "scaleX: " + scaleX + ", scaleY: " + scaleY);
					
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
				ticks = 1 + Number(timingSettings.speed)*box2.text.length / 10;
				
				box2.x = (stage.stageWidth - (box2.width * scaleX) - (50 + (Math.random()*100) * scaleX)) / scaleX;
				box2.y = box1.y + box1.height + 30 + (Math.random()*30) * scaleY;
				
				/*
				if (Math.random() < .5)
				{
					//box2.x = box1.x - 50;
				}
				else
				{
					//box2.x = box1.x + 50;
				}
				
				box2.x = box1.x;
				box2.y = box1.y + box1.height + 30 + (Math.random()*30);
				*/
				
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
					TweenMax.delayedCall(Number(timingSettings.pauseAfterLastLine), showNextChunk);
				});
			}
		}
		

		
		public function endShow():void
		{
			Monster.info(this, "ending show...");
			showInProgress = false;
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
//			Monster.info(this, "width: " + box1.width);
//			Monster.info(this, "scale: " + box1.scaleX);
			
//			box1.x = (stage.stageWidth - (box1.width * scaleX)) / scaleX;
//			box2.x = box1.x;
//			Monster.warning(this,box1.x);
		}

		public function get poemData():PoemData
		{
			return _poemData;
		}

		public function set poemData(value:PoemData):void
		{
			_poemData = value;
			poemText = _poemData.poem;
			poemAuthor = _poemData.author;
//			Monster.info(this, _poemData.poem);
//			Monster.info(this, _poemData.author);
		}

	}
}