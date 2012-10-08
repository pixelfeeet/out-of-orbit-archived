package data {
	import net.flashpunk.graphics.Image;
	
	public class InteractionItems {
		
		public var food:InteractionItem;
		public var mediPack:InteractionItem;
		public var rocket:InteractionItem;
		public var list:Array;
		
		public function InteractionItems() {
			food = new InteractionItem();
			food.graphic = new Image(Assets.FOOD_IMG);
			food.setInventoryItem(GameWorld.inventoryItems.food);
			food.label = "food";
			
			mediPack = new InteractionItem();
			mediPack.graphic = new Image(Assets.MEDIPACK_IMG);
			mediPack.setInventoryItem(GameWorld.inventoryItems.mediPack);
			mediPack.label = "mediPack";
			
			rocket = new InteractionItem();
			rocket.graphic = new Image(Assets.ROCKET_IMAGE);

			rocket.label = "rocket";
			
			list = [food, mediPack, rocket];
		}
	}
}