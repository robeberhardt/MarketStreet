package com.rgs.market
{
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.data.VideoLoaderVars;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	public class VideoLooper extends Sprite
	{
		private var vars			: VideoLoaderVars;
		private var loader			: VideoLoader;
		private var videoURL		: String;
		private var vw				: int;
		private var vh				: int;
		private var loop			: Boolean;
		
		public function VideoLooper(url:String, width:int, height:int, xpos:Number, ypos:Number, shouldLoop:Boolean = true)
		{
			videoURL = url;
			vw = width;
			vh = height;
			x = xpos;
			y = ypos;
			loop = shouldLoop;
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			var vars:VideoLoaderVars = new VideoLoaderVars();
			vars.name = "video";
			vars.container = this;
			vars.width = vw;
			vars.height = vh;
			if (loop) { vars.repeat = -1; } else { vars.repeat = 0; }
			vars.onComplete = onComplete;
			vars.onFail = onFail;
			loader = new VideoLoader(videoURL, vars);
			loader.load();
		}
		
		public function resize():void
		{
			scaleX = stage.stageWidth / 1280;
			scaleY = stage.stageHeight / 800;
		}
		
		private function onComplete(e:LoaderEvent):void
		{
			loader.playVideo();
		}
		
		private function onFail(e:LoaderEvent):void
		{
			MonsterDebugger.trace(this, "Couldn't load video for some reason", 0xff0000);
		}
	}
}