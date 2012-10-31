package data {
	import net.flashpunk.graphics.Image;
	
	public class InteractionItems {
		
		public var food:InteractionItem;
		public var mediPack:InteractionItem;
		public var rocket:InteractionItem;
		public var powerBlaster:InteractionItem;
		public var ammunition:Ammunition;
		
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
			
			powerBlaster = new InteractionItem();
			powerBlaster.graphic = new Image(Assets.PB);
			powerBlaster.setInventoryItem(GameWorld.inventoryItems.powerBlaster);
			powerBlaster.respawning = false;
			powerBlaster.label = "powerBlaster";
			
			ammunition = new Ammunition();
			ammunition.graphic = new Image(Assets.FRUIT_PLANT);
			ammunition.label = "ammunition";
			
			list = [food, mediPack, rocket, powerBlaster, ammunition];
		}
	}
}