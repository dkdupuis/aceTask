package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	public class TextBox extends Entity
	{
		private var codeDisplayPos:Point = new Point(300, 500);
		private var codeDisplay:Entity = null;
		private var codeDisplayText:Text;
		private var codeString:String = "";
		private const codeKeys:Object = { };
		
		public var currentWorld:TitleScreen;
		private const idLength:int = 10;
		
		public function TextBox( currentWorld:TitleScreen )
		{
			this.currentWorld = currentWorld;
			
		}
		
		// sets up our code entry system
		private function InitCodeKeys():void
		{
			// each array on the right has the function to handle the key, 
			// and the string to append for those keys that will add to the code
			codeKeys[Key.DIGIT_0] = [EnterCode, "0"];
			codeKeys[Key.DIGIT_1] = [EnterCode, "1"];
			codeKeys[Key.DIGIT_2] = [EnterCode, "2"];
			codeKeys[Key.DIGIT_3] = [EnterCode, "3"];
			codeKeys[Key.DIGIT_4] = [EnterCode, "4"];
			codeKeys[Key.DIGIT_5] = [EnterCode, "5"];
			codeKeys[Key.DIGIT_6] = [EnterCode, "6"];
			codeKeys[Key.DIGIT_7] = [EnterCode, "7"];
			codeKeys[Key.DIGIT_8] = [EnterCode, "8"];
			codeKeys[Key.DIGIT_9] = [EnterCode, "9"];
			//codeKeys[Key.SPACE] = [EnterCode, " "];
			
			// we don't need any additional info after the function for these
			// however, the value must remain an array
			codeKeys[Key.BACKSPACE] = [EraseCode];
			codeKeys[Key.ENTER] = [AcceptCode];	
		}
		
		// appends the entered code
		private function EnterCode(codeKey:Array):void 
		{ 
			codeString += (codeKey[1] as String); 
		}
		
		public function getCodeString():String
		{
			return codeString;
		}
		
		// removes the last entered code
		private function EraseCode(codeKey:Array):void 
		{ 
			codeString = codeString.slice(0, codeString.length - 1);
		}
		
		// do something with the entered code
		private function AcceptCode(codeKey:Array):void 
		{
			//trace("Entered Code: " + codeString);
			currentWorld.start(codeString);
		}
		
		// handles code input - returns true when a valid code key is pressed
		private function GetCode():Boolean
		{
			// if there is no registered code for the last key pressed, we bail
			if (null == codeKeys[Input.lastKey]) { return false; }
			
			// grab the code key
			var codeKey:Array = codeKeys[Input.lastKey];
			
			// get the function to call for the key
			var fp:Function = codeKey[0] as Function;
			
			// cal the function
			fp(codeKey);
			
			// tell flashpunk that the last key is something that 
			// we are not using to prevent repeated key entry
			Input.lastKey = Key.F10;
			return true;
		}
		
		// changes the displayed code on-screen to match the entered code
		private function UpdateCodeDisplay():void
		{
			// If you write more than 10 numbers, you can't write anything more
			if (codeString.length > idLength) 
			{
				codeString = codeString.slice(0, 10);
			}
			
			// create display entity if it does not exist
			if (codeDisplay == null)
			{
				codeDisplay = new Entity(codeDisplayPos.x, codeDisplayPos.y, codeDisplayText);
			}
			
			// if the entered code length is zero, we hide the code display
			if (0 == codeString.length)
			{
				codeDisplay.visible = false;
				return;
			}
			
			// we have a code to show, so make it visisble
			codeDisplay.visible = true;
			
			// create new text
			codeDisplayText = new Text(codeString);
			
			// update the entity with the new code
			codeDisplay.graphic = codeDisplayText;
		}
		
		// handles updating the entered code
		private function UpdateCodeEntry():void
		{
			if (GetCode())
			{
				UpdateCodeDisplay();
			}
		}
		
		override public function added():void 
		{
			//FP.screen.color = 0x000096;
			
			// initialize the code keys object
			InitCodeKeys();
			
			// creates the code display stuff
			Text.size = 32;
			UpdateCodeDisplay();
			
			// add to the world
			FP.world.add(codeDisplay);
			
			super.added();
		}
		
		override public function update():void 
		{
			// update code entry
			if (currentWorld == (world as TitleScreen))
			{
				if (!currentWorld.conflictMode){UpdateCodeEntry();}
			}
			else{UpdateCodeEntry();}
			
			
			super.update();
		}
		
		override public function render():void 
		{
			// draw a cursor
			var cursorRect:Rectangle = new Rectangle(
				codeDisplayPos.x + ((codeString.length > 0) ? codeDisplayText.width : 0),
				codeDisplayPos.y + Text.size,
				Text.size, 4);
			var background:Rectangle = new Rectangle (codeDisplayPos.x - 20, codeDisplayPos.y - 5, Text.size * idLength, 50);
			FP.buffer.fillRect(background, 0x333333);
			FP.buffer.fillRect(cursorRect, 0xFFFFFF);	
			super.render();
		}
		
	
	}
}