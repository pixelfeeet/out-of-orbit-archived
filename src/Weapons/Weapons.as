package Weapons
{
	
	public class Weapons {
		public var powerBlaster:PowerBlaster;
		public var unarmed:Unarmed;
		public var pipe:Pipe;
		public var axe:Axe;
		public var knife:Knife;
		
		public var list:Array;
		
		public function Weapons() {
			powerBlaster = new PowerBlaster();
			unarmed = new Unarmed();
			pipe = new Pipe();
			axe = new Axe();
			knife = new Knife();
			
			list = [powerBlaster, unarmed, pipe, axe, knife]
		}
		
	}
}