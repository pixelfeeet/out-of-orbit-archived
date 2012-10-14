package {
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.xml.XMLNode;
	
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
		
		private var rawData:ByteArray;
		private var dataString:String;
		private var xmlData:XML
		
		private var solidList:Array;
		private var gw:GameWorld;
		private var player:SpacemanPlayer;
		private var doorsLoaded:Boolean;
		
		public var label:String;
		//private var settings;
		private var w:int;
		private var h:int;
		
		public var doorList:Array;
		public var interactionItemList:Array;
		public var enemiesList:Array;
		
		public function Level(_xml:Class) {
			t = Settings.TILESIZE;
			xml = _xml;
			
			rawData = new xml;
			dataString = rawData.readUTFBytes( rawData.length );
			xmlData = new XML(dataString);
			
			//settings = xmlData.map;

			w = xmlData.@width;
			h = xmlData.@height;
			
			tiles = new Tilemap(Assets.CAVE_TILESET, w * t, h * t, t, t);
			graphic = tiles;
			layer = 1;
			
			grid = new Grid(w * t, h * t, t, t, 0, 0);
			mask = grid;
			
			type = "level";
			label = "defaultLevel"
			
			solidList = [];
			doorList = [];
			interactionItemList = [];
			enemiesList = [];
			
			
			loadTileProperties();
			loadTiles();
			doorsLoaded = false;
		}
		
		public function loadLevel(_w:GameWorld, _p:SpacemanPlayer):void {
			gw = _w;
			player = _p;
			loadEnemies(_w);
			loadDoors(_w, _p);
			loadInteractionItems(_w);
			loadPlayer(_w, _p);
		}
		
		override public function update():void {
			if (!doorsLoaded) loadDoors(gw, player);
		}
		
		private function loadTiles():void {
			
			var dataList:XMLList = xmlData.layer.(@name=="ground").data.tile.@gid;
			
			var column:int;
			var row:int;
			var gid:int;
			
			//set tiles
			gid = 0;
			for(row = 0; row < h; row ++){
				for(column = 0; column < w; column ++){
					tiles.setTile(column, row, dataList[gid] - 1);
					gid++;
				}
			}
			
			//set grid
			gid = 0;
			for(row = 0; row < h; row ++){
				for(column = 0; column < w; column ++){
					if (solidList[dataList[gid] - 1] == 1) {
						grid.setTile(column, row, true);
					} else {
						grid.setTile(column, row, false);
					}
					gid++;
				}
			}
		}
		
		public function loadTileProperties():void {
			var dataList:XMLList = xmlData.tileset.(@name == "cave_tileset").tile.properties.property;
			for (var i:int = 0; i < dataList.length(); i++){
				solidList[i] = dataList[i].(@name=="solid").@value;
			}
		}
		
		public function loadEnemies(_w:World):void {
			
			var dataList:XMLList = xmlData.objectgroup.(@name=="enemies").object;
			for (var i:int = 0; i < dataList.length(); i++){

				var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
				var e:Enemy = new Enemy(ePos, 60);
				enemiesList.push(e);
				_w.add(e);
			}
		}
		
		public function loadInteractionItems(_w:World):void {
			
			var dataList:XMLList = xmlData.objectgroup.(@name=="interactionitems").object;
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
				interactionItemList.push(ii);
				_w.add(ii);
			}
		}
		
		public function loadPlayer(_w:World, _player:SpacemanPlayer):void{
			var dataList:XMLList = xmlData.objectgroup.(@name=="player").object;
			_player.x = dataList.@x;
			_player.y = dataList.@y;
			_w.add(_player);
		}
		
		public function loadDoors(_w:GameWorld, _player:SpacemanPlayer):void{
			var dataList:XMLList = xmlData.objectgroup.(@name=="doors").object;
			for (var i:int = 0; i < dataList.length(); i ++){
				var j:XML = dataList[i];
				var d:Door = new Door(new Point(j.@x, j.@y), _w, this, _player, j.@height, j.@width);
				d.label = j.@name;
				d.destinationLevelLabel = j.properties.property.(@name=="destinationLevel").@value;
				d.destinationDoor = j.properties.property.(@name=="destinationDoor").@value;
				if (j.properties.property.(@name=="playerSpawnsToLeft").@value == "true")
					d.playerSpawnsToLeft = true;
				else d.playerSpawnsToLeft = false;

				doorList.push(d);
				_w.add(d);
			}
			doorsLoaded = true;
		}
		
		override public function removed():void {
			for each (var door:Door in doorList) {
				gw.remove(door);
			}
			
			for each (var item:InteractionItem in interactionItemList) {
				gw.remove(item);
			}
			
			for each (var enemy:Enemy in enemiesList) {
				gw.remove(enemy);
			}
		}
		
	}
	
}