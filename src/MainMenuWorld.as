package {
	import mx.core.ButtonAsset;
	
	import net.flashpunk.World;
	import net.flashpunk.graphics.*;
	import net.flashpunk.utils.*;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import ui.Button;
	import ui.Checkbox;
	import ui.RadioButton;
	import ui.RadioButtonGroup;

	public class MainMenuWorld extends World {
		
		public function MainMenuWorld() {
			
		}
		
		override public function begin():void {
			super.begin();
			add(new Button(10, 10, "Confirm"));
			add(new Checkbox(20, 140, "Penguins are socially awkward"));
			
			var group1:RadioButtonGroup = new RadioButtonGroup();
			add(new RadioButton(20, 200, group1, "Red"));
			add(new RadioButton(20, 250, group1, "Green"));
			add(new RadioButton(20, 300, group1, "Navy"));
			
			var group2:RadioButtonGroup = new RadioButtonGroup();
			add(new RadioButton(200, 200, group2, "Reggie"));
			add(new RadioButton(200, 250, group2, "Watts"));
		}
		
		private function playTheGame():void {
			FP.world = new GameWorld();
			destroy();
		}
		
		public function destroy():void {
			removeAll();
		}

	}
}