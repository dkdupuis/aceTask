package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	
	public class SequenceTask extends Entity
	{
		[Embed(source="../assets/graphics/popup-bg.png")] public const POPUP:Class;
		[Embed(source="../assets/graphics/sequenceArrow.png")] public const ARROW:Class;
		
		
		public var letters:Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
		public var sequence:Array;
		public var sequenceSorted:Array;
		
		public var buckets:Array;
		public var bucketsHolder:Array;
		public var targets:Array;
		public const SEQUENCE_SIZE:int = 8;
		public var NUM_SEQUENCES:int;
		public var arrowEntity:Entity;
		
	 	public var submitButt:Entity;
		public var resetButt:Entity;
		public var giveupButt:Entity;
		
		public static var finished:Boolean = false;
		
		public var worldController:GamePhase;
		
		public var bgImage:Image;
		
		public function SequenceTask( num:int, world:GamePhase )
		{
			super();
			NUM_SEQUENCES = num;
			this.worldController = world;
			
			x = FP.halfWidth;
			y = FP.halfHeight;
			
			bgImage = new Image(POPUP);
			bgImage.originX = bgImage.width / 2;
			bgImage.originY = bgImage.height / 2;
			bgImage.scale = 0;
			
			graphic = bgImage;
			layer = -5;
		}
		
		override public function added():void
		{
			super.added();
			var expand:VarTween = new VarTween(start);
			expand.tween(bgImage, "scale", 1, 0.3);
			addTween(expand, true);
		}
		
		public function start():void
		{
			sequence = new Array(NUM_SEQUENCES);
			sequenceSorted = new Array(NUM_SEQUENCES);
			buckets = new Array(NUM_SEQUENCES);
			targets = new Array(NUM_SEQUENCES);
			
			arrowEntity = new Entity(300, 110, new Image(ARROW));
			arrowEntity.layer = this.layer - 1;
			FP.world.add(arrowEntity);
			
			
			for(var i:int = 0; i < NUM_SEQUENCES; i++)
			{
				// generate array of random sequences
				sequence[i] = generateChars(SEQUENCE_SIZE);
				// copy array into another array to sort
				sequenceSorted[i] = sequence[i];
								
				// create and add the sequences to the game (x, y, arrayPosition#, sequence)
				buckets[i] = new SequenceContainer(100, 80+(i*50), i, sequence[i]);
				FP.world.add(buckets[i]);
				
				// create and add the drag targets (x, y, arrayPosition#)
				targets[i] = new DropTarget(420, 80+(i*50), i);
				FP.world.add(targets[i]);
			}
			
			// sort the copy array
			sequenceSorted.sort();
			trace("sequence sorted" + sequenceSorted);
			
			//giveupButt = new Button(700, 240, "giveup", null, this);
			giveupButt = new Button(700, 400, "giveup", null, this);
			giveupButt.layer = -6;
			FP.world.add(giveupButt);
			
			resetButt = new Button(700, 540, "reset", null, this);
			resetButt.layer = -6;
			FP.world.add(resetButt);
			
			submitButt = new Button(700, 610, "submit", null, this);
			submitButt.layer = -6;
			FP.world.add(submitButt);
		}
		
		
		public function submit():void
		{
			var testArray:Array = new Array(NUM_SEQUENCES);

			try
			{
				for (var i:int = 0; i < NUM_SEQUENCES; i++)
				{
					if (targets[i].heldValue == -1) { throw new Error ("please finish"); }
					else testArray[i] = targets[i].heldValue;
				}
			
					if (testArray.toString() ==sequenceSorted.toString())
					{
						worldController.keepSuccess();
					}
					else
					{
						//worldController.keepFailure(); //Added, //Changed. Commented out line. Not a failure, they are just asked to re-//alphabetize
						throw new Error("list not alphabetized"); //Added, Changed. They can explicitly give up if they get //too frustrated	
					}
				FP.world.remove(this);
			}
			catch (errObject:Error)
			{
				var text:Entity = new TextAlert(710, 670, errObject.message);
				FP.world.add(text);
			}
			
		}
		
		public function reset():void
		{
			for (var i:int = 0; i < NUM_SEQUENCES; i++) {
				buckets[i].snapBack();
			}
		}
		
		public function giveup():void
		{
			worldController.keepFailure();
			FP.world.remove(this);
		}
		
		protected function generateChars(size:int):String
		{
			// function that returns a string of random characters (size is character length);
			var letters:Array = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"];
			var seqString:String = "";
			for (var i:int = 0; i < size; i++)
			{
				//choose random value 0-25
				var pos:int = Math.floor(Math.random() * 26);  
				// add corresponding letter to current string
				seqString += letters[pos];
			}
			//return the completed string of chars
			return seqString;
		}
		
		override public function removed():void
		{
			super.removed(); 
			for (var i:int = 0; i < NUM_SEQUENCES; i++)
			{
				FP.world.remove(buckets[i].sequenceText);
				FP.world.remove(buckets[i]);
				FP.world.remove(targets[i]);
				FP.world.remove(giveupButt);
				FP.world.remove(submitButt);
				FP.world.remove(resetButt);
				FP.world.remove(arrowEntity);
			}
		}	
	}
}