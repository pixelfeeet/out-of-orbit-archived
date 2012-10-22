package {
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import utilities.Settings;
	
	public class SpacemanPlayer extends Character {
		
		public var player_speed:int = PLAYER_SPEED;
		
		private var isCrouched:Boolean;
		private var running:Boolean;
		
		private var standingTorso:Image;
		private var standingLegs:Image;
		private var pbTorso:Image;
		private var head:Image;
		
		private var pb:Image;
		
		private var interactionRadius:Image;
	
		//ESSENTIALS
		
		//STATS
		private var strength:int;
		private var intelligence:int;
		private var dexterity:int;
		private var agility:int;
		
		private var experience:int;
		private var level:int;
		
		private var display:Graphiclist;
		private var legsMap:Spritemap;

		private var bulletFrequency:int;
		private var bulletTimer:int;
		private var bulletSource:Point;
		
		//INVENTORY
		public static var inventory:Inventory;
		public static var weaponInventory:WeaponInventory;
		public var reachDistance:int;
		public var inventoryLength:int;
		public var weaponInventoryLength:int;
		
		//SOUNDS
		public var landSound:Sfx;
		public var injurySound:Sfx;
		public var jumpSound:Sfx;
		public var shootSound:Sfx;
		public var walkSound:Sfx;
		
		public function SpacemanPlayer(_position:Point = null) {
			if (!_position) _position = new Point(0, 0);
			x = _position.x;
			y = _position.y;
			
			PLAYER_SPEED = 240;
			player_speed = PLAYER_SPEED;
			JUMP = 580;
			
			health = 100;
			hunger = 100;
			
			bulletFrequency = 10;
			bulletTimer = 0;
			
			//Legs
			legsMap = new Spritemap(Assets.LEGS_MAP, 42, 34)
			legsMap.add("running", [0, 1, 2, 3, 4], 18);
			legsMap.add("backwards_running", [4, 3, 2, 1, 0], 18);
			legsMap.add("standing", [0]);
			legsMap.add("jumping", [5]);
			legsMap.y = (Settings.TILESIZE * 2) - legsMap.height + 2;
			
			//Torso
			pbTorso = new Image(Assets.TORSO);
			pbTorso.originX = 5;
			pbTorso.originY = pbTorso.height - 10;
			pbTorso.x = 12;
			pbTorso.y = 57;
			
			//Head
			head = new Image(Assets.HEAD);
			head.originX = 12;
			head.originY = 12;
			head.x = 26;
			head.y = 14;
			
			//PB - Weapon
			pb = new Image(Assets.PB);
			pb.originX = 15;
			pb.originY = pb.height / 2;
			pb.x = 32;
			pb.y = 34;
			
			display = new Graphiclist(pb, legsMap, pbTorso, head);
			graphic = display;
			
			Input.define("Jump", Key.W);
			Input.define("Crouch", Key.S)
			Input.define("Use", Key.E);
			
			this.setHitbox(Settings.TILESIZE, Settings.TILESIZE * 2, 0, 0);
			isCrouched = false;
			running = false;
			
			animations = new Animations();
			
			inventoryLength = 14;
			inventory = new Inventory(inventoryLength);
			weaponInventoryLength = 2;
			weaponInventory = new WeaponInventory(weaponInventoryLength);
			reachDistance = 100;
			
			experience = 0;
			level = 5;
			
			//Sound
			landSound = new Sfx(Assets.LAND);
			injurySound = new Sfx(Assets.INJURY);
			jumpSound = new Sfx(Assets.JUMP);
			shootSound = new Sfx(Assets.SHOOT);
			walkSound = new Sfx(Assets.BLIP);
			
			super(_position, health, hunger);

		}
		
		override public function update():void {
			
			updateGraphic();
			updateMovement();
			shoot();
			debug();
			checkForEnemyCollision();
				
			if (damageTimer > 0) damageTimer--;
			if (bulletTimer > 0) bulletTimer--;

			if (Input.pressed("Use")){
				onUse();
			}
			super.update();
		}
		
		private function onUse():void {
			for (var i:int = 0; i < HUD.inventoryBoxes.length; i++){
				if (HUD.inventoryBoxes[i].isSelected()) {
					trace("#" + i + " is selected");
					if (inventory.inventory[i] != null) inventory.inventory[i].onUse();
					else trace("nothing to use");
					return;
				}
			}
			trace("no selected things");
		}
		
		protected function checkForEnemyCollision():void {
			var enemy:Enemy = collide("enemy", x, y) as Enemy;
			if (enemy) getHurt(10);
		}
		
		override protected function shoot():void {
			if (Input.mouseDown && !Input.check(Key.SHIFT) && bulletTimer == 0) {
				var bullet_speed:int = 1000;
				var initX:int;
				var initY:int;
				if (facingLeft) {
					initX = x + pb.x;
					initY = y + pb.y;
				} else {
					initX = x + pb.x;
					initY = y + pb.y;
				}
				//initY = y + halfHeight - 20;
				var initPos:Point = new Point(initX, initY);
				var destination:Point = new Point(Input.mouseX + FP.camera.x - 10, Input.mouseY + FP.camera.y - 10);
				var speed:Point = new Point(destination.x - initPos.x, destination.y - initPos.y);
				
				var len:Number = cLength(initPos, destination);
				speed.x = (speed.x / len) * bullet_speed;
				speed.y = (speed.y / len) * bullet_speed;
				
				//Add projectile to world; determine init position
				var p:Projectile = new Projectile(initPos.x, initPos.y, speed.x, speed.y);
				if (facingLeft) FP.angleXY(p, pb.angle, -pb.width, initPos.x, initPos.y);
				else FP.angleXY(p, pb.angle, pb.width, initPos.x, initPos.y);
				
				FP.world.add(p);
				shootSound.play();
				bulletTimer = bulletFrequency;
			}
		}

		private function updateGraphic():void {
			
			//Get the player to face the horizontal direction as the cursor
			if (Input.mouseX < x + halfWidth - FP.camera.x) facingLeft = true;
			else facingLeft = false;
			
			//Play the animation
			if (!onGround){
				legsMap.play("jumping");
			} else if (FP.sign(velocity.x) != 0) {
				if (!facingLeft) {
					if (FP.sign(velocity.x) == 1) legsMap.play("running");
					else legsMap.play("backwards_running");
				} else {
					if (FP.sign(velocity.x) == -1) legsMap.play("running");
					else legsMap.play("backwards_running");
				}
				//if(legsMap.frame == 1) walkSound.play();
			} else {
				legsMap.play("standing");
			}
			
			//Calculating angles of head and weapon
			if (facingLeft) { 
				for (var i:int = 0; i < display.count; i++) {
					Image(display.children[i]).flipped = true;
				}
				head.originX = 12;
				head.originY = 12;
				head.x = 18;

				pb.originX = pb.width - 15;
				pb.x = 12;
			} else {
				for (var j:int = 0; j < display.count; j++) {
					Image(display.children[j]).flipped = false;
				}
				head.originX = 12;
				head.originY = 12;
				head.x = 24;
				
				pb.originX = 15;
				pb.x = 35;
			}
			
			pbTorso.originX = 22;
			pbTorso.x = 22;

			var angle:Number = FP.angle(Math.abs(FP.camera.x - x), Math.abs(FP.camera.y - y), Input.mouseX, Input.mouseY - 30);
			
			var f:Boolean = Image(display.children[3]).flipped;
			if(f) angle -= 180;
			if(angle > 180) angle += 360;
			
			var headAngle:Number = angle;
			headAngle /= 2;
			trace(angle);
			//player is bending down too low
			if (f && headAngle < -15) headAngle = -15;
			else if (!f && 270 <= headAngle && headAngle < 350) headAngle = 350;
			
			//player is bending back too much
			if (f && headAngle > 15) headAngle = 15;
			else if (!f && headAngle > 15 && headAngle < 90) headAngle = 15;
			

			Image(display.children[3]).angle = headAngle; //HEAD
			Image(display.children[0]).angle = angle; //PB
			
		}
			
		override protected function updateMovement():void {
			
			super.updateMovement();
			
			var xInput:int = 0;
			var yInput:int = 0;
			
			//CHECK PLAYER INPUT
			
			//WSAD: MOVEMENT
			if (Input.check(Key.A)) {
				xInput -= 1;
				if(!Input.check(Key.D)) running = true;
			} else {
				running = false;
			}
			if (Input.check(Key.D)) {
				xInput += 1;
				if(!Input.check(Key.A)) running = true;
			} else {
				if (!running) {
					running = false;
				}
			}
			
			if (Input.pressed(Key.D) || Input.pressed(Key.A)) {

			}
			
			if (Input.pressed("Jump")) {
				jump();
			}
			
			velocity.x = player_speed * xInput;

		}
		
		override protected function land():void {
			
			if(!onGround){
				calcFallDamage(velocity.y);
				onGround = true;
			}
		}
		
		private function debug():void {
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
			
			//DEBUG: remove last item from inventory
			if (Input.pressed(Key.DIGIT_1)) {
				inventory.removeLastItemFromInventory();
			}
			
			//DEBUG: addItemToInventory
			if (Input.pressed(Key.DIGIT_2)) {
				inventory.addItemToInventory();
			}
			
		}
		
		override protected function jump():void {
			if (onGround){
				velocity.y = -JUMP;
				onGround = false;
				jumpSound.play();
			}
		}
		
		//tentative idea: getHurt includes enemy-inflicted damage-
		//specific animations, takeDamage displays only the default,
		//i.e. red flash.
		private function getHurt(damage:int):void{
			trace("player hit!");
			if (damageTimer == 0) {
				takeDamage(10);
				injurySound.play();
				damageTimer = 60;
			}
			//Jump up
		}
		
		override protected function calcFallDamage(_v:int):void {
			var damageVelocity:int = 700;
			var totalDamage:int = 0;
			if (_v - damageVelocity > 0 ) {
				_v-= damageVelocity;
				while(_v > 0) {
					totalDamage += 5;
					_v -= 50;
				}
			}
			if (totalDamage != 0) getHurt(totalDamage);
			velocity.y = 0;
		}
		
		//INVENTORY
		public function getInventory():Inventory {
			return inventory;
		}
		
		public function getWeaponInventory():WeaponInventory {
			return weaponInventory;
		}
		
		//EXPERIENCE
		public function gainExperience(_exp:int):void {
			experience += _exp;
			checkForLevelUp();
		}
		
		private function checkForLevelUp():void {
			if (experience % 20 == 0) levelUp();
		}
		
		private function levelUp():void {
			level++;
		}
		
		public function getPlayerExperience():int {
			return experience;
		}
		
		public function getLevel():int {
			return level;
		}
	}
}