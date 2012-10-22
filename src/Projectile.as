package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	public class Projectile extends Entity
	{
		private var speed:Number = 1000;
		private var xSpeed:int;
		private var ySpeed:int;
		
		//the amount of damage this bullet does to other
		//entities.
		private var damagePoints:int;
		
		public function Projectile(_x:Number, _y:Number, _xSpeed:int, _ySpeed:int) {
			x = _x;
			y = _y;
			xSpeed = _xSpeed;
			ySpeed = _ySpeed;
			
			damagePoints = 10;
			
			graphic = Image.createRect(5, 5, 0x3B3B3B);

			setHitbox(5, 5, 0, 0);
			type = "bullet";
			
		}
		
		override public function update():void {
			x += xSpeed * FP.elapsed;
			y += ySpeed * FP.elapsed;
			//TODO: if it goes off-screen, destory it.
			if (collide("level", x, y)) FP.world.remove(this);
		}
		
		public function destroy():void {
			FP.world.remove(this);
		}
		
		public function getDamagePoints():int {
			return damagePoints;
		}
		
	}
}