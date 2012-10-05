package {
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class InteractionRadius extends Entity {
		[Embed(source = 'assets/interaction_radius.png')] private const INTERACTION_RADIUS:Class;
		
		private var interactionRadiusImg:Image;
		private var thePlayer:SpacemanPlayer;
		public function InteractionRadius(player:SpacemanPlayer) {
			interactionRadiusImg = new Image(INTERACTION_RADIUS);
			thePlayer = player;
			graphic = interactionRadiusImg;
			Image(graphic).alpha = 0.5;
			layer = 1;
		}
		
		override public function update():void {
			x = thePlayer.x + (thePlayer.width / 2) - (Image(graphic).width / 2);
			y = thePlayer.y + (thePlayer.height / 2) -  (Image(graphic).height / 2) - 20;
		}
	}
}