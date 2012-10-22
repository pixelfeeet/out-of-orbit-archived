package {
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class HUD extends Entity {
		
		private var healthHUD:Text;
		private var hungerHUD:Text;
		private var expHUD:Text;
		private var levelHUD:Text;
		
		private var thePlayer:SpacemanPlayer;
		 
		private var display:Graphiclist;
		
		private var inventory:Array;
		private var weaponInventory:Array;
		
		//this doesn't seem good.
		public static var inventoryDisplay:Array;
		public static var inventoryBoxes:Array;
		public static var inventoryBoxesInitiated:Boolean;
		
		public static var weaponInventoryDisplay:Array;
		public static var weaponInventoryBoxes:Array;
		public static var weaponInventoryBoxesInitiated:Boolean;
		
		public function HUD(player:SpacemanPlayer) {
			layer = 1;
			//At some point player I should make gameworld's player
			//a static variable, or something.
			thePlayer = player;
			
			healthHUD = new Text("Health: " + thePlayer.getHealth(), 10, 10, 200, 50)
			healthHUD.color = 0x6B6B6B;
			healthHUD.size = 32
				
			hungerHUD = new Text("Hunger: " + thePlayer.getHunger(), FP.screen.width - 210, 10); 
			hungerHUD.color = 0x6B6B6B;
			hungerHUD.size = 32;
			
			expHUD = new Text("EXP: " + thePlayer.getPlayerExperience(), 10, 50);
			expHUD.color = 0x6B6B6B;
			expHUD.size = 24;
			
			levelHUD = new Text("Level: " + thePlayer.getLevel(), 10, 80);
			levelHUD.color = 0x6B6B6B;
			levelHUD.size = 24;
			

			display = new Graphiclist(healthHUD, hungerHUD, expHUD, levelHUD);
			
			inventoryDisplay = new Array(thePlayer.inventoryLength);
			inventoryBoxesInitiated = false;
			
			weaponInventoryDisplay = new Array(thePlayer.weaponInventoryLength);
			weaponInventoryBoxesInitiated = false;
			
			graphic = display;
			
			layer = -100;
		}
		
		override public function update():void {
			display.x = FP.camera.x;
			display.y = FP.camera.y;
			
			updateHealth();
			
			getInventory();
			getWeaponInventory();
			
			updateInventoryPosition();
			updateInventoryDisplay();
			
			//for some reason if initInventoryBoxes is called in the
			//constructor 
			if(!inventoryBoxesInitiated) initInventoryBoxes();
			updateInventoryBoxes();
			
		}
		
		//ITEM INVENTORY
		private function getInventory():void {
			inventory = thePlayer.getInventory().inventory;
		}
		
		//WEAPON INVENTORY
		private function getWeaponInventory():void {
			weaponInventory = thePlayer.getWeaponInventory().inventory;
		}
		
		
		private function updateHealth():void{
			hungerHUD.text = "Hunger: " + thePlayer.getHunger();
			healthHUD.text = "Health: " + thePlayer.getHealth();
			expHUD.text = "EXP: " + thePlayer.getPlayerExperience();
			levelHUD.text = "Level: " + thePlayer.getLevel();
		}
		
		private function initInventoryBoxes():void {
			inventoryBoxes = [];
			
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				var item:InventoryBox = new InventoryBox(new Point(10 + (i * 55), FP.screen.height - 60));
				item.layer = -100;
				inventoryBoxes.push(item);
				FP.world.add(item);
			}
			
			inventoryBoxesInitiated = true;
			
			weaponInventoryBoxes = [];
			
			for (var j:int = 0; j < weaponInventoryDisplay.length; j++) {
				var wItem:InventoryBox = new InventoryBox(new Point(FP.camera.x + FP.screen.width - 60, FP.camera.y + 120 + (j * 55)));
				wItem.layer = -100;
				weaponInventoryBoxes.push(wItem);
				FP.world.add(wItem);
			}
			
			weaponInventoryBoxesInitiated = true;
		}
		
		
		private function updateInventoryPosition():void{
			//Item Inventory
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				var a:InventoryItem = inventoryDisplay[i];
				if (a != null){
					a.x = FP.camera.x + 10 + (i * 55);
					a.y = FP.camera.y + FP.screen.height - 60;
				}
			}
			
			//Weapon Inventory
			for (var j:int = 0; i < weaponInventoryDisplay.length; j++){
				var b:Weapon = weaponInventoryDisplay[i];
				if (b != null){
					b.x = FP.camera.x + FP.screen.width - 60;
					b.y = FP.camera.y + 120 + (j * 55);
				}
			}
		}
		
		private function updateInventoryBoxes():void{
			//Item Inventory
			for (var i:int = 0; i < inventoryBoxes.length; i++){
				inventoryBoxes[i].x = FP.camera.x + 10 + (i * 55);
				inventoryBoxes[i].y = FP.camera.y + FP.screen.height - 60;
			}
			
			//Weapon Inventory
			for (var j:int = 0; j < weaponInventoryBoxes.length; j++){
				weaponInventoryBoxes[j].x = FP.camera.x + FP.screen.width - 60;
				weaponInventoryBoxes[j].y = FP.camera.y + 120 + (j * 55);
			}
		}
		
		public function updateInventoryDisplay():void {
			//Item Inventory
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				if (inventory[i] != null){
					if (inventoryDisplay[i] == null) drawNewItem(i, inventory[i]);
				} else {
					if (inventoryDisplay[i] != null) removeItemFromInventory(i);
				}
			}
			
			//Weapon Inventory
			for (var j:int = 0; j < inventoryDisplay.length; j++){
				if (weaponInventory[i] != null){
					if (weaponInventoryDisplay[j] == null) drawNewItem(j, weaponInventory[j]);
				} else {
					if (inventoryDisplay[j] != null) removeItemFromInventory(j);
				}
			}
		}
		
		private function drawNewItem(_slot:int, _e:InventoryItem = null):void{
			var e:InventoryItem = _e;
			e.x = FP.camera.x + 10 + (_slot * 55);
			e.y = FP.camera.y + FP.screen.height - 60;
			inventoryDisplay[_slot] = e;
			world.add(e);
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (inventoryDisplay[_slot] != null){
				var a:InventoryItem = inventoryDisplay[_slot];
				display.remove(a.graphic);
				FP.world.remove(a);	
				inventoryDisplay[_slot] = null;
			}
		}
		
		public function deselectAll():void{
			for (var i:int = 0; i < inventoryBoxes.length; i++){
				inventoryBoxes[i].deselect();
			}
		}
		
	}
}