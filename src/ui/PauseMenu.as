package ui {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkWindow;
	
	import ui.Button;
	
	public class PauseMenu extends Entity {
		
		private var panel:Entity;
		private var resumeButton:Button;
		private var quitButton:Button;
		
		private var w:GameWorld;
		
		public function PauseMenu(_w:GameWorld) {
			super();

			w = _w;

			panel = new Entity(0, 0, Image.createRect(500, 200, 0x333333, 0.8));
			panel.setHitboxTo(panel.graphic);
			panel.layer = -550;
			
			quitButton = new Button(0, 0, "Quit", onQuit);
			resumeButton = new Button(0, 0, "Resume", onResume);
			
			quitButton.layer = resumeButton.layer = -555;
		}
		
		override public function update():void {
			quitButton.update();	
			resumeButton.update();
		}
		
		public function show():void {
			panel.x = FP.camera.x + (FP.screen.width /2) - (panel.width / 2);
			panel.y = FP.camera.y + 10 + (FP.screen.height / 2) - (panel.height / 2);
			resumeButton.x = panel.x + 30;
			resumeButton.y = panel.y + 30;
			quitButton.x = panel.x + 30;
			quitButton.y = panel.y + 90;
			FP.world.add(panel); 
			FP.world.add(quitButton);
			FP.world.add(resumeButton);
		}
		
		public function onResume():void {
			//Todo: fix
			w.onPause();
		}
		
		public function remove():void {
			FP.world.remove(panel); 
			FP.world.remove(quitButton);
			FP.world.remove(resumeButton)
		}
		
		public function onQuit():void {
			FP.world = new MainMenuWorld();
			destroy();
		}
		
		public function destroy():void {
			FP.world.removeAll();
		}
	}
}