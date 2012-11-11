package ui {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class ConstructionBox extends Entity {
		
		private var selected:Boolean;
		private var length:int;
		private var clickable:Boolean;
		private var w:GameWorld;
		
		public function ConstructionBox(_position:Point, _w:GameWorld, _clickable:Boolean = true) {
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
			for each (var box:ConstructionBox in w.constructionMenu.boxes) {
				box.deselect();
			}
			if (selected) {
				selected = false;
			} else {
				selected = true;
				w.constructionMenu.displayPrice();
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