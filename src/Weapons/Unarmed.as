package Weapons {
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;

	public class Unarmed extends Weapon {
		
		public function Unarmed() {
			super();
			ranged = false;
			range = 100;

			shootSound = new Sfx(Assets.SHOOT);
			graphic = new Image(Assets.ARM);
			label = "Unarmed";
			
			originX = 0;
			originY = Image(graphic).height / 2;
			x = 28;
			leftX = 18;
			y = 28;
			
			damage = 8;
			
			fireRate = 10;
			graphic.visible = false;
		}
		
		override public function update():void {
			super.update()
			if (fireTimer == 0) graphic.visible = false;
			else graphic.visible = true;

			if (fireTimer < fireRate - 1) player.meleeAttacking = false;
			else player.meleeAttacking = true;
			trace(fireTimer);
		}
		
		override public function shoot():void {
			if (Input.mousePressed && fireTimer == 0) {
				fireTimer = fireRate;
				shootSound.play();
			}
		}
		
	}
}