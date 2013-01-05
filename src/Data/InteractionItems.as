package data {
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import flash.geom.Point;
	
	public class InteractionItems {
		
		public var food:InteractionItem;
		public var mediPack:InteractionItem;
		public var rocket:InteractionItem;
		public var powerBlaster:InteractionItem;
		public var scraps:Scraps;
		public var ammunition:Ammunition;
		public var shrub1:InteractionItem;
		public var shrub2:InteractionItem;
		
		public var list:Array;
		
		public function InteractionItems() {
			food = new InteractionItem();
			food.graphic = new Image(Assets.FOOD_IMG);
			food.setInventoryItem(GameWorld(FP.world).inventoryItems.food);
			food.label = "food";
			
			mediPack = new InteractionItem();
			mediPack.graphic = new Image(Assets.MEDIPACK_IMG);
			mediPack.setInventoryItem(GameWorld(FP.world).inventoryItems.mediPack);
			mediPack.label = "medipack";
			
			powerBlaster = new InteractionItem();
			powerBlaster.graphic = new Image(Assets.PB);
			powerBlaster.setInventoryItem(GameWorld(FP.world).inventoryItems.powerBlaster);
			powerBlaster.respawning = false;
			powerBlaster.label = "power_blaster";
			
			ammunition = new Ammunition();
			ammunition.graphic = new Image(Assets.FRUIT_PLANT);
			ammunition.label = "ammunition";
			
			scraps = new Scraps();
			scraps.graphic = Image.createCircle(10, 0xffee33, 0.8);
			scraps.label = "scraps";
			
			list = [food, mediPack, rocket, powerBlaster, ammunition, scraps];
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