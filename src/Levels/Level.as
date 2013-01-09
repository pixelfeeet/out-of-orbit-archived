package Levels {
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;

	import net.flashpunk.graphics.Graphiclist;
	
	import utilities.Settings;
	
	public class Level extends Entity {
		public var tiles:Tilemap;
		public var grid:Grid;
		public var xml:Class;
		
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
		
		public var w:int;
		public var h:int;
		
		public function Level(params:Object = null) {
			super();
			t = Settings.TILESIZE;
		
			layer = -600;
			
			solidList = [];
			doorList = [];
			interactionItemList = [];
			enemiesList = [];
			NPClist = [];
			
			type = "level";
			
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
		
		override public function added():void {
			tiles = new Tilemap(Assets.JUNGLE_TILESET, w * t, h * t, t, t);
			grid = new Grid(w * t, h * t, t, t, 0, 0);
			mask = grid;
			graphic = new Graphiclist(tiles);
		}
		
		protected function setGrid():void {
			var gid:int = 0;
			for (var row:int = 0; row < h; row++) {
				for (var column:int = 0; column < w; column++){
					if (checkSolid(column, row)) grid.setTile(column, row, true);
					else grid.setTile(column, row, false);
					trace(checkSolid(column, row));
					gid++;
				}
			}
		}
		
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