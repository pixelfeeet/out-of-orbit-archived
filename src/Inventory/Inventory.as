package Inventory {
	
	import data.InteractionItems;
	import data.InventoryItems;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	/**
	 * A wrapper class for the player's inventory -- the 'items' array.
	 * This class provides several functions for easily adding/removing
	 * items from the inventory items array
	 */
	public class Inventory {
		
		public var items:Array;
		
		public function Inventory(_inventoryLength:int) {
			initItems(_inventoryLength);
		}
 
		private function initItems(_inventoryLength:int):void{
			items = new Array(_inventoryLength);
			for (var i:int = 0; i < items.length; i++) {
				items[i] = {
					"active": false,
					"contents": []
				};
			}
		}
		
		public function findSlot(e:InventoryItem):int{
			for (var i:int = 0; i < items.length; i++){
				if (items[i].contents.length == 0){
					return i;
				} else if (items[i].contents[0].label == e.label
					    && items[i].contents[0].isStackable()) {
					return i;
				}
			}
			
			// Inventory is full
			return -1;
		}
		
		private function findLastInventoryItem():int {
			if (items != null && items.length > 0) {
				for (var i:int = items.length - 1; i > -1; i--){
					if (items[i].contents.length > 0) return i;
				}
			}
			
			//Inventory is empty
			return -1;
		}
		
		public function addItemToSlot(_e:InventoryItem, _slot:int):void {
			items[_slot].contents.push(_e);
		}
		
		/**
		 * Transfer contents of one slot in the inventory to another slot
		 */
		public function transferItems(_fromSlot:int, _toSlot:int):void {
			items[_toSlot] = [];
			for (var i:int = 0; i < items[_fromSlot].length; i++)
				items[_toSlot].contents[i] = items[_fromSlot].contents[i];
			items[_fromSlot].contents = [];
		}
		
		/**
		 * TODO
		 * 1. clean this function up as part of revamping the
		 * way inventory items work
		 */
		public function addItemToInventory(_e:InventoryItem = null):void{
			var e:InventoryItem = new InventoryItem();
			e.behavior = _e.behavior;
			e.numOfUses = _e.numOfUses;
			e.sourceImage = _e.sourceImage;
			e.graphic = new Image(e.sourceImage);
			e.label = _e.label;
			e.scrapValue = _e.scrapValue;
			e.stackable = _e.stackable;
			
			var slot:int = findSlot(e);
			if (slot != -1) {
				items[slot].contents.push(e);
			}
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (items[_slot].contents.length > 0) items[_slot].contents.pop();
		}
		
		public function removeLastItemFromInventory():void {
			var slot:int = findLastInventoryItem();
			if (slot != -1) removeItemFromInventory(slot);
		}
	}
}