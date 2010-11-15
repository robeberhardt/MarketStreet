package com.rgs.market.fonts
{
	import flash.display.Sprite;
	
	public class FontLibrary extends Sprite
	{
		[Embed(source="../../../../../assets/fonts/FuturaStd-Light.otf", fontName="Futura Light", mimeType="application/x-font-opentype")]
		private static var FuturaLight : Class;
		
		[Embed(source="../../../../../assets/fonts/FuturaStd-Book.otf", fontName="Futura Book", mimeType="application/x-font-opentype")]
		private static var FuturaBook : Class;
		
		[Embed(source="../../../../../assets/fonts/FuturaStd-Medium.otf", fontName="Futura Medium", mimeType="application/x-font-opentype")]
		private static var FuturaMedium : Class;
		
		[Embed(source="../../../../../assets/fonts/FuturaStd-Bold.otf", fontName="Futura Bold", fontWeight = "bold", mimeType="application/x-font-opentype")]
		private static var FuturaBold : Class;
		
		[Embed(source="../../../../../assets/fonts/acmesa.ttf", fontName="A.C.M.E. Secret Agent", mimeType="application/x-font-truetype")]
		private static var ACMESecretAgent : Class;
		
		private static var instance					: FontLibrary;
		private static var allowInstantiation		: Boolean;
		
		public static const FUTURA_LIGHT			: String = "Futura Light";
		public static const FUTURA_BOLD				: String = "Futura Bold";
		public static const FUTURA_BOOK				: String = "Futura Book";
		public static const FUTURA_MEDIUM			: String = "Futura Medium";
		public static const ACME_SECRET_AGENT		: String = "A.C.M.E. Secret Agent";
		
		public function FontLibrary(name:String = "FontLibrary") 
		{
			if (!allowInstantiation) {
				throw new Error("Error: Instantiation failed: Use FontLibrary.getInstance()");
			} else {
				this.name = name;
				init();
			}
		}
		
		public static function getInstance(name:String = "FontLibrary"):FontLibrary {
			if (instance == null) {
				allowInstantiation = true;
				instance = new FontLibrary(name);
				allowInstantiation = false;
			}
			return instance;
		}
		
		private function init():void
		{		
			//
		}
	}
}