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
		
		public var items:Array;
		private var inventoryItems:InventoryItems;
		private var interactionItems:InteractionItems;
		
		public function Inventory(_inventoryLength:int) {
			items = new Array(_inventoryLength);
			initItems();
		}
 
		private function initItems():void{
			for (var i:int = 0; i < items.length; i++) {
				items[i] = [];
			}
		}
		
		override public function update():void { }
		
		public function findSlot(e:InventoryItem):int{
			for (var i:int = 0; i < items.length; i++){
				if (items[i].length == 0){
					return i;
				} else if (items[i][0].label == e.label
					&& items[i][0].isStackable()) {
					return i;
				}
			}
			return -1;
		}
		
		private function findLastInventoryItem():int {
			if (items != null && items.length > 0) {
				for (var i:int = items.length - 1; i > -1; i--){
					if (items[i].length > 0) {
						return i;
					}
				}
			}
			//Inventory is empty;
			return -1;
		}
		
		public function addItemToSlot(_e:InventoryItem, _slot:int):void {
			items[_slot].push(_e);
		}
		
		public function transferItems(_fromSlot:int, _toSlot:int):void {
			items[_toSlot] = [];
			for (var i:int = 0; i < items[_fromSlot].length; i++){
				items[_toSlot][i] = items[_fromSlot][i];
			}
			items[_fromSlot] = [];
		}
		
		public function addItemToInventory(_e:InventoryItem = null):void{
			var e:InventoryItem = new InventoryItem();
			if (_e){
				e.behavior = _e.behavior;
				e.numOfUses = _e.numOfUses;
				e.sourceImage = _e.sourceImage;
				e.graphic = new Image(e.sourceImage);
				e.label = _e.label;
				e.scrapValue = _e.scrapValue;
				e.stackable = _e.stackable;
			} else {
				//Some default values
				e.behavior = GameWorld.inventoryItems.food.behavior;
				e.numOfUses = GameWorld.inventoryItems.food.numOfUses;
				e.graphic = GameWorld.inventoryItems.food.graphic;
			}
			
			var slot:int = findSlot(e);
			
			if (slot != -1){
				items[slot].push(e);
			}
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (items[_slot].length > 0) items[_slot].pop();
		}
		
		public function removeLastItemFromInventory():void {
			var slot:int = findLastInventoryItem();
			if (slot != -1) removeItemFromInventory(slot);
		}
	}
}