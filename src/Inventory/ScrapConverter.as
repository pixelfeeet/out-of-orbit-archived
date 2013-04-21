package Inventory {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
	public class ScrapConverter extends Entity {
		private var w:GameWorld;
		
		public function ScrapConverter(_position:Point = null) {
			if (!_position) _position = new Point(0,0);
			super(_position.x, _position.y, graphic);
		
			graphic = Image.createRect(50, 50, 0xffffff, 0.8);
			setHitboxTo(graphic);
			layer = -1110;
		}
		
		override public function added():void {
			w = GameWorld(FP.world);
		}
		
		override public function update():void {
			if (collidePoint(x, y, FP.world.mouseX, FP.world.mouseY))
				if (Input.mouseReleased) click();
		}
		
		public function click():void{
			if (!w.cursor.carryingItem) return;
			
			var value:Number = Math.floor(w.inventoryMenu.carriedItem.scrapValue * w.player.recycleRate);
			w.player.scraps += value;
			w.player.inventory.items[w.inventoryMenu.carriedItemSlot] = [];
			FP.world.remove(w.inventoryMenu.inventoryDisplay[w.inventoryMenu.carriedItemSlot]);
			w.hud.update();
			w.inventoryMenu.inventoryDisplay[w.inventoryMenu.carriedItemSlot] = null;
			w.cursor.setDefault();
			w.cursor.carryingItem = false;
		}
	}
}