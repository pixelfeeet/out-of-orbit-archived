package ui.HUD {
	
	import Inventory.Inventory;
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
		
		private var healthHUD:Graphic;
		private var healthHUDbg:Graphic;
		private var hungerHUD:Graphic;
		private var hungerHUDbg:Graphic;
		private var bulletsHUD:Text;
		private var scrapsHUD:Text;
		private var fuelHUDbg:Graphic;
		private var fuelHUD:Graphic;
		private var fuelText:Text;
		
		public var display:Graphiclist;
		
		private var expList:Array;
		private var expHeight:int;
		private var expTextSize:int;
		
		public static var inventoryDisplay:Array;
		public var inventoryBoxes:Array;
		
		private var w:GameWorld;
		private var player:Player;
		
		public function HUD() {			
			expList = [];
			expHeight = 70;
			expTextSize = 20;
			
			layer = -1000;
		}
		
		/**
		 * TODO
		 * Break these components up into their own classes --
		 * healthHUD, hungerHUD,
		 * most importantly inventoryDisplay
		 */
		override public function added():void {
			w = GameWorld(FP.world);
			player = w.player;
			
			healthHUDbg = Image.createRect(204, 14, 0xeeeeee, 1.0);
			healthHUDbg.x = 8;
			healthHUDbg.y = 8;
			
			healthHUD = Image.createRect(player.getHealth(), 10, 0xbb3333, 0.8);
			healthHUD.x = 10;
			healthHUD.y = 10;
			
			hungerHUDbg = Image.createRect(204, 14, 0xeeeeee, 1.0);
			hungerHUDbg.x = 8;
			hungerHUDbg.y = 28;
			
			hungerHUD = Image.createRect(player.getHunger(), 10, 0x444433, 0.8); 
			hungerHUD.x = 10;
			hungerHUD.y = 30;
			
			bulletsHUD = new Text("Ammo: " + player.ammunition, 10, 100);
			bulletsHUD.color = 0x6b6b6b;
			bulletsHUD.size = 22;
			
			scrapsHUD = new Text("Scraps: " + player.scraps, 10, 126);
			scrapsHUD.color = 0x6b6b6b;
			scrapsHUD.size = 22;
			
			fuelHUDbg = Image.createRect(34, (player.jetFuel * 0.7) + 4, 0xeeeeee, 1.0)
			Image(fuelHUDbg).originY = player.jetFuel;
			fuelHUDbg.x = FP.screen.width - 42;
			fuelHUDbg.y = 38 + (player.jetFuel * 0.7);
			
			fuelHUD = Image.createRect(30, player.jetFuel, 0x222222, 0.8);
			Image(fuelHUD).originY = player.jetFuel;
			fuelHUD.x = FP.screen.width - 40;
			fuelHUD.y = player.jetFuel - 20;
			
			fuelText = new Text("FUEL", FP.screen.width - 42, 82);
			
			display = new Graphiclist(
				healthHUDbg,
				healthHUD,
				hungerHUDbg,
				hungerHUD,
				bulletsHUD,
				scrapsHUD,
				fuelHUDbg,
				fuelHUD,
				fuelText
			);
			
			inventoryDisplay = new Array(playerInventory.items.length);
			
			graphic = display;
			
			initInventoryBoxes();
		}
		
		override public function update():void {
			updateDisplayPosition();
			
			updateHUD();
			
			updateInventoryPosition();
			updateInventoryDisplay();
			updateExp();
			
			updateBoxPosition();
			updateInventoryBoxes();
		}
		
		private function updateHUD():void{
			Image(healthHUD).scaleX = player.getHealth() / 50;
			Image(hungerHUD).scaleX = player.getHunger() / 50;
			bulletsHUD.text = "Ammo: " + player.weapon.getAmmo();
			scrapsHUD.text = "Scraps: " + player.scraps;
			Image(fuelHUD).scaleY = player.jetFuel * 0.007;
			
			if (player.jetBurnedOut) {
				Image(fuelHUD).color = 0xee4433;
			} else {
				Image(fuelHUD).color = 0x222222;
			}
		}
		
		private function initInventoryBoxes():void {
			inventoryBoxes = [];
			
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				var box:InventoryBox = new InventoryBox(new Point(10 + (i * 55), FP.screen.height - 60), false);
				box.layer = -1000;
				
				var text:Text = new Text(playerInventory.items[i].contents.length, 10 + (i * 55), FP.screen.height - 60),
					boxGraphics:Object = { "box": box, "text": text };
				
				inventoryBoxes.push(boxGraphics);
				FP.world.add(boxGraphics["box"]);
				display.add(boxGraphics["text"]);
			}
		}
		
		private function updateDisplayPosition():void {
			display.x = FP.camera.x;
			display.y = FP.camera.y;
		}
		
		private function updateInventoryPosition():void{
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				var e:InventoryItem = inventoryDisplay[i];
				if (e != null){
					var baseX:int = FP.camera.x + 10 + (i * 55),
						baseY:int = FP.camera.y + FP.screen.height - 60;
					e.x = baseX + (25) - (Image(e.graphic).width / 2);
					e.y = baseY + (25) - (Image(e.graphic).height / 2);
				}
			}	
		}
		
		private function updateInventoryBoxes():void{
			if (playerInventory == null) return;
			//Item Inventory
			for (var i:int = 0; i < inventoryBoxes.length; i++) {
				if (playerInventory.items[i].contents.length > 0
				 && playerInventory.items[i].contents[0].isStackable()) {
					inventoryBoxes[i]["text"].text = playerInventory.items[i].contents.length;
				} else {
					inventoryBoxes[i]["text"].text = "";
				}
				
				if (playerInventory.items[i].active) {
					inventoryBoxes[i].box.select();
				} else {
					inventoryBoxes[i].box.deselect();
				}
			}
		}
		
		private function updateBoxPosition():void {
			for (var i:int = 0; i < inventoryBoxes.length; i++) {
				inventoryBoxes[i]["box"].x = FP.camera.x + 10 + (i * 55);
				inventoryBoxes[i]["box"].y = FP.camera.y + FP.screen.height - 60;
			}
		}
		
		public function updateInventoryDisplay():void {
			resetInventoryDisplay();
			//Item Inventory
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				drawItem(i, playerInventory.items[i].contents[0]);
			}
		}
		
		private function resetInventoryDisplay():void {
			for (var i:int = 0; i < inventoryDisplay.length; i++) {
				if (inventoryDisplay[i] != null)
					FP.world.remove(inventoryDisplay[i]);	
			}
			
			inventoryDisplay = [];
			inventoryDisplay = new Array(playerInventory.items.length);
		}
		
		private function drawItem(_slot:int, _e:InventoryItem = null):void{
			if (_e) {
				var e:InventoryItem = _e,
					baseX:int = FP.camera.x + 10 + (_slot * 55),
					baseY:int = FP.camera.y + FP.screen.height - 60;
				e.x = baseX + (25) - (Image(e.graphic).width / 2);
				e.y = baseY + (25) - (Image(e.graphic).height / 2);
				inventoryDisplay[_slot] = e;
				world.add(e);
			}
		}
		
		public function deselectAll():void{
			for (var i:int = 0; i < inventoryBoxes.length; i++)
				inventoryBoxes[i]["box"].deselect();
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
				
				// Continue to move up
				if (currentY < expHeight) {
					exp["text"].y--;
					exp["text"].x = x - FP.camera.x + player.x + player.halfWidth  - (expTextSize / 2);
					if (currentY > 30) exp["text"].alpha = 1;
				}
				
				// Get rid of text
				if (currentY >= expHeight) {
					expList.splice(expList.indexOf(exp["text"]));
					display.remove(exp["text"])
				}
			}
		}
		
		private function get playerInventory():Inventory {
			return player.inventory;
		}
	}
}