package {
	
	import Inventory.Inventory;
	
	import NPCs.Enemy;
	
	import Weapons.Weapon;
	
	import data.Weapons;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import ui.HUD;
	
	import utilities.Settings;
	
	public class Player extends Character {

		private var running:Boolean;
		
		private var standingTorso:Image;
		private var standingLegs:Image;
		private var torso:Image;
		private var head:Image;
		private var weaponImg:Image;
		
		private var display:Graphiclist;
		private var legsMap:Spritemap;
		
		private var speech:Text;
		private var speechTimer:int;
		private var speechLength:int;
		
		private var informedHunger:Boolean;
		private var informedExtremeHunger:Boolean;
		private var informedHealth:Boolean;
		private var informedExtremeHealth:Boolean;
		private var informedLevelUp:Boolean;
		
		public var jetFuel:int;
		private var fuelCapacity:int;
		
		private var jetRecharge:int;
		private var jetRechargeTimer:int;
		public var jetBurnedOut:Boolean; //When fuel hits 0
		
		//Stats		
		public var statsList:Array;
		
		private var experience:int;
		private var level:int;

		//Level		
		public var allocationPoints:int;
		public var levelUpTime:Boolean;
		
		//debug movement
		private var debugFlying:Boolean;
		//other movement
		private var jetpacking:Boolean;

		//Inventory
		public static var inventory:Inventory;
		public var reachDistance:int;
		public var inventoryLength:int;
		public var weaponInventoryLength:int;
		
		//tentitive currency name
		public var scraps:int;
		
		//Exchange rate
		public var constructionRate:Number;
		public var recycleRate:Number;
		
		//Combat/Weapons
		private var bulletFrequency:int;
		private var bulletTimer:int;
		private var bulletSource:Point;

		public var equipped:Boolean;
		public var weapon:Weapon;
		public var ammunition:int;
		public var weapons:Weapons;
		public var meleeAttacking:Boolean;
		
		//Sounds
		public var landSound:Sfx;
		public var injurySound:Sfx;
		public var jumpSound:Sfx;
		public var shootSound:Sfx;
		public var walkSound:Sfx;
		
		private var gameworld:GameWorld;

		public function Player(_position:Point = null) {
			
			if (!_position) _position = new Point(0, 0);
			
			super(_position, health, hunger);
			
			type = "Player";
			
			SPEED = 400;
			vSpeed = SPEED;
			JUMP = 580;
			
			fuelCapacity = 100;
			jetFuel = fuelCapacity;
			jetRecharge = 5;
			jetRechargeTimer = jetRecharge; 
			jetBurnedOut = false;
				
			/**
			 * Stats
			 */
			maxHealth = 100;
			maxHunger = 100;
			health = 100;
			hunger = 100;
			
			statsList = [
				{"name": "Fuel Capacity", "value": fuelCapacity, "points": 3},
				{"name": "Armor", "value": 10, "points": 3},
				{"name": "Max Ammo", "value": null, "points": 2},
				{"name": "Jump Height", "value": null, "points": 3},
				{"name": "Construction Skill", "value": null, "points": 2},
				{"name": "Inventory Capacity", "value": null, "points": 8},
				{"name": "Fuel Capacity", "value": null, "points": 3}
			];
			
			/**
			 * Graphiclist components
			 */
			//Weapons/Combat
			weapons = new Weapons(this);
			weapon = weapons.unarmed;
			meleeAttacking = false;
			
			bulletFrequency = 10;
			bulletTimer = 0;

			equipWeapon(weapon);
			FP.world.add(weapon);
			
			//Legs
			legsMap = new Spritemap(Assets.LEGS_MAP, 42, 34)
			legsMap.add("running", [0, 1, 2, 3, 4], 18);
			legsMap.add("backwards_running", [4, 3, 2, 1, 0], 18);
			legsMap.add("standing", [0]);
			legsMap.add("jumping", [5]);
			legsMap.y = (Settings.TILESIZE * 2) - legsMap.height + 2;
			
			//Torso
			torso = new Image(Assets.TORSO);
			torso.originX = 5;
			torso.originY = torso.height - 10;
			torso.x = 12;
			torso.y = 57;
			
			//Head
			head = new Image(Assets.HEAD);
			head.originX = 12;
			head.originY = 12;
			head.x = 26;
			head.y = 14;
			
			speech = new Text("");
			speech.x = x + torso.width;
			speech.y = y - 10;
			speechLength = 60;
			speechTimer = 0;
			informedHunger = false;
			informedExtremeHunger = false;
			informedHealth = false;
			informedExtremeHealth = false;
			
			display = new Graphiclist(weaponImg, legsMap, torso, head, speech);
			graphic = display;
			
			this.setHitbox(Settings.TILESIZE, Settings.TILESIZE * 2, 0, 0);
			running = false;
			
			debugFlying = true;
			jetpacking = false;
			
			//Input Definitions
			Input.define("Left", Key.A);
			Input.define("Right", Key.D);
			Input.define("Jump", Key.W);
			Input.define("Use", Key.E);
			Input.define("Toggle Flying", Key.T);
			
			//Inventory
			inventoryLength = 7;
			inventory = new Inventory(inventoryLength);
			reachDistance = 100;
			scraps = 0;
			
			//Stats
			experience = 0;
			level = 5;
			levelUpTime = true;
			allocationPoints = 10;
			
			//Exchange rate
			constructionRate = 1.1;
			recycleRate = 0.9;
			
			//Sound
			landSound = new Sfx(Assets.LAND);
			injurySound = new Sfx(Assets.INJURY);
			jumpSound = new Sfx(Assets.BUMP);
			shootSound = new Sfx(Assets.SHOOT);
			walkSound = new Sfx(Assets.BLIP);
			
			layer = -500
		}
		
		override public function added():void { gameworld = GameWorld(FP.world); }
		
		override public function update():void {
			super.update();

			if (!debugFlying) updateMovement();
			else debugMovement();
			
			updateGraphic();
			debug();
			checkForEnemyCollision();
			inventoryButtons();
			updateSpeech();
			
			//combat
			shoot();
			weapon.update();
			if (damageTimer > 0) damageTimer--;

			//Interaction
			if (Input.pressed("Use")) onUse();
			if (Input.pressed("Toggle Flying")) toggleFlying();
		}
		
		private function updateSpeech():void {
			if (speechTimer > 0) speechTimer--;
			if (speechTimer <= 0 && speech.text != "") onFinishedSpeech();
		}
		
		private function setSpeech(str:String):void {
			speech.text = str;
			speechTimer = speechLength;
		}
		
		private function onFinishedSpeech():void { speech.text = ""; }
		
		override protected function updateCollision():void {
			if (!debugFlying) super.updateCollision();
			else {
				x += velocity.x * FP.elapsed;
				y += velocity.y * FP.elapsed;
			}
		}
		
		public function inventoryButtons():void {
			var boxes:Array = gameworld.hud.inventoryBoxes;
			var keys:Array = [Key.DIGIT_1, Key.DIGIT_2, Key.DIGIT_3, Key.DIGIT_4, Key.DIGIT_5, Key.DIGIT_6, Key.DIGIT_7]
			for (var i:int = 0; i < keys.length; i++)
				if (Input.pressed(keys[i])) {
					gameworld.hud.deselectAll();
					gameworld.hud.inventoryBoxes[i]["box"].select();
				}
		}
		
		public function equipWeapon(_weapon:Weapon):void {
			weapon = _weapon;
			setWeaponGfx(weapon);
		}
		
		public function setWeaponGfx(_weapon:Weapon):void{
			weaponImg = Image(_weapon.graphic)
			
			if (!facingLeft) weaponImg.originX = _weapon.originX;
			else weaponImg.originX = _weapon.leftOriginX;
			weaponImg.originY = _weapon.originY;
			
			if (!facingLeft) weaponImg.x = _weapon.x;
			else weaponImg.x = _weapon.leftX;
			weaponImg.y = _weapon.y;
			
			if (display) display.children[0] = weaponImg;
		}
		
		private function onUse():void {
			for (var i:int = 0; i < gameworld.hud.inventoryBoxes.length; i++){
				if (gameworld.hud.inventoryBoxes[i]["box"].isSelected()) {
					if (inventory.items[i].length > 0)
						inventory.items[i][inventory.items[i].length - 1].onUse();
					return;
				}
			}
		}
		
		private function toggleFlying():void {
			if (!debugFlying) {
				debugFlying = true;
				velocity.x = 0;
				velocity.y = 0;
				xSpeed = 0;
				vSpeed = 840;
			} else {
				debugFlying = false;
				vSpeed = 400;
			}
		}
		
		protected function checkForEnemyCollision():void {
			var enemy:Enemy = collide("enemy", x, y) as Enemy;
			if (enemy) getHurt(10);
		}
		
		override protected function shoot():void { 
			if (weapon.fireTimer > 0) weapon.fireTimer--;
			if (Input.mouseDown) weapon.shoot();
		}

		override protected function updateGraphic():void {
			
			//Get the player to face the cursor horizontally
			if (Input.mouseX < x + halfWidth - FP.camera.x) facingLeft = true;
			else facingLeft = false;
			
			//Calculating angles of head and weapon
			if (facingLeft) { 
				for (var i:int = 0; i < display.count; i++)
					if (i != display.count - 1) // don't flip speech bubble
						Image(display.children[i]).flipped = true;
				head.originX = 12;
				head.originY = 12;
				head.x = 18;

				weaponImg.originX = weaponImg.width - weapon.leftOriginX;
				weaponImg.x = weapon.leftX;
			} else {
				for (var j:int = 0; j < display.count; j++)
					Image(display.children[j]).flipped = false;
				head.originX = 12;
				head.originY = 12;
				head.x = 24;
				
				weaponImg.originX = weapon.originX;
				weaponImg.x = weapon.x;
			}
			
			//Play the animation
			if (!onGround || isInWater) legsMap.play("jumping");
			else if (FP.sign(velocity.x) != 0) {
				if (!facingLeft) {
					if (FP.sign(velocity.x) == 1) legsMap.play("running");
					else legsMap.play("backwards_running");
				} else {
					if (FP.sign(velocity.x) == -1) legsMap.play("running");
					else legsMap.play("backwards_running");
				}
			} else legsMap.play("standing");
			
			torso.originX = 22;
			torso.x = 22;

			var angle:Number = FP.angle(Math.abs(FP.camera.x - x), Math.abs(FP.camera.y - y), Input.mouseX, Input.mouseY - 30);
			
			var f:Boolean = Image(display.children[3]).flipped;
			if(f) angle -= 180;
			if(angle > 180) angle += 360;
			
			var headAngle:Number = angle;
			headAngle /= 2;
			
			//player is bending down too low
			if (f && headAngle < -15) headAngle = -15;
			else if (!f && 270 <= headAngle && headAngle < 350) headAngle = 350;
			
			//player is bending back too much
			if (f && headAngle > 15) headAngle = 15;
			else if (!f && headAngle > 15 && headAngle < 90) headAngle = 15;

			Image(display.children[0]).angle = angle; //PB
			Image(display.children[3]).angle = headAngle; //HEAD
		}
			
		override protected function updateMovement():void {
			if (!debugFlying) super.updateMovement();
			var xInput:int = 0;
			var yInput:int = 0;2
			//WSAD: MOVEMENT
			if (Input.check("Left")) {
				xInput -= 1;
				if(!Input.check("Right")) running = true;
			} else running = false;
			
			if (Input.check("Right")) {
				xInput += 1;
				if(!Input.check("Left")) running = true;
			} else running = false;
			
			//Check if player is in water
			if (isInWater) {
				setSpeech("I can't swim.")
				//DEBUG MOVEMENT
				if (Input.check(Key.W)) yInput -= 1;
				if (Input.check(Key.S)) yInput += 1;
				
				velocity.y = (vSpeed * yInput) + vGravity;
			} else {
				jump();
				if (!debugFlying) vSpeed = SPEED;
				else vSpeed = SPEED * 2
				acceleration.y = GRAVITY;
			}
			velocity.x = vSpeed * xInput;
		}
		
		private function debugMovement():void {
			
			var xInput:int = 0;
			var yInput:int = 0;
			
			//WSAD: MOVEMENT
			if (Input.check("Left")) {
				xInput -= 1;
				if(!Input.check("Right")) running = true;
			} else running = false;
			if (Input.check("Right")) {
				xInput += 1;
				if(!Input.check("Left")) running = true;
			} else running = false;
			
			//DEBUG MOVEMENT
			if (Input.check(Key.W)) yInput -= 1;
			if (Input.check(Key.S)) yInput += 1;
			
			velocity.y = vSpeed * yInput; //This isn't normally here
			velocity.x = vSpeed * xInput;
		}
		
		override protected function land():void {
			if (!onGround) {
				calcFallDamage(velocity.y);
				onGround = true;
			}
		}
		
		private function debug():void {
			if (Input.pressed(Key.U)) changeHunger(-10);
			if (Input.pressed(Key.Y)) changeHunger(10);
			if (Input.pressed(Key.J)) changeHealth(-10);
			if (Input.pressed(Key.H)) changeHealth(10);
			if (Input.pressed(Key.M)) scraps += 100;
		}
		
		override protected function jump():void {
			if (Input.check("Jump")) {
				if (Input.check(Key.SHIFT)) {
					if (!jetBurnedOut) {
						jetpacking = true;
						jetFuel--;
						velocity.y = -JUMP;
					}
				} else {
					if (onGround){
						velocity.y = -JUMP;
						onGround = false;
						jumpSound.play();
					}
				}
			}
			if (jetpacking) {
				if (jetRechargeTimer <= 0) { 
					if (jetFuel < fuelCapacity) jetFuel++;
					jetRechargeTimer = jetRecharge;
				} else jetRechargeTimer--;
			}
			
			if (jetFuel <= 0) jetBurnedOut = true;
			else if (jetFuel == 100) jetBurnedOut = false;
		}
		
		//tentative idea: getHurt includes enemy-inflicted damage-
		//specific animations, takeDamage displays only the default,
		//i.e. red flash.
		private function getHurt(damage:int):void{
			if (damageTimer == 0) {
				takeDamage(10);
				injurySound.play();
				damageTimer = 60;
			}
			//TODO: animation
		}
		
		override public function changeHealth(h:int):void {
			super.changeHealth(h);
			
			if (health <= 30 && !informedHealth) {
				setSpeech("My health is low.")
				informedHealth = true;
			}
			
			if (health <= 10 && !informedExtremeHealth) {
				setSpeech("I'm dying.")
				informedExtremeHealth = true;
			}
			
			if (health > 30) informedHealth = false;
			if (health > 10) informedExtremeHealth = false;
		}
		
		override public function changeHunger(h:int):void {
			super.changeHunger(h);
			if (hunger <= 30 && !informedHunger) {
				setSpeech("I'm getting very hungry.")
				informedHunger = true;
			}
			
			if (hunger <= 10 && !informedExtremeHunger) {
				setSpeech("I'm extremely hungry.")
				informedExtremeHunger = true;
			}
			
			if (hunger > 30) informedHunger = false;
			if (hunger > 10) informedExtremeHunger = false;
		}
		
		override protected function calcFallDamage(_v:int):void {
			var damageVelocity:int = 700;
			var totalDamage:int = 0;
			if (_v - damageVelocity > 0 ) {
				_v -= damageVelocity;
				while(_v > 0) {
					totalDamage += 5;
					_v -= 50;
				}
			}
			if (totalDamage != 0) getHurt(totalDamage);
			velocity.y = 0;
		}
		
		//INVENTORY
		public function getInventory():Inventory { return inventory; }

		//EXPERIENCE
		public function gainExperience(_exp:int):void {
			experience += _exp;
			gameworld.hud.expText(_exp);
			checkForLevelUp();
		}
		
		private function checkForLevelUp():void {
			//checking logic goes here!
			levelUp();
		}
		
		private function levelUp():void {
			setSpeech("Level up!")
			level++;
			allocationPoints += 5;
			levelUpTime = true;
		}
		
		//Getter functions
		public function getPlayerExperience():int { return experience; }
		public function getLevel():int { return level; }
		public function getExperience():int { return experience; }
		public function isFacingLeft():Boolean { return facingLeft; }
		
	}
}