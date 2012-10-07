package {
	
	import flash.utils.ByteArray;
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	import utilities.Settings;
	
	public class Level extends Entity {
		private var tiles:Tilemap;
		private var grid:Grid;
		private var t:int; //Settings.TILESIZE
		
		public function Level(xml:Class) {
			t = Settings.TILESIZE;
			
			tiles = new Tilemap(Assets.CAVE_TILESET, 40 * t, 40 * t, t, t);
			graphic = tiles;
			layer = 1;
			
			grid = new Grid(40 * t, 40 * t, t, t, 0, 0);
			mask = grid;
			
			type = "level";
			
			loadLevel(xml);
		}
		
		private function loadLevel(xml:Class):void {
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes( rawData.length );
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			
			dataList = xmlData.layer.(@name=="ground").data.tile.@gid;
			
			//set tiles
			var column:int;
			var row:int;
			
			var gid:int = 0;
			for(row = 0; row < 40; row ++){
				for(column = 0; column < 40; column ++){
					tiles.setTile(column, row, dataList[gid] - 1);
					gid++;
				}
			}
			
			//set grid
			gid = 0;
			for(row = 0; row < 40; row ++){
				for(column = 0; column < 40; column ++){
					if (dataList[gid] == 2) {
						grid.setTile(column, row, true);
					} else {
						grid.setTile(column, row, false);
					}
					gid++;
				}
			}
		}
		
	}
	
}