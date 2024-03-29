package Levels {
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
	
	public class StaticLevel extends Level {		
		private var rawData:ByteArray;
		private var dataString:String;
		private var xmlData:XML;
		
		public var first:Boolean;
		
		public function StaticLevel(params:Object) {
			super();
			label = "static level"
			xml = params["xml"];
			if (params["label"]) label = params["label"];			
			
			rawData = new xml;
			dataString = rawData.readUTFBytes(rawData.length);
			xmlData = new XML(dataString);
			
			w = xmlData.@width;
			h = xmlData.@height;
			
			first = false;
			//loadTileProperties();
		}
		
		override public function added():void {
			super.added();
			gameworld = GameWorld(FP.world);
			player = gameworld.player;
			
			loadLevel();
		}
		
		override public function loadLevel():void {
			loadTiles();
			setGrid();
			loadDoors();
		}
		
		public function loadPlayer():void{
			var dataList:XMLList = xmlData.objectgroup.(@name=="player").object;
			player.x = dataList.@x;
			player.y = dataList.@y;
			gameworld.add(player);
		}
		
		
		private function loadTiles():void {
			var dataList:XMLList = xmlData.layer.(@name=="ground").data.tile.@gid;
			var column:int;
			var row:int;
			var gid:int;
			
			//set tiles
			gid = 0;
			for(row = 0; row < h; row ++) {
				for(column = 0; column < w; column ++) {
					var index:int = dataList[gid] - 1;
					if (index >= 0) tiles.setTile(column, row, index);
						gid++;
				}
			}
		}
		
		public function loadScenery(_w:World):void {
			loadWScenery(_w, "backgroundScenery", false);
			loadWScenery(_w, "frontScenery", true);
		}
		
		public function loadWScenery(_w:World, _name:String, inFront:Boolean):void {
			var dataList:XMLList = xmlData.objectgroup.(@name==_name).object;
			for (var i:int = 0; i < dataList.length(); i++){
				var e:InteractionItem;
				for (var j:int = 0; j < gameworld.scenery.list.length; j++){
					if (gameworld.scenery.list[j].label == dataList[i].@type)
						e = gameworld.scenery.list[j];
				}
				var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
				var ii:InteractionItem = new InteractionItem();
				ii = gameworld.scenery.copyItem(e, ePos);
				if (inFront) ii.layer = -100
				else ii.layer = 100;
				interactionItemList.push(ii);
				_w.add(ii);
			}	
		}
		
//		public function loadEnemies(_w:World):void {
//			if (enemiesList.length == 0){
//				var dataList:XMLList = xmlData.objectgroup.(@name=="enemies").object;
//				for (var i:int = 0; i < dataList.length(); i++){
//					
//					var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
//					var e:Enemy = new Enemy(ePos, 60);
//					enemiesList.push(e);
//					_w.add(e);
//				}
//			} else {
//				for (var j:int = 0; j < enemiesList.length; j++){
//					if (enemiesList[j].eliminated == false)
//						gameworld.add(enemiesList[j]);
//				}
//			}
//		}
		
//		public function loadNPCs(_w:World):void {
//			if (NPClist.length == 0){
//				var dataList:XMLList = xmlData.objectgroup.(@name=="NPCs").object;
//				for (var i:int = 0; i < dataList.length(); i++){
//					var e:Entity;
//					var list:Array = GameWorld.npcs.list;
//					for (var j:int = 0; j < list.length; j++){
//						if (dataList[i].@type == list[j].label) {
//							e = new list[j]();
//							e.x = dataList[i].@x
//							e.y = dataList[i].@y;
//							break;
//						}
//					}
//					NPClist.push(e);
//					_w.add(e);
//				}
//			} else {
//				for (var k:int = 0; k < NPClist.length; k++){
//					if (NPClist[k].eliminated == false) {
//						_w.add(NPClist[k]);
//					}
//				}
//			}
//		}
		
//		public function loadInteractionItems(_w:World):void {
//			var dataList:XMLList = xmlData.objectgroup.(@name=="interactionitems").object;
//			for (var i:int = 0; i < dataList.length(); i++){
//				var e:InteractionItem;
//				for (var j:int = 0; j < gameworld.interactionItems.list.length; j++){
//					if (gameworld.interactionItems.list[j].label == dataList[i].@type){
//						e = gameworld.interactionItems.list[j];
//					}
//				}
//				var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
//				var ii:InteractionItem = new InteractionItem();
//				ii = gameworld.interactionItems.copyItem(e, ePos);
//				interactionItemList.push(ii);
//				_w.add(ii);
//			}
//		}
		
		public function loadDoors():void{
			if (xmlData.objectgroup.(@name=="start").object.(@name=="start") && first) {
				trace(typeof xmlData.objectgroup.(@name=="start"))
				var start:XMLList = xmlData.objectgroup.(@name=="start").object;
				player.x = start.@x;
				player.y = start.@y;
				first = false;
			}
			
			var dataList:XMLList = xmlData.objectgroup.(@name=="doors").object;
			for (var i:int = 0; i < dataList.length(); i ++){
				var j:XML = dataList[i];
				var d:Door = new Door(new Point(j.@x, j.@y), this, j.@height, j.@width);
				d.label = j.@name;
				d.destinationLevelLabel = j.properties.property.(@name=="destinationLevel").@value;
				
				d.destinationDoor = j.properties.property.(@name=="destinationDoor").@value;
				if (j.properties.property.(@name=="playerSpawnsToLeft").@value == "true")
					d.playerSpawnsToLeft = true;
				else d.playerSpawnsToLeft = false;
				
				doorList.push(d);
				gameworld.add(d);
			}
		}
	}
}