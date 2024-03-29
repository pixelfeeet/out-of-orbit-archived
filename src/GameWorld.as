package {
	
	import Levels.*;
	
	import NPCs.*;
	
	import data.*;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
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
	
	import ui.menus.ConstructionMenu;
	import ui.HUD.HUD;
	import ui.menus.InventoryMenu;
	import ui.menus.PauseMenu;
	import ui.menus.StatsMenu;
	
	import utilities.Camera;
	import utilities.Settings;
	import ui.Cursor;
	
	public class GameWorld extends World {
		
		public var player:Player;
		public var hud:HUD;
		public var cam:Camera;
		
		public var inventoryItems:InventoryItems;
		public var interactionItems:InteractionItems;
		public var enemies:Enemies;
		public var npcs:NPCs;
		public var scenery:Scenery;
		public var levels:Levels;
		
		public var pause:Boolean;
		public var pauseMenu:PauseMenu;
		public var statsMenu:StatsMenu;
		public var inventoryMenu:InventoryMenu;
		public var constructionMenu:ConstructionMenu;
		
		private var pauseMenuShowing:Boolean;
		private var statsMenuShowing:Boolean;
		private var inventoryMenuShowing:Boolean;
		private var constructionMenuShowing:Boolean;
		
		private var adjusted:Boolean;
		
		private var background:Background;
		public var lightMask:LightMask;
		
		public var currentLevel:Level;
		public var insideShip:StaticLevel;
		public var homeBase:StaticLevel;
		public var level1:ProceduralLevel;
		public var level2:ProceduralLevel;		
		public var levelsList:Array;
		
		public var cursor:Cursor;
		
		public function GameWorld() {
			super();
			
			pause = false;
			pauseMenuShowing = false;
			statsMenuShowing = false;
			constructionMenuShowing = false;
			
			Input.define("Pause", Key.ESCAPE, Key.P);
			Input.define("Stats", Key.L);
			Input.define("Inventory", Key.I);
			Input.define("Construct", Key.C);
			
			//Sound
			FP.volume = 0.05;
		}
		
		override public function begin():void {
			inventoryItems = new InventoryItems();
			interactionItems = new InteractionItems();

			enemies = new Enemies();
			npcs = new NPCs();
			scenery = new Scenery();
			
			lightMask = new LightMask();
			add(lightMask);
			
			player = new Player();
			add(player);
			
			/**
			 * TODO:
			 * Everytime the player enters or re-enters level1 it regenerates.
			 * The tile/NPC data needs to get saved so it stays the same.
			 */
			level1 = new ProceduralLevel();
			level1.label = "level1";
				
			var shipSource:Class = Assets.INSIDESHIP;
			var baseSource:Class = Assets.HOMEBASE;
			
			insideShip = new StaticLevel({"xml": shipSource, label: "insideShip"});
			insideShip.first = true;
			homeBase = new StaticLevel({"xml": baseSource, label: "homeBase"})
			
			levelsList = [level1, homeBase, insideShip];

			currentLevel = insideShip;
			add(currentLevel);
			
			pauseMenu = new PauseMenu();
			statsMenu = new StatsMenu();
			inventoryMenu = new InventoryMenu();
			constructionMenu = new ConstructionMenu();
			
			cursor = new Cursor();
			add(cursor);

			//UI
			hud = new HUD();
			add(hud);
			
			//Camera
			cam = new Camera();
			add(cam);
		}
		
		override public function update():void {
			if (!pause) super.update();
			else {
				if (pauseMenuShowing) pauseMenu.update();
				if (statsMenuShowing) statsMenu.update();
				if (inventoryMenuShowing) inventoryMenu.update();
				if (constructionMenuShowing) constructionMenu.update();
				cursor.update();
			}
			
			//UI
			if (Input.pressed("Pause")) onPause();
			if (Input.pressed("Stats")) onStats();
			if (Input.pressed("Inventory")) onInventory();
			if (Input.pressed("Construct")) onConstruct();
		}
		
		public function onConstruct():void {
			removeMenus();
			if (pause) {
				pause = false;
				constructionMenuShowing = false;
			} else {
				pause = true;
				constructionMenu.show();
				constructionMenuShowing = true;
			}
		}
		
		public function onPause():void {
			removeMenus();
			if (pause) {
				pause = false;
				pauseMenuShowing = false;
			} else {
				pause = true;
				pauseMenu.show();
				pauseMenuShowing = true;
			}
		}
		
		public function onStats():void {
			removeMenus();
			if (pause) {
				pause = false;
				statsMenuShowing = false;
			} else {
				pause = true;
				statsMenu.show();
				statsMenuShowing = true;
			}
		}
		
		public function onInventory():void {
			removeMenus();
			if (pause) {
				pause = false;
				inventoryMenuShowing = false;
			} else {
				pause = true;
				inventoryMenu.show();
				inventoryMenuShowing = true;
			}
		}
		
		public function removeMenus():void {
			if (statsMenuShowing) {
				statsMenu.remove();
				statsMenuShowing = false;
			}
			
			if (pauseMenuShowing) {
				pauseMenu.remove();
				statsMenuShowing = false;
			}
			
			if (inventoryMenuShowing) {
				inventoryMenu.remove();
				inventoryMenuShowing = false;
			}
			
			if (constructionMenuShowing) {
				constructionMenu.remove();
				constructionMenuShowing = false;
			}
		}
		
		public function switchLevel(_destinationLevel:Level, _destinationDoor:String):void{
			// for each (var npc:NPC in currentLevel.NPClist) remove(npc);
			// for each (var ii:InteractionItem in currentLevel.interactionItemList) remove(ii);
			
			remove(currentLevel);
			currentLevel = _destinationLevel;
			add(currentLevel);
			
			for each (var door:Door in _destinationLevel.doorList) {
				if (door.label == _destinationDoor){
					if (door.playerSpawnsToLeft) player.x = door.x - 70;
					else player.x = door.x + 100;
					player.y = door.y + 10;
				}
			}
				
			cam.configure(currentLevel);
			cam.adjustToPlayer();
		}
		
	}
	
}