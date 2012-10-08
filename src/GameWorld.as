package {
	
	import data.*;
	
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	
	import utilities.Camera;
	import utilities.Settings;
	
	
	public class GameWorld extends World {
		
		public static var player:SpacemanPlayer;
		public static var hud:HUD;
		private var cam:Camera;
		
		public static var inventoryItems:InventoryItems;
		public static var interactionItems:InteractionItems;
		public static var enemies:Enemies;
		
		public var caveLevel:Level;
		
		public function GameWorld() {
		
			inventoryItems = new InventoryItems();
			interactionItems = new InteractionItems();
			enemies = new Enemies();
			
			player = new SpacemanPlayer(new Point(400, 100));
			add(player);
			
			caveLevel = new Level(Assets.CAVE_MAP);
			caveLevel.loadEnemies(this);
			caveLevel.loadInteractionItems(this);
			add(caveLevel)
			
			//var ii:InteractionItem = new InteractionItem(new Point(300, 100));
			//ii.setGraphic(interactionItems.mediPack.graphic);
			///add(ii);
			
			add(new Cursor());

			//var enemy:Enemy = new Enemy(new Point(200, 200), 60);
			//enemy.targetCharacter = player;
			//add(enemy);
			
			//UI
			hud = new HUD(player);
			add(hud);
			
			//Camera
			cam = new Camera();
		}
		
		override public function update():void {
			cam.followPlayer();
			super.update();
		}
		
		public function getPlayer():SpacemanPlayer {
			return player;	
		}
	}
	
}