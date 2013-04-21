package NPCs {
	
	import flash.geom.Point;
	
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.Pixelmask;
	
	import utilities.Settings;
	import Weapons.Ammunition;
	
	public class Worm extends NPC {
		
		public function Worm(_position:Point = null, _health:int = 100) {
			if (!_position) _position = new Point(0, 0);
			super(_position, _health);
			SPEED = 25;
			JUMP = 300;
			
			hungerTimer = -1;
			viewDistance = 500;
			var t:int = Settings.TILESIZE;
			
			graphic = Image.createRect(t - 10, t*2 - 10, 0xee8877, 1);
			type = "neutral";
			habitat = "water"; 
			expValue = 10;
			
			dropItems = generateDropItems();
						
			spriteMap = new Spritemap(Assets.WORM, 252, 32);
			spriteMap.add("standing", [0]);
			
			graphic = spriteMap;
			setHitboxTo(graphic);
		}
		
		override protected function generateDropItems():Array{
			var f:InteractionItem = GameWorld(FP.world).interactionItems.food;
			var a:Ammunition = new Ammunition();
			var s:Scraps = new Scraps();
			return [f, a, a, s];
		}
		
		public function getEXP():int { return expValue; }
		
	}
}