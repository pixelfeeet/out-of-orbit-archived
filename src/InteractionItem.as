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
	import utilities.Settings;
	
	public class InteractionItem extends Entity {
		private var rocketImage:Image;
		private var velocity:Point;
		private var acceleration:Point;
		private var xSpeed:int;
		protected const GRAVITY:int = 8;
		
		private var upTween:VarTween;
		private var downTween:VarTween;
		
		public function InteractionItem(_position:Point) {
			
			super();
			
			rocketImage = new Image(Assets.ROCKET_IMAGE);
			graphic = rocketImage;
			
			x = _position.x;
			y = _position.y;
			
			acceleration = new Point();
			velocity = new Point();
			
			xSpeed = 0;
			
			setHitboxTo(graphic);
			
			
		}

		
		override public function update():void {
			updateMovement();
			updateCollision();
			super.update();
			
			if (collidePoint(x, y, world.mouseX, world.mouseY)) {
				if (Input.mouseReleased) click();
			}

		}
		
		protected function click():void {
			if (Input.check(Key.SHIFT)){
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
					if (height > Settings.TILESIZE) y = Math.floor(y / 32) * 32;
					else y = Math.floor(y / 32) * 32 + Math.abs((height % 32) - 32);
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