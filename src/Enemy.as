package {
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	public class Enemy extends Character {
		
		//the character this enemy will attack --usually
		//the player.
		public var targetCharacter:Entity;
		
		[Embed(source = 'assets/player.png')] private const ENEMY:Class;
		public function Enemy(_position:Point, _health:int = 100) {

			super(_position, _health);
			PLAYER_SPEED = 25;
			JUMP = 200;
			hungerTimer = -1;
			
			graphic = new Image(ENEMY);
			type = "enemy";
			setHitbox(Image(graphic).width, Image(graphic).height, 0, 0);
		}
		
		public function destroy():void {
			FP.world.remove(this);
		}
		
		override public function update():void {

			super.update();
			behavior();
			
		}
		
		override protected function updateMovement():void {
			
			super.updateMovement();

		}
		
		protected function behavior():void {
			
			if (Math.abs(targetCharacter.x - x) <= 20) velocity.x = 0;
			else if (targetCharacter.x > x) xSpeed = PLAYER_SPEED;
			else xSpeed = -PLAYER_SPEED; // (targetCharacter.x < x)
			
			if (velocity.x == 0) jump();
		}

		override protected function takeDamage(damage:int):void {
			super.takeDamage(damage);
			//TODO: destroy animation
			if (health <= 0) FP.world.remove(this);
		}
	
	}
}