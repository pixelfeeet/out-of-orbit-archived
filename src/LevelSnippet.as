package {
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class LevelSnippet extends Entity {


		private var t:int; //Settings.TILESIZE
		public var xml:Class;
		
		private var rawData:ByteArray;
		private var dataString:String;
		private var xmlData:XML;
		
		private var w:int;
		private var h:int;

		public function LevelSnippet(_xml:Class) {
			super();
			xml = _xml;
			rawData = new xml;
			dataString = rawData.readUTFBytes(rawData.length);
			xmlData = new XML(dataString);
			
			w = xmlData.@width;
			h = xmlData.@height;

		}
		
		public function loadTiles():Array {
			var dataList:XMLList = xmlData.layer.data.tile.@gid;
			var tileData:Array = [];
			var column:int;
			var row:int;
			var gid:int;
			
			//set tiles
			gid = 0;
			for(row = 0; row < h; row ++){
				for(column = 0; column < w; column ++){
					var index:int = dataList[gid] - 1;
					if (index >= 0) {
						var data:Object = {"x": column, "y": row, "index": index};
						tileData.push(data);
					}
					gid++;
				}
			}
			return tileData;
		}
	}
} 