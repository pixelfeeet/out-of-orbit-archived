package NPCs {
	import flash.geom.Point;
	
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	public class Amoeba extends NPC {		
		public static var label:String = "amoeba"
		public function Amoeba(_position:Point=null, _health:int=100, _hunger:int=-1) {
			super(_position, _health, _hunger);
			health = 20;
			
			habitat = "water";
			
			spriteMap = new Spritemap(Assets.AMOEBA, 34, 38);
			spriteMap.add("moving", [0, 1, 2, 1], 4);

			graphic = spriteMap;
			setHitboxTo(graphic);
		}
		
		override protected function updateGraphic():void {
			this.centerOrigin();
			if (FP.sign(xSpeed) > 0) Image(graphic).angle = -15;
			else if (FP.sign(xSpeed) < 0) Image(graphic).angle = 15;
			else Image(graphic).angle = 0;
			spriteMap.play("moving");
		}
	}
}