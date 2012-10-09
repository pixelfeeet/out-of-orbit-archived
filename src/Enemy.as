package {
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	import utilities.UtilityFunctions;
	
	public class Enemy extends Character {
		
		//the character this enemy will attack --usually
		//the player.
		public var targetCharacter:Entity;
		public var viewDistance:int;
		//this should be an array, and maybe not just
		//interactionitems
		private var dropItems:Array;
		
		public function Enemy(_position:Point = null, _health:int = 100) {
			if (!_position) _position = new Point(0, 0);
			super(_position, _health);
			PLAYER_SPEED = 25;
			JUMP = 200;
			
			hungerTimer = -1;
			viewDistance = 500;
			graphic = Image.createRect(24, 40, 0xee8877, 1);
			type = "enemy";
			targetCharacter = GameWorld.player;
			var f:InteractionItem = GameWorld.interactionItems.food;
			dropItems = [f, f, f];
			
			setHitboxTo(graphic);
		}
		
		public function destroy():void {
			
			for (var i:int = 0; i < dropItems.length; i++){
				var item:InteractionItem = new InteractionItem();
				item.getPropertiesFrom(dropItems[i], new Point(x + ((i + 1) * 10), y + i));
				FP.world.add(item);
			}
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
				if (distanceFrom(GameWorld.player) <= viewDistance){
					if (Math.abs(targetCharacter.x - x) <= 20) velocity.x = 0;
					else if (targetCharacter.x > x) xSpeed = PLAYER_SPEED;
					else xSpeed = -PLAYER_SPEED;
					
					if (velocity.x == 0) jump();
				} else {
					xSpeed = 0;
				}
			
		}

		override protected function takeDamage(damage:int):void {
			super.takeDamage(damage);
			//TODO: destroy animation
			if (health <= 0) destroy();
		}
	
	}
}