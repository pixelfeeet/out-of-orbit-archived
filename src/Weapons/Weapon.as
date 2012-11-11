package Weapons {
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	
	public class Weapon extends Entity {
		//false = melee
		protected var ranged:Boolean;
		//time in millisecondes after firing before next
		//bullet fires.
		protected var fireRate:int;
		//# of projectiles before reloading
		protected var clipSize:int;
		//Total bullets
		public var fireTimer:int;
		protected var ammunition:int;
		protected var projectileSpeed:int;
		protected var equipped:Boolean;
		protected var scrapValue:int;
		protected var range:int;
		protected var damage:int;
		
		protected var shootSound:Sfx;
		
		public var label:String;
		public var leftX:int;
		public var leftOriginX:int;
		
		public function Weapon(p:SpacemanPlayer) {
			super();
			ammunition = 10;
			fireTimer = 0;
			equipped = false;
			scrapValue = 100;
			label = "default";
			damage = 10;
			
			leftX = x;
			leftOriginX = originX;
		}
		
		public function shoot():void { }
		
		public function addAmmo(i:int):void { ammunition += i; }
		public function getAmmo():int { return ammunition; }
		public function getRange():int { return range; }
		public function getDamage():int { return damage; }
	}
}