package {
	
	import Inventory.Inventory;
	
	import NPCs.Enemy;
	
	import Weapons.Weapon;
	
	import Weapons.Weapons;
	
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
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import ui.HUD;
	
	import utilities.Settings;
	import Levels.Level;
	
	public class Player extends Character {

		private var standingTorso:Image;
		private var standingLegs:Image;
		private var torso:Image;
		private var head:Image;
		private var weaponImg:Image;
		
		public var display:Graphiclist;
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
		
		//Movement
		private var movementState:String;

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
		
		public var angle:Number;
		
		//Sounds
		public var landSound:Sfx;
		public var injurySound:Sfx;
		public var jumpSound:Sfx;
		public var shootSound:Sfx;
		public var walkSound:Sfx;
		
		private var gameworld:GameWorld;
		private var xInput:int;
		private var yInput:int;
		private var debugFlying:Boolean;

		public function Player(_position:Point = null) {
			if (!_position) _position = new Point(0, 0);			
			super(_position, health, hunger);
			
			movementState = "jumping";
			debugFlying = true;
			
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
			
			//Input Definitions
			Input.define("Left", Key.A);
			Input.define("Right", Key.D);
			Input.define("Jump", Key.W);
			Input.define("Down", Key.S);
			Input.define("Use", Key.E);
			Input.define("Toggle Flying", Key.T);
			Input.define("Center Camera", Key.Z);
			
			//Stats
			experience = 0;
			level = 5;
			levelUpTime = true;
			allocationPoints = 10;
			
			//Exchange rate
			constructionRate = 1.1;
			recycleRate = 0.9;
			
			//Combat
			meleeAttacking = false;
		}
		
		override public function added():void {
			gameworld = GameWorld(FP.world);
			type = "Player";
			
			/**
			 * Graphiclist components
			 */
			weapons = new Weapons();
			weapon = weapons.knife;
			equipWeapon(weapon);
			gameworld.add(weapon);
			
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
			
			display = new Graphiclist(legsMap, torso, head, speech);
			graphic = display;
			
			this.setHitbox(Settings.TILESIZE, Settings.TILESIZE * 2, 0, 0);
			
			//Inventory
			inventoryLength = 7;
			inventory = new Inventory(inventoryLength);
			reachDistance = 100;
			scraps = 0;
			
			//Sound
			landSound = new Sfx(Assets.LAND);
			injurySound = new Sfx(Assets.INJURY);
			jumpSound = new Sfx(Assets.BUMP);
			shootSound = new Sfx(Assets.SHOOT);
			walkSound = new Sfx(Assets.BLIP);
			
			layer = -500	
		}
		
		override public function update():void {
			super.update();
			
			updateState();
			updateMovement();
			updateGraphic();
			checkForEnemyCollision();
			inventoryButtons();
			updateSpeech();
			
			//combat
			shoot();
			if (damageTimer > 0) damageTimer--;

			//Interaction
			if (Input.pressed("Use")) onUse();
			
			//debug
			debug();
			if (Input.pressed("Toggle Flying")) toggleDebugFlying();
			if (Input.pressed("Center Camera")) gameworld.cam.adjustToPlayer();
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
			var keys:Array = [Key.DIGIT_1, Key.DIGIT_2, Key.DIGIT_3, Key.DIGIT_4, Key.DIGIT_5, Key.DIGIT_6, Key.DIGIT_7];
			for (var i:int = 0; i < keys.length; i++) {
				if (Input.pressed(keys[i])) {
					gameworld.hud.deselectAll();
					gameworld.hud.inventoryBoxes[i]["box"].select();
				}
			}
		}
		
		public function equipWeapon(_weapon:Weapon):void {
			var w:Array = [];
			gameworld.getClass(Weapon, w);
			if (w.length != 0) gameworld.remove(weapon);
			
			weapon = _weapon;
			gameworld.add(weapon);
		}
		
		/**
		 * TODO
		 * 1. Move the isSelected boolean to the actual inventory data, not
		 * the hud -- mvc.
		 */
		private function onUse():void {
			for (var i:int = 0; i < gameworld.hud.inventoryBoxes.length; i++) {
				if (gameworld.hud.inventoryBoxes[i]["box"].isSelected()) {
					if (inventory.items[i].length > 0) {
						inventory.items[i][inventory.items[i].length - 1].onUse();
						return;
					}
				}
			}
		}
		
		private function toggleDebugFlying():void { debugFlying = !debugFlying; }
		
		protected function checkForEnemyCollision():void {
			var enemy:Enemy = collide("enemy", x, y) as Enemy;
			if (enemy) getHurt(10);
		}
		
		override protected function shoot():void {
			weapon.shoot();
		}
		
		private function updateState():void {
			if (!debugFlying) {
				var l:Level = gameworld.currentLevel;
				if (l.tiles.getTile(Math.floor(x / t), Math.floor(y / t) + 1) == l.jungleTiles["water"])
					movementState = "swimming";
				else if (FP.sign(velocity.x) != 0) {
					if (!facingLeft) {
						if (FP.sign(velocity.x) == 1) movementState = "running";
						else movementState = "backwards running";
					} else {
						if (FP.sign(velocity.x) == -1) movementState = "running";
						else movementState = "backwards running";
					}
				} else movementState = "standing";
			}
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
			} else {
				for (var j:int = 0; j < display.count; j++)
					Image(display.children[j]).flipped = false;
				head.originX = 12;
				head.originY = 12;
				head.x = 24;
			}
			
			torso.originX = 22;
			torso.x = 22;

			angle = FP.angle(Math.abs(FP.camera.x - x), Math.abs(FP.camera.y - y), Input.mouseX, Input.mouseY - 30);
			var f:Boolean = facingLeft;
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

			Image(display.children[2]).angle = headAngle; //Head
			
			//Weapon
			weapon.x = x;
			weapon.y = y;
			
			// this needs to be called explicitly to make sure the
			// above code does not reset any tween x/y values defined
			// in weapon.update
			weapon.update();
			
			if (!f) {
				weapon.x += weapon.offsetX;
				Image(weapon.graphic).originX = weapon.originX;
			} else {
				weapon.x += weapon.leftOffsetX
				Image(weapon.graphic).originX = weapon.leftOriginX;
			}
			
			weapon.y += weapon.offsetY;
			Image(weapon.graphic).originY = weapon.originY;
			
			//Play appropriate movement animation
			if (!onGround || movementState == "swimming") legsMap.play("jumping");
			else if (movementState == "running") legsMap.play("running");
			else if (movementState == "backwards running") legsMap.play("backwards_running");
			else legsMap.play("standing");
		}
			
		override protected function updateMovement():void {
			if (!debugFlying) super.updateMovement();
			xInput = 0;
			yInput = 0;
			
			if (Input.check("Left")) xInput -= 1;
			if (Input.check("Right")) xInput += 1;
			
			if (debugFlying) debugMovement();
			else if (movementState == "swimming") swimmingMovement();
			else defaultMovement();
			
			velocity.x = vSpeed * xInput;
		}
	
		private function swimmingMovement():void {
			setSpeech("I can't swim.");
			if (Input.check("Jump")) yInput -= 1;
			if (Input.check("Down")) yInput += 1;
			velocity.y = (vSpeed * yInput) + vGravity;
		}
		
		private function defaultMovement():void {
			jump();
			vSpeed = SPEED;
			acceleration.y = GRAVITY;
			Image(display.children[2]).color = 0xffffff; //debug
		}
		
		private function debugMovement():void {
			vSpeed = SPEED * 2;
			
			if (Input.check("Jump")) yInput -= 1;
			if (Input.check("Down")) yInput += 1;
			
			velocity.y = vSpeed * yInput;
			
			Image(display.children[2]).color = 0x00ff00; //debug
		}
		
		override protected function land():void {
			if (!onGround) {
				calcFallDamage(velocity.y);
				onGround = true;
			}
		}
		
		private function debug():void {
			if (Input.pressed(Key.Y)) changeHunger(10);
			if (Input.pressed(Key.U)) changeHunger(-10);
			if (Input.pressed(Key.H)) changeHealth(10);
			if (Input.pressed(Key.J)) changeHealth(-10);
			if (Input.pressed(Key.M)) scraps += 100;
		}
		
		override protected function jump():void {
			if (Input.check("Jump")) {
				if (Input.check(Key.SHIFT) && !jetBurnedOut) {
					movementState = "jetpacking";
					jetFuel--;
					velocity.y = -JUMP;
				} else {
					if (onGround) {
						velocity.y = -JUMP;
						onGround = false;
						jumpSound.play();
					}
				}
			}
			
			if (movementState != "jetpacking") {
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