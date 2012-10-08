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
			
			player = new SpacemanPlayer(new Point(0,0));

			
			caveLevel = new Level(Assets.CAVE_MAP);
			caveLevel.loadEnemies(this);
			caveLevel.loadInteractionItems(this);
			caveLevel.loadPlayer(this, player);
			add(player);
			add(caveLevel);

			
			add(new Cursor());

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