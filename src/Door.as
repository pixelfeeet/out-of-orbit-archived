package {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import Levels.ProceduralLevel;
	
	public class Door extends Entity {
		public var currentLevel:ProceduralLevel;
		public var destinationLevelLabel:String;
		public var destinationLevel:ProceduralLevel;
		public var destinationDoor:String;

		//if true, the player must press the use key to travel
		//to the door's destination.  Else, it happens on collision.
		public var useToTravel:Boolean;
		private var w:GameWorld;
		private var player:Player;
		private var c:ProceduralLevel;
		public var label:String;
		//if false, player spawns to the right of 
		//the door.
		public var playerSpawnsToLeft:Boolean;
		
		public function Door(_position:Point, _w:GameWorld, _c:ProceduralLevel, _player:Player, _height:int, _width:int) {
			super(_position.x, _position.y);
			w = _w;
			c = _c;
			useToTravel = false;
			player = _player;
			height = _height;
			width = _width;

			type = "door";
			setHitbox(width, height);
			playerSpawnsToLeft = true;
		}
		
		override public function update():void {
			//if (!destinationLevel) destinationLevel = w.levels.caveLevel;
			if (collideWith(player, x + halfWidth, y + halfHeight)){
				if(!useToTravel) {
					changeLevel();
				} else {
					//check for use key pressed
				}
			}
		}
		
		public function setDestinationLevel(levelLabel:String):void{ 
			destinationLevelLabel = levelLabel;
			var levelsList:Array = w.levels.levelsList;
			for each (var level:ProceduralLevel in levelsList){
				if (level.label == levelLabel) {
					destinationLevel = level;
					trace("destination level set to: " + level.label);
					trace("the destination door is: " + destinationDoor);
					return;
				}
			}
			trace("destinationLevel was not found.")
		}
		
		public function changeLevel():void {
			setDestinationLevel(destinationLevelLabel);
			w.switchLevel(c, destinationLevel, destinationDoor);
		}
	}
}