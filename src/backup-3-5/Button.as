package
{
	//import flash.ui.Mouse;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	
	public class Button extends Entity
	{
		[Embed(source="../assets/graphics/btn_keep.png")] private const KEEP_BUTTON:Class;
		[Embed(source="../assets/graphics/btn_skip.png")] private const SKIP_BUTTON:Class;
		
		//[Embed(source="../assets/graphics/btn_keep_hover.png")] private const KEEP_BUTTON_HOVER:Class;
		[Embed(source="../assets/graphics/btn_keep_hover_green.png")] private const KEEP_BUTTON_HOVER:Class;
		//[Embed(source="../assets/graphics/btn_skip_hover.png")] private const SKIP_BUTTON_HOVER:Class;
		[Embed(source="../assets/graphics/btn_skip_hover_red.png")] private const SKIP_BUTTON_HOVER:Class;
		[Embed(source="../assets/graphics/btn_keep_click.png")] private const KEEP_BUTTON_CLICK:Class;
		[Embed(source="../assets/graphics/btn_skip_click.png")] private const SKIP_BUTTON_CLICK:Class;
		[Embed(source="../assets/graphics/btn_submit.png")] private const SUBMIT_BUTTON:Class;
		[Embed(source="../assets/graphics/btn_hover_submit.png")] private const SUBMIT_BUTTON_HOVER:Class;
		[Embed(source="../assets/graphics/btn_reset.png")] private const RESET_BUTTON:Class;
		[Embed(source="../assets/graphics/btn_hover_reset.png")] private const RESET_BUTTON_HOVER:Class;
		[Embed(source="../assets/graphics/btn_hover_giveup.png")] private const GIVEUP_BUTTON_HOVER:Class;
		[Embed(source="../assets/graphics/btn_giveup.png")] private const GIVEUP_BUTTON:Class;
		[Embed(source = "../assets/graphics/btn_start.png")] private const START_BUTTON:Class;
		
		[Embed(source = "../assets/graphics/sound_high.png")] private const SOUNDON_BUTTON:Class;
		[Embed(source="../assets/graphics/sound_mute.png")] private const SOUNDOFF_BUTTON:Class;
		
		public var imageState:Array;
		public var image:Image;
		
		public var btnType:String = "";
		
		public var phaseWorld:GamePhase;
		public var titleWorld:TitleScreen;
		public var textBox:TextBox;
		public var delay:DelayInfo
		
		public var clicked:Boolean = false;
		
		public var taskController:SequenceTask; 
		
		public var hovering:Boolean = false;
		public var toggle:Boolean = false;
		
		public function Button(x:Number, y:Number, btnType:String, _world:GamePhase = null, controller:SequenceTask = null, titleWorld:TitleScreen = null, textBox:TextBox = null,delay:DelayInfo=null)
		{
			super(x, y);
			setHitbox(150,50);
			this.btnType = btnType;
			phaseWorld = _world;			
			taskController = controller;
			this.titleWorld = titleWorld;
			this.textBox = textBox;
			this.delay = delay;
			
			//store button states in an array to make calls uniform
			if (btnType == "keep")
				imageState = new Array(new Image(KEEP_BUTTON), new Image(KEEP_BUTTON_HOVER), new Image(KEEP_BUTTON_CLICK));
			else if (btnType == "skip")
				imageState = new Array(new Image(SKIP_BUTTON), new Image(SKIP_BUTTON_HOVER), new Image(SKIP_BUTTON_CLICK));
			else if (btnType == "submit")
				imageState = new Array (new Image(SUBMIT_BUTTON), new Image(SUBMIT_BUTTON_HOVER), new Image(SUBMIT_BUTTON_HOVER));
			else if (btnType == "reset")
				imageState = new Array (new Image(RESET_BUTTON), new Image(RESET_BUTTON_HOVER), new Image(RESET_BUTTON_HOVER));
			else if (btnType == "giveup")
				imageState = new Array (new Image(GIVEUP_BUTTON), new Image(GIVEUP_BUTTON_HOVER), new Image(GIVEUP_BUTTON_HOVER));
			else if (btnType == "start")
				imageState = new Array(new Image(START_BUTTON), new Image(START_BUTTON), new Image(START_BUTTON));
			else if (btnType == "sound")
				imageState = new Array(new Image(SOUNDON_BUTTON), new Image(SOUNDON_BUTTON), new Image(SOUNDOFF_BUTTON));
			else if (btnType == "giveup-time")
				imageState = new Array (new Image(GIVEUP_BUTTON), new Image(GIVEUP_BUTTON_HOVER), new Image(GIVEUP_BUTTON_HOVER));
			else
				trace("error initializing buttons on Button class");
			
			graphic = imageState[0];
		}
		
		override public function update():void
		{
			super.update();
			if (!toggle)
			{
				if(collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					if (hovering == false) {
						//Mouse.cursor = "button";
						hovering = true;
					}
					if (Input.mousePressed) clicked = true;
					
					if (clicked) graphic = imageState[2];
					else graphic = imageState[1];
					
					if (clicked && Input.mouseReleased)	click();
					if (Input.mouseReleased) clicked = false; 
				} 
				
				if (!collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					graphic = imageState[0];
					if (hovering == true) {
						//Mouse.cursor = "auto";
						hovering = false;
					}
				}
			}
			else if (toggle)
			{
				if(collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					if (hovering == false) {
						hovering = true;
					}
					if (Input.mousePressed) { if (!clicked) { clicked = true; } else { clicked = false; }}
					if (Input.mouseReleased)	click();
					
				} 
				
				if (!collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					if (hovering == true) {
						hovering = false;
					}
				}
				if (clicked) graphic = imageState[2];
				else graphic = imageState[0];
			}
			
			
		}
		
		protected function click():void
		{
			if (btnType == "keep" && !phaseWorld.locked)
				phaseWorld.keepCard();
			else if (btnType == "skip" && !phaseWorld.locked)
				phaseWorld.skipCard();
			else if (btnType == "submit")
				taskController.submit();
			else if (btnType == "reset")
				taskController.reset();
			else if (btnType == "giveup")
				taskController.giveup();
			else if (btnType == "start" && !titleWorld.conflictMode)
				titleWorld.start(textBox.getCodeString());
			else if (btnType == "sound")
				titleWorld.soundSetting();
			else if (btnType == "giveup-time")
				delay.giveUp();
				
				
			
		}
		
		override public function render():void
		{
			if (btnType == "sound")
			{
				Draw.world = (titleWorld as World);
				Draw.circlePlus(x +25 , y +25 , 30, 0xFFFFFF, .50, true, 1);
			}
			
			super.render();
		}
		
	}
}