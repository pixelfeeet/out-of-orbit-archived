package ui.HUD {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import Inventory.Inventory;
	
	public class InventoryBox extends Entity {
		
		private var selected:Boolean;
		private var length:int;
		private var clickable:Boolean;
		private var w:GameWorld;
		
		public function InventoryBox(_position:Point, _clickable:Boolean = true) {
			super();
			x = _position.x;
			y = _position.y;
			clickable = _clickable;
			
			length = 50;
			graphic = Image.createRect(length, length, 0x444444, 0.8);
			setHitboxTo(graphic);
			
			selected = false;
			layer = -1110;
		}
		
		override public function added():void {
			w = FP.world as GameWorld;
		}
		
		override public function update():void {
			if (collidePoint(x, y, FP.world.mouseX, FP.world.mouseY))
				if (Input.mouseReleased) click();
			
			if (selected) graphic = selectedBox();
			else graphic = deselectedBox();
		}
		
		private function selectedBox():Graphic {
			return Image.createRect(length, length, 0xffffff, 0.8);
		}
		
		private function deselectedBox():Graphic {
			return Image.createRect(length, length, 0x444444, 0.8);
		}
		
		/**
		 * TODO: refactor this function
		 * 1 Theres's several things going on here that could probably
		 * do with getting split up into smaller component pieces
		 * 2. Too many nested contitionals!
		 */
		public function click():void {
			if (!clickable) return;
				
			var inv:Array = w.inventoryMenu.inventoryBoxes;
			for (var i:int = 0; i < inv.length; i++) {
				var playerInv:Inventory = GameWorld(FP.world).player.inventory;
				
				if (inv[i]["box"] == this) {
					if (w.cursor.carryingItem) {
						if (i != w.inventoryMenu.carriedItemSlot) {
							if (playerInv.items[i] != [])
								w.inventoryMenu.inventoryDisplay[i] = playerInv.items[i][0];
							
							if (playerInv.items[i] != []) {	
								FP.world.remove(w.inventoryMenu.inventoryDisplay[w.inventoryMenu.carriedItemSlot]);
								playerInv.transferItems(w.inventoryMenu.carriedItemSlot, i);
								w.inventoryMenu.inventoryDisplay[w.inventoryMenu.carriedItemSlot] = null;	
							}
						}
						
						w.cursor.carryingItem = false;
						w.cursor.setDefault();
						w.inventoryMenu.carriedItemSlot = -1;
					}
					
					if (playerInv.items[i] != []) {
						if (w.inventoryMenu.inventoryDisplay[i] != null) {
							w.inventoryMenu.carriedItemSlot = i;
							w.cursor.carryingItem = true;
							w.cursor.graphic = playerInv.items[i][0].graphic;
							w.inventoryMenu.carriedItem = playerInv.items[i][0];
						}
					}
				}
			}
		}
		
		public function isSelected():Boolean {
			return selected;
		}
		
		public function select():void {
			selected = true;	
		}
		
		public function deselect():void{
			selected = false;
		}
		
		public function setAlpha(_alpha:Number):void {
			Image(graphic).alpha = _alpha;
		}
		
		public function setColor(_color:uint):void {
			graphic = Image.createRect(length, length, _color, Image(graphic).alpha);
		}
	}
}