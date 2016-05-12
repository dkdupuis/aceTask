package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class EffortInfo extends Entity
	{
		[Embed(source="../assets/graphics/seqInfo-full.png")] public const EFFORT_FULL:Class;
		[Embed(source="../assets/graphics/seqInfo-empty.png")] public const EFFORT_EMPTY:Class;
		
		public var blockInfo:Array = new Array(12);
		
		public var sequenceNumEntity:Entity;
		public var sequenceTextEntity:Entity;
		
		public var efforNum:int;
		
		public var worldController:GamePhase;
		public function EffortInfo(effortNum:int, worldController:GamePhase)
		{
			super();
			
			this.worldController = worldController;
			
			var sequenceNum:Text = new Text(effortNum.toString());
			sequenceNum.color = 0xc00e43;
			sequenceNum.size = 84;
			sequenceNumEntity = new Entity(170, 420, sequenceNum);
			FP.world.add(sequenceNumEntity);
			
			var sequenceText:Text = new Text("sequences");
			sequenceText.size = 48;
			sequenceText.color = 0x555555;
			sequenceTextEntity = new Entity(230, 450, sequenceText);  
			FP.world.add(sequenceTextEntity);
			
			for (var i:int = 0; i < 12; i++)
			{
				var blockImage:Image;
				if (i < effortNum) { blockImage = new Image(EFFORT_FULL); }
				else { blockImage = new Image(EFFORT_EMPTY); }
				blockInfo[i] = new Entity(65 + 130 * Math.floor(i/4), 175 + (50*(i%4)), blockImage);
				FP.world.add(blockInfo[i]);
			}
		}
		
		override public function removed():void
		{
			FP.world.remove(sequenceNumEntity);
			FP.world.remove(sequenceTextEntity);
			for (var i:int = 0; i < 12; i++) {
				FP.world.remove(blockInfo[i]);
			}
			super.removed();
		}
	}
}