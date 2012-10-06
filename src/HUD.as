package {
	
	import flash.display.Shape;
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
		private var thePlayer:SpacemanPlayer;
		 
		private var display:Graphiclist;
		
		private var inventoryDisplay:Array;
		
		public function HUD(player:SpacemanPlayer) {
			layer = 1;
			thePlayer = player;
			
			healthHUD = new Text("Health: " + thePlayer.getHealth(), 10, 10, 200, 50)
			healthHUD.color = 0x6B6B6B;
			healthHUD.size = 32
				
			hungerHUD = new Text("Hunger: " + thePlayer.getHunger(), FP.screen.width - 210, 10); 
			hungerHUD.color = 0x6B6B6B;
			hungerHUD.size = 32;

			display = new Graphiclist(healthHUD, hungerHUD);
			
			inventoryDisplay = thePlayer.getInventory();
			initInventoryDisplay();
			
			graphic = display;
		}
		
		override public function update():void {
			display.x = FP.camera.x;
			display.y = FP.camera.y;
			

			if (Input.pressed(Key.DIGIT_1)) {
				removeLastItemFromInventory();
			}
			
			if (Input.pressed(Key.DIGIT_2)) {
				addItemToInventory();
			}
			
			updateHealth();
			updateInventory();
		}
		
		private function initInventoryDisplay():void {
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				var item:Graphic = new Graphic;
				item = Image.createRect(50, 50, 0x444444, 0.8);
				item.x = 10 + (i * 55);
				item.y = FP.screen.height - 60;
				display.add(item);
			}
		}
		
		private function findOpenSlot():int{
			inventoryDisplay = thePlayer.getInventory();
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				if (inventoryDisplay[i] == null || inventoryDisplay[i] == undefined){
					trace("slot#" + i + " is free");
					return i;
				}
			}
			trace("last slot: " + inventoryDisplay[-1])
			trace("no slots full");
			return -1;
		}
		
		private function findLastInventoryItem():int {
			if (inventoryDisplay != null && inventoryDisplay.length > 0) {
				for (var i:int = inventoryDisplay.length - 1; i > -1; i--){
					if (inventoryDisplay[i] != null) {
						trace("slot #" + i + " is not empty");
						return i;
					}
				}
			}
			trace("Inventory is empty");
			return -1;
		}
		
		public function addItemToInventory():void{
			inventoryDisplay = thePlayer.getInventory();
			var slot:int = findOpenSlot();
			
			if (slot != -1){
				var a:Entity = new Entity();
				a.graphic = new Image(Assets.SPACEMAN_STANDING);
				a.x = FP.camera.x + 10 + (slot * 55);
				a.y = FP.camera.y + FP.screen.height - 60;
				inventoryDisplay[slot] = a;
				world.add(a);
				return;
			}
		}
		
		public function removeLastItemFromInventory():void {
			var slot:int = findLastInventoryItem();
			if (slot != -1){
				removeItemFromInventory(slot);
			}
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (inventoryDisplay[_slot] != null){
				var a:Entity = inventoryDisplay[_slot];
				world.remove(a);	
				inventoryDisplay[_slot] = null;
			}
		}
		
		private function updateHealth():void{
			hungerHUD.text = "Hunger: " + thePlayer.getHunger();
			healthHUD.text = "Health: " + thePlayer.getHealth();
		}
		
		private function updateInventory():void{
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				var a:Entity = inventoryDisplay[i];
				if (a != null){
					a.x = FP.camera.x + 10 + (i * 55);
					a.y = FP.camera.y + FP.screen.height - 60;
				}
			}
		}
		
	}
}