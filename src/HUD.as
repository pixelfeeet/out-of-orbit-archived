package {
	
	import flash.ui.Mouse;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class HUD extends Entity {
		
		private var healthHUD:Text;
		private var hungerHUD:Text;
		private var thePlayer:SpacemanPlayer;
		 
		private var display:Graphiclist;
		public function HUD(player:SpacemanPlayer) {
			layer = -1;
			thePlayer = player;
			
			healthHUD = new Text("Health: " + thePlayer.getHealth(), 10, 10, 200, 50)
			healthHUD.color = 0x6B6B6B;
			healthHUD.size = 32
				
			hungerHUD = new Text("Hunger: " + thePlayer.getHunger(), FP.screen.width - 210, 10); 
			hungerHUD.color = 0x6B6B6B;
			hungerHUD.size = 32;

			display = new Graphiclist(healthHUD, hungerHUD);
			graphic = display;
		}
		
		override public function update():void {
			display.x = FP.camera.x;
			display.y = FP.camera.y;
			
			
			hungerHUD.text = "Hunger: " + thePlayer.getHunger();
			healthHUD.text = "Health: " + thePlayer.getHealth();
		}
	}
}