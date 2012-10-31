package {
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;

	
	public class Weapon extends Entity {
		//false = melee
		private var ranged:Boolean;
		//time in millisecondes after firing before next
		//bullet fires.
		private var fireRate:int;
		//# of projectiles before reloading
		private var clipSize:int;
		//Total bullets
		public var projectiles:int;
		
		public function Weapon() {
			super();
		}
	}
}