package Weapons {
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.AngleTween;
	import net.flashpunk.utils.Input;
	
	public class Pipe extends Weapon {
		
		public var swingTween:AngleTween;
		
		public function Pipe() {
			super();
			ranged = false;
			range = 100;
			
			shootSound = new Sfx(Assets.SHOOT);
			graphic = new Image(Assets.PIPE);
			label = "Pipe";
			
			originX = 0;
			originY = Image(graphic).height;
			x = 28;
			leftX = 18;
			y = 34;
			
			damage = 10;
			
			fireRate = 10;
			
			graphic.visible = true;
		}
		
		override public function added():void {
			super.added();
			var angle:int = Image(graphic).angle;
			swingTween = new AngleTween(null);
			addTween(swingTween);
		}
		
		override public function update():void {
			super.update();
			
			if (fireTimer < fireRate - 1) player.meleeAttacking = false;
			else player.meleeAttacking = true;

			if (swingTween.active) Image(graphic).angle = swingTween.angle;
			
			trace(fireTimer)
		}
		
		override public function shoot():void {
			if (Input.mousePressed && fireTimer == 0) {
				fireTimer = fireRate;
				shootSound.play();
				
				var f:Boolean = Image(player.display.children[3]).flipped;
				var angle:Number = Image(graphic).angle;
				
				var startOffset:int = -50;
				var endOffset:int = 100;
				if (!f) {
					startOffset *= -1;
					endOffset *= -1;
				}
				swingTween.tween(startOffset, endOffset, 0.2);
				
				player.meleeAttacking = true;
				swingTween.start();
			}
		}
		
	}
}