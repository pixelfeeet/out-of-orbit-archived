package {
	import flash.geom.Point;
	
	import mx.core.ButtonAsset;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.*;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.motion.LinearMotion;
	import net.flashpunk.utils.*;
	import net.flashpunk.utils.Ease;
	
	import ui.components.Button;
	import ui.components.Checkbox;
	import ui.components.RadioButton;
	import ui.components.RadioButtonGroup;

	public class MainMenuWorld extends World {
		
		private var ship:Entity;
		private var shipPos:Point;
		private var shipOffsets:Array;
		private var shipTimer:int;
		private var shipFreq:int;
		private var i:int;
		private var shipTween:LinearMotion;
		private var startDelay:int;
		
		private var starsBg:Graphic;
		private var starsLayer1:Graphic;
		private var starsLayer2:Graphic;
		private var starsTitle:Graphic;
		private var starsGraphics:Graphiclist;
		
		private var starSpeed:Number;
		private var starX:Number;
		
		public function MainMenuWorld() {}
		
		override public function begin():void {
			super.begin();
			var title:Entity = new Entity(0, 0);
			
			starsBg = new Backdrop(Assets.STARS_BG);
			starsLayer1 = new Backdrop(Assets.STARS_LAYER_1);
			starsLayer2 = new Backdrop(Assets.STARS_LAYER_2);
			starsTitle = new Image(Assets.STARS_TITLE)
			starsTitle.x = 265;
			starsTitle.y = 35;
			starsGraphics = new Graphiclist(starsBg, starsLayer1, starsLayer2, starsTitle);
			title.graphic = starsGraphics;
			add(title);
			
			//Ship
			shipPos = new Point(370, 240);
			ship = new Entity(shipPos.x, shipPos.y);
			shipFreq = 40;
			shipTimer = shipFreq;
			i = 0;
			
			startDelay = -1;
			
			starSpeed = 0.3;
			starX = ship.x;
			
			shipOffsets = [0, 2, 4, 2, 0, -2, -4, -2, 0]
			ship.graphic = Image.createRect(300, 100, 0x999999);
			add(ship);
			
			add(new Button(430, 525, "New Game", shipLeaveScreen));
			shipTween = new LinearMotion(delay, ONESHOT);
			
//			add(new Button(10, 10, "Confirm"));
//			add(new Checkbox(20, 140, "Penguins are socially awkward"));
//			
//			var group1:RadioButtonGroup = new RadioButtonGroup();
//			add(new RadioButton(20, 200, group1, "Red"));
//			add(new RadioButton(20, 250, group1, "Green"));
//			add(new RadioButton(20, 300, group1, "Navy"));
//			
//			var group2:RadioButtonGroup = new RadioButtonGroup();
//			add(new RadioButton(200, 200, group2, "Reggie"));
//			add(new RadioButton(200, 250, group2, "Watts"));
		}
		
		override public function update():void {
			super.update();
			updateShip();
			starsLayer1.x -= starSpeed * 2;
			starsLayer2.x -= starSpeed;
		}
		
		private function updateShip():void {
			if(shipTween.active) {
				ship.x = shipTween.x;
				ship.y = shipTween.y;
			} else {
				if (shipTimer > 0) shipTimer--;
				else {
					if (i > shipOffsets.length - 1) i = 0;
					ship.y = shipPos.y + shipOffsets[i];
					i++;
					shipTimer = shipFreq;
				}
			}
			
			if (startDelay > 0 && startDelay < 2) playTheGame();
			else if (startDelay != -1) startDelay--;
		}
		
		private function shipLeaveScreen():void {
			shipTween.setMotion(ship.x, ship.y, ship.x + 1500, ship.y, 2, Ease.quadIn);
			addTween(shipTween, true);
		}
		
		private function delay():void {
			startDelay = 120;
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