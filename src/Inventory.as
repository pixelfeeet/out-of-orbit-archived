package {
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Graphic;

	public class Inventory extends Entity {
		
		public var inventory:Array;
		
		public function Inventory() {
			inventory = new Array(10);
		}
		
		public function findOpenSlot():int{
			for (var i:int = 0; i < inventory.length; i++){
				if (inventory[i] == null || inventory[i] == undefined){
					trace("slot#" + i + " is free");
					return i;
				}
			}
			trace("no free slots");
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
		
		public function addItemToInventory(_e:Entity = null):void{
			var slot:int = findOpenSlot();
			var e:Entity = new Entity();
			if (slot != -1){
				if (_e) e.graphic = _e.graphic;
				inventory[slot] = e;
			}
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (inventory[_slot] != null) inventory[_slot] = null;
		}
		
		public function removeLastItemFromInventory():void {
			var slot:int = findLastInventoryItem();
			if (slot != -1) removeItemFromInventory(slot);
		}
	}
}