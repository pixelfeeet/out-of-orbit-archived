package {
	
	import data.InteractionItems;
	import data.InventoryItems;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class Inventory extends Entity {
		
		public var inventory:Array;
		private var inventoryItems:InventoryItems;
		private var interactionItems:InteractionItems;
		
		public function Inventory(_inventoryLength:int) {
			inventory = new Array(_inventoryLength);
			initItems();
		}
 
		private function initItems():void{

		}
		override public function update():void {
			//if(!inventoryItems) inventoryItems = GameWorld.inventoryItems;
			//if(!interactionItems) interactionItems = GameWorld.interactionItems;
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
		
		public function addItemToInventory(_e:InventoryItem = null):void{
			var slot:int = findOpenSlot();
			var e:InventoryItem = new InventoryItem();
			if (!_e){
				e.behavior = GameWorld.inventoryItems.food.behavior;
				e.numOfUses = GameWorld.inventoryItems.food.numOfUses;
				e.graphic = GameWorld.inventoryItems.food.graphic;
			} else {
				e.behavior = _e.behavior;
				e.numOfUses = _e.numOfUses;
				e.graphic = _e.graphic;
			}
			if (slot != -1){
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