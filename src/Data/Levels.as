package data {
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	
	public class Levels {
		//public var caveLevel:Level;
		//public var caveLevel2:Level;
		public var jungleLevel:Level;
		
		public var levelsList:Array;
		public var ambience:Sfx;
		
		public function Levels(_w:GameWorld, _p:Player){
			levelsList = [];
			
			//jungleLevel = new Level(Assets.JUNGLE);
			//jungleLevel.backgroundColor = 0xc2baad;
			//jungleLevel.loadEnemies(_w);
			//jungleLevel.loadInteractionItems(_w);
			//jungleLevel.loadDoors(_w, _p);
			//jungleLevel.loadPlayer(_w, _p);
			
			//levelsList = [jungleLevel];
			
			ambience = new Sfx(Assets.AMBIENCE);
			ambience.loop();
		}
	}
}