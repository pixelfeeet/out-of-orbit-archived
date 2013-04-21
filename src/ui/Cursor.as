package ui {
	
	import flash.ui.Mouse;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class Cursor extends Entity {
		
		public var carryingItem:Boolean;
		private var reticule:Image;
		
		public function Cursor() {
			reticule = new Image(Assets.CURSOR);
			graphic = reticule;
			Mouse.hide();
			layer = -1500;
			carryingItem = false;
		}
		
		override public function update():void {
			// Assigns the Entity's position to that of the mouse (relative to the Camera).
			x = Input.mouseX;
			y = Input.mouseY;
			// Assigns the Entity's position to that of the mouse (relative to the World).
			x =FP.world.mouseX - 12;
			y =FP.world.mouseY - 12;

		}
		
		public function setDefault():void { graphic = reticule; }
		public function getReticule():Image { return reticule; }
	}
}