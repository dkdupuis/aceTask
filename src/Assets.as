package
{	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class Assets extends Entity
	{
		[Embed(source="../assets/graphics/bg.jpg")] private const BACKGROUND:Class;
		[Embed(source="../assets/graphics/card_bucket.png")] private const CARD_BUCKET:Class;
		[Embed(source="../assets/graphics/card_bucket1.png")] private const CARD_BUCKET1:Class;
		[Embed(source="../assets/graphics/card_bucket2.png")] private const CARD_BUCKET2:Class;
		[Embed(source="../assets/graphics/card_bucket3.png")] private const CARD_BUCKET3:Class;
		[Embed(source="../assets/graphics/card_bucket4.png")] private const CARD_BUCKET4:Class;
		[Embed(source="../assets/graphics/card_bucket_full.png")] private const CARD_BUCKET_FULL:Class;
		

		public var keepBucket:Entity;
		public var skipBucket:Entity;
		
		public var cardCountText:Text;
		public var cardCountEnt:Entity;
		public var keepTextEnt:Entity;
		public var skipTextEnt:Entity;
		public var phaseTextEnt:Entity;
		
		public var keepMax:int;
		public var skipMax:int;
		public var deckMax:int;
		
		public var scoreEnt:Entity;
		
		public var phaseType:int;
		
		public function Assets( currentWorld:World, dMax:int, kMax:int, sMax:int, phase:int)
		{
			super();
			
			
			// card variables
			deckMax = dMax;
			keepMax = kMax;
			skipMax = sMax;
			phaseType = phase;
			
			// card background
			var bgImage:Image = new Image(BACKGROUND);
			var bgImageEntity:Entity = new Entity(0,0, bgImage);
			FP.world.add(bgImageEntity);
			
			// phase type title
			var phaseTypeText:Text = new Text(phaseText(phaseType));
			phaseTypeText.size = 64;
			phaseTextEnt= new Entity(40, 600, phaseTypeText);
			FP.world.add(phaseTextEnt);
			
			// card buckets
			keepBucket = new Entity(750, 450, new Image(CARD_BUCKET));
			FP.world.add(keepBucket);
			skipBucket = new Entity(545, 450, new Image(CARD_BUCKET));
			FP.world.add(skipBucket);
			
			// pile text
			keepTextEnt = new Entity(750, 700, new Text("KEPT 0/" + keepMax));
			keepTextEnt.visible = false;
			FP.world.add(keepTextEnt);
			skipTextEnt = new Entity(545, 700, new Text("SKIPPED 0/" + skipMax));		
			skipTextEnt.visible = false; //Hide this text
			FP.world.add(skipTextEnt);
			
			// card count text
			cardCountText = new Text("CARD 1/" + deckMax);
			cardCountText.size = 40;										
			cardCountEnt = new Entity(730, 130, cardCountText);
			cardCountEnt.visible = false;//Hide this text
			FP.world.add(cardCountEnt);
			
			
			// score text
			//scoreEnt = new Entity(50, 50);
			//scoreEnt.graphic = new Text("SCORE: 0");
			//FP.world.add(scoreEnt);
		}
		
		
		public function phaseText(phaseType:int):String
		{
			switch(phaseType)
			{
				case 1:
					return "PROBABILITY TASK";
					break;
				case 2:
					return "TIME TASK";
					break;
				case 3:
					return "EFFORT TASK";
					break;
				default:
					return "undefined";
			}
		}
		
		public function increaseKeepPile( keepSize:int, keepMax:int ):void {
			if (keepSize == keepMax) { keepBucket.graphic = new Image(CARD_BUCKET_FULL); }
			else if (keepSize > keepMax*(3/4)) { keepBucket.graphic = new Image(CARD_BUCKET4); }
			else if (keepSize > keepMax*(1/2)) { keepBucket.graphic = new Image(CARD_BUCKET3); }
			else if (keepSize > keepMax/4) { keepBucket.graphic = new Image(CARD_BUCKET2); }
			else if (keepSize == 1) { keepBucket.graphic = new Image(CARD_BUCKET1); }
			keepTextEnt.graphic = new Text("KEPT " + keepSize + "/" + keepMax);
		}
		
		public function increaseSkipPile( skipSize:int, skipMax:int ):void {
			if (skipSize == skipMax) { skipBucket.graphic = new Image(CARD_BUCKET_FULL); }
			else if (skipSize > skipMax*(3/4)) { skipBucket.graphic = new Image(CARD_BUCKET4); }
			else if (skipSize > skipMax*(1/2)) { skipBucket.graphic = new Image(CARD_BUCKET3); }
			else if (skipSize > skipMax/4) { skipBucket.graphic = new Image(CARD_BUCKET2); }
			else if (skipSize == 1) { skipBucket.graphic = new Image(CARD_BUCKET1); }
			skipTextEnt.graphic = new Text("SKIPPED " + skipSize + "/" + skipMax);
		}
		
		public function decreaseDeck( deckSize:int):void {
			cardCountText.text = "CARD " + (deckMax - deckSize) + "/" + deckMax;
		}
		
		public function updateScore( score:int ):void {
			//scoreEnt.graphic = new Text("SCORE: " + score);
		}
		
		public function fillBucket( bucket:Entity ):void {
			bucket.graphic = new Image(CARD_BUCKET1);
		}
		
		override public function removed():void
		{
			FP.world.remove(keepBucket);
			FP.world.remove(skipBucket);
			FP.world.remove(cardCountEnt);
			FP.world.remove(keepTextEnt);
			FP.world.remove(skipTextEnt);
			FP.world.remove(phaseTextEnt);
		}
	}
}