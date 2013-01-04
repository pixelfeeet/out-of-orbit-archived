package Weapons {
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.AngleTween;
	import net.flashpunk.utils.Input;
	
	public class Pipe extends MeleeWeapon {
		
		public function Pipe() {
			super();
			ranged = false;
			range = 100;
			
			shootSound = new Sfx(Assets.SHOOT);
			graphic = new Image(Assets.PIPE);
			label = "Pipe";
			
			attackType = "swing"
			
			originX = 0;
			originY = Image(graphic).height;
			
			offsetX = 25;			
			offsetY = 33;
			
			leftOriginX = 0
			leftOffsetX = 16;
			
			damage = 10;
			fireRate = 10;

		}
		
	}
}