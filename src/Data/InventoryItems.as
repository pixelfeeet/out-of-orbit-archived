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
			food.sourceImage = Assets.FOOD_IMG;
			food.graphic = new Image(food.sourceImage);
			food.label = "food";
			food.scrapValue = 10;
			food.behavior = function():void {
				GameWorld.player.changeHunger(2);
			};
				
			mediPack = new InventoryItem();
			mediPack.numOfUses = 1;
			mediPack.sourceImage = Assets.MEDIPACK_IMG;
			mediPack.graphic = new Image(mediPack.sourceImage);
			mediPack.label = "mediPack";
			mediPack.scrapValue = 25;
			mediPack.behavior = function():void {
				GameWorld.player.changeHealth(10);
			};
			
			powerBlaster = new InventoryItem();
			powerBlaster.sourceImage = Assets.PB;
			powerBlaster.graphic = new Image(powerBlaster.sourceImage);
			powerBlaster.label = "powerBlaster";
			powerBlaster.scrapValue = 100;
			powerBlaster.stackable = false;
			powerBlaster.behavior = function():void {
				if (GameWorld.player.weapon.label == "Unarmed") {
					GameWorld.player.equipWeapon(GameWorld.player.weapons.powerBlaster);
				} else {
					GameWorld.player.equipWeapon(GameWorld.player.weapons.unarmed);
				}
			};
			
			list = [food, mediPack, powerBlaster];
		}
		
		public function copyItem(_e:InventoryItem):InventoryItem {
			var e:InventoryItem = new InventoryItem;
			e.behavior = _e.behavior;
			e.numOfUses = _e.numOfUses;
			e.sourceImage = _e.sourceImage;
			e.graphic = new Image(e.sourceImage);
			e.label = _e.label;
			e.scrapValue = _e.scrapValue;
			e.stackable = _e.stackable;
			return e;
		}
	}
}