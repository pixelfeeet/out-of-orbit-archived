package Weapons {
	public class Knife extends MeleeWeapon {
		import net.flashpunk.Sfx;
		import net.flashpunk.graphics.Image;
		
		public function Knife() {
			super();
			ranged = false;
			range = 100;
			
			shootSound = new Sfx(Assets.SHOOT);
			graphic = new Image(Assets.KNIFE);
			label = "Knife";
			attackType = "stab";
			
			originX = 0;
			originY = 10;
			
			offsetX = 22;			
			offsetY = 24;
			
			leftOriginX = 0
			leftOffsetX = 24;
			
			damage = 8;
			
			stabStart = 45;
			stabEnd = -25;
			lengthMod = 4;
			
			fireRate = 10;
			graphic.visible = true;
			setHitboxTo(graphic);
		}
	}
}