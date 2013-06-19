package Inventory {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	
	public class InventoryItem extends Entity {
			
		public var numOfUses:int; //# of uses before used up
		public var behavior:Function;
		public var label:String;
		public var stackable:Boolean;
		public var sourceImage:Class;
		public var scrapValue:int;
		
		private var useSound:Sfx;
		private var w:GameWorld;
		
		public function InventoryItem(_graphic:Graphic=null) {
			
			numOfUses = -1;
			behavior = function():void{};
			label = "default_inventory_item";
			
			sourceImage = Assets.ARM;
			
			stackable = true;
			useSound = new Sfx(Assets.USE);
			scrapValue = 10;
			layer = -1010;

			w = FP.world as GameWorld;
		}
		
		public function onUse():void {	
			behavior();
			useSound.play();
			if (numOfUses != -1) numOfUses--;
			if (numOfUses == 0) destroy();
		}
		
		public function isStackable():Boolean {
			return stackable;
		}
		
		private function destroy():void {
			for (var i:int = 0; i < w.player.inventoryLength; i++){
				if (w.player.inventory.items[i].contents[0].label == this.label){
					w.player.inventory.removeItemFromInventory(i);
					FP.world.remove(this);
					return;
				}
			}
		}
	}
}