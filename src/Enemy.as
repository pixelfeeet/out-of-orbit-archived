package {
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	import utilities.UtilityFunctions;
	import utilities.Settings;
	
	public class Enemy extends Character {
		
		//the character this enemy will attack --usually
		//the player.
		public var targetCharacter:Entity;
		public var viewDistance:int;
		//this should be an array, and maybe not just
		//interactionitems
		private var dropItems:Array;
		private var expValue:int;
		
		public var respawning:Boolean;
		public var eliminated:Boolean;
		
		public function Enemy(_position:Point = null, _health:int = 100) {
			if (!_position) _position = new Point(0, 0);
			super(_position, _health);
			PLAYER_SPEED = 25;
			JUMP = 200;
			
			hungerTimer = -1;
			viewDistance = 500;
			var t:int = Settings.TILESIZE;
			graphic = Image.createRect(t - 10, t*2 - 10, 0xee8877, 1);
			type = "enemy";
			expValue = 10;
			targetCharacter = GameWorld.player;
			dropItems = generateDropItems();
			
			respawning = true;
			eliminated = false;
			
			setHitboxTo(graphic);
		}
		
		private function generateDropItems():Array{
			var f:InteractionItem = GameWorld.interactionItems.food;
			return [f, f, f];
		}
		
		public function destroy():void {
			
			for (var i:int = 0; i < dropItems.length; i++){
				var item:InteractionItem = new InteractionItem();
				item.getPropertiesFrom(dropItems[i], new Point(x + ((i + 1) * 10), y + i));
				FP.world.add(item);
			}
			GameWorld.player.gainExperience(expValue);
			FP.world.remove(this);
			if (!respawning) eliminated = true;
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
		
		public function getEXP():int {
			return expValue;
		}
		
		override public function removed():void {
			
		}
	
	}
}