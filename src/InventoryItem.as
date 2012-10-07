package {
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	
	public class InventoryItem extends Entity {
		public function InventoryItem(_position:Point, _graphic:Graphic=null) {
			super(_position.x, _position.y, _graphic);
		
		}
	}
}