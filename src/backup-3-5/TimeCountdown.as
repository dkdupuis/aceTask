package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	
	public class TimeCountdown extends Entity
	{
		public var timetoWait: int;
		public var timeElapsed:Number = 0;
		
		public var numCountdown:Entity;
		
		public var worldController:GamePhase;
		public function TimeCountdown(time:int, worldController:GamePhase)
		{
			super();
			x = 0;
			y = 0;
		
			this.worldController = worldController;
			
			timetoWait = time;
			
			graphic = new Image(new BitmapData(1024, 768, false, 0x000000));
			layer = -5;
			
		}
		
		override public function added():void
		{
			numCountdown = new Entity(512, 384);
			numCountdown.graphic = new Text(timetoWait.toString());
			numCountdown.layer = - 6;
			FP.world.add(numCountdown);
		}
		
		override public function update():void
		{
			timeElapsed += FP.elapsed;
			numCountdown.graphic = new Text(int(timeElapsed + 1).toString());
			
			if (timeElapsed > timetoWait)
			{
				worldController.keepSuccess();
				FP.world.remove(numCountdown);
				FP.world.remove(this);
			}
		}
	}
}