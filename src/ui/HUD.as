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
		
		private var thePlayer:SpacemanPlayer;
		 
		public var display:Graphiclist;
		
		private var inventory:Array;
		private var weaponInventory:Array;
		
		private var expList:Array;
		private var expHeight:int;
		private var expTextSize:int;
		
		//this doesn't seem good.
		public static var inventoryDisplay:Array;
		public static var inventoryBoxes:Array;
		public static var inventoryBoxesInitiated:Boolean;
		
		public static var weaponInventoryDisplay:Array;
		public static var weaponInventoryBoxes:Array;
		public static var weaponInventoryBoxesInitiated:Boolean;
		
		public function HUD(player:SpacemanPlayer) {
			layer = 1;
			//At some point player I should make gameworld's player
			//a static variable, or something.
			thePlayer = player;
			
			healthHUD = new Text("Health: " + thePlayer.getHealth(), 10, 10, 200, 50)
			healthHUD.color = 0x6B6B6B;
			healthHUD.size = 32
				
			hungerHUD = new Text("Hunger: " + thePlayer.getHunger(), FP.screen.width - 210, 10); 
			hungerHUD.color = 0x6B6B6B;
			hungerHUD.size = 32;
			
			expHUD = new Text("EXP: " + thePlayer.getPlayerExperience(), 10, 50);
			expHUD.color = 0x6B6B6B;
			expHUD.size = 24;
			
			levelHUD = new Text("Level: " + thePlayer.getLevel(), 10, 80);
			levelHUD.color = 0x6B6B6B;
			levelHUD.size = 24;
			
			bulletsHUD = new Text("Ammo: " + thePlayer.ammunition, 10, 100);
			bulletsHUD.color = 0x6b6b6b;
			bulletsHUD.size = 22;
			

			display = new Graphiclist(healthHUD, hungerHUD, expHUD, levelHUD, bulletsHUD);
			
			inventoryDisplay = new Array(thePlayer.inventoryLength);
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
			inventory = thePlayer.getInventory().inventory;
		}
		
		
		private function updateHealth():void{
			hungerHUD.text = "Hunger: " + thePlayer.getHunger();
			healthHUD.text = "Health: " + thePlayer.getHealth();
			expHUD.text = "EXP: " + thePlayer.getPlayerExperience();
			levelHUD.text = "Level: " + thePlayer.getLevel();
			bulletsHUD.text = "Ammo: " + thePlayer.ammunition;
		}
		
		private function initInventoryBoxes():void {
			inventoryBoxes = [];
			
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				var boxGraphics:Object = {};
				var box:InventoryBox = new InventoryBox(new Point(10 + (i * 55), FP.screen.height - 60));
				box.layer = -100;
				var text:Text = new Text(inventory[i].length, 10 + (i * 55), FP.screen.height - 60);
				boxGraphics = {"box": box, "text": text};
				inventoryBoxes.push(boxGraphics);
				FP.world.add(boxGraphics["box"]);
				display.add(boxGraphics["text"])
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
				if (inventory[i] != []){
					if (inventoryDisplay[i] == null) drawNewItem(i, inventory[i][0]);
				} else {
					if (inventoryDisplay[i] != null) removeItemFromInventory(i);
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
				Math.abs(x - FP.camera.x + thePlayer.x + thePlayer.halfWidth) - (expTextSize / 2),
				Math.abs(y - FP.camera.y + thePlayer.y - expTextSize), null, 100);
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
				currentY = Math.abs(y - FP.camera.y + thePlayer.y - exp["text"].y);
				if (currentY < expHeight) {
					exp["text"].y--;
					exp["text"].x = x - FP.camera.x + thePlayer.x + thePlayer.halfWidth  - (expTextSize / 2);
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