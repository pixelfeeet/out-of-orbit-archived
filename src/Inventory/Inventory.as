package Inventory {
	
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
			for (var i:int = 0; i < inventory.length; i++) {
				inventory[i] = [];
			}
		}
		
		override public function update():void { }
		
		public function findSlot(e:InventoryItem):int{
			for (var i:int = 0; i < inventory.length; i++){
				if (inventory[i].length == 0){
					return i;
				} else if (inventory[i][0].label == e.label
					&& inventory[i][0].isStackable()) {
					return i;
				}
			}
			return -1;
		}
		
		private function findLastInventoryItem():int {
			if (inventory != null && inventory.length > 0) {
				for (var i:int = inventory.length - 1; i > -1; i--){
					if (inventory[i].length > 0) {
						return i;
					}
				}
			}
			//Inventory is empty;
			return -1;
		}
		
		public function addItemToInventory(_e:InventoryItem = null):void{
			var e:InventoryItem = new InventoryItem();
			if (_e){
				e.behavior = _e.behavior;
				e.numOfUses = _e.numOfUses;
				e.graphic = _e.graphic;
				e.label = _e.label;
				e.stackable = _e.stackable;
			} else {
				//Some default values
				e.behavior = GameWorld.inventoryItems.food.behavior;
				e.numOfUses = GameWorld.inventoryItems.food.numOfUses;
				e.graphic = GameWorld.inventoryItems.food.graphic;
			}
			
			var slot:int = findSlot(e);
			
			if (slot != -1){
				inventory[slot].push(e);
			}
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (inventory[_slot].length > 0) inventory[_slot].pop();
		}
		
		public function removeLastItemFromInventory():void {
			var slot:int = findLastInventoryItem();
			if (slot != -1) removeItemFromInventory(slot);
		}
	}
}