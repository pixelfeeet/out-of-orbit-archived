package {
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import punk.ui.PunkButton;
	import punk.ui.PunkWindow;
	
	public class PauseMenu extends Entity {
		
		private var punk:PunkWindow;
		private var quitButton:PunkButton;
		private var resumeButton:PunkButton;
		private var w:GameWorld;
		
		public function PauseMenu(_w:GameWorld) {
			super();

			w = _w;
			punk = new PunkWindow(0, 0, 500, 200, "PAUSE", true);
			quitButton = new PunkButton(0, 0, 440, 50, "Quit");
			quitButton.setCallbacks(onQuit);
			resumeButton = new PunkButton(0, 0, 440, 50, "Resume");
			resumeButton.setCallbacks(resume);

		}
		
		override public function update():void {
			quitButton.update();	
			resumeButton.update();
		}
		
		public function show():void {
			punk.x = FP.camera.x + (FP.screen.width /2) - (punk.width / 2);
			punk.y = FP.camera.y + 10 + (FP.screen.height / 2) - (punk.height / 2);
			resumeButton.x = punk.x + 30;
			resumeButton.y = punk.y + 30;
			quitButton.x = punk.x + 30;
			quitButton.y = punk.y + 90;
			FP.world.add(punk); 
			FP.world.add(quitButton);
			FP.world.add(resumeButton);
		}
		
		public function resume():void {
			//Todo: fix
			w.onPause();
		}
		
		public function remove():void {
			FP.world.remove(punk); 
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