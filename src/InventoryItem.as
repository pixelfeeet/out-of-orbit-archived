package {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	
	public class InventoryItem extends Entity {
		public function InventoryItem(_graphic:Graphic=null) {
			
			graphic = new Image(Assets.SPACEMAN_JUMPING);
		}
		
		public function onUse():void {
			GameWorld.player.changeHunger(10);
			for (var i:int = 0; i < GameWorld.player.inventoryLength; i++){
				if (GameWorld.player.getInventory().inventory[i] == this){
					GameWorld.player.getInventory().removeItemFromInventory(i);
					GameWorld.hud.deselectAll();
					FP.world.remove(this);
					return;
				}
			}
			//remove from inventory and world
			//AND/OR multiple uses.
		}
	}
}