package data {
	import flash.geom.Point;
	
	import net.flashpunk.graphics.Image;
	
	public class Scenery {
		
		public var shrub1:InteractionItem;
		public var shrub2:InteractionItem;
		
		public var list:Array;
		
		public function Scenery() {
			shrub1 = new InteractionItem();
			shrub1.graphic = new Image(Assets.SHRUB1);
			shrub1.label = "shrub1";
			shrub1.pickUpable = false;
			
			shrub2 = new InteractionItem();
			shrub2.graphic = new Image(Assets.SHRUB2);
			shrub2.label = "shrub2";
			shrub2.pickUpable = false;
			
			list = [shrub1, shrub2];	
		}
		
		public function copyItem(_e:InteractionItem, _position:Point = null):InteractionItem {
			if (!_position) _position = new Point(0,0);
			var e:InteractionItem = new InteractionItem(_position);
			e.graphic = _e.graphic;
			e.setHitboxTo(e.graphic);
			e.label = _e.label;
			e.pickUpable = _e.pickUpable;
			e.respawning = _e.respawning;
			e.setInventoryItem(_e.inventoryItem);
			return e;
		}
	}
}