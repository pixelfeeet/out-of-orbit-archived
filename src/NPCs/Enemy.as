package NPCs {
	
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	import utilities.Settings;
	import utilities.UtilityFunctions;
	
	public class Enemy extends NPC {
		
		//the character this enemy will attack -- at this point only the player.
		public var targetCharacter:Entity;
		public var viewDistance:int;
		
		public function Enemy(_position:Point = null, _health:int = 100) {
			if (!_position) _position = new Point(0, 0);
			super(_position, _health);
			SPEED = 25;
			JUMP = 300;
			
			hungerTimer = -1;
			viewDistance = 500;
			var t:int = Settings.TILESIZE;
			graphic = Image.createRect(t - 10, t*2 - 10, 0xee8877, 1);
			type = "enemy";
			expValue = 10;
			targetCharacter = GameWorld.player;
			dropItems = generateDropItems();
			
			initBehavior();
			//Sounds
			enemy_destroy = new Sfx(Assets.ENEMY_DESTROY);
			
			setHitboxTo(graphic);
		}
		
		override protected function generateDropItems():Array{
			var f:InteractionItem = GameWorld.interactionItems.food;
			var a:Ammunition = new Ammunition();
			var s:Scraps = new Scraps();
			return [f, a, a, s];
		}
		
		override protected function updateMovement():void {
			super.updateMovement();
			
			if (distanceFrom(GameWorld.player) <= viewDistance){
				if (Math.abs(targetCharacter.x - x) <= 20) velocity.x = 0;
				else if (targetCharacter.x > x) velocity.x = SPEED;
				else velocity.x = -SPEED;
				
				if (velocity.x == 0) jump();
			} else {
				speed = 0;
			}
		
		}
		
		public function getEXP():int {
			return expValue;
		}
		
		
	
	}
}