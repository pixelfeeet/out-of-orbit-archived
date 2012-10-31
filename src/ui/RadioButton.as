package ui
{
	import flash.geom.Rectangle;
	import net.flashpunk.graphics.Image;
	
	public class RadioButton extends Checkbox
	{
		internal var group:RadioButtonGroup;
		public var id:String = "";
		
		public function RadioButton(x:Number=0, y:Number=0, group:RadioButtonGroup = null, text:String = "", params:Object = null) 
		{
			super(x, y, text, null, params);
			
			if (group) group.add(this);
			
			normal = new Image(Assets.RADIOBUTTON, new Rectangle(0, 0, 39, 44));
			hover = new Image(Assets.RADIOBUTTON, new Rectangle(39, 0, 39, 44));
			down = new Image(Assets.RADIOBUTTON, new Rectangle(78, 0, 39, 44));
			
			normalChecked = new Image(Assets.RADIOBUTTON, new Rectangle(0, 44, 39, 44));
			hoverChecked = new Image(Assets.RADIOBUTTON, new Rectangle(39, 44, 39, 44));
			downChecked = new Image(Assets.RADIOBUTTON, new Rectangle(78, 44, 39, 44));
			
			graphic = normal;
			setHitboxTo(normal);
		}
		
		override protected function click():void
		{
			group.click(this, params);
		}
		
		override public function removed():void
		{
			super.removed();
			
			group.remove(this);
		}
	}
}