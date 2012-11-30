package {
	
	import NPCs.DustBall;
	import NPCs.Enemy;
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
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import utilities.Settings;
	
	public class Level extends Entity {
		public var tiles:Tilemap;
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
		
		public var w:int;
		public var h:int;
		
		public var backgroundColor:uint;
		
		public var doorList:Array;
		public var interactionItemList:Array;
		public var enemiesList:Array;
		public var NPClist:Array;
		
		public var timeMask:Entity;
		private var graphicList:Graphiclist;
		
		private var groundDepth:int;
		
		private var jungleTiles:Object;
		private var notSolids:Array;
		private var waterLevel:int;
		
		private var flatGround:Array;
		
		public function Level(_w:GameWorld, _p:SpacemanPlayer) {
			t = Settings.TILESIZE;
			
			w = 150;
			h = 60;
			
			tiles = new Tilemap(Assets.JUNGLE_TILESET, w * t, h * t, t, t);
			graphic = new Graphiclist(tiles);
			layer = -600;
			
			grid = new Grid(w * t, h * t, t, t, 0, 0);
			mask = grid;
			
			type = "level";
			label = "defaultLevel"
			
			solidList = [];
			doorList = [];
			interactionItemList = [];
			enemiesList = [];
			NPClist = [];
			
			jungleTiles = {"ground": {
					"topLeft": 1,
					"topMid": 2,
					"topRight": 3,
					"midLeft": 11,
					"middle": 12,
					"midRight": 13,
					"botLeft": 21,
					"botMid": 22,
					"botRight": 23,
					"topLeftTuft": 4,
					"topRightTuft": 5,
					"bottomLeftTuft": 14,
					"bottomRightTuft": 15
				},
				"structure": {
					"block": 7,
					"bg": 17
				},
				"constructionBlock": 10,
				"water": 30
			};
			
			notSolids = [
				0,
				jungleTiles["structure"]["bg"]
			];
			
			backgroundColor = 0xa29a8d;
			loadLevel(_w, _p);
			doorsLoaded = false;
			
			groundDepth = 0;
			waterLevel = 8;
			
			generateTiles();
			generateNPCs(_w, {"kind": "enemy"});
			generateNPCs(_w, {"kind": "NPC"});
		}
		
		public function loadLevel(_w:GameWorld, _p:SpacemanPlayer):void {
			gw = _w;
			player = _p;
			//loadNPCs(_w);
			//loadDoors(_w, _p);
			//loadInteractionItems(_w);
			//loadScenery(_w);
			loadPlayer(_w, _p);
		}

		
		private function generateTiles():void {

			flatGround = [];
			
			//drawGround(groundDepth);
			generateHillStops()
			generateWater();
			drawBergs();
			generateIslands();
			generateStructure();
			generateAbandonedShip();
			fixGround();
			setGrid();
			generateRocks();

			setHitboxTo(grid);
		}
		
		private function generateStructure():void {
			var wallWidth:int = 1;
			
			var structWidth:int = (Math.random() * 10) + 5;
			var structHeight:int = (Math.random() * 10) + 5;
			var structX:int = Math.random() * (w - structWidth);
			var structY:int = Math.random() * (h - structHeight);
			tiles.setRect(structX, structY, structWidth, structHeight, jungleTiles["structure"]["block"]);
			tiles.setRect(structX + wallWidth, structY + wallWidth,
			structWidth - (wallWidth * 2), structHeight - (wallWidth * 2), jungleTiles["structure"]["bg"]);
		}
		
		private function generateAbandonedShip():void {
			
		}
		
		private function generateRocks():void {
			
			var smallRocks:Array = [
				Assets.ROCK1,
				Assets.ROCK3,
				Assets.ROCK5,
				Assets.ROCK6,
				Assets.ROCK7,
				Assets.ROCK8,
			]
			
			var largeRocks:Array = [
				Assets.ROCK2,
				Assets.ROCK4,
			]
			
			for (var i:int = 0; i < flatGround.length; i++){
				var roll:int = Math.floor(Math.random() * 6)
				if (roll <= 1) {
					//TODO: 1. check how much space there surrounding this tile and
					//choose an appropriately-sized rock
					var rock:Character = new Character(new Point(0, 0));
					var rockIndex:int;
					
					trace(flatGround[i].x + 2 + ", " + flatGround[i].y + ": "
						+ tiles.getTile(flatGround[i].x + 2, flatGround[i].y))
					
					
					if (tiles.getTile(flatGround[i].x + 1, flatGround[i].y) != 0 
						&& tiles.getTile(flatGround[i].x + 2, flatGround[i].y) != 0) {
						//large rocks
						rockIndex = Math.floor(Math.random() * largeRocks.length);
						rock.graphic = new Image(largeRocks[rockIndex]);
					} else {
						//small rocks
						rockIndex = Math.floor(Math.random() * smallRocks.length);
						rock.graphic = new Image(smallRocks[rockIndex]);
					}
					
					var layerRoll:Number = Math.random();
					
					if (layerRoll <= 0.5) {
						
						Image(rock.graphic).color = 0xffffff;
						rock.layer = -550;
					} else {
						
						Image(rock.graphic).color = 0xbbaabb;
						rock.layer = -100;
					}
					
					
					rock.setHitboxTo(rock.graphic);
					rock.setPosition(new Point(flatGround[i].x * t, (flatGround[i].y * t) - rock.height));
					
					gw.add(rock);
				}
			}
		}
		
		override public function update():void {
			if (Input.mousePressed) {
				//click();	
			}
		}
		
		private function click():void {
			var x:int = Math.floor((FP.camera.x + Input.mouseX) / Settings.TILESIZE);
			var y:int = Math.floor((FP.camera.y + Input.mouseY) / Settings.TILESIZE);
			var blastRadius:int = 2;
			if (Input.check(Key.SHIFT)) {
				removeTiles(x, y, blastRadius);
			} else{
				if (!collide("Player", x, y)) {
					addTiles(x, y, blastRadius);
				}
			}
			fixGround();
		}
		
		private function drawBergs():void {
			var bergAmount:int = 5;
			for (var i:int = 0; i < bergAmount; i++) {
				drawBerg();
			}
		}
		
		private function drawBerg():void {
			var width:int = Math.floor(Math.random() * 10) + 15;
			var susHeight:int = 25 //suspention height
			var start:Point = new Point (Math.floor(Math.random() * w) - width, h - susHeight);
			var end:Point = new Point(start.x + width, h - susHeight);
			var border:int = 4;
			var currentPoint:Point;
			drawLine(start, end);

			drawHill([start,
				new Point(start.x + (width * 0.25), start.y - (Math.random() * 8)),
				new Point(start.x + (width * 0.5), start.y - (Math.random() * 8)),
				new Point(start.x + (width * 0.75), start.y - (Math.random() * 8)),
				end], false);

			var y:int;		
			for (var x:int = start.x; x <= start.x + width; x++) {
				y = start.y + 1;
				while(tiles.getTile(x, y + border) == 0) {
					tiles.setTile(x, y, jungleTiles["ground"]["middle"]);
					y++;
				}
			}
		}
		
		private function removeTiles(x:int, y:int, blastRadius:int):void {
			tiles.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, 0);
			grid.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, false)
			fixGround();
		}
		
		private function addTiles(x:int, y:int, blastRadius:int):void {
			tiles.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, jungleTiles["constructionBlock"]);
			grid.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, true)
			fixGround();
		}
		
		private function generateWater():void {
			for (var x:int = 0; x < w; x++){
				for (var y:int = h - waterLevel; y <  h; y++){
					if (tiles.getTile(x, y) == 0) tiles.setTile(x, y, jungleTiles["water"]);	
				}
			}
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
			var ts:Object = jungleTiles["ground"];
			if (tiles.getTile(x, y - 1) == 0) {
				//tile above is empty
				if (tiles.getTile(x - 1, y) == 0) {
					//tile to the left is also empty
					return ts["topLeft"];
				} else if (tiles.getTile(x + 1, y) == 0) {
					//tile to the right is also empty
					return ts["topRight"];
				}
				flatGround.push(new Point(x, y));
				return ts["topMid"];
			}
			
			//tile below is empty
			if (tiles.getTile(x, y + 1) == 0) {
				//tile to the left is also empty
				if (tiles.getTile(x - 1, y) == 0) {
					return ts["botLeft"];
					//tile to the right is also empty
				} else if (tiles.getTile(x + 1, y) == 0) {
					return ts["botRight"];
				}
				if (y != h - 1) return ts["botMid"];
				else return ts["middle"];
			}
			
			//tile to the right is empty
			if (tiles.getTile(x + 1, y) == 0) return ts["midRight"];
			
			//tile to the left is empty
			if (tiles.getTile(x - 1, y) == 0) return ts["midLeft"];
			
			//tile to the top-left is empty
			if (tiles.getTile(x - 1, y - 1) == 0) return ts["topLeftTuft"];

			//tile to the top-right is empty
			if (tiles.getTile(x + 1, y - 1) == 0) return ts["topRightTuft"];
			
			//tile to the bottom-left is empty
			if (tiles.getTile(x - 1, y + 1) == 0) return ts["bottomLeftTuft"];
			
			//tile to the bottom-right is empty
			if (tiles.getTile(x + 1, y + 1) == 0) return ts["bottomRightTuft"];
				
			return ts["middle"];
		}
		
		//TODO: add overlapping/not overlapping logic,
		//optional parameters for different shapes -- isoceles etc.
		private function drawIsland(options:Object=null):void {
			var kind:String = "vShaped"
			var minWidth:int = 2;
			var minHeight:int = 2;
			var overlap:Boolean = false;
			var border:int = 2;
			
			if (options) {
				if (options["kind"]) kind = options["kind"];
				if (options["minWidth"]) minWidth = options["minWidth"];
				if (options["minHeight"]) minHeight = options["minHeight"];
				if (options["overlap"]) overlap = options["overlap"];
			}
	
			//Ensure no overlap
			var isolated:Boolean = false;
			
			var tries:int = 0;
			var maxTries:int = 100;
			while (!isolated) {
				
				var islandWidth:int = Math.round(minWidth + (FP.random * 5));
				var islandHeight:int = Math.round(minHeight + (FP.random * 5));
				var x:int = Math.floor((FP.random * w) - islandWidth);
				var y:int = Math.floor((FP.random * h) - islandHeight);
				
				var flag:Boolean = true;
				if (!overlap) {
					outsideLoop: for (var i:int = -border; i < islandWidth + border; i++) {
						for (var j:int = -border; j <= islandHeight + border; j++){
							if (tiles.getTile(x + i, y + j) == 0) {
								flag = true
							} else {
								flag = false;
								break outsideLoop;
							}
						}
					}
				}
				isolated = flag;
				
				tries++
				if (tries >= maxTries) break;
			}
			
			if (kind == "rect") {
				tiles.setRect(x, y, islandWidth, islandHeight, 12);
			} else if (kind == "vShaped") {
				var start:Point = new Point(x, y);
				var end:Point = new Point(x + islandWidth, y);
				var peak:Point = new Point(x + (islandWidth / 2), y + islandHeight);
				drawLine(start, end)
				
				//Randomize the direction it is drawn in
				var roll:Number = Math.random();
				if (roll <= 0.5) {
					fillSlope(start, peak, false);
					fillSlope(peak, end, false);
				} else {
					fillSlope(end, peak, false);
					fillSlope(peak, start, false);
				}
			}
		}
		
		private function generateIslands():void {
			var islands:int = 60;
			var minSize:int = 2;
			for (var i:int = 0; i < islands; i++) {
				var roll:Number = Math.random();
				drawIsland({"kind": "rect"});
			}
		}
		
		private function randomPoint():Point {
			var x:int = Math.ceil(FP.random * w);
			var y:int = Math.ceil(FP.random * h);
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
		
		private function drawLine(start:Point, end:Point, options:Object = null):void {
			var currentPoint:Point = new Point(start.x, start.y);
			var width:int = 1;
			var height:int = 1;
			var positive:Boolean = true; //true = setTile, false = clearTile
			
			if (options) {
				if (options["width"]) width = options["width"];
				if (options["height"]) height = options["height"];
				if (options["positive"]) positive = options["positive"];
			}
			
			var points:Array = getLine(start.x, end.x, start.y, end.y);
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
				drawLine(start, end);
			}
		}
		
		private function drawSlope(start:Point, end:Point, fillDown:Boolean = true):void {
			drawLine(start, end);
		}
		
		private function fillSlope(start:Point, end:Point, fillDown:Boolean = true, baseline:int = -1):void {
			var current:Point = new Point(start.x, start.y);
			var points:Array = getLine(start.x, end.x, start.y, end.y);
			if (baseline == -1) baseline = h;
			for each(var po:Point in points){
				var c:Point = po;
				while(tiles.getTile(c.x, c.y) == 0 && c.y < baseline) {
					tiles.setTile(c.x, c.y, 12);
					if (fillDown) c.y++;
					else c.y--
				}
			}
		}
		
		private function drawHill(stops:Array, relativeToGround:Boolean = true):void {
			var start:Point;
			var end:Point;
			for (var i:int = 0; i < stops.length - 1; i++){
				/**
				 * The current fill algorithm breaks if the x points are drawn on
				 * top of each other, so after the first point they need to be offset
				 * by 1
				 */
//				var offsetX:int;
//				if (i == 0) offsetX = 0;
//				else offsetX = 1;
				var newStartY:int;
				var newEndY:int;
				if (relativeToGround) newStartY = h - groundDepth - 1 - stops[i].y;
				else newStartY = stops[i].y;
				if (relativeToGround) newEndY = h - groundDepth - 1 - stops[i + 1].y;
				else newEndY = stops[i + 1].y;
				start = new Point(stops[i].x, newStartY);
				end = new Point(stops[i + 1].x, newEndY)
				fillSlope(start, end);
			}

		}
		
		private function generateHillStops():void {
			//TODO: base values off of cumulative hill width rather than
			//individual segment width.
			var hillStopsNum:int = 10;
			var hillStops:Array = [];
			var segmentWidth:int = w / hillStopsNum;
			var maxSegmentWidth:int = 5;
			var minSegmentWidth:int = 2;
			var peak:int = 18;
			var leftoverHeight:int = peak;
			var startX:int = 6;
			var startY:int = 0;
			
			var x:int = startX;
			var y:int = startY;
			hillStops.push(new Point(x, y));
			for (var i:int = 0; i < hillStopsNum; i++) {
				
				//segmentWidth = Math.ceil((FP.random * maxSegmentWidth) + minSegmentWidth);
				x += segmentWidth;
				
				if (i != hillStopsNum - 1) y  = Math.ceil(FP.random * peak);
				else y = 0;
					
				hillStops.push(new Point(x, y));
			}
			drawHill(hillStops);
		}
		
		private function loadTiles():void {

			generateTiles();
			setGrid();

		}
		
		private function setGrid():void {
			var gid:int = 0;
			for(var row:int = 0; row < h; row++){
				for(var column:int = 0; column < w; column++){
					if (tiles.getTile(column, row) != 0 &&
						tiles.getTile(column, row) != jungleTiles["water"]) {
						grid.setTile(column, row, true);
					} else {
						grid.setTile(column, row, false);
					}

					gid++;
				}
			}
		}

		public function generateNPCs(_w:World, options:Object):void {
			//TODO: add different spawning regions--in the water, on the ground, on
			//the suspended islands etc.
			var kind:String = "enemy";
			var region:String = "groundLevel"
			var amount:int = 15;
				
			if(options) {
				if (options["kind"]) kind = options["kind"];
				if (options["amount"]) amount = options["amount"];
				if (options["region"]) region = options["region"];
			}
				
			var t:int = Settings.TILESIZE;
			for (var i:int = 0; i < amount; i++) {

				var pos:Point = findSpawn();
				var e:Entity;
				if (kind == "enemy") {
					e = new Enemy(pos, 60);
					enemiesList.push(e);
				} else if (kind == "NPC") {
					e = new DustBall(pos);
					NPClist.push(e);
				}
				_w.add(e);
			}
		}
		
		private function findSpawn(region:String = "groundLevel"):Point {
			var x:int;
			var y:int;
			var open:Boolean;
			
			if (region == "groundLevel") {
				x = Math.floor(FP.random * (w * t));
				y = (h * t) - t;
				open = false;
				while(!open) {
					if (tiles.getTile(int(x / t), int(y / t)) == 0) {
						open = true;
					} else if (tiles.getTile(int(x / t), int(y / t)) == 20) {
						//don't spawn in water
						x += t;
						open = false;
					} else {
						open = false;
					}
					y -= t;	
				}
			} else if (region == "water") {
				x = Math.floor(FP.random * (w * t));
				y = (h * t) - (waterLevel * t);
				open = false;
				var tries:int = 200;
				while (!open){
					if (tiles.getTile(int(x / t), int(y / t)) == 20) {
						open = true;
					} else {
						open = false;
					}
					x += t;
					
					tries--;
					if (tries == 0) open = true;
				}
			}
			return new Point(x, y);
		}

		
		public function loadPlayer(_w:World, _player:SpacemanPlayer):void{
			_player.x = 30;
			_player.y = 30;
			_w.add(_player);
		}
		
		
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
		
		private function drawPockets():void {
			var gid:int;
			
			var pockets:int = 10;
			var pocketWidth:int = 7;
			var halfPocketWidth:int = Math.abs(pocketWidth / 2)
			var pocketPoints:Array = [];
			
			
			var column:int;
			var row:int; 
			
			//Generate center points for pockets
			
			//for (var j:int = 0; j < pockets; j++) {
			
			//			while (pocketPoints.length < pockets) {
			//				var p:Point;
			//				if (pocketPoints.length == 0) {
			//					p = randomPoint();
			//					pocketPoints.push(p);
			//				}
			//				p = randomPoint();
			//				var isolated:Boolean = true;
			//				iLoop: for (var i:int = 0; i < pocketPoints.length; i++) {
			//
			//					if (Math.abs(pocketPoints[i].x - p.x) > pocketWidth + 1
			//						|| Math.abs(pocketPoints[i].y - p.y) > pocketWidth + 1) {
			//						isolated = true;
			//					} else {
			//						isolated = false;
			//						break iLoop;
			//					}
			//				}
			//				if (isolated) pocketPoints.push(p);
			//				//trace("isolated: " + isolated);
			//				//trace("length: " + pocketPoints.length);
			//			}
			
			//drawPocket(pockets, pocketPoints, pocketWidth);
		}	
	}
	
}