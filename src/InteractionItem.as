package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class InteractionItem extends Entity {
		private var rocketImage:Image;
		public function InteractionItem(x:Number=0, y:Number=0, graphic:Graphic=null, mask:Mask=null) {
			rocketImage = new Image(Assets.ROCKET_IMAGE);
			graphic = rocketImage;
			width = 10;
			height = 10;
			super(x, y, graphic, mask);
		}
	}
}