package {
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	
	public class Scraps extends InteractionItem {
		public var amount:int;
		public function Scraps(_position:Point=null) {
			super(_position);
			graphic = Image.createCircle(10, 0xffee44, 0.8);
			setHitboxTo(graphic);
			type = "Scraps";
			amount = 10;
		}
		
		override protected function getPickedUp():void {
			GameWorld.player.scraps += amount;
			trace("Scraps has been picked up")
			this.destroy();
		}
	}
}