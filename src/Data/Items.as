package Data {
	public class Items {
		
		public var food:InventoryItem;
		
		public function Items() {
			food = new InventoryItem;
			food.name = "food";
			food.behavior = function():void {
				GameWorld.player.changeHunger(10);
			}
		}
	}
}