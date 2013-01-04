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
		
		public var list:Array;
		public function Weapons() {
			powerBlaster = new PowerBlaster();
			unarmed = new Unarmed();
			pipe = new Pipe();
			
			list = [powerBlaster, unarmed, pipe]			
		}
		
	}
}