package Weapons {
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.AngleTween;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.Input;
	
	public class MeleeWeapon extends Weapon {
		protected var attackType:String;
		protected var raiseTween:AngleTween;
		protected var swingTween:AngleTween;
		protected var stabTween:LinearMotion;
		
		protected var origX:int, origY:int;
		
		protected var raiseStartOffset:int, raiseEndOffset:int,
		swingStartOffset:int, swingEndOffset:int, 
		stabStart:int, stabEnd:int, lengthMod:int;
		
		public function MeleeWeapon() {
			super();
			
			//can be set to 'swing' or 'stab'
			attackType = 'none'
				
			raiseStartOffset = 0;
			raiseEndOffset = 50;
			swingStartOffset = 50;
			swingEndOffset = 65 + angleMod;
			
			stabStart = 25;
			stabEnd = -5;
			
			lengthMod = 1;
		}
		
		override public function update():void {
			super.update();
			x = player.x;
			y = player.y;
			
			if (fireTimer < fireRate - 1) player.meleeAttacking = false;
			else player.meleeAttacking = true;
			
			if (attackType == "swing") {
//				if (raiseTween.active) {
//					Image(graphic).angle = raiseTween.angle;
//					if (player.facingLeft) Image(graphic).angle -= 180;
//				} else if (swingTween.active) {
//					Image(graphic).angle = swingTween.angle;
//					if (player.facingLeft) Image(graphic).angle -= 180;
//				}
			} if (attackType == "stab") {
				if (stabTween.active) {
					x += stabTween.x;
					y += stabTween.y;
				}
			}
		}
		
		override public function added():void {
			super.added();
			if (attackType == "swing") {
				raiseTween = new AngleTween(function():void{
					angleMod = raiseTween.angle;
				});
				swingTween = new AngleTween(function():void{
					angleMod = 0;
					player.meleeAttacking = false
				});
				addTween(raiseTween);
				addTween(swingTween);
			} else if (attackType == "stab") {
				stabTween = new LinearMotion(function():void {
					//graphic.visible = false;
					player.meleeAttacking = false;
				});
				addTween(stabTween);
			}
		}
		
		override public function shoot():void {
			if (Input.mousePressed && fireTimer == 0) {
				if (attackType == "swing") raiseWeapon();
				if (attackType == "stab") stabAttack();
			}
			
			if (Input.mouseReleased) {
				if (attackType == "swing") {
					swingAttack();
				}
			}
		}
		
		protected function raiseWeapon():void {
			var startOffset:int = raiseStartOffset;
			var endOffset:int = raiseEndOffset;
			if (player.facingLeft()) startOffset *= -1;
			raiseTween.tween(startOffset, endOffset, 0.3);
			raiseTween.start();
		}
		
		protected function swingAttack():void {
			fireTimer = fireRate;
			shootSound.play();	
			
			var startOffset:int = -50;
			var endOffset:int = 65 + angleMod;
			if (!player.facingLeft()) {
				startOffset *= -1;
				endOffset *= -1;
			}
			swingTween.tween(startOffset, endOffset, 0.2);
			
			player.meleeAttacking = true;
			swingTween.start();
		}
		
		protected function stabAttack():void {
			fireTimer = fireRate;
			shootSound.play();
			graphic.visible = true;
			player.meleeAttacking = true;
			
			var f:Boolean = player.facingLeft();
			var startX:Number = stabStart;
			var endX:Number = stabStart;
			if (f) {
				startX *= -1;
				endX *= -1;
			}
			var endPoint:Point = new Point(x, y);
			if (f) FP.angleXY(endPoint, Image(graphic).angle, Image(graphic).width / lengthMod, 0, 0);
			else FP.angleXY(endPoint, Image(graphic).angle, Image(graphic).width / lengthMod, 0, 0);
			
			stabTween.setMotion(0, 0, endPoint.x, endPoint.y, 0.18);
			stabTween.start();
		}
	}
}