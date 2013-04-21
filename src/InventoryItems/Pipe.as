package InventoryItems {
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	import Inventory.InventoryItem;
	
	import net.flashpunk.Graphic;
	
	public class Pipe extends InventoryItem {
		public function Pipe(_graphic:Graphic=null) {
			sourceImage = Assets.PIPE;
			graphic = new Image(sourceImage);
			label = "Pipe";
			scrapValue = 100;
			stackable = false;
			
			behavior = function():void {
				if (GameWorld(FP.world).player.weapon.label == "Pipe") {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.unarmed);
				} else {
					GameWorld(FP.world).player.equipWeapon(GameWorld(FP.world).player.weapons.pipe);
				}
			};
		}
	}
}