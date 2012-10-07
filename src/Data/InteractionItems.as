package data {
	import net.flashpunk.graphics.Image;
	
	public class InteractionItems {
		
		public var food:InteractionItem;
		public var mediPack:InteractionItem;
		public var rocket:InteractionItem;
		
		public function InteractionItems() {
			food = new InteractionItem();
			food.graphic = new Image(Assets.SPACEMAN_RUNNING);
			
			mediPack = new InteractionItem();
			mediPack.graphic = new Image(Assets.SPACEMAN_RUNNING);
			
			rocket = new InteractionItem();
		}
	}
}