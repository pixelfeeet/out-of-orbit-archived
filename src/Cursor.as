package {
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import flash.ui.Mouse;
	
	public class Cursor extends Entity {
		
		//[Embed(source = 'assets/crosshair.png')] private const PLAYER:Class;
		public function Cursor() {
			graphic = Image.createCircle(6, 0xffffff, 0.6);
			Mouse.hide();
			layer = -110;
		}
		
		override public function update():void {
			// Assigns the Entity's position to that of the mouse (relative to the Camera).
			x = Input.mouseX;
			y = Input.mouseY;
			// Assigns the Entity's position to that of the mouse (relative to the World).
			x =FP.world.mouseX - 12;
			y =FP.world.mouseY - 12;
		}
	}
}