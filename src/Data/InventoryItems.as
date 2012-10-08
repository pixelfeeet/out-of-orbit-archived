package data {
	import net.flashpunk.graphics.Image;

	public class InventoryItems {
		
		public var food:InventoryItem;
		public var mediPack:InventoryItem;
		public var list:Array;
		
		public function InventoryItems() {
			food = new InventoryItem();
			food.numOfUses = 2;
			food.graphic = new Image(Assets.FOOD_IMG);
			food.label = "food";
			food.behavior = function():void {
				GameWorld.player.changeHunger(10);
			};
				
			mediPack = new InventoryItem();
			mediPack.numOfUses = 1;
			mediPack.graphic = new Image(Assets.MEDIPACK_IMG);
			mediPack.label = "mediPack";
			mediPack.behavior = function():void {
				GameWorld.player.changeHealth(10);
			};
			
			list = [food, mediPack];
		}
	}
}