package NPCs {
	import net.flashpunk.graphics.Image;
	public class FruitPlant extends NPC {
		public static var label:String = "fruit_plant";
		public function FruitPlant() {
			super();
			graphic = new Image(Assets.FRUIT_PLANT);
			setHitboxTo(graphic);
			setMovementFrequency(0);
			health = 20;
			behavior = function():void {} //no behavior
		}
	}
}