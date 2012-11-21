package ui {

	import Inventory.InventoryBox;
	import Inventory.InventoryItem;
	
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class HUD extends Entity {
		
		private var healthHUD:Text;
		private var hungerHUD:Text;
		private var expHUD:Text;
		private var levelHUD:Text;
		private var bulletsHUD:Text;
		private var scrapsHUD:Text;
		private var jumpHUD:Text;
		
		private var player:SpacemanPlayer;
		 
		public var display:Graphiclist;
		
		private var inventory:Array;
		
		private var expList:Array;
		private var expHeight:int;
		private var expTextSize:int;
		
		//this doesn't seem good.
		public static var inventoryDisplay:Array;
		public var inventoryBoxes:Array;
		public static var inventoryBoxesInitiated:Boolean;
		
		public static var weaponInventoryDisplay:Array;
		public static var weaponInventoryBoxes:Array;
		public static var weaponInventoryBoxesInitiated:Boolean;
		
		private var w:GameWorld;
		
		public function HUD(_player:SpacemanPlayer, _w:GameWorld) {
			layer = 1;
			//At some point player I should make gameworld's player
			//a static variable, or something.
			player = _player;
			w = _w;
			
			healthHUD = new Text("Health: " + player.getHealth(), 10, 10, 200, 50)
			healthHUD.color = 0x6B6B6B;
			healthHUD.size = 32
				
			hungerHUD = new Text("Hunger: " + player.getHunger(), FP.screen.width - 210, 10); 
			hungerHUD.color = 0x6B6B6B;
			hungerHUD.size = 32;
			
			expHUD = new Text("EXP: " + player.getPlayerExperience(), 10, 50);
			expHUD.color = 0x6B6B6B;
			expHUD.size = 24;
			
			levelHUD = new Text("Level: " + player.getLevel(), 10, 80);
			levelHUD.color = 0x6B6B6B;
			levelHUD.size = 24;
			
			bulletsHUD = new Text("Ammo: " + player.ammunition, 10, 100);
			bulletsHUD.color = 0x6b6b6b;
			bulletsHUD.size = 22;
			
			scrapsHUD = new Text("Scraps: " + player.scraps, 10, 126);
			scrapsHUD.color = 0x6b6b6b;
			scrapsHUD.size = 22;
			
			jumpHUD = new Text("Fuel: " + player.jumpHeight, 10, 146);
			
			display = new Graphiclist(healthHUD, hungerHUD, expHUD, levelHUD, bulletsHUD, scrapsHUD, jumpHUD);
			
			inventoryDisplay = new Array(player.inventoryLength);
			inventoryBoxesInitiated = false;
			
			expList = [];
			expHeight = 70;
			expTextSize = 20;
			
			graphic = display;
			
			layer = -100;
		}
		
		override public function update():void {
			display.x = FP.camera.x;
			display.y = FP.camera.y;
			
			updateHealth();
			
			getInventory();
			
			updateInventoryPosition();
			updateInventoryDisplay();
			updateExp();
			
			//for some reason if initInventoryBoxes is called in the
			//constructor it breaks things
			if(!inventoryBoxesInitiated) initInventoryBoxes();
			updateInventoryBoxes();
			
		}
		
		//ITEM INVENTORY
		private function getInventory():void {
			inventory = player.getInventory().items;
		}
		
		private function updateHealth():void{
			hungerHUD.text = "Hunger: " + player.getHunger();
			healthHUD.text = "Health: " + player.getHealth();
			expHUD.text = "EXP: " + player.getPlayerExperience();
			levelHUD.text = "Level: " + player.getLevel();
			bulletsHUD.text = "Ammo: " + player.weapon.getAmmo();
			scrapsHUD.text = "Scraps: " + player.scraps;
			jumpHUD.text = "Jump: " + player.jumpHeight;
		}
		
		private function initInventoryBoxes():void {
			inventoryBoxes = [];
			
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				var boxGraphics:Object = {};
				var box:InventoryBox = new InventoryBox(new Point(10 + (i * 55), FP.screen.height - 60), w, false);
				box.layer = -100;
				var text:Text = new Text(inventory[i].length, 10 + (i * 55), FP.screen.height - 60);
				boxGraphics = {"box": box, "text": text};
				inventoryBoxes.push(boxGraphics);
				FP.world.add(boxGraphics["box"]);
				display.add(boxGraphics["text"]);
			}
			
			inventoryBoxesInitiated = true;
			
		}
		
		private function updateInventoryPosition():void{
			//Item Inventory
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				var e:InventoryItem = inventoryDisplay[i];
				if (e != null){
					var baseX:int = FP.camera.x + 10 + (i * 55);
					var baseY:int = FP.camera.y + FP.screen.height - 60;
					e.x = baseX + (25) - (Image(e.graphic).width / 2);
					e.y = baseY + (25) - (Image(e.graphic).height / 2);
				}
			}
			
		}
		
		private function updateInventoryBoxes():void{
			//Item Inventory
			for (var i:int = 0; i < inventoryBoxes.length; i++){
				inventoryBoxes[i]["box"].x = FP.camera.x + 10 + (i * 55);
				inventoryBoxes[i]["box"].y = FP.camera.y + FP.screen.height - 60;
				if (inventory[i].length > 1) inventoryBoxes[i]["text"].text = inventory[i].length;
				else inventoryBoxes[i]["text"].text = "";
			}
		}
		
		public function updateInventoryDisplay():void {
			//Item Inventory
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				removeItemFromInventory(i);
				if (inventory[i] != []){
					if (inventoryDisplay[i] == null) drawNewItem(i, inventory[i][0]);
				}
			}
			
		}
		
		private function drawNewItem(_slot:int, _e:InventoryItem = null):void{
			if (_e){
				var e:InventoryItem = _e;
				var baseX:int = FP.camera.x + 10 + (_slot * 55);
				var baseY:int = FP.camera.y + FP.screen.height - 60;
				e.x = baseX + (25) - (Image(e.graphic).width / 2);
				e.y = baseY + (25) - (Image(e.graphic).height / 2);
				inventoryDisplay[_slot] = e;
				world.add(e);
			}
		}
		
		public function removeItemFromInventory(_slot:int):void {
			if (inventoryDisplay[_slot] != null){
				var a:InventoryItem = inventoryDisplay[_slot];
				display.remove(a.graphic);
				FP.world.remove(a);	
				inventoryDisplay[_slot] = null;
			}
		}
		
		public function deselectAll():void{
			for (var i:int = 0; i < inventoryBoxes.length; i++){
				inventoryBoxes[i]["box"].deselect();
			}
		}
		
		public function expText(_exp:int):void {
			var exp:Object = new Object;
			var expText:Text = new Text(_exp.toString(),
				Math.abs(x - FP.camera.x + player.x + player.halfWidth) - (expTextSize / 2),
				Math.abs(y - FP.camera.y + player.y - expTextSize), null, 100);
			expText.color = 0xffffff;
			expText.size = expTextSize;
			exp["text"] = expText;
			exp["origY"] = expText.y;
			expList.push(exp);
			display.add(expText);
		}
		
		//Exp Text
		private function updateExp():void {
			var currentY:int;
			for each (var exp:Object in expList){
				currentY = Math.abs(y - FP.camera.y + player.y - exp["text"].y);
				if (currentY < expHeight) {
					exp["text"].y--;
					exp["text"].x = x - FP.camera.x + player.x + player.halfWidth  - (expTextSize / 2);
					if (currentY > 30) exp["text"].alpha = 1;
				}
				
				if (currentY >= expHeight) {
					exp["text"].visible = false;	
				}
				
				if (exp["text"].render == false) {
					expList.splice(expList.indexOf(exp["text"]));
					display.remove(exp["text"])
					trace(exp["text"].x);
				}
			}
		}
		
	}
}