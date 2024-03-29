package {
	import Inventory.InventoryItem;
	
	import data.InteractionItems;
	import data.InventoryItems;
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
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
		
		public var inventoryItem:InventoryItem; //corresponding inventoryItem;
		private var inventoryItems:InventoryItems;
		
		private var pickupSound:Sfx;
		
		public var respawning:Boolean;
		public var eliminated:Boolean;
		public var scrapValue:int;
		
		public var pickUpable:Boolean;
		
		public function InteractionItem(_position:Point = null) {
			if (!_position) _position = new Point(0,0);
			super(_position, -1, -1);
						
			//default graphic
			setGraphic(Image.createRect(30, 30, 0x4488ff, 0.9));
			
			xSpeed = 0;
			
			label = "default";
			type = "InteractionItem";
			pickupSound = new Sfx(Assets.BLIP);
			scrapValue = 10;
			
			respawning = true;
			eliminated = false;
			pickUpable = true;
			
		}

		override public function added():void {
			inventoryItem = GameWorld(FP.world).inventoryItems.mediPack;
		}
		
		override public function update():void {
			super.update();
			
			if (collideWith(player, x, y)) {
				getPickedUp();
			}
		}
		
		protected function getPickedUp():void {
			if (!pickUpable) return;
			
			pickupSound.play();
				if (player.inventory.findSlot(this.inventoryItem) != -1
				 && inventoryItem != null
				 && distanceFrom(player) <= player.reachDistance) {
					player.inventory.addItemToInventory(inventoryItem);
					destroy();
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
		
	}
}