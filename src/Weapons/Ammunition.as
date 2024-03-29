package Weapons  {
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	public class Ammunition extends InteractionItem {
		public var amount:int;
		public function Ammunition(_position:Point=null) {
			super(_position);
			graphic = Image.createRect(20, 20, 0x775555, 0.8);
			setHitboxTo(graphic);
			type = "Ammunition";
			amount = 10;
		}
		
		override protected function getPickedUp():void {
			GameWorld(FP.world).player.weapon.addAmmo(amount);
			trace("Ammunition has been picked up")
			this.destroy();
		}
	}
}