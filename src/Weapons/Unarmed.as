package Weapons {
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;

	public class Unarmed extends MeleeWeapon {
		
		public function Unarmed() {
			super();
			ranged = false;
			range = 100;

			shootSound = new Sfx(Assets.SHOOT);
			graphic = new Image(Assets.ARM);
			label = "Unarmed";
			attackType = "stab";
			
			originX = 0;
			originY = Image(graphic).height / 2;
			
			offsetX = 28;			
			offsetY = 30;
			
			leftOriginX = 0
			leftOffsetX = 18;
			
			damage = 8;
			
			fireRate = 10;
			graphic.visible = true;
			setHitboxTo(graphic);
		}
		
	}
}