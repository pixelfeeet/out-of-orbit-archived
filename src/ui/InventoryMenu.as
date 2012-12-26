package ui {
	import Inventory.Inventory;
	import Inventory.InventoryItem;
	import Inventory.ScrapConverter;
	import Inventory.InventoryBox;
	
	import flash.geom.Point;
	
	import mx.core.IAssetLayoutFeatures;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	import ui.Button;
	
	public class InventoryMenu extends Entity {
		
		private var panel:Entity;
		private var resumeButton:Button;
		private var quitButton:Button;
		
		private var w:GameWorld;
		private var hud:HUD;

		public var inventoryBoxes:Array;
		public var inventoryDisplay:Array;
		private var inventory:Array;
		private var inventoryBoxesInitiated:Boolean;
		
		private var display:Graphiclist;
		private var player:Player;
		
		public var carriedItem:InventoryItem;
		public var carriedItemSlot:int;
		
		public var scrapConverter:ScrapConverter;
		
		public function InventoryMenu(_w:GameWorld, _p:Player) {
			super();
			
			w = _w;
			player = _p;
			hud = w.hud;
			
			inventoryDisplay = new Array(21);
			inventoryBoxesInitiated = false;
			inventory = [];
			
			panel = new Entity(0, 0, Image.createRect(500, 200, 0x333333, 0.8));
			panel.setHitboxTo(panel.graphic);
			panel.layer = -1100;

			inventoryDisplay = new Array(player.inventoryLength);
			scrapConverter = new ScrapConverter(w);

			display = new Graphiclist();
			graphic = display;
			layer = -1110;
		}
		
		override public function update():void {
			x = FP.camera.x;
			y = FP.camera.y;
			
			getInventory();
			if (!inventoryBoxesInitiated) initInventoryBoxes();
			if (inventoryBoxesInitiated) updateInventoryBoxes();
			updateInventoryDisplay();
			updateInventoryPosition();
			for (var i:int = 0; i < inventoryBoxes.length; i ++) {
				inventoryBoxes[i]["box"].update();
			}
			scrapConverter.update();
		}
		
		private function getInventory():void {
			inventory = player.getInventory().items;
		}
		
		public function show():void {
			w.add(this);
			panel.x = FP.camera.x + (FP.screen.width /2) - (panel.width / 2);
			panel.y = FP.camera.y + 10 + (FP.screen.height / 2) - (panel.height / 2);
			
			FP.world.add(panel); 
			if (!inventoryBoxesInitiated) initInventoryBoxes();
			for (var i:int = 0; i < inventoryBoxes.length; i++) {
				FP.world.add(inventoryBoxes[i]["box"]);
				display.add(inventoryBoxes[i]["text"]);
			}
			for (var j:int = 0; j < inventoryDisplay.length; j++){
				if (inventoryDisplay[j]) inventoryDisplay[j] = null;
			}
			
			scrapConverter.x = panel.x + Image(panel.graphic).width - 60;
			scrapConverter.y = panel.y + Image(panel.graphic).height - 60;
			FP.world.add(scrapConverter);
		}
		
		private function initInventoryBoxes():void {
			inventoryBoxes = [];
			var i:int = 0;
			
			for (var x:int = 0; x < 9; x++) {
				for (var y:int = 0; y < inventoryDisplay.length / 9; y++){
					var boxGraphics:Object = {};
					var box:InventoryBox = new InventoryBox(new Point(FP.screen.x + FP.camera.x + 5 + panel.x + (x * 55),
						FP.screen.y + FP.camera.y + panel.y + 5 + (y * 60)), w, true);
					box.layer = -555;
					box.setAlpha(1.0);
					box.setColor(0x222222);
					var text:Text = new Text("5", panel.x + 5 + (i * 55), panel.y + 5);
					boxGraphics = {"box": box, "text": text};
					inventoryBoxes.push(boxGraphics);
					i++;
				}
			}
			
			inventoryBoxesInitiated = true;
			
		}
		
		private function updateInventoryBoxes():void{
			//Item Inventory
			var i:int = 0;
			for (var x:int = 0; x < 9; x++){
				for (var y:int = 0; y < inventoryBoxes.length / 9; y++){
					if (inventoryBoxes[i]) {
						inventoryBoxes[i]["box"].x = panel.x + 5 + (x * 55);
						inventoryBoxes[i]["box"].y = panel.y + 5 + (y * 60);
					}
					//if (inventory[i].length > 1) 
					if (player.getInventory().items[i])
						inventoryBoxes[i]["text"].text = player.getInventory().items[i].length;
					//else inventoryBoxes[i]["text"].text = "";
					i++;
				}
			}
		}
		
		public function deselectAll():void{
			for (var i:int = 0; i < inventoryBoxes.length; i++){
				if (inventoryBoxes[i]) inventoryBoxes[i]["box"].deselect();
			}
		}
		
		private function showInventoryBoxes():void {
			var i:int = 0;
			for (var x:int = 0; x < 7; x++){
				for (var y:int = 0; y < inventoryBoxes.length / 7; y++){
					FP.world.add(inventoryBoxes[i]["box"]);
					display.add(inventoryBoxes[i]["text"]);
				}
			}
		}
		
		private function updateInventoryDisplay():void {

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
				trace(_e.label)
				var e:InventoryItem = new InventoryItem();
				e.graphic = new Image(_e.sourceImage);
				e.layer = -560;
				var baseX:int = panel.x + 5 + (_slot * 55);
				var baseY:int = panel.y + 5;
				e.x = baseX + (25) - (Image(e.graphic).width / 2);
				e.y = baseY + (25) - (Image(e.graphic).height / 2);
				inventoryDisplay[_slot] = e;
				FP.world.add(e);
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
		
		private function updateInventoryPosition():void{
			//Item Inventory
			for (var i:int = 0; i < inventoryDisplay.length; i++){
				var e:InventoryItem = inventoryDisplay[i];
				if (e != null){
					var baseX:int = panel.x + 5 + (i * 55);
					var baseY:int = panel.y + 5;
					e.x = baseX + (25) - (Image(e.graphic).width / 2);
					e.y = baseY + (25) - (Image(e.graphic).height / 2);
				}
			}
			
		}
		
		public function onResume():void {
			w.onPause();
		}
		
		public function remove():void {
			w.cursor.graphic = new Image(Assets.CURSOR);
			FP.world.remove(panel);
			FP.world.remove(scrapConverter);
			for (var i:int = 0; i < inventoryBoxes.length; i++) {
				FP.world.remove(inventoryBoxes[i]["box"]);
			}
			for (var j:int = 0; j < inventoryDisplay.length; j++) {
				if (inventoryDisplay[j]) inventoryDisplay[j].graphic.visible = false;
			}
			FP.world.remove(this);
		}
		
		public function onQuit():void {
			FP.world = new MainMenuWorld();
			destroy();
		}
		
		public function destroy():void {
			//FP.world.removeAll();
		}
	}
}