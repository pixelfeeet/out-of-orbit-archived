package {
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	public class Inventory extends Entity {
		
		public var inventory:Array;
		public function Inventory() {
			inventory = new Array(10);
		}
		
		
		private function findOpenSlot():int{
			for (var i:int = 0; i < inventory.length; i++){
				if (inventory[i] == null || inventory[i] == undefined){
					trace("slot#" + i + " is free");
					return i;
				}
			}
			trace("last slot: " + inventory[-1])
			trace("no slots full");
			return -1;
		}
		
		private function findLastInventoryItem():int {
			if (inventory != null && inventory.length > 0) {
				for (var i:int = inventory.length - 1; i > -1; i--){
					if (inventory[i] != null) {
						trace("slot #" + i + " is not empty");
						return i;
					}
				}
			}
			trace("Inventory is empty");
			return -1;
		}
		
		public function addItemToInventory():void{
			var slot:int = findOpenSlot();
			
			if (slot != -1){
				var a:Entity = new Entity();
				a.graphic = new Image(Assets.SPACEMAN_STANDING);
				a.x = FP.camera.x + 10 + (slot * 55);
				a.y = FP.camera.y + FP.screen.height - 60;
				inventory[slot] = a;
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
			if (inventory[_slot] != null){
				var a:Entity = inventory[_slot];
				world.remove(a);	
				inventory[_slot] = null;
			}
		}
	}
}