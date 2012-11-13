package data {
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	
	public class Levels {
		//public var caveLevel:Level;
		//public var caveLevel2:Level;
		public var jungleLevel:Level;
		
		public var levelsList:Array;
		public var ambience:Sfx;
		
		public function Levels(_w:GameWorld, _p:SpacemanPlayer){
			levelsList = [];
			//caveLevel = new Level(Assets.CAVE_MAP);
//			caveLevel.label = "caveLevel";
			
			//caveLevel2 = new Level(Assets.CAVE_MAP2);
//			caveLevel2.label = "caveLevel2";
//			caveLevel2.loadEnemies(_w);
//			caveLevel2.loadInteractionItems(_w);
//			caveLevel2.loadDoors(_w, _p);
//			caveLevel2.loadPlayer(_w, _p);
			
			jungleLevel = new Level(Assets.JUNGLE);
			jungleLevel.backgroundColor = 0xc2baad;
			jungleLevel.loadEnemies(_w);
			jungleLevel.loadInteractionItems(_w);
			jungleLevel.loadDoors(_w, _p);
			jungleLevel.loadPlayer(_w, _p);
			
			levelsList = [jungleLevel];
			
			ambience = new Sfx(Assets.AMBIENCE);
			ambience.loop();
		}
	}
}