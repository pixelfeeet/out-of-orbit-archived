package {
	
	import NPCs.NPC;
	
	import data.*;
	
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.ColorTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import ui.HUD;
	import ui.InventoryMenu;
	import ui.PauseMenu;
	import ui.StatsMenu;
	
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
		public static var npcs:NPCs;
		
		public var pause:Boolean;
		private var pauseMenu:PauseMenu;
		private var statsMenu:StatsMenu;
		
		private var pauseMenuShowing:Boolean;
		private var statsMenuShowing:Boolean;
		
		private var adjusted:Boolean;
		
		private var background:Background;
		private var lightMask:LightMask;
		
		public var currentLevel:Level;
		
		public function GameWorld() {
			super();
			
			player = new SpacemanPlayer();
			inventoryItems = new InventoryItems();
			interactionItems = new InteractionItems();
			enemies = new Enemies();
			levels = new Levels(this, player);
			npcs = new NPCs();

			pause = false;
			pauseMenuShowing = false;
			statsMenuShowing = false;
			
			add(player);
			currentLevel = levels.caveLevel2;
			background = new Background(currentLevel.xml);
			add(background);
			add(currentLevel);
			currentLevel.loadLevel(this, player);
			
			pauseMenu = new PauseMenu(this);
			statsMenu = new StatsMenu(this);

			add(new Cursor());
			
			Input.define("Pause", Key.ESCAPE, Key.P);
			Input.define("Stats", Key.I);

			//UI
			hud = new HUD(player);
			add(hud);
			
			//Camera
			cam = new Camera();
			adjusted = false;
			
			//Sound
			FP.volume = 0.1;
			
			lightMask = new LightMask(this);
			add(lightMask);
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
				if (pauseMenuShowing) pauseMenu.update();
				if (statsMenuShowing) statsMenu.update();
			}
			
			if (Input.pressed("Pause")){
				onPause();
			}
			
			if (Input.pressed("Stats")) {
				onStats();
			}
		}
		
		public function getPlayer():SpacemanPlayer {
			return player;	
		}
		
		public function onPause():void {
			if (pause) {
				pause = false;
				removeMenus();
				Mouse.hide();
			} else {
				pause = true;
				pauseMenu.show();
				pauseMenuShowing = true;
				Mouse.show();
			}
		}
		
		public function onStats():void {
			if (pause) {
				pause = false;
				removeMenus();
				Mouse.hide();
			} else {
				pause = true;
				statsMenu.show();
				statsMenuShowing = true;
				Mouse.show();
			}
		}
		
		public function removeMenus():void {
			if (statsMenuShowing) {
				statsMenu.remove();
				statsMenuShowing = false;
			} else if (pauseMenuShowing) {
				pauseMenu.remove();
				statsMenuShowing = false;
			}
		}
		
		public function switchLevel(currentLevel:Level, destinationLevel:Level, destinationDoor:String):void{
			for each (var npc:NPC in currentLevel.NPClist){
				remove(npc);	
			}
			
			for each (var ii:InteractionItem in currentLevel.interactionItemList) {
				remove(ii);
			}
			
			remove(currentLevel);
			background.init(destinationLevel.xml);
			destinationLevel.loadLevel(this, player);
			add(destinationLevel);
			for each (var door:Door in destinationLevel.doorList) {
				if (door.label == destinationDoor){
					if (door.playerSpawnsToLeft) player.x = door.x - 70;
					else player.x = door.x + 100;
					player.y = door.y + 10;

				}
			}
			
			lightMask.resize(destinationLevel.width, destinationLevel.height);
		}
		
	}
	
	
	
}