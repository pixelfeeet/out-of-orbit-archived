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
		private var useSound:Sfx;
		
		public function InventoryItem(_graphic:Graphic=null) {
			
			numOfUses = -1;
			behavior = function():void{};
			label = "default_inventory_item";
			
			stackable = true;
			useSound = new Sfx(Assets.USE);
			layer = -205;
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
			for (var i:int = 0; i < GameWorld.player.inventoryLength; i++){
				if (GameWorld.player.getInventory().inventory[i][0].label == this.label){
					GameWorld.player.getInventory().removeItemFromInventory(i);
					//GameWorld.hud.deselectAll();
					FP.world.remove(this);
					return;
				}
			}
		}
	}
}