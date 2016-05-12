package
{
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class ProbabilityInfo extends Entity
	{
		[Embed(source="../assets/graphics/bar_container.png")] public const BAR_CONTAINER:Class;
		[Embed(source="../assets/graphics/bar_fill.png")] public const 	BAR_FILL:Class;
		
		public var barContainer:Entity;
		public var barFill:Entity;
		public var probTextEntity:Entity;
		public var percentTextEntity:Entity;
		
		public var worldController:GamePhase;
		
		public function ProbabilityInfo(probability:Number, worldController:GamePhase)
		{
			super();
			
			this.worldController = worldController;
			
			barContainer = new Entity(60, 180, new Image(BAR_CONTAINER));
			FP.world.add(barContainer);
			
			var barFillImage:Image = new Image(BAR_FILL, new Rectangle(0, 0, 380*probability, 90));
			barFill = new Entity(60, 181, barFillImage);
			FP.world.add(barFill);
			
			var probText:Text = new Text((probability*100).toString());
			probText.color = 0xc00e43;
			probText.size = 84;
			probTextEntity = new Entity(150, 320, probText);
			FP.world.add(probTextEntity);
			
			var percentText:Text = new Text("percent");
			percentText.size = 48;
			percentText.color = 0x555555;
			if (probText.text == "100") { percentTextEntity = new Entity(240, 350, percentText); } 
				else { percentTextEntity = new Entity(220, 350, percentText); }
			FP.world.add(percentTextEntity);
		}
		
		override public function added():void
		{
			
		}
		
		override public function removed():void
		{
			
			FP.world.remove(barContainer);
			FP.world.remove(barFill);
			FP.world.remove(probTextEntity);
			FP.world.remove(percentTextEntity);
			
			super.removed();
			
		}
	}
}