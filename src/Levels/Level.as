package Levels {
	
	import Levels.Background;
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	import net.flashpunk.tweens.misc.ColorTween;
	
	import utilities.Settings;
	
	public class Level extends Entity {
		public var tiles:Tilemap;
		public var grid:Grid;
		public var xml:Class;
		public var label:String;
		
		protected var t:int; //Settings.TILESIZE
		protected var graphicList:Graphiclist;
		
		protected var solidList:Array;
		public var doorList:Array;
		public var interactionItemList:Array;
		public var enemiesList:Array;
		public var NPClist:Array;
		
		public var jungleTiles:Object;
		protected var notSolids:Array;
		
		protected var smallRocks:Array;
		protected var largeRocks:Array;
		
		public var backgroundColor:uint;
		
		public var w:int;
		public var h:int;
		
		protected var gameworld:GameWorld;
		protected var player:Player;
		
		protected var playerStart:Point;
		
		protected var dayNight:Boolean; //determines whether the lightMask is visible
		
		protected var fader:Entity;
		protected var fadeMask:Graphic;
		public var fadeTween:ColorTween;
		
		protected var destinationLevel:Level;
		protected var destinationDoor:String;
		
		public function Level(params:Object = null) {
			super();
			t = Settings.TILESIZE;
			
			/**
			 * TODO: (parallaxing) background image
			 */
			backgroundColor = 0xa29a8d;
		
			layer = -600;
			
			solidList = [];
			doorList = [];
			interactionItemList = [];
			enemiesList = [];
			NPClist = [];
			
			type = "level";
			label = "level"
			
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
				jungleTiles["structure"]["bg"],
				jungleTiles["plants"]["treeTrunk"],
				jungleTiles["plants"]["treeLeaves"]
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
		}
		
		override public function update():void {
			fader.x = FP.camera.x;
			fader.y = FP.camera.y;
			if (fadeTween.active) {
				Image(fader.graphic).alpha = fadeTween.alpha;
				Image(fader.graphic).color = fadeTween.color;
				trace(fadeTween.percent);
			}
		}
		
		override public function added():void {
			gameworld = GameWorld(FP.world);
			player = gameworld.player;
			
			tiles = new Tilemap(Assets.JUNGLE_TILESET, w * t, h * t, t, t);
			grid = new Grid(w * t, h * t, t, t, 0, 0);
			mask = grid;
			graphic = new Graphiclist(tiles);
			
			var b:Background = new Background(this);
			gameworld.add(b);
			
			fadeMask = Image.createRect(FP.screen.width, FP.screen.height, 0xffffff, 0);
			fader = new Entity(FP.camera.x, FP.camera.y, fadeMask);
			fader.layer = -1000;
			gameworld.add(fader);
				
			fadeTween = new ColorTween(fadedOut);
		}
		
		protected function fadedOut():void {
			gameworld.switchLevel(destinationLevel, destinationDoor);
			//Image(fader.graphic).alpha = 0;
			//this.clearTweens();
		}
		
		public function switchLevel(_destinationLevel:Level, _destinationDoor:String):void {
			destinationLevel = _destinationLevel;
			destinationDoor = _destinationDoor;
			//fadeTween.tween(1, 0x222222, 0x222222, 0, 1);
			//addTween(fadeTween, true);
			gameworld.switchLevel(destinationLevel, destinationDoor);
		}
		
		protected function setGrid():void {
			var gid:int = 0;
			for (var row:int = 0; row < h; row++) {
				for (var column:int = 0; column < w; column++){
					if (checkSolid(column, row)) grid.setTile(column, row, true);
					else grid.setTile(column, row, false);
					gid++;
				}
			}
		}
		
		public function loadLevel():void { }
		
		/**
		 * Returns true if tile is solid, false if not
		 */
		private function checkSolid(x:int, y:int):Boolean {
			var solid:Boolean = true;
			for (var i:int = 0; i < notSolids.length; i++)
				if (tiles.getTile(x, y) == notSolids[i]) {
					solid = false;
					break;
				} else solid = true;
			
			return solid;
		}
	}
}