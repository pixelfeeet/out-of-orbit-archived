package Inventory {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import ui.HUD;
	
	public class InventoryBox extends Entity {
		
		private var selected:Boolean;
		private var length:int;
		private var clickable:Boolean;
		private var w:GameWorld;
		
		public function InventoryBox(_position:Point, _w:GameWorld, _clickable:Boolean = true) {
			super();
			x = _position.x;
			y = _position.y;
			clickable = _clickable;
			w = _w;
			
			length = 50;
			graphic = Image.createRect(length, length, 0x444444, 0.8);
			setHitboxTo(graphic);
			
			selected = false;
			layer = 1;
		}
		
		override public function update():void {
			if (collidePoint(x, y, FP.world.mouseX, FP.world.mouseY))
				if (Input.mouseReleased) click();
			
			if (selected) graphic = Image.createRect(length, length, 0xffffff, 0.8);
			else graphic = Image.createRect(length, length, 0x444444, 0.8);
		}
		
		public function click():void {
			trace(clickable)
			if (clickable){

				var inv:Array = w.inventoryMenu.inventoryBoxes;
				for (var i:int = 0; i < inv.length; i++){
					var playerInv:Inventory = GameWorld.player.getInventory();
					if (inv[i]["box"] == this) {
						if (w.cursor.carryingItem) {
							if (i != w.inventoryMenu.carriedItemSlot) {
								if (playerInv.items[i] != [])
									w.inventoryMenu.inventoryDisplay[i] = playerInv.items[i][0];
								
								if (playerInv.items[i] != []) {	
									//w.inventoryMenu.inventoryDisplay[w.inventoryMenu.carriedItemSlot].graphic.visible = true;
									FP.world.remove(w.inventoryMenu.inventoryDisplay[w.inventoryMenu.carriedItemSlot]);
									//FP.world.remove(w.inventoryMenu.carriedItem);
									playerInv.transferItems(w.inventoryMenu.carriedItemSlot, i);
									//playerInv.removeItemFromInventory(w.inventoryMenu.carriedItemSlot);
									w.inventoryMenu.inventoryDisplay[w.inventoryMenu.carriedItemSlot] = null;	
								}
							}
							
							w.cursor.carryingItem = false;
							w.cursor.setDefault();
							w.inventoryMenu.carriedItemSlot = -1;
						}
						if (playerInv.items[i] != []) {
							if (w.inventoryMenu.inventoryDisplay[i] != null) {
								//w.inventoryMenu.inventoryDisplay[i].graphic.visible = false;
								w.inventoryMenu.carriedItemSlot = i;
								w.cursor.carryingItem = true;
								w.cursor.graphic = playerInv.items[i][0].graphic;
								w.inventoryMenu.carriedItem = playerInv.items[i][0];
							}
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