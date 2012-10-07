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
		
		private var inventory:Array;
		private var inventoryDisplay:Array;
		private var inventoryBoxes:Array;
		
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

			display = new Graphiclist(healthHUD, hungerHUD);
			
			inventoryDisplay = new Array(thePlayer.inventoryLength);
			initInventoryBoxes();
			
			graphic = display;
		}
		
		override public function update():void {
			display.x = FP.camera.x;
			display.y = FP.camera.y;
			
			updateHealth();
			
			getInventory();
			updateInventoryPosition();
			updateInventoryDisplay();
		}
		
		private function getInventory():void {
			inventory = thePlayer.getInventory().inventory;
		}
		
		private function updateHealth():void{
			hungerHUD.text = "Hunger: " + thePlayer.getHunger();
			healthHUD.text = "Health: " + thePlayer.getHealth();
		}
		
		private function initInventoryBoxes():void {
			inventoryBoxes = [];
			//Populate inventoryBoxes
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				var item:Graphic = new Graphic;
				item = Image.createRect(50, 50, 0x444444, 0.8);
				item.x = 10 + (i * 55);
				item.y = FP.screen.height - 60;
				inventoryBoxes.push(item);
			}
			
			//iterate through inventoryBoxes and display each one.
			for each (var g:Graphic in inventoryBoxes){
				display.add(g);
			}
		}
		
		
		private function updateInventoryPosition():void{
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				var a:Entity = inventoryDisplay[i];
				if (a != null){
					a.x = FP.camera.x + 10 + (i * 55);
					a.y = FP.camera.y + FP.screen.height - 60;
				}
			}
		}
		
		private function updateInventoryDisplay():void {
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				if (inventory[i] != null){
					if (inventoryDisplay[i] == null) drawNewItem(i, inventory[i]);
				} else {
					if (inventoryDisplay[i] != null) removeItemFromInventory(i);
				}
			}
		}
		
		private function drawNewItem(_slot:int, _e:Entity = null):void{
			var e:Entity = _e;
			if (!e.graphic) e.graphic = new Image(Assets.SPACEMAN_STANDING);
			e.x = FP.camera.x + 10 + (_slot * 55);
			e.y = FP.camera.y + FP.screen.height - 60;
			inventoryDisplay[_slot] = e;
			world.add(e);
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (inventoryDisplay[_slot] != null){
				var a:Entity = inventoryDisplay[_slot];
				display.remove(a.graphic);
				world.remove(a);	
				inventoryDisplay[_slot] = null;
			}
		}
		
	}
}