package com.rgs.market
{
	import com.greensock.TweenMax;
	import com.greensock.text.SplitTextField;
	import com.rgs.market.fonts.FontLibrary;
	
	import flash.display.Sprite;
	import flash.events.Event;
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
		private var currentSide : TextField;
		private var stf : SplitTextField;
		
		private var linesArray : Array;

		private var timing : XMLList;
		private var ticks : Number;
		private var timeIn : int;
		private var timeOut : int;
		
		public function BubbleManager(thePoem:String, theSettings:XMLList)
		{
			poem = cleanup(thePoem);
			timing = theSettings;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function cleanup(inString:String):String
		{
			var outString:String = inString;
			outString = outString.split("\n\n").join("\n");
			outString = outString.split("\\n").join("");
			outString = outString.split("'").join("’");
			return outString;
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			FontLibrary.getInstance();
			
			poemFormat = new TextFormat();
			poemFormat.letterSpacing = 1;
			poemFormat.size = 18;
			poemFormat.color = 0xFFFFFF;
			poemFormat.align = TextFormatAlign.LEFT;
			poemFormat.font = FontLibrary.FUTURA_LIGHT;
			
			poemField = new TextField();
			poemField.antiAliasType = AntiAliasType.ADVANCED;
			poemField.autoSize = TextFieldAutoSize.LEFT;
			poemField.wordWrap = true;
			poemField.embedFonts = true;
			poemField.selectable = false;
			poemField.width = 800;
			poemField.multiline = true;
			poemField.wordWrap = true;
			poemField.text = poem;
			poemField.setTextFormat(poemFormat);
			poemField.alpha = .2;
			
			//addChild(poemField);
			
			//MonsterDebugger.trace(this, poemField);
			
			linesArray = new Array();
			linesArray = poemField.text.split("\r");
			MonsterDebugger.trace(this, linesArray);
			
			lineFormat = new TextFormat();
			lineFormat.letterSpacing = 1;
			lineFormat.size = 48;
			lineFormat.color = 0xFFFFFF;
			lineFormat.align = TextFormatAlign.LEFT;
			lineFormat.font = FontLibrary.FUTURA_BOLD;
			
//			stf = new SplitTextField(poemField, "lines");
//			linesArray = stf.textFields;
			
//			for (var i:int=0; i<linesArray.length; i++)
//			{
//				MonsterDebugger.trace(this, "line: " + i + " -- " + linesArray[i]);
//			}
			
			leftField = new TextField();
			leftField = new TextField();
			leftField.antiAliasType = AntiAliasType.ADVANCED;
			leftField.autoSize = TextFieldAutoSize.LEFT;
			leftField.wordWrap = true;
			leftField.multiline = true;
			leftField.embedFonts = true;
			leftField.selectable = false;
			leftField.width = 300;
			leftField.defaultTextFormat = lineFormat;
			leftField.alpha = 0;
			addChild(leftField);
			
			rightField = new TextField();
			rightField = new TextField();
			rightField.antiAliasType = AntiAliasType.ADVANCED;
			rightField.autoSize = TextFieldAutoSize.RIGHT;
			rightField.wordWrap = true;
			rightField.multiline = true;
			rightField.embedFonts = true;
			rightField.selectable = false;
			rightField.width = 300;
			rightField.defaultTextFormat = lineFormat;
			rightField.alpha = 0;
			addChild(rightField);
			
			currentLine = 0;
			
			showNextLine();
			
		}
		
		
		private function showNextLine():void
		{
			if (currentLine % 2 == 0)
			{
				currentSide = leftField;
			}
			else
			{
				currentSide = rightField;
			}
			
			currentSide.text = linesArray[currentLine];
			
			ticks = 1 + Number(timing.speed)*currentSide.text.length / 10;
			timeIn = Number(timing.lineIn);
			timeOut = Number(timing.lineOut);
			
			MonsterDebugger.trace(this, "currentSide.text = " + currentSide.text);
			MonsterDebugger.trace(this, "ticks = " + ticks);
			
			currentSide.y = 150 + Math.floor(Math.random()*250);
			if (currentSide == leftField) { currentSide.x = 30; } else { currentSide.x = stage.stageWidth - 30 - currentSide.textWidth; }
			
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
	}
}