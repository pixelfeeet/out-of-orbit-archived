package data
{
	import Weapons.Pipe;
	import Weapons.PowerBlaster;
	import Weapons.Unarmed;
	import Weapons.Weapon;
	
	public class Weapons {
		public var powerBlaster:PowerBlaster;
		public var unarmed:Unarmed;
		public var pipe:Pipe;
		
		public function Weapons(p:Player) {
			powerBlaster = new PowerBlaster();
			unarmed = new Unarmed();
			pipe = new Pipe();
		}
	}
}