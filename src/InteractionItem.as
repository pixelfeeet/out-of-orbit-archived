package {
	import data.Items;
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.*;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import utilities.Settings;
	
	public class InteractionItem extends Character {
		private var rocketImage:Image;
		
		private var isInventoryItem:Boolean;
		private var inventoryImage:Graphic;
		private var inventoryItem:InventoryItem;
		private var items:Items;
		
		public function InteractionItem(_position:Point) {
			
			super(_position, -1, -1);
			
			rocketImage = new Image(Assets.ROCKET_IMAGE);
			graphic = rocketImage;
			
			x = _position.x;
			y = _position.y;
			
			acceleration = new Point();
			velocity = new Point();
			
			xSpeed = 0;
			
			setHitboxTo(graphic);
			
			items = new Items();
			
			isInventoryItem = true;
			inventoryImage = graphic;
			inventoryItem = items.mediPack;
			
		}

		
		override public function update():void {

			super.update();
			
			if (collidePoint(x, y, world.mouseX, world.mouseY)) {
				if (Input.mouseReleased) click();
			}

		}
		
		protected function click():void {
			if (Input.check(Key.SHIFT)){
				if(GameWorld.player.getInventory().findOpenSlot() != -1
				&& isInventoryItem
				&& distanceFrom(GameWorld.player) <= GameWorld.player.reachDistance){
				trace(distanceFrom(GameWorld.player));
					GameWorld.player.getInventory().addItemToInventory(inventoryItem);
					destroy();
				}
			}
		}
		
		protected function destroy():void{
			world.remove(this);
		}
		
	}
}