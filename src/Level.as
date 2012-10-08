package {
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	import utilities.Settings;
	
	public class Level extends Entity {
		private var tiles:Tilemap;
		private var grid:Grid;
		private var t:int; //Settings.TILESIZE
		private var xml:Class;
		
		public function Level(_xml:Class) {
			t = Settings.TILESIZE;
			
			tiles = new Tilemap(Assets.CAVE_TILESET, 40 * t, 40 * t, t, t);
			graphic = tiles;
			layer = 1;
			
			grid = new Grid(40 * t, 40 * t, t, t, 0, 0);
			mask = grid;
			
			type = "level";
			
			xml = _xml;
			
			loadLevel();
			//loadEnemies();
		}
		
		private function loadLevel():void {
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
		
		public function loadEnemies(_w:World):void {
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes( rawData.length );
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			
			dataList = xmlData.objectgroup.(@name=="enemies").object;
			for (var i:int = 0; i < dataList.length(); i++){
				//var enemyType:String = dataList[i].@type;
				var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
				var e:Enemy = new Enemy(ePos, 60);
				_w.add(e);
			}
		}
		
		public function loadInteractionItems(_w:World):void {
			var rawData:ByteArray = new xml;
			var dataString:String = rawData.readUTFBytes( rawData.length );
			var xmlData:XML = new XML(dataString);
			
			var dataList:XMLList;
			var dataElement:XML;
			
			dataList = xmlData.objectgroup.(@name=="interactionitems").object;
			for (var i:int = 0; i < dataList.length(); i++){
				var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
				var e:InteractionItem;
				for (var j:int = 0; j < GameWorld.interactionItems.list.length; j++){
					if (GameWorld.interactionItems.list[j].label == dataList[i].@type){
						e = GameWorld.interactionItems.list[j];
					}
				}
				var ii:InteractionItem = new InteractionItem(ePos);
				ii.setGraphic(e.graphic);
				ii.setInventoryItem(e.getInventoryItem());
				_w.add(ii);
			}
		}
		
	}
	
}