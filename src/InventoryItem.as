package {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	
	public class InventoryItem extends Entity {
		
		private var uses:int; //# of uses before used up
		
		public function InventoryItem(_graphic:Graphic=null) {
			
			graphic = new Image(Assets.SPACEMAN_JUMPING);
			uses = 2;
			name = "food";
			
		}
		
		public function onUse():void {
			
			behavior();
			if (uses != -1) uses--;
			if (uses == 0) destroy();
		}
		
		public function behavior():void {
			trace("used.");
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