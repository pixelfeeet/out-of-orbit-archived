package {
	
	import NPCs.NPC;
	
	import flash.display3D.IndexBuffer3D;
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
	
	import utilities.Settings;
	
	public class Level extends Entity {
		private var tiles:Tilemap;
		private var grid:Grid;
		private var t:int; //Settings.TILESIZE
		public var xml:Class;
		
		private var rawData:ByteArray;
		private var dataString:String;
		private var xmlData:XML;
		
		private var solidList:Array;
		private var gw:GameWorld;
		private var player:SpacemanPlayer;
		private var doorsLoaded:Boolean;
		
		public var label:String;
		
		private var w:int;
		private var h:int;
		
		public var backgroundColor:uint;
		
		public var doorList:Array;
		public var interactionItemList:Array;
		public var enemiesList:Array;
		public var NPClist:Array;
		
		public var timeMask:Entity;
		private var graphicList:Graphiclist;
		
		private var groundDepth:int;
		
		public function Level(_w:GameWorld, _p:SpacemanPlayer) {
			t = Settings.TILESIZE;

			//xml = _xml;
			//rawData = new xml;
			//dataString = rawData.readUTFBytes(rawData.length);
			//xmlData = new XML(dataString);
			
			//w = xmlData.@width;
			//h = xmlData.@height;
			
			w = 50;
			h = 40;
			
			tiles = new Tilemap(Assets.JUNGLE_TILESET, w * t, h * t, t, t);
			graphic = new Graphiclist(tiles);
			layer = -10;
			
			grid = new Grid(w * t, h * t, t, t, 0, 0);
			mask = grid;
			
			setHitboxTo(grid);
			
			type = "level";
			label = "defaultLevel"
			
			solidList = [];
			doorList = [];
			interactionItemList = [];
			enemiesList = [];
			NPClist = [];
			
			//loadTileProperties();
			//loadTiles();
			loadLevel(_w, _p);
			doorsLoaded = false;
			
			groundDepth = 3;
			
			generateTiles();
		}
		
		public function loadLevel(_w:GameWorld, _p:SpacemanPlayer):void {
			gw = _w;
			player = _p;
			//loadEnemies(_w);
			//loadNPCs(_w);
			//loadDoors(_w, _p);
			//loadInteractionItems(_w);
			//loadScenery(_w);
			loadPlayer(_w, _p);
		}

		
		private function generateTiles():void {
			var gid:int;
			
			var pockets:int = 10;
			var pocketWidth:int = 7;
			var halfPocketWidth:int = Math.abs(pocketWidth / 2)
			var pocketPoints:Array = [];
			
			//Fill the entire map in
			//tiles.setRect(0, 0, w, h, 12);
		
			var column:int;
			var row:int; 
			
			//Generate center points for pockets

			//for (var j:int = 0; j < pockets; j++) {

			while (pocketPoints.length < pockets) {
				var p:Point;
				if (pocketPoints.length == 0) {
					p = randomPoint();
					pocketPoints.push(p);
				}
				p = randomPoint();
				var isolated:Boolean = true;
				iLoop: for (var i:int = 0; i < pocketPoints.length; i++) {

					if (Math.abs(pocketPoints[i].x - p.x) > pocketWidth + 1
						|| Math.abs(pocketPoints[i].y - p.y) > pocketWidth + 1) {
						isolated = true;
					} else {
						isolated = false;
						break iLoop;
					}
				}
				if (isolated) pocketPoints.push(p);
				//trace("isolated: " + isolated);
				//trace("length: " + pocketPoints.length);
			}
		
			//drawPocket(pockets, pocketPoints, pocketWidth);
			
			//Draw tunnel
//			for (var line:int = 0; line < pockets - 1; line++) {
//				drawLine(pocketPoints[line], pocketPoints[line + 1]);
//			}
			
			//Horizontal tunnel
//			var horzTunnels:int = 5;
//			var horzTunnelLen:int = 20;
//			for (var t:int = 0; t < horzTunnels; t++) {
//				var start:Point = randomPoint();
//				var end:Point = new Point(start.x + horzTunnelLen, start.y);
//				drawLine(start, end, {"width": 5, "height": 5, "positive": true});
//			}

//			for (var f:int = 0; f < horzTunnels; f++){
//				var start:Point = randomPoint();
//				for (var s:int = 0; s < horzTunnelLen; s++){
//					tiles.clearTile(start.x + s, start.y);
//					tiles.clearTile(start.x + s, start.y + 1);
//				}
//			}
			drawGround(groundDepth);
			drawHill([new Point(5, 0), new Point(20, 10), new Point(25, 10)]);
			drawIsland();
			fixGround();
		}
		
		private function fixGround():void {
			for (var x:int = 0; x < w; x++){
				for (var y:int = 0; y < h; y++){
					if (tiles.getTile(x, y) == 12){
						var index:int = fixTile(x, y);
						tiles.setTile(x, y, index);
					}
				}
			}
		}
		
		private function fixTile(x:int, y:int):int {
			//tile above is empty
			if (tiles.getTile(x, y - 1) == 0) {
				//tile to the left is also empty
				if (tiles.getTile(x - 1, y) == 0) {
					return 1;
				//tile to the right is also empty
				} else if (tiles.getTile(x + 1, y) == 0) {
					return 3;
				}
				return 2;
			}
			
			//tile below is empty
			if (tiles.getTile(x, y + 1) == 0) {
				//tile to the left is also empty
				if (tiles.getTile(x - 1, y) == 0) {
					return 21;
					//tile to the right is also empty
				} else if (tiles.getTile(x + 1, y) == 0) {
					return 23;
				}
				return 22;
			}
			
			//tile to the right is empty
			if (tiles.getTile(x + 1, y) == 0) return 13;
			
			//tile to the left is empty
			if (tiles.getTile(x - 1, y) == 0) return 11;
			
			//tile to the top-left is empty
			if (tiles.getTile(x - 1, y - 1) == 0) return 4;

			//tile to the top-right is empty
			if (tiles.getTile(x + 1, y - 1) == 0) return 5;
			
			return 12;
		}
		
		private function drawIsland():void {
			var minWidth:int = 8;
			var minHeight:int = 8;
			
			var islandWidth:int = Math.round(minWidth + (Math.random() * 5));
			var islandHeight:int = Math.round(minHeight + (Math.random() * 5));
			var x:int = Math.floor((Math.random() * w) - islandWidth);
			var y:int = Math.floor((Math.random() * h) - islandHeight);
			tiles.setRect(x, y, islandWidth, islandHeight, 12);
		}
		
		private function randomPoint():Point {
			var x:int = Math.ceil(Math.random() * w);
			var y:int = Math.ceil(Math.random() * h);
			return new Point(x, y);
		}
		
		private function drawPocket(pockets:int, pocketPoints:Array, pocketWidth:int):void {
			for (var pocket:int = 0; pocket < pockets; pocket++) {
				var _x:int = pocketPoints[pocket].x;
				var _y:int = pocketPoints[pocket].y;
				
				var startX:int = _x - (pocketWidth / 2);
				var startY:int = _y - (pocketWidth / 2);
				
				startX = _x - Math.floor(pocketWidth / 2);
				startY = _y - Math.floor(pocketWidth / 2);
				for (var column:int = startX; column < startX + pocketWidth; column++){
					for (var row:int = startY; row < startY + pocketWidth; row++) {
						tiles.clearTile(column, row);
					}
				}
			}
		}
		
		private function drawLine(startPoint:Point, endPoint:Point, options:Object = null):void {
			var currentPoint:Point = new Point(startPoint.x, startPoint.y);
			var width:int = 1;
			var height:int = 1;
			var positive:Boolean = false; //true = setTile, false = clearTile
			
			if (options) {
				if (options["width"]) width = options["width"];
				if (options["height"]) height = options["height"];
				if (options["positive"]) positive = options["positive"];
			}
			
			//trace("options: " + options)
			//trace(width + ", " + height + ", postive = " + positive)
			
			var points:Array = getLine(startPoint.x, endPoint.x, startPoint.y, endPoint.y);
			for each(var po:Point in points){
				
				for (var w:int = 0; w < width; w++){
					for (var h:int = 0; h < height; h++){
						if (positive) tiles.setTile(po.x + w, po.y + h, 12)
						else tiles.clearTile(po.x + w, po.y + h);
					}
				}
			}
		}
		
		private function drawGround(depth:int):void {
			for (var i:int = 0; i < depth; i++) {
				var start:Point = new Point(0, h - (i + 1));
				var end:Point = new Point(w - 1, h - (i + 1));
				drawLine(start, end, {"positive": true});
			}
		}
		
		private function drawSlope(start:Point, end:Point):void {
			drawLine(start, end, {"positive": true});
		}
		
		private function fillSlope(start:Point, end:Point):void {
			drawSlope(start, end);
			var fillStart:Point;
			//handle horizontal slopes
			if (start.y == end.y) {
				//return;
			}
			
			//if the slope is vertical, no filling is needed.
			if (start.x == end.x) return;
			
			if (start.y < end.y) fillStart = start;
			else fillStart = end;
			
			var current:Point = new Point(fillStart.x, fillStart.y + 1);
			
			while (current.y < (h - groundDepth)){
				while(tiles.getTile(current.x, current.y) == 0) {
					tiles.setTile(current.x, current.y, 12);
					if ((start.x < end.x && start.y > end.y) || start.y == end.y) current.x--;
					else current.x++;
				}
				current.x = fillStart.x;
				current.y++;
			}
			
		}
		
		private function drawHill(stops:Array):void {
			var start:Point;
			var end:Point;
			for (var i:int = 0; i < stops.length - 1; i++){
				/**
				 * The current fill algorithm breaks if the x points are drawn on
				 * top of each other, so after the first point they need to be offset
				 * by 1
				 */
				var offsetX:int;
				if (i == 0) offsetX = 0;
				else offsetX = 1;
				start = new Point(stops[i].x + offsetX, h - (groundDepth + 1) - stops[i].y);
				end = new Point(stops[i + 1].x, h - (groundDepth + 1) - stops[i + 1].y)
				fillSlope(start, end);
			}
			start = new Point(10, h - (groundDepth + 1));
			end = new Point(20, h - (groundDepth + 1) - 5);

		}
		
		private function loadTiles():void {

			generateTiles();
//			var dataList:XMLList = xmlData.layer.(@name=="ground").data.tile.@gid;
//			
//			var column:int;
//			var row:int;
//			var gid:int;
//			
//			//set tiles
//			gid = 0;
//			for(row = 0; row < h; row ++){
//				for(column = 0; column < w; column ++){
//					var index:int = dataList[gid] - 1;
//					if (index >= 0) {
//						tiles.setTile(column, row, index);
//					}
//					gid++;
//				}
//			}
//			
//			//set grid
//			gid = 0;
//			for(row = 0; row < h; row ++){
//				for(column = 0; column < w; column ++){
//					if (solidList[dataList[gid] - 1] != null &&
//						solidList[dataList[gid] - 1] == 1) {
//						grid.setTile(column, row, true);
//					} else {
//						grid.setTile(column, row, false);
//					}
//					gid++;
//				}
//			}
		}
//		
//		public function loadTileProperties():void {
//			var dataList:XMLList = xmlData.tileset.(@name == "jungle_tileset").tile;
//			for (var i:int = 0; i < dataList.length(); i++){
//				solidList[dataList[i].@id] = dataList[i].properties.property.(@name=="solid").@value;
//			}
//		}
//		
//		public function loadScenery(_w:World):void {
//			loadWScenery(_w, "backgroundScenery", false);
//			loadWScenery(_w, "frontScenery", true);
//		}
//		
//		public function loadWScenery(_w:World, _name:String, inFront:Boolean):void {
//			var dataList:XMLList = xmlData.objectgroup.(@name==_name).object;
//			for (var i:int = 0; i < dataList.length(); i++){
//				var e:InteractionItem;
//				for (var j:int = 0; j < GameWorld.scenery.list.length; j++){
//					if (GameWorld.scenery.list[j].label == dataList[i].@type){
//						e = GameWorld.scenery.list[j];
//					}
//				}
//				var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
//				var ii:InteractionItem = new InteractionItem();
//				ii = GameWorld.scenery.copyItem(e, ePos);
//				if (inFront) ii.layer = -100
//				else ii.layer = 100;
//				interactionItemList.push(ii);
//				_w.add(ii);
//			}	
//		}
//		
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
//					if (enemiesList[j].eliminated == false) {
//						_w.add(enemiesList[j]);
//					}
//				}
//			}
//		}
//		
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
//		
//		public function loadInteractionItems(_w:World):void {
//			var dataList:XMLList = xmlData.objectgroup.(@name=="interactionitems").object;
//			for (var i:int = 0; i < dataList.length(); i++){
//				var e:InteractionItem;
//				for (var j:int = 0; j < GameWorld.interactionItems.list.length; j++){
//					if (GameWorld.interactionItems.list[j].label == dataList[i].@type){
//						e = GameWorld.interactionItems.list[j];
//					}
//				}
//				var ePos:Point = new Point(dataList[i].@x, dataList[i].@y);
//				var ii:InteractionItem = new InteractionItem();
//				ii = GameWorld.interactionItems.copyItem(e, ePos);
//				interactionItemList.push(ii);
//				_w.add(ii);
//			}
//		}
		
		public function loadPlayer(_w:World, _player:SpacemanPlayer):void{
			//var dataList:XMLList = xmlData.objectgroup.(@name=="player").object;
			//_player.x = dataList.@x;
			//_player.y = dataList.@y;
			_player.x = 30;
			_player.y = 30;
			_w.add(_player);
		}
		
//		public function loadDoors(_w:GameWorld, _player:SpacemanPlayer):void{
//			var dataList:XMLList = xmlData.objectgroup.(@name=="doors").object;
//			for (var i:int = 0; i < dataList.length(); i ++){
//				var j:XML = dataList[i];
//				var d:Door = new Door(new Point(j.@x, j.@y), _w, this, _player, j.@height, j.@width);
//				d.label = j.@name;
//				d.destinationLevelLabel = j.properties.property.(@name=="destinationLevel").@value;
//				d.destinationDoor = j.properties.property.(@name=="destinationDoor").@value;
//				if (j.properties.property.(@name=="playerSpawnsToLeft").@value == "true")
//					d.playerSpawnsToLeft = true;
//				else d.playerSpawnsToLeft = false;
//				
//				doorList.push(d);
//				_w.add(d);
//			}
//			doorsLoaded = true;
//		}
		
		
		//Based on Bresenham's Line Algorithm:
		// http://roguebasin.roguelikedevelopment.org/index.php?title=Bresenham%27s_Line_Algorithm
		private function getLine(x0:int, x1:int, y0:int, y1:int):Array {
			var points:Array = []
			var steep:Boolean = (Math.abs(y1-y0)) > (Math.abs(x1-x0))
			var placeHolder:int;
			if (steep) {
				//x0, y0 = y0, x0;
				placeHolder = x0;
				x0 = y0;
				y0 = placeHolder;
				//x1, y1 = y1, x1;
				placeHolder = x1;
				x1 = y1;
				y1 = placeHolder;
			}
			if (x0 > x1) {
				//x0, x1 = x1, x0;
				placeHolder = x0;
				x0 = x1;
				x1 = placeHolder;
				//y0, y1 = y1, y0;
				placeHolder = y0;
				y0 = y1;
				y1 = placeHolder;
			}
			var deltax:Number = x1 - x0
			var deltay:Number = Math.abs(y1 - y0)
			var error:int = (deltax / 2)
			var y:int = y0
			var ystep:Number;
			if (y0 < y1) {
				ystep = 1
			} else {
				ystep = -1
			}
			for (var x:int = x0; x <= x1; x++) {
				var o:Point;
				if (steep) {
					points.push(new Point(y, x));
				} else {
					points.push(new Point(x, y));
				}
				error -= deltay;
				if (error < 0) {
					y += ystep
					error += deltax
				}
			}

			return points;
		}
		

		
		override public function removed():void {
			
			for each (var door:Door in doorList) {
				FP.world.remove(door);
			}
			
			for each (var item:InteractionItem in interactionItemList) {
				FP.world.remove(item);
			}
			
			for each (var enemy:Enemy in enemiesList) {
				FP.world.remove(enemy);
			}
			
		}
		
	}
	
}