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
			GameWorld.player.changeHealth(10);
		}
	}
}