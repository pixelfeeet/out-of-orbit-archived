package {
	
	import data.Weapons;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;

	public class WeaponInventory extends Inventory {
		
		public function WeaponInventory(_inventoryLength:int) {
			super(_inventoryLength);
		}
 
		private function initItems():void{

		}
		override public function update():void {
			//if(!inventoryItems) inventoryItems = GameWorld.inventoryItems;
			//if(!interactionItems) interactionItems = GameWorld.interactionItems;
		}
	}
}