package NPCs {
	import flash.geom.Point;
	import flash.utils.getDefinitionByName;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	
	public class NPC extends Character {

		public var behavior:Function;
		public var dropItems:Array;
		public var expValue:int;
		public var label:String;
		public var attackRange:int;
		public var viewDistance:int;
		
		protected var movementTimer:int;
		public var movementFrequency:int;
		
		public var destroyed:Sfx;
		
		protected var spriteMap:Spritemap;
		
		public function NPC(_position:Point = null, _health:int=100, _hunger:int=-1) {
			if(!_position) _position = new Point(0,0);
			super(_position, _health, _hunger);
			SPEED = 50;
			JUMP = 300;
			dropItems = generateDropItems();
			expValue = 2;
			viewDistance = 5;
			
			health = 40;
			hunger = _hunger;
			label = "NPC";
			habitat = "ground";
			
			movementFrequency = 100;
			movementTimer = movementFrequency;
			
			graphic = Image.createRect(30, 30, 0xffaa88, 0.5);
			setHitboxTo(graphic);
			behavior = function():void {}
			
			//Sounds
			destroyed = new Sfx(Assets.ENEMY_DESTROY);
		}
		
		override public function added():void {
			super.added();
			initBehavior();
		}
		
		override public function update():void {
			behavior();
			super.update();
		}
		
		protected function initBehavior():void {
			if (habitat == "ground") behavior = groundMovement;
			else if (habitat == "water") behavior = waterMovement;
			else if (habitat == "sky") behavior = skyMovement;
		}
		
		protected function generateDropItems():Array{
			var f:InteractionItem = GameWorld(FP.world).interactionItems.food;
			return [f];
		}
		
		override protected function takeDamage(damage:int):void {
			super.takeDamage(damage);
			if (health <= 0) destroy();
		}
		
		public function setMovementFrequency(n:int):void {
			movementFrequency = n;
			movementTimer = movementFrequency;
		}
		
		public function destroy():void {
			//Generate drop items
			for (var i:int = 0; i < dropItems.length; i++){
				if (dropItems[i].type == "InteractionItem") {
					var item:InteractionItem = new InteractionItem();
					item.getPropertiesFrom(dropItems[i], new Point(x + ((i + 1) * 10), y + i));
					FP.world.add(item);
				} else {
					var myClass:Class = getDefinitionByName(dropItems[i].toString()) as Class;

					var anItem:Entity = new myClass();
					var p:Point = new Point(x + ((i + 1) * 10), y + i);
					anItem.x = p.x;
					anItem.y = p.y;
					
					FP.world.add(anItem);
				}
			}
			GameWorld(FP.world).player.gainExperience(expValue);
			destroyed.play();
			FP.world.remove(this);
		}
		
		protected function groundMovement():void {
			if (xSpeed != 0 && velocity.x == 0) jump();
			
			if (movementTimer == 0) {
				if (FP.sign(xSpeed) != 0) {
					idleMovement();
					movementTimer = movementFrequency * Math.ceil(Math.random() * 5);
				} else {
					var r:Number = Math.random() * 2;
					if (r < 1) xSpeed = -vSpeed;
					else xSpeed = vSpeed;
					movementTimer = Math.ceil(Math.random() * 50) + 50;
				}
			} else movementTimer--;
		}
		
		/**
		 * TODO:
		 * 1. Improve direction finding algorithm -- i.e, don't choose
		 * to go in a direction the NPC can't go, like into a wall
		 */
		protected function waterMovement():void {
			if (movementTimer == 0) {
				stopMoving();
				var r:int = Math.floor(FP.random * 5);
				if (r == 0) xSpeed = -vSpeed;
				else if (r == 1) xSpeed = vSpeed;
				else if (r == 2) ySpeed = -vSpeed;
				else if (r == 3) ySpeed = vSpeed;
				else if (r == 4) idleMovement();
				movementTimer = Math.ceil(Math.random() * 50) + 50;				
			} else movementTimer--;
			
			dontLeaveWater();
		}
		
		protected function dontLeaveWater():void {
			if (FP.sign(ySpeed) < 0) {
				if (gameworld.currentLevel.tiles.getTile(x / t, (y / t) - t) == gameworld.currentLevel.jungleTiles["water"])
					velocity.y = 0;
			} else velocity.y = ySpeed;	
		}
		
		protected function skyMovement():void {}

		protected function stopMoving():void {
			xSpeed = 0;
			ySpeed = 0;
		}
		
		protected function idleMovement():void {
			stopMoving();
			vSpeed = 0;
		}
		
		protected function attack():void {}
		
		public function randomRange(max:Number, min:Number = 0):Number {
			return Math.random() * (max - min) + min;
		}

	}
}