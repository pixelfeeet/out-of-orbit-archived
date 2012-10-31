package Inventory {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import ui.HUD;
	
	public class InventoryBox extends Entity {
		
		private var selected:Boolean;
		
		public function InventoryBox(_position:Point) {
			super();
			x = _position.x;
			y = _position.y;
			graphic = Image.createRect(50, 50, 0x444444, 0.8);
			setHitboxTo(graphic);
			
			selected = false;
			layer = 1;
		}
		
		override public function update():void {
			if (collidePoint(x, y, FP.world.mouseX, FP.world.mouseY))
				if (Input.mouseReleased) click();
			
			if (selected) graphic = Image.createRect(50, 50, 0xffffff, 0.8);
			else graphic = Image.createRect(50, 50, 0x444444, 0.8);
		}
		
		public function click():void {
			if (Input.check(Key.SHIFT)){
				GameWorld.hud.deselectAll();
				if (!selected) select();
				else deselect();
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
	}
}