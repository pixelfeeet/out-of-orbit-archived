package
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	
	import utilities.Settings;

	public class Character extends Entity {
		
		protected const GRAVITY:int = 14;
		protected var SPEED:int;
		protected var JUMP:int;
		
		protected var vSpeed:int;
		protected var vGravity:int;
		protected var vJump:int;
		protected var acceleration:Point;
		public var velocity:Point;
		
		protected var health:int;
		protected var maxHealth:int;
		protected var minHealth:int;
		
		protected var hunger:int;
		protected var maxHunger:int;
		protected var minHunger:int;
		
		protected var onGround:Boolean;
		
		protected var damageTimer:int;
		protected var hungerTimer:int;
		
		protected var xSpeed:int;
		protected var ySpeed:int;
		
		protected var isInWater:Boolean;
		
		protected var t:int; //Settings.TILESIZE
		
		protected var gameworld:GameWorld;
		protected var player:Player;
		
		public var lightRadius:int;
		public var facingLeft:Boolean;
		
		public var habitat:String;
		
		public function Character(_position:Point , _health:int = 100, _hunger:int = -1) {
			super();
			
			x = _position.x;
			y = _position.y;
			
			acceleration = new Point();
			velocity = new Point();
			
			vGravity = GRAVITY;
			vSpeed = SPEED;
			vJump = JUMP;

			onGround = false;
			isInWater = false;
			
			habitat = "space";
			
			//ESSENTIALS
			health = _health;
			maxHealth = health;
			minHealth = 0;
			damageTimer = 0;
			
			hunger = _hunger;
			maxHunger = hunger;
			minHunger = 0;
			hungerTimer = 0;
			
			lightRadius = 100;
			
			t = Settings.TILESIZE;	
		}
		
		override public function added():void {
			gameworld = GameWorld(FP.world);
			player = gameworld.player;
		}
		
		override public function update():void {
			updateMovement();
			updateCollision();
			updateGraphic();
			if (health != -1 && player) checkForDamage();
			if (hunger != -1 && player) updateHunger();
			
			super.update();
		}
		
		protected function updateGraphic():void {}
		
		protected function updateCollision():void {

			//HORIZONTAL MOVEMENT
			x += velocity.x * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.x) > 0){
					//moving to the right
					velocity.x = 0;
					
					x = Math.floor(x / t) * t;
					while (!collide("level", x + 1, y)) x++;
				
				} else {
					//moving the left
					velocity.x = 0;
					x = Math.floor(x / t) * t + t;
				}
			}
			
			// VERTICAL MOVEMENT
			y += velocity.y * FP.elapsed;
			
			if(collide("level", x, y)){
				if(FP.sign(velocity.y) > 0){
					//moving down
					calcFallDamage(velocity.y);
					velocity.y = 0;
					y = Math.floor(y / t) * t;
					while (!collide("level", x, y + 1)) y++;
					
					if (!onGround) {
						onGround = true;
						land();
					}
				} else {
					//moving up
					velocity.y = 0;
					y = Math.floor(y / t) * t + t;
					onGround = false;
				}
			}
			
		}
		
		protected function land():void{}
		
		protected function calcFallDamage(_v:int):void { }

		/**
		 * TODO: if hunger is at 100, stay there for a while
		 * and regenerate the players health
		 */
		private function updateHunger():void {
			if (hungerTimer < 60 * 5) hungerTimer++; //5 seconds
			else {
				hungerTimer = 0;
				if (hunger > 0) increaseHunger(1);
				else takeDamage(10);
			}
		}
		
		protected function updateMovement():void{
			if (gameworld.currentLevel.tiles){
				if (gameworld.currentLevel.tiles.getTile(x / t, (y / t) + 1) == gameworld.currentLevel.jungleTiles["water"])
					isInWater = true;
				else isInWater = false;
			}
			
			if (isInWater) {
				vGravity = GRAVITY * 3;
				vSpeed = SPEED * 0.7;
				vJump = JUMP * 0.7;
			} else {
				vGravity = GRAVITY;
				vSpeed = SPEED;
				vJump = JUMP;
			}

			//xSpeed = vSpeed;
			velocity.x = xSpeed;
			if (habitat != "water") {
				acceleration.y = GRAVITY;
				velocity.y += acceleration.y;
			}
		}
		
		protected function checkForDamage():void {
			var bullet:Projectile = collide("bullet", x, y) as Projectile;
			
			if (bullet) {
				bullet.destroy();
				takeDamage(bullet.getDamagePoints());
			}
			
			if (player.meleeAttacking &&
				cLength(new Point(x, y), new Point(player.x, player.y)) < 100 &&
				this.type != "Player") {
				var dist:int = 0;
				if (player.isFacingLeft()) {
					dist = player.x - x;
					if (0 <= dist && dist < 100) takeDamage(player.weapon.getDamage());
				} else {
					dist = x - player.x;
					if (0 <= dist && dist < player.weapon.getRange()) takeDamage(player.weapon.getDamage());
				}
			}
			
		}
		
		//ACTIONS
		protected function jump():void {
			if (onGround){
				velocity.y = -JUMP;
				onGround = false;
			}
		}
		
		//ATTACK
		protected function shoot():void {
			var bullet_speed:int = 100;
			var initPos:Point = new Point(0,0);
			var destination:Point = new Point (x, y);
			var speed:Point = new Point(destination.x - initPos.x, destination.y - initPos.y);
			
			var len:Number = cLength(initPos, destination);
			speed.x = (speed.x / len) * bullet_speed;
			speed.y = (speed.y / len) * bullet_speed;
			FP.world.add(new Projectile(initPos.x, initPos.y, speed.x, speed.y));
		}
		
		protected function increaseHunger(addedHunger:int):void{
			changeHunger(-addedHunger);
			//hunger animation goes here
		}
		
		protected function takeDamage(damage:int):void{
			changeHealth(-damage);
		}
		
		//GETTER FUNCTIONS		
		public function getHealth():int { return health; }
		public function getMaxHealth():int { return maxHealth; }
		public function getHunger():int { return hunger; }
		public function getMaxHunger():int { return maxHunger; }
		
		//SETTER FUNCTIONS
		public function changeHunger(newHunger:int):void {
			if (newHunger > 0) {
				if (hunger < maxHunger && hunger + newHunger <= maxHunger) hunger += newHunger;
				else hunger = maxHunger;
			} else {
				if (hunger > minHunger && hunger + newHunger > minHunger) hunger += newHunger;
				else hunger = minHunger;
			}
		}
		
		public function changeHealth(newHealth:int):void {
			if(newHealth > 0) {
				if (health < maxHealth && health + newHealth <= maxHealth) health += newHealth;
				else health = maxHealth;
			} else {
				if (health > minHealth && health + newHealth > minHealth) health += newHealth;
				else health = minHealth;
			}
		}
		
		protected function cLength(a:Point, b:Point):Number {
			return Math.sqrt(((b.x - a.x) * (b.x - a.x)) + (b.y - a.y) * (b.y - a.y));
		}
		
		public function set position(p:Point):void {
			x = p.x;
			y = p.y;
		}

	}
}