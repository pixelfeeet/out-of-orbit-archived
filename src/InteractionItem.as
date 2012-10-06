package {
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.*;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class InteractionItem extends Entity {
		private var rocketImage:Image;
		private var velocity:Point;
		private var acceleration:Point;
		private var xSpeed:int;
		protected const GRAVITY:int = 8;
		
		private var upTween:VarTween;
		private var downTween:VarTween;
		
		public function InteractionItem(_x:Number=0, _y:Number=0) {
			
			super();
			
			rocketImage = new Image(Assets.EXAMPLE_ITEM);
			graphic = rocketImage;
			
			x = _x;
			y = _y;
			
			acceleration = new Point();
			velocity = new Point();
			
			xSpeed = 0;
			
			this.setHitbox(10, 10, 0, 0);
			
			
		}

		
		override public function update():void {
			updateMovement();
			updateCollision();
			super.update();
			
			if (Input.pressed(Key.DIGIT_3)){
				if(GameWorld.player.getInventory().findOpenSlot() != -1){
					GameWorld.player.getInventory().addItemToInventory(this);
					destroy();
				}
			}
		}
		
		protected function updateMovement():void{	
			acceleration.y = GRAVITY;
			velocity.y += acceleration.y;
		}
		
		protected function updateCollision():void {
			
			//TODO: don't let character move offscreen.
			// or do?
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.x) > 0){
					//moving to the right
					velocity.x = 0;
					
					x = Math.floor(x / 32) * 32;
				} else {
					//moving the left
					velocity.x = 0;
					x = Math.floor(x/32) * 32 + 32;
				}
			}
			
			// VERTICAL MOVEMENT
			y += velocity.y * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.y) > 0){
					//moving down
					velocity.y = 0;
					y = Math.floor(y / 32) * 32 + Math.abs((height % 32) - 32);
				} else {
					//moving up
					velocity.y = 0;
					y = Math.floor(y / 32) * 32 + 32;
				}
			}
		}
		
		protected function destroy():void{
			world.remove(this);
		}
		
	}
}