package {
	import data.InteractionItems;
	import data.InventoryItems;
	
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
		
		private var inventoryImage:Graphic;
		public var label:String;
		
		private var inventoryItem:InventoryItem; //corresponding inventoryItem;
		private var inventoryItems:InventoryItems;
		
		public function InteractionItem(_position:Point = null) {
			
			if (!_position) _position = new Point(0,0);
			super(_position, -1, -1);
						
			//default graphic
			setGraphic(new Image(Assets.ROCKET_IMAGE));
			
			xSpeed = 0;
			
			label = "default";

		}

		override public function update():void {
			
			super.update();
			
			//here's that declaring stuff in the constructor problem
			//again.  I don't know of there's a better way of doing this.
			if (!inventoryItem) inventoryItem = GameWorld.inventoryItems.mediPack;
			
			if (collidePoint(x, y, world.mouseX, world.mouseY)) {
				if (Input.mouseReleased) click();
			}

		}
		
		protected function click():void {
			if (Input.check(Key.SHIFT)){
				if(GameWorld.player.getInventory().findOpenSlot() != -1
				&& inventoryItem != null
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
		
		public function setGraphic(_g:Graphic):void {
			graphic = _g;
			setHitboxTo(graphic);
		}
		
		public function setInventoryItem(_i:InventoryItem):void{
			inventoryItem = _i;
		}
		
		public function getInventoryItem():InventoryItem{
			return inventoryItem;
		}
		
		public function getPropertiesFrom(i:InteractionItem, _position:Point = null):void{
			inventoryItem = i.inventoryItem;
			setGraphic(i.graphic);
			label = i.label;
			if (_position) {
				x = _position.x;
				y = _position.y;
			}
		}
		
		public function setPosition(_position:Point):void{
			x = _position.x;
			y = _position.y;
		}
		
	}
}