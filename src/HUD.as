package {
	
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.geom.Point;
	
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
		public static var inventoryBoxes:Array;
		private var inventoryBoxesInitiated:Boolean;
		
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
			inventoryBoxesInitiated = false;
			
			graphic = display;
		}
		
		override public function update():void {
			display.x = FP.camera.x;
			display.y = FP.camera.y;
			
			updateHealth();
			
			getInventory();
			updateInventoryPosition();
			updateInventoryDisplay();
			
			if(!inventoryBoxesInitiated) initInventoryBoxes();
			updateInventoryBoxes();
			
			if (Input.mouseReleased) click();
		}
		
		private function click():void{
			for (var i:int = 0; i < inventoryBoxes.length; i++) {
				var b:InventoryBox = inventoryBoxes[i];
				if (b.collidePoint(b.x, b.y, FP.world.mouseX, FP.world.mouseY)) {
					b.click();
					return;
				}
			}
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
			
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				var item:InventoryBox = new InventoryBox(new Point(10 + (i * 55), FP.screen.height - 60));
				inventoryBoxes.push(item);
				FP.world.add(item);
			}
			
			inventoryBoxesInitiated = true;
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
		
		private function updateInventoryBoxes():void{
			for (var i:int = 0; i < inventoryBoxes.length; i++){
				inventoryBoxes[i].x = FP.camera.x + 10 + (i * 55);
				inventoryBoxes[i].y = FP.camera.y + FP.screen.height - 60;
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