package {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	
	public class InventoryItem extends Entity {
		
		public var numOfUses:int; //# of uses before used up
		public var behavior:Function;
		public var label:String;
		
		public function InventoryItem(_graphic:Graphic=null) {
			
			graphic = new Image(Assets.SPACEMAN_JUMPING);
			numOfUses = 1;
			behavior = function():void{
				trace("used.");
			};
			label = "default";
			
		}
		
		public function onUse():void {
			
			behavior();
			if (numOfUses != -1) numOfUses--;
			if (numOfUses == 0) destroy();
		}
		
		
		
		private function destroy():void {
			for (var i:int = 0; i < GameWorld.player.inventoryLength; i++){
				if (GameWorld.player.getInventory().inventory[i] == this){
					GameWorld.player.getInventory().removeItemFromInventory(i);
					GameWorld.hud.deselectAll();
					FP.world.remove(this);
					return;
				}
			}
		}
	}
}