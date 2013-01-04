package Weapons {
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class PowerBlaster extends Weapon {
		
		public function PowerBlaster() {
			super();
			ranged = true;
			fireRate = 10;
			clipSize = 20;
			ammunition = clipSize;
			projectileSpeed = 1000;
			graphic = new Image(Assets.PB);
			shootSound = new Sfx(Assets.SHOOT);
			label = "PowerBlaster";
			graphic.visible = true;
			
			originX = 15;
			leftOriginX = 15;
			originY = Image(graphic).height / 2;
			x = 36;
			leftX = 10;
			y = 34;
		}

		override public function shoot():void {
			if (Input.mouseDown && fireTimer == 0
				&& ammunition > 0
				&& !Input.check(Key.SHIFT)) {
				player = GameWorld(FP.world).player;
				
				var initX:int;
				var initY:int;
				
				initX = player.x + graphic.x;
				initY = player.y + graphic.y;
				
				//initY = y + halfHeight - 20;
				var initPos:Point = new Point(initX, initY);
				var destination:Point = new Point(Input.mouseX + FP.camera.x - 10, Input.mouseY + FP.camera.y - 10);
				var speed:Point = new Point(destination.x - initPos.x, destination.y - initPos.y);
				
				var len:Number = cLength(initPos, destination);
				speed.x = (speed.x / len) * projectileSpeed;
				speed.y = (speed.y / len) * projectileSpeed;
				
				//Add projectile to world; determine init position
				var p:Projectile = new Projectile(initPos.x, initPos.y, speed.x, speed.y);
				if (player.isFacingLeft()) FP.angleXY(p, Image(graphic).angle, -Image(graphic).width, initPos.x, initPos.y);
				else FP.angleXY(p, Image(graphic).angle, Image(graphic).width, initPos.x, initPos.y);
				
				FP.world.add(p);
				shootSound.play();
				fireTimer = fireRate;
				ammunition--;
			}
		}
		
		protected function cLength(a:Point, b:Point):Number {
			return Math.sqrt(((b.x - a.x) * (b.x - a.x)) + (b.y - a.y) * (b.y - a.y));
		}

	}
}