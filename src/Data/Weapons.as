package data
{
	import Weapons.PowerBlaster;
	import Weapons.Unarmed;
	import Weapons.Weapon;
	
	public class Weapons {
		public var powerBlaster:PowerBlaster;
		public var unarmed:Unarmed;
		
		public function Weapons(p:SpacemanPlayer) {
			powerBlaster = new PowerBlaster(p);
			unarmed = new Unarmed(p);
		}
	}
}