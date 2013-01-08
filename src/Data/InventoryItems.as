package data {
	import Inventory.InventoryItem;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	public class InventoryItems {
		
		public var food:InventoryItem;
		public var mediPack:InventoryItem;
		public var powerBlaster:InventoryItem;
		public var axe:InventoryItem;
		public var pipe:InventoryItem;
		public var knife:InventoryItem;
		
		public var list:Array;
		
		public function InventoryItems() {
			food = new InventoryItem();
			food.numOfUses = 1;
			food.sourceImage = Assets.FOOD_IMG;
			food.graphic = new Image(food.sourceImage);
			food.label = "food";
			food.scrapValue = 10;
			food.behavior = function():void {
				GameWorld(FP.world).player.changeHunger(2);
			};
				
			mediPack = new InventoryItem();
			mediPack.numOfUses = 1;
			mediPack.sourceImage = Assets.MEDIPACK_IMG;
			mediPack.graphic = new Image(mediPack.sourceImage);
			mediPack.label = "mediPack";
			mediPack.scrapValue = 25;
			mediPack.behavior = function():void {
				GameWorld(FP.world).player.changeHealth(10);
			};
			
			powerBlaster = new InventoryItem();
			powerBlaster.sourceImage = Assets.PB;
			powerBlaster.graphic = new Image(powerBlaster.sourceImage);
			powerBlaster.label = "powerBlaster";
			powerBlaster.scrapValue = 100;
			powerBlaster.stackable = false;
			powerBlaster.behavior = function():void {
				if (GameWorld(FP.world).player.weapon.label == "powerBlaster") {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.unarmed);
				} else {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.powerBlaster);
				}
			};
			
			axe = new InventoryItem();
			axe.sourceImage = Assets.AXE;
			axe.graphic = new Image(axe.sourceImage);
			axe.label = "Axe";
			axe.scrapValue = 100;
			axe.stackable = false;
			axe.behavior = function():void {
				if (GameWorld(FP.world).player.weapon.label == "Axe") {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.unarmed);
				} else {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.axe);
				}
			};
			
			pipe = new InventoryItem();
			pipe.sourceImage = Assets.PIPE;
			pipe.graphic = new Image(pipe.sourceImage);
			pipe.label = "Pipe";
			pipe.scrapValue = 100;
			pipe.stackable = false;
			pipe.behavior = function():void {
				if (GameWorld(FP.world).player.weapon.label == "Pipe") {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.unarmed);
				} else {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.pipe);
				}
			};
			
			knife = new InventoryItem();
			knife.sourceImage = Assets.KNIFE;
			knife.graphic = new Image(knife.sourceImage);
			knife.label = "Knife";
			knife.scrapValue = 100;
			knife.stackable = false;
			knife.behavior = function():void {
				if (GameWorld(FP.world).player.weapon.label == "Knife") {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.unarmed);
				} else {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.knife);
				}
			};
			
			list = [food, mediPack, powerBlaster, axe, pipe, knife];
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