package Weapons {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	
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
		
		public var offsetX:int;
		public var offsetY:int;
		
		public var leftOffsetX:int;
		public var leftOriginX:int;
		
		protected var angleMod:int; 
		
		public function Weapon() {
			super();
			
			layer = -499;
			
			//Default values
			ranged = false;
			
			fireRate = 10
			fireTimer = 0;
			damage = 10;
			equipped = false;
			scrapValue = 100;
			label = "default";
			range = 100;
			
			//the x/y offsets relative to the player's x/y values
			offsetX = x;
			offsetY = y;
			
			//the rotation points
			originX = 0;
			originY = 0;
		
			//values for if the player is facing left
			leftOffsetX = x;
			leftOriginX = 0;
			
			angleMod = 0;
		}
		
		override public function added():void {
			player = GameWorld(FP.world).player;
		}
		
		override public function update():void {
			super.update();
			
			if (fireTimer > 0) fireTimer--;
			Image(graphic).angle = player.angle + angleMod;
			
			if (player.facingLeft) {
				Image(graphic).scaleY = -1;
				Image(graphic).angle -= 180;
			} else Image(graphic).scaleY = 1;
			
			//Note: weapon positioning is in Player.as to
			//prevent laggyness
		}
		
		public function shoot():void { }
		public function addAmmo(i:int):void { ammunition += i; }
		public function getAmmo():int { return ammunition; }
		public function getRange():int { return range; }
		public function getDamage():int { return damage; }
	}
}