package {
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	
	import utilities.Settings;
	
	public class Background extends Entity {
		public var t:int;
		
		public var xml:Class;
		private var rawData:ByteArray;
		private var dataString:String;
		private var xmlData:XML;
		
		private var color:uint;

		private var w:int;
		private var h:int;
		
		private var tiles:Tilemap;
		
		public function Background(_color:uint) {
			super();
			
			t = Settings.TILESIZE;
			color = _color;
			
			init();
			layer = 100;
		}
		
		public function init():void {
			//xml = _xml;
			//rawData = new xml;
			//dataString = rawData.readUTFBytes( rawData.length );
			//xmlData = new XML(dataString);
			
			w = 100;// xmlData.@width;
			h = 40;//xmlData.@height;
			
			//tiles = new Tilemap(Assets.CAVE_TILESET, w * t, h * t, t, t);
			graphic = Image.createRect(w * t, h * t, color, 1);
		}
	}
}