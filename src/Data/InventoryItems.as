package data {
	import Inventory.InventoryItem;
	
	import net.flashpunk.graphics.Image;

	public class InventoryItems {
		
		public var food:InventoryItem;
		public var mediPack:InventoryItem;
		public var powerBlaster:InventoryItem;
		
		public var list:Array;
		
		public function InventoryItems() {
			food = new InventoryItem();
			food.numOfUses = 1;
			food.graphic = new Image(Assets.FOOD_IMG);
			food.label = "food";
			food.behavior = function():void {
				GameWorld.player.changeHunger(2);
			};
				
			mediPack = new InventoryItem();
			mediPack.numOfUses = 1;
			mediPack.graphic = new Image(Assets.MEDIPACK_IMG);
			mediPack.label = "mediPack";
			mediPack.behavior = function():void {
				GameWorld.player.changeHealth(10);
			};
			
			powerBlaster = new InventoryItem();
			powerBlaster.graphic = new Image(Assets.PB);
			powerBlaster.label = "powerBlaster";
			powerBlaster.stackable = false;
			powerBlaster.behavior = function():void {
				if (!GameWorld.player.equipped) {
					GameWorld.player.equipWeapon(Assets.PB);
					GameWorld.player.equipped = true;
				} else {
					GameWorld.player.equipWeapon(Assets.NO_WEAPON);
					GameWorld.player.equipped = false;	
				}
			};
			
			list = [food, mediPack, powerBlaster];
		}
	}
}