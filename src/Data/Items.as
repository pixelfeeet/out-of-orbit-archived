package data {
	import net.flashpunk.graphics.Image;

	public class Items {
		
		public var food:InventoryItem;
		public var mediPack:InventoryItem;
		
		public function Items() {
			food = new InventoryItem();
			food.numOfUses = 2;
			food.graphic = new Image(Assets.SPACEMAN_CROUCHING);
			food.behavior = function():void {
				GameWorld.player.changeHunger(10);
			};
				
			mediPack = new InventoryItem();
			mediPack.numOfUses = 1;
			mediPack.behavior = function():void {
				GameWorld.player.changeHealth(10);
			};
		}
	}
}