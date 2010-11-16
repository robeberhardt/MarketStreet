package com.rgs.market.vis
{
	import com.greensock.TweenMax;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.VideoLoader;
	import com.greensock.loading.data.VideoLoaderVars;
	import com.rgs.utils.monster.Monster;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	import nl.demonsters.debugger.MonsterDebugger;
	
	import org.osflash.signals.Signal;
	
	public class VideoLooper extends Sprite
	{
		private var settings		: XMLList;
		
		private var vars			: VideoLoaderVars;
		private var request			: URLRequest;
		private var loader			: VideoLoader;
		private var videoURL		: String;
		private var vw				: int;
		private var vh				: int;
		private var loop			: Boolean;
		
		private var hideComplete	: Signal;
		
		private var videoData		: XML;
		
		public function VideoLooper(settings:XMLList)
		{
			this.settings = settings;
			alpha = 0;
			visible = false;
			hideComplete = new Signal();
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init); }
		}
				
		public function load(d:Date):void
		{
			Monster.debug(this, "wtf");
			hideComplete.addOnce(function():void
			{
				Monster.debug(this, "loading " + d.date);
				loader.unload();
				videoData = settings.video[d.day];
				Monster.info(this, videoData);
				request.url = videoData.url.toString();
				x = Number(videoData.@xpos);
				y = Number(videoData.@ypos);
				loader.load();
			});
			hide();
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			request = new URLRequest();
			request.url = "http://www.google.com";
			
			vars = new VideoLoaderVars();
			vars.name("video");
			vars.container(this);
			vars.width(1280);
			vars.height(720);
			vars.repeat(-1);
			//if (loop) { vars.repeat = -1; } else { vars.repeat = 0; }
			vars.onComplete(onComplete);
			vars.onFail(onFail);
			
			loader = new VideoLoader(request, vars);
			
		}
		
		public function hide():void
		{
			Monster.debug(this, "hiding");
			TweenMax.to(this, 1, { autoAlpha: 0, onUpdate: sendHideUpdate, onComplete: sendHideCompleteSignal } );
		}
		
		private function sendHideUpdate():void
		{
			//Monster.debug(this, "hiding update");
		}
		
		public function sendHideCompleteSignal():void
		{
			Monster.debug(this, "seinding hide complete signal");
			hideComplete.dispatch();
		}
		
		public function show():void
		{
			TweenMax.to(this, 1, { autoAlpha: 1 });
		}
		
		public function resize():void
		{
			scaleX = stage.stageWidth / 1280;
			scaleY = stage.stageHeight / 720;
		}
		
		private function onComplete(e:LoaderEvent):void
		{
			show();
			loader.playVideo();
		}
		
		private function onFail(e:LoaderEvent):void
		{
			Monster.error(this, "Couldn't load video for some reason");
		}
	}
}