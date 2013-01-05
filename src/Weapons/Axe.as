package Weapons {
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	
	public class Axe extends MeleeWeapon {
		public function Axe() {
			super();
			ranged = false;
			range = 100;
			
			shootSound = new Sfx(Assets.SHOOT);
			graphic = new Image(Assets.AXE);
			label = "Axe";
			
			attackType = "swing"
			
			originX = 0;
			originY = Image(graphic).height;
			
			offsetX = 25;			
			offsetY = 38;
			
			leftOriginX = 0
			leftOffsetX = 16;
			
			damage = 10;
			fireRate = 10;
		}
	}
}