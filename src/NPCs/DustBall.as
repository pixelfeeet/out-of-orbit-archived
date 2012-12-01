package NPCs {
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	public class DustBall extends NPC {
		//TODO: fix the bug that causes the dustballs only to face right
		// even when they're moving left.
		protected var spriteMap:Spritemap;
		
		public static var label:String = "dust_ball"
		public function DustBall(_position:Point=null, _health:int=100, _hunger:int=-1) {
			super(_position, _health, _hunger);
			health = 20;
			
			spriteMap = new Spritemap(Assets.DUST_BALL, 40, 40);
			spriteMap.add("standing", [0]);
			spriteMap.add("moving", [0, 1], 4);
			
			graphic = spriteMap;
			setHitboxTo(graphic);
		}
		
		override protected function updateGraphic():void {
			if (FP.sign(xSpeed) > 0) Image(graphic).flipped = false;
			else if (FP.sign(xSpeed) < 0) Image(graphic).flipped = true;	
			if (velocity.x == 0) spriteMap.play("standing");
			else spriteMap.play("moving");
		}
		
		override protected function updateMovement():void {
			if (movementFrequency != 0) {
				if (xSpeed != 0 && velocity.x == 0) jump();
				
				if (movementTimer == 0) {
					if (FP.sign(xSpeed) != 0) {
						xSpeed = 0;
						movementTimer = movementFrequency * Math.ceil(Math.random() * 5);
					} else {
						var r:Number = Math.random() * 2;
						if (r < 1) { 
							xSpeed = -vSpeed;
							movementTimer = Math.ceil(Math.random() * 50) + 50;
						} else {
							xSpeed = vSpeed;
							movementTimer = Math.ceil(Math.random() * 50) + 50;
						}
					}
				} else {
					movementTimer--;
				}	
			}
			super.updateMovement();
		}
	}
}