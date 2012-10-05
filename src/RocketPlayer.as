package {
	
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class RocketPlayer extends Entity {
		
		protected const PLAYER_SPEED:Number = 2.4;

		private var player_speed:int = PLAYER_SPEED;
		private var acceleration:Point;
		public var velocity:Point;
		
		private var newY:int;
		
		private var onGround:Boolean;
		private var isCrouched:Boolean;
		private var running:Boolean;
		
		private var standingImg:Image;
		private var runningImg:Image;
		private var jumpingImg:Image;
		private var crouchingImg:Image;
		
		private var interactionRadius:InteractionRadius;
		//ESSENTIALS
		private var health:int;
		private var maxHealth:int;
		private var minHealth:int;
		
		private var hunger:int;
		private var maxHunger:int;
		private var minHunger:int;
		
		private var inventory:Array;
		
		//STATS
		private var strength:int;
		private var intelligence:int;
		private var dexterity:int;
		private var agility:int;
	
		private var hungerTimer:int;
		
		[Embed(source = 'assets/rocket.png')] private const ROCKET:Class;
		
		public function RocketPlayer(position:Point) {
			x = position.x;
			y = position.y;
			
			standingImg = new Image(ROCKET);
			
			graphic = standingImg;
			
			Input.define("Jump", Key.SPACE, Key.W);
			Input.define("Crouch", Key.S)
				
			acceleration = new Point();
			velocity = new Point();
			
			Image(graphic).centerOrigin();
			verticalHitbox();
			
			onGround = false;
			running = false;
			
			//ESSENTIALS
			health = 100;
			maxHealth = 100;
			minHealth = 0;
			
			hunger = 100;
			maxHunger = 100;
			minHunger = 0;
			
			hungerTimer = 0;
			interactionRadius = new InteractionRadius();
			add(interactionRadius);
		}
		
		override public function update():void {
			
			updateGraphic();
			updateMovement();
			updateCollision();
			updateHunger();
			
			interactionRadius.x = x;
			interactionRadius.y = y;
			
			//UPDATE PARENT
			super.update();
		}
		
		private function updateHunger():void {
			if (hungerTimer < 60) {
				hungerTimer++;
			} else {
				hungerTimer = 0;
				if (hunger > 0) increaseHunger(1);
				else takeDamage(10);
			}

		}
		
		private function updateGraphic():void {
			
		}
		
		private function verticalHitbox():void {
			setHitbox(Image(graphic).width, Image(graphic).height, Image(graphic).width / 2, Image(graphic).height / 2);
		}
		
		private function horizontalHitbox():void {
			setHitbox(Image(graphic).height, Image(graphic).width, Image(graphic).height / 2, Image(graphic).width / 2);
		}
		
		private function updateMovement():void {
			var xInput:int = 0;
			var yInput:int = 0;
			
			//CHECK PLAYER INPUT
			
			if (Input.check(Key.W)) {
				Image(graphic).angle = 0;
				yInput -= 1;
				//verticalHitbox();
			}
			if (Input.check(Key.S)) {
				Image(graphic).angle = 0;
				Image(graphic).angle = 180;
				yInput += 1;
				//verticalHitbox();
			}
			if (Input.check(Key.A)) {
				xInput -= 1;
				Image(graphic).angle = 0;
				//horizontalHitbox();
				
				//Check for other keys pressed
				if(Input.check(Key.W)) Image(graphic).angle = 45;
				else if (Input.check(Key.S)) Image(graphic).angle = 125;
				else Image(graphic).angle = 90;
			}
			if (Input.check(Key.D)) {
				xInput += 1;
				Image(graphic).angle = 0;
				//horizontalHitbox();
				
				//Check for other keys pressed
				if(Input.check(Key.W)) Image(graphic).angle = -45;
				else if (Input.check(Key.S)) Image(graphic).angle = -125;
				else Image(graphic).angle = -90;
			}
			
			//DEBUG: increase hunger
			if (Input.pressed(Key.U)) {
				changeHunger(-10);
			}			
			//DEBUG: decrease hunger
			if (Input.pressed(Key.Y)) {
				changeHunger(10);
			}
			//DEBUG: take damage
			if (Input.pressed(Key.J)) {
				changeHealth(-10);
			}
			
			//DEBUG: heal
			if (Input.pressed(Key.H)) {
				changeHealth(10);
			}
			
			//UPDATE PHYSICS
			velocity.x += player_speed * xInput;
			velocity.y += player_speed * yInput;
			
			//APPLY PHYSICS
		}
		
		private function updateCollision():void {

			//HORIZONTAL MOVEMENT
			x += velocity.x * FP.elapsed;
		
			if(collide("level", x, y)){
				if(FP.sign(velocity.x) > 0){
					//moving to the right
					velocity.x = 0;
					
					x = Math.floor(x/32) * 32;
					trace(width);
				} else {
					//moving the left
					velocity.x = 0;
					x = Math.floor(x/32) * 32 + 32;
				}
			}
			
			// VERTICAL MOVEMENT
			y += velocity.y * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.y) > 0){
					//moving down
					velocity.y = 0;
					y = Math.floor(y / 32) * 32 + (32 / 2);
					onGround = true;
				} else {
					//moving up
					velocity.y = 0;
					y = Math.floor(y / 32) * 32 + (32 / 2);
					onGround = false;
				}
			}
			
		}
		
		private function takeDamage(damage:int):void{
			changeHealth(-damage);
			//Damage animation logic goes here
		}
		
		private function increaseHunger(addedHunger:int):void{
			changeHunger(-addedHunger);
			//hunger animation goes here.
		}
		
		//GETTER FUNCTIONS
		public function getVelocity():Point {
			return velocity;
		}
		
		public function getHealth():int {
			return health;
		}
		
		public function getHunger():int {
			return hunger;
		}
		
		//SETTER FUNCTIONS
		public function changeHealth(newHealth:int):void {
			if(newHealth > 0) {
				if (health < maxHealth && health + newHealth <= maxHealth) health += newHealth;
				else health = maxHealth;
			} else {
				if (health > minHealth && health + newHealth > minHealth) health += newHealth;
				else health = minHealth;
			}
		}
		
		public function changeHunger(newHunger:int):void {
			if (newHunger > 0) {
				if (hunger < maxHunger && hunger + newHunger <= maxHunger) hunger += newHunger;
				else hunger = maxHunger;
			} else {
				if (hunger > minHunger && hunger + newHunger > minHunger) hunger += newHunger;
				else hunger = minHunger;
			}
		}
	}
}