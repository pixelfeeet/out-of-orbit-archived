package {
	
	import NPCs.DustBall;
	import NPCs.Enemy;
	import NPCs.NPC;
	
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
	import net.flashpunk.graphics.Canvas;
	
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
		private var player:Player;
		
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
		
		private var smallRocks:Array;
		private var largeRocks:Array;
		
		private var flatGround:Array;
		private var backTiles:Tilemap;
		private var backLayer:Entity;
		
		private var treeNum:int; //amount of trees in level 
		
		private var shadowColor:uint;
		private var lightColor:uint;
		
		public function Level() {
			t = Settings.TILESIZE;
			
			w = 150;
			h = 60;
			
			tiles = new Tilemap(Assets.JUNGLE_TILESET, w * t, h * t, t, t);
			backTiles = new Tilemap(Assets.JUNGLE_TILESET, w * t, h * t, t, t);
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
			
			jungleTiles = {
				"ground": {
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
				"plants": {
					"treeTrunk": 8,
					"treeLeaves": 9
				},
				"constructionBlock": 10,
				"water": 30
			};
			
			notSolids = [
				0,
				jungleTiles["water"],
				jungleTiles["structure"]["bg"]
			];
			
			smallRocks = [
				Assets.ROCK1,
				Assets.ROCK3,
				Assets.ROCK5,
				Assets.ROCK6,
				Assets.ROCK7,
				Assets.ROCK8,
			];
			
			largeRocks = [
				Assets.ROCK2,
				Assets.ROCK4,
			];
			
			backgroundColor = 0xa29a8d;			
			groundDepth = 0;
			waterLevel = 8;
			treeNum = 20;
			
			shadowColor = 0xbbaabb;
			lightColor = 0xffffff;
		}
		
		override public function added():void {
			loadLevel();
		}
		
		public function loadLevel():void {
			generateTiles();
			generateNPCs({"kind": "enemy"});
			generateNPCs({"kind": "NPC"});
		}
		
		private function generateTiles():void {
			flatGround = [];
			
			initBackLayer();
			//draw tiles
			generateHillStops()
			generateWater();
			//generateIslands();
			
			//pretty the ground up/set grid/hitbox
			fixGround();
			setGrid();
			setHitboxTo(grid);
			
			//add scenery
			generateRocks();
			buildForest();
		}
		
		override public function update():void { if (Input.mousePressed) click(); }
		
		private function setGrid():void {
			var gid:int = 0;
			for (var row:int = 0; row < h; row++)
				for (var column:int = 0; column < w; column++){
					if (checkSolid(column, row)) grid.setTile(column, row, true);
					else grid.setTile(column, row, false);
					gid++;
				}
		}
		
		private function click():void {
			var x:int = Math.floor((FP.camera.x + Input.mouseX) / Settings.TILESIZE);
			var y:int = Math.floor((FP.camera.y + Input.mouseY) / Settings.TILESIZE);
			var blastRadius:int = 2;
			/*
			if (Input.check(Key.SHIFT)) removeTiles(x, y, blastRadius);
			else if (!collide("Player", x, y)) addTiles(x, y, blastRadius);
			*/
			fixGround();
		}

		/**
		 * Returns true if tile is solid, false if not
		 */
		private function checkSolid(x:int, y:int):Boolean {
			var flag:Boolean = true;
			for (var i:int = 0; i < notSolids.length; i++)
				if (tiles.getTile(x, y) == notSolids[i]) {
					flag = false;
					break;
 				} else flag = true;
			
			return flag;
		}
		
		/**
		 * Draw tiles
		 */
		private function buildBergs():void {
			var bergAmount:int = 5;
			for (var i:int = 0; i < bergAmount; i++) drawBerg();
		}

		/**
		 * TODO:
		 * 1. Remove the hard-coded values in drawHill
		 * 2. Return values like drawTree
		 */
		private function drawBerg():void {
			var width:int = Math.floor(FP.random * 10) + 15;
			var susHeight:int = 25 //suspention height
			var start:Point = new Point (Math.floor(FP.random * w) - width, h - susHeight);
			var end:Point = new Point(start.x + width, h - susHeight);
			var border:int = 4;
			var currentPoint:Point;
			drawLine(start, end);
			
			drawHill([start,
				new Point(start.x + (width * 0.25), start.y - (FP.random * 8)),
				new Point(start.x + (width * 0.5), start.y - (FP.random * 8)),
				new Point(start.x + (width * 0.75), start.y - (FP.random * 8)),
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
		
		private function generateWater():void {
			for (var x:int = 0; x < w; x++)
				for (var y:int = h - waterLevel; y <  h; y++)
					if (tiles.getTile(x, y) == 0) tiles.setTile(x, y, jungleTiles["water"]);
		}
		
		/**
		 * Player terrain manipulation
		 */
		private function addTiles(x:int, y:int, blastRadius:int):void {
			tiles.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, jungleTiles["constructionBlock"]);
			grid.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, true)
			fixGround();
		}
		
		private function removeTiles(x:int, y:int, blastRadius:int):void {
			tiles.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, 0);
			grid.setRect(x - Math.floor(blastRadius / 2), y - Math.floor(blastRadius / 2), blastRadius, blastRadius, false)
			fixGround();
		}
		
		/**
		 * TODO
		 * 1. Calculate start position based off of height and width values
		 * taken from the xmldata itself.
		 * 2. Be smarter about placement: i.e. above ground level, and fill in
		 * any empty blocks underneath
		 */
		private function generateSnippets():void {
			var ls:LevelSnippet = new LevelSnippet(Assets.TEMPLE);
			var temple:Array = ls.loadTiles();
			var tOrigin:Point = new Point(0,0); //temple origin;
			
			tOrigin.x = Math.floor(FP.random * w);
			tOrigin.y = h - Math.floor(FP.random * 10) - 10;
			
			for (var i:int = 0; i < temple.length; i++)
				tiles.setTile(temple[i]["x"] + tOrigin.x, temple[i]["y"] + tOrigin.y, temple[i]["index"]);
		}
		
		/**
		 * Fix tile
		 */
		//Iterate through each tile and call fixTile on ground tiles
		private function fixGround():void {
			for (var x:int = 0; x < w; x++)
				for (var y:int = 0; y < h; y++)
					if (tiles.getTile(x, y) == 12) {
						var index:int = fixTile(x, y);
						tiles.setTile(x, y, index);
					}
		}
		
		/**
		 * TODO: Refactor
		 */
		private function fixTile(x:int, y:int):int {
			var ts:Object = jungleTiles["ground"];
			if (tiles.getTile(x, y - 1) == 0) { //tile above is empty
				if (tiles.getTile(x - 1, y) == 0) return ts["topLeft"]; //tile to the left is also empty
				else if (tiles.getTile(x + 1, y) == 0) return ts["topRight"]; //tile to the right is also empty
				flatGround.push(new Point(x, y));
				return ts["topMid"];
			}
			
			//tile below is empty
			if (tiles.getTile(x, y + 1) == 0) { //tile to the left is also empty
				if (tiles.getTile(x - 1, y) == 0) return ts["botLeft"]; //tile to the right is also empty
				else if (tiles.getTile(x + 1, y) == 0) return ts["botRight"];
				else if (y != h - 1) return ts["botMid"];
				else return ts["middle"];
			}
			
			if (tiles.getTile(x + 1, y) == 0) return ts["midRight"]; //tile to the right is empty
			if (tiles.getTile(x - 1, y) == 0) return ts["midLeft"]; //tile to the left is empty			
			if (tiles.getTile(x - 1, y - 1) == 0) return ts["topLeftTuft"]; //tile to the top-left is empty			
			if (tiles.getTile(x + 1, y - 1) == 0) return ts["topRightTuft"]; //tile to the top-right is empty			
			if (tiles.getTile(x - 1, y + 1) == 0) return ts["bottomLeftTuft"]; //tile to the bottom-left is empty
			if (tiles.getTile(x + 1, y + 1) == 0) return ts["bottomRightTuft"]; //tile to the bottom-right is empty
			
			return ts["middle"];
		}
		
		private function initBackLayer():void {
			backLayer = new Entity(0, 0);
			backLayer.graphic = backTiles;
			Canvas(backTiles).color = shadowColor;
			backLayer.layer = -100;
			FP.world.add(backLayer);
		}

		
		private function renderBehind(e:Entity):void {
			Image(e.graphic).color = shadowColor;
			e.layer = -100;
		}
		
		private function renderInFront(e:Entity):void {
			Image(e.graphic).color = lightColor;
			e.layer = -550;
		}
		
		/**
		 * TODO:
		 * 1. Add more shapes
		 * 2. REFACTOR -- this function is probably too long
		 */
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
				
				isolated = false;
				if (!overlap) {
					outsideLoop: for (var i:int = -border; i < islandWidth + border; i++) {
						for (var j:int = -border; j <= islandHeight + border; j++){
							if (tiles.getTile(x + i, y + j) == 0) isolated = true;
							else {
								isolated = false;
								break outsideLoop;
							}
						}
					}
				}
				tries++
				if (tries >= maxTries) break;
			}
			
			if (kind == "rect") tiles.setRect(x, y, islandWidth, islandHeight, 12);
			else if (kind == "vShaped") {
				var start:Point = new Point(x, y);
				var end:Point = new Point(x + islandWidth, y);
				var peak:Point = new Point(x + (islandWidth / 2), y + islandHeight);
				drawLine(start, end)
				
				//Randomize the direction it is drawn in
				var roll:Number = FP.random;
				if (roll <= 0.5) {
					fillSlope(start, peak, false);
					fillSlope(peak, end, false);
				} else {
					fillSlope(end, peak, false);
					fillSlope(peak, start, false);
				}
			}
		}
		
		/**
		 * TODO:
		 * 1. Add variable to control the lowest height an island can
		 * be drawn at
		 */
		private function generateIslands():void {
			var islands:int = 60;
			var minSize:int = 2;
			for (var i:int = 0; i < islands; i++)
				if (FP.random < 0.5) drawIsland({"kind": "rect"});
				else drawIsland({"kind": "vShaped"});
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
			for each(var po:Point in points)
				for (var w:int = 0; w < width; w++)
					for (var h:int = 0; h < height; h++)
						if (positive) tiles.setTile(po.x + w, po.y + h, 12)
						else tiles.clearTile(po.x + w, po.y + h);			
		}
		
		private function fillSlope(start:Point, end:Point, fillDown:Boolean = true, baseline:int = -1):void {
			var current:Point = new Point(start.x, start.y);
			var points:Array = getLine(start.x, end.x, start.y, end.y);
			if (baseline == -1) baseline = h;
			for each(var po:Point in points) {
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
			for (var i:int = 0; i < stops.length - 1; i++) {
				var newStartY:int;
				var newEndY:int;
				
				if (relativeToGround) newStartY = h - groundDepth - 1 - stops[i].y;
				else newStartY = stops[i].y;
				
				if (relativeToGround) newEndY = h - groundDepth - 1 - stops[i + 1].y;
				else newEndY = stops[i + 1].y;
				
				start = new Point(stops[i].x, newStartY);
				end = new Point(stops[i + 1].x, newEndY);
				
				fillSlope(start, end);
			}
		}
		
		/**
		 * TODO:
		 * 1. base values off of width of level rather than
		 * individual segment width.
		 */
		private function generateHillStops():void {
			var hillStopsNum:int = 10;
			var hillStops:Array = [];
			var segmentWidth:int = w / hillStopsNum;
			var maxSegmentWidth:int = 5;
			var minSegmentWidth:int = 2;
			var peak:int = 18;
			
			var startX:int = 6;
			var startY:int = 0;
			
			var x:int = startX;
			var y:int = startY;
			
			hillStops.push(new Point(x, y));
			for (var i:int = 0; i < hillStopsNum; i++) {
				x += segmentWidth;				
				if (i != hillStopsNum - 1) y = Math.ceil(FP.random * peak);
				else y = 0;
				hillStops.push(new Point(x, y));
			}
			drawHill(hillStops);
		}
		
		private function buildForest():void {
			var index:int = 0;
			while (index < treeNum) {
				var b:Boolean = drawTree(); //b == tree built successfully
				if (b) index++;
			}
		}
		
		/**
		 * TODO
		 * 1. Clean up the preliminary checking if statement
		 * 2. Don't draw this tree if:
		 * 		a) If there is another tree within 2(?) blocks if this one
		 * 		b) There isn't enough room to draw most of the tree.
		 * 3. Use the same sort of layring as with the rocks
		 * 4. Non-rectangular canopy
		 */
		private function drawTree():Boolean {
			var _x:int = FP.random * w;
			var _y:int = h - 1;
			var padding:int = 2; //min distance between trees
			var leavesWidth:int = 2 + (FP.random * 2); //radius
			var leavesHeight:int = 2 + (FP.random * 4); //full height
			var trunkWidth:int = 1;
			var trunkHeight:int = 6 + (FP.random * 4);
			//Find ground level
			while (tiles.getTile(_x, _y) != 0) {
				var t:int = tiles.getTile(_x, _y);
				if (t == jungleTiles["plants"]["treeTrunk"]) return false;
				else _y--;
			}
			//ground level found; remember where the base of the tree is
			var baseY:int = _y;
			//preliminary checking
			while (_y >= baseY - trunkHeight) {
				if (tiles.getTile(_x + 1, _y) == jungleTiles["plants"]["treeTrunk"] ||
					tiles.getTile(_x + 2, _y) == jungleTiles["plants"]["treeTrunk"] ||
					tiles.getTile(_x - 1, _y) == jungleTiles["plants"]["treeTrunk"] ||
					tiles.getTile(_x - 2, _y) == jungleTiles["plants"]["treeTrunk"] ||
					backTiles.getTile(_x + 1, _y) == jungleTiles["plants"]["treeTrunk"] ||
					backTiles.getTile(_x + 2, _y) == jungleTiles["plants"]["treeTrunk"] ||
					backTiles.getTile(_x - 1, _y) == jungleTiles["plants"]["treeTrunk"] ||
					backTiles.getTile(_x - 2, _y) == jungleTiles["plants"]["treeTrunk"])
					return false;
				else _y--;
			}
			
			//actual tree building
			//trunk
			_y = baseY;
			var tilemap:Tilemap;
			if (FP.random <= 0.5) tilemap = backTiles;
			else tilemap = tiles;
			while (_y >= baseY - trunkHeight) {
				if (tiles.getTile(_x, _y) == 0 && backTiles.getTile(_x, _y) == 0)
					tilemap.setTile(_x, _y, jungleTiles["plants"]["treeTrunk"]);
				else return true;
				_y--;
			}
		
			//leaves
			var leavesBaseY:int = _y;
			var leavesX:int = _x - leavesWidth;
			for (_y = leavesBaseY; _y > leavesBaseY - leavesHeight; _y--)
				for (_x = leavesX; _x < leavesX + (leavesWidth * 2) + trunkWidth; _x++)
					if (tiles.getTile(_x, _y) == 0)
						tiles.setTile(_x, _y, jungleTiles["plants"]["treeLeaves"]);	
			
			return true;
		}
		
		private function buildFloatingFarm():void { }
		private function buildAbandonedShip():void { }
		
		/**
		 * Generate Scenery
		 */
		
		/**
		 * TODO
		 * 1. check how much space there surrounding this tile and
		 * choose an appropriately-sized rock
		 */
		private function generateRocks():void {
			for (var i:int = 0; i < flatGround.length; i++){
				var roll:int = Math.floor(FP.random * 6)
				if (roll <= 1) {
					var rock:Character = new Character(new Point(0, 0));
					var rockIndex:int;
					
					if (tiles.getTile(flatGround[i].x + 1, flatGround[i].y) != 0 &&
						tiles.getTile(flatGround[i].x + 2, flatGround[i].y) != 0) { //large rocks
						rockIndex = FP.random * largeRocks.length;
						rock.graphic = new Image(largeRocks[rockIndex]);
					} else { //small rocks
						rockIndex = FP.random * smallRocks.length;
						rock.graphic = new Image(smallRocks[rockIndex]);
					}
					
					var layerRoll:Number = FP.random;
					if (layerRoll <= 0.5) renderBehind(rock);
					else renderInFront(rock);
					
					rock.setHitboxTo(rock.graphic);
					rock.setPosition(new Point(flatGround[i].x * t, (flatGround[i].y * t) - rock.height));
					FP.world.add(rock);
				}
			}
		}
		
		/**
		 * NPC Generation
		 */
		public function generateNPCs(options:Object):void {
			//TODO: add different spawning regions--in the water, on the ground, on
			//the suspended islands etc.
			var kind:String = "enemy";
			var region:String = "groundLevel"
			var amount:int = 15;
			
			if (options) {
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
				FP.world.add(e);
			}
		}
		
		/**
		 * TODO:
		 * 1. Not spawning in water logic doesn't work
		 */
		private function findSpawn(region:String = "groundLevel"):Point {
			var x:int;
			var y:int;
			var open:Boolean;
			
			if (region == "groundLevel") {
				x = Math.floor(FP.random * (w * t));
				y = (h * t) - t;
				open = false;
				while(!open) {
					if (tiles.getTile(int(x / t), int(y / t)) == 0) open = true;
					else if (tiles.getTile(int(x / t), int(y / t)) == 20) {
						//don't spawn in water
						x += t;
						open = false;
					} else open = false;
					
					y -= t;	
				}
			} else if (region == "water") {
				x = Math.floor(FP.random * (w * t));
				y = (h * t) - (waterLevel * t);
				open = false;
				var tries:int = 200;
				while (!open){
					if (tiles.getTile(int(x / t), int(y / t)) == 20) open = true;
					else open = false;
					
					x += t;					
					tries--;
					if (tries == 0) open = true;
				}
			}
			return new Point(x, y);
		}
		
		/** Based on Bresenham's Line Algorithm:
		 * http://roguebasin.roguelikedevelopment.org/index.php?title=Bresenham%27s_Line_Algorithm
		 */
		private function getLine(x0:int, x1:int, y0:int, y1:int):Array {
			var points:Array = []
			var steep:Boolean = (Math.abs(y1-y0)) > (Math.abs(x1-x0))
			var placeHolder:int;
			if (steep) {
				placeHolder = x0;
				x0 = y0;
				y0 = placeHolder;
				placeHolder = x1;
				x1 = y1;
				y1 = placeHolder;
			}
			if (x0 > x1) {
				placeHolder = x0;
				x0 = x1;
				x1 = placeHolder;
				placeHolder = y0;
				y0 = y1;
				y1 = placeHolder;
			}
			var deltax:Number = x1 - x0
			var deltay:Number = Math.abs(y1 - y0)
			var error:int = (deltax / 2)
			var y:int = y0
			var ystep:Number;
			if (y0 < y1) ystep = 1
			else ystep = -1
			
			for (var x:int = x0; x <= x1; x++) {
				var o:Point;
				if (steep) points.push(new Point(y, x));
				else points.push(new Point(x, y));
				
				error -= deltay;
				if (error < 0) {
					y += ystep
					error += deltax
				}
			}
			
			return points;
		}
		
		override public function removed():void {
			for each (var door:Door in doorList) FP.world.remove(door);
			for each (var item:InteractionItem in interactionItemList) FP.world.remove(item);
			for each (var enemy:Enemy in enemiesList) FP.world.remove(enemy);			
		}
	}
}