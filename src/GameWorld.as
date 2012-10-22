package {
	
	import data.*;
	
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import utilities.Camera;
	import utilities.Settings;
	
	public class GameWorld extends World {
		
		public static var player:SpacemanPlayer;
		public static var hud:HUD;
		private var cam:Camera;
		
		public static var inventoryItems:InventoryItems;
		public static var interactionItems:InteractionItems;
		public static var enemies:Enemies;
		public var levels:Levels;
		
		public var pause:Boolean;
		private var pauseMenu:PauseMenu;
		private var adjusted:Boolean;
		
		public function GameWorld() {
			super();
			
			player = new SpacemanPlayer();
			inventoryItems = new InventoryItems();
			interactionItems = new InteractionItems();
			enemies = new Enemies();
			levels = new Levels(this, player);

			pause = false;
			
			add(player);
			add(levels.caveLevel2);
			levels.caveLevel2.loadLevel(this, player);

			
			pauseMenu = new PauseMenu(this);

			add(new Cursor());
			
			Input.define("Pause", Key.SPACE, Key.ESCAPE, Key.P);

			//UI
			hud = new HUD(player);
			add(hud);
			
			//Camera
			cam = new Camera();
			
			adjusted = false;
		}
		
		override public function update():void {
			
			if (!adjusted) {
				cam.adjustToPlayer();
				//adjusted = true;
			}
			if (!pause) {
				cam.followPlayer();
				super.update();
			} else {
				pauseMenu.update();
			}
			
			if (Input.pressed("Pause")){
				onPause();
			}
		}
		
		public function getPlayer():SpacemanPlayer {
			return player;	
		}
		
		public function onPause(p:PauseMenu = null):void {
			if (pause) {
				pause = false;
				if (!p) pauseMenu.remove();
				else p.remove();
				Mouse.hide();
			} else {
				pause = true;
				pauseMenu.show();
				Mouse.show();
			}
		}
		
		public function switchLevel(currentLevel:Level, destinationLevel:Level, destinationDoor:String):void{


			remove(currentLevel);
			destinationLevel.loadLevel(this, player);
			add(destinationLevel);
			var doorList:Array = destinationLevel.doorList;
			for each (var door:Door in doorList) {
				//trace ("door.label: " + door.label);
				//trace("toDoor: " + destinationDoor);
				if (door.label == destinationDoor){
					//trace("door coordinates: " + door.x + ", " + door.y);
					if (door.playerSpawnsToLeft) player.x = door.x - 70;
					else player.x = door.x + 100;
					player.y = door.y + 10;

				}
			}
			//trace("time to switch levels");
		}
		
	}
	
	
	
}