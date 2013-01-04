package Weapons {
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	
	public class Weapon extends Entity {
		protected var player:Player;
		protected var ranged:Boolean; //false = melee
		protected var fireRate:int; //minimum time in milliseconds between shots
		public var fireTimer:int; //used to determine whether a shot can be fired yet

		protected var clipSize:int; //# of projectiles before reloading
		protected var ammunition:int; //total ammunition
		protected var projectileSpeed:int;
		protected var equipped:Boolean;
		protected var scrapValue:int;
		protected var damage:int;
		public var range:int;
		
		protected var shootSound:Sfx;
		
		public var label:String;
		public var leftX:int;
		public var leftOriginX:int;
		
		public function Weapon() {
			super();
			
			//Default values
			ranged = false;
			
			fireRate = 10
			fireTimer = 0;
			damage = 10;
			equipped = false;
			scrapValue = 100;
			label = "default";
			range = 100;
			
			leftX = x;
			leftOriginX = originX;
		}
		
		override public function added():void {
			player = GameWorld(FP.world).player;
		}
		
		override public function update():void {
			if (fireTimer > 0) fireTimer--;
		}
		
		public function shoot():void { }
		
		public function addAmmo(i:int):void { ammunition += i; }
		public function getAmmo():int { return ammunition; }
		public function getRange():int { return range; }
		public function getDamage():int { return damage; }
	}
}