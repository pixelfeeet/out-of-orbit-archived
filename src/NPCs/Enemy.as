package NPCs {
	
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	import utilities.Settings;
	
	public class Enemy extends NPC {
		public var player:Entity;
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
			
			dropItems = generateDropItems();
			
			initBehavior();
			//Sounds
			enemy_destroy = new Sfx(Assets.ENEMY_DESTROY);
			
			setHitboxTo(graphic);
		}
	
		override public function added():void {
			player = GameWorld(FP.world).player;
		}
		
		override protected function generateDropItems():Array{
			var f:InteractionItem = GameWorld(FP.world).interactionItems.food;
			var a:Ammunition = new Ammunition();
			var s:Scraps = new Scraps();
			return [f, a, a, s];
		}
		
		override protected function updateMovement():void {
			super.updateMovement();
			
			if (distanceFrom(player) <= viewDistance){
				if (Math.abs(player.x - x) <= 20) velocity.x = 0;
				else if (player.x > x) velocity.x = vSpeed;
				else velocity.x = -vSpeed;
				
				if (vSpeed != 0 && velocity.x == 0) jump();
			} else vSpeed = 0;
		}
		
		public function getEXP():int {
			return expValue;
		}
		
		
	
	}
}