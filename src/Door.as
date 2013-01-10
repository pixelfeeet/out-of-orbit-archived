package {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import Levels.Level;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Door extends Entity {
		public var currentLevel:Level;
		public var destinationLevelLabel:String;
		public var destinationLevel:Level;
		public var destinationDoor:String;

		//if true, the player must press the use key to travel
		//to the door's destination.  Else, it happens on collision.
		public var useToTravel:Boolean;
		private var gameworld:GameWorld;
		private var player:Player;
		private var c:Level;
		public var label:String;
		//if false, player spawns to the right of 
		//the door.
		public var playerSpawnsToLeft:Boolean;
		
		public function Door(_position:Point, _c:Level, _height:int, _width:int) {
			super(_position.x, _position.y);
			c = _c;
			useToTravel = false;
			height = _height;
			width = _width;

			type = "door";
			setHitbox(width, height);
			playerSpawnsToLeft = true;
		}
		
		override public function added():void {
			gameworld = GameWorld(FP.world);
			player = gameworld.player;
		}
		
		override public function update():void {
			//if (!destinationLevel) destinationLevel = w.levels.caveLevel;
			if (collideWith(player, x + halfWidth, y + halfHeight)){
				if(!useToTravel) changeLevel();
				else if (Input.check(Key.E)) changeLevel();
			}
		}
		
		public function setDestinationLevel(levelLabel:String):Level { 
			destinationLevelLabel = levelLabel;
			for each (var level:Level in gameworld.levelsList)
				if (level.label == levelLabel) return level;
			return null;
		}
		
		public function changeLevel():void {
			destinationLevel = setDestinationLevel(destinationLevelLabel);
			gameworld.switchLevel(destinationLevel, destinationDoor);
		}
	}
}