package Weapons {
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Input;

	public class Unarmed extends Weapon {
		
		private var stabTween:LinearMotion;
		private var origX:int, origY:int;
		
		public function Unarmed() {
			super();
			ranged = false;
			range = 100;

			shootSound = new Sfx(Assets.SHOOT);
			graphic = new Image(Assets.ARM);
			label = "Unarmed";
			
			originX = 0;
			originY = Image(graphic).height / 2;
			
			offsetX = 28;			
			offsetY = 30;
			
			leftOriginX = 0
			leftOffsetX = 18;
			
			damage = 8;
			
			fireRate = 10;
			graphic.visible = true;
			setHitboxTo(graphic);
		}
		
		override public function added():void {
			super.added();
			var angle:int = Image(graphic).angle;
			stabTween = new LinearMotion(function():void {
				graphic.visible = false;
			});
			addTween(stabTween);
		}
		
		override public function update():void {
			super.update()

			if (fireTimer < fireRate - 1) player.meleeAttacking = false;
			else player.meleeAttacking = true;
			
			if (stabTween.active) {
				x += stabTween.x;
				y += stabTween.y;
			}
		}
		
		override public function shoot():void {
			if (Input.mousePressed && fireTimer == 0) {
				fireTimer = fireRate;
				shootSound.play();
				graphic.visible = true;
				
				var f:Boolean = Image(player.display.children[3]).flipped;
				var startX:Number = 25;
				var endX:Number = -5;
				if (f) {
					startX *= -1;
					endX *= -1;
				}
				var endPoint:Point = new Point(x, y);
				if (player.isFacingLeft()) FP.angleXY(endPoint, Image(graphic).angle, Image(graphic).width, 0, 0);
				else FP.angleXY(endPoint, Image(graphic).angle, Image(graphic).width, 0, 0);
				trace(endPoint);

				stabTween.setMotion(0, 0, endPoint.x, endPoint.y, 0.18);
				stabTween.start();
			}
		}
		
	}
}