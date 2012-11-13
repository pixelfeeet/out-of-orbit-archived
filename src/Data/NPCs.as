package data {
	import NPCs.DustBall;
	import NPCs.FruitPlant;
	import NPCs.NPC;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;

	public class NPCs {
		
		public var list:Array;
		
		public function NPCs() {
			
			list = [FruitPlant, DustBall];
		
		}

	}
}