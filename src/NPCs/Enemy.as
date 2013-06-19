package NPCs {
	
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	import utilities.Settings;
	import Weapons.Ammunition;
	
	public class Enemy extends NPC {
		
		public function Enemy(_position:Point = null, _health:int = 100) {
			if (!_position) _position = new Point(0, 0);
			super(_position, _health);
			SPEED = 25;
			JUMP = 300;
			
			hungerTimer = -1;
			viewDistance = 20;
			
			graphic = Image.createRect(t - 10, t*2 - 10, 0xee8877, 1);
			type = "enemy";
			habitat = "ground";
			expValue = 10;
			
			dropItems = generateDropItems();

			graphic = Image.createRect(t, t * 2,0xffaa99);
			setHitboxTo(graphic);
		}

		override protected function generateDropItems():Array{
//			var a:Class = Ammunition;
//			var s:Class = Scraps;
//			return [new a(), new a(), new s()];
			return [];
		}
		
		override protected function updateMovement():void {
			super.updateMovement();
			
			if (distanceFrom(player) <= viewDistance) attackBehavior();
			else idleMovement();
		}
		
		protected function attackBehavior():void {
			if (Math.abs(player.x - x) <= viewDistance) velocity.x = 0;
			else if (player.x > x) velocity.x = vSpeed;
			else velocity.x = -vSpeed;
			
			if (Math.abs(player.x - x) <= attackRange) attack();
			if (xSpeed != 0 && velocity.x == 0) jump();
		}
		
		public function getEXP():int { return expValue; }
	
	}
}