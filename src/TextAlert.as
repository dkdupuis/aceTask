package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.FP;
	import flash.utils.setTimeout;
	
	public class TextAlert extends Entity
	{
		public var text:Text;

		public function TextAlert(xPos:Number, yPos:Number, textDisplay:String)
		{
			text = new Text(textDisplay);
			text.size = 30;
			text.color = 0x000000;
			graphic = text;
			x = xPos;
			y = yPos;
			layer = -10;
		}
		
		override public function added():void
		{
			setTimeout(fade, 2000);
		}
		
		public function fade():void
		{
			var fadeOut:VarTween = new VarTween(finished);
			fadeOut.tween(graphic,"alpha", 0, 3);
			addTween(fadeOut,true);
		}
		
		protected function finished():void
		{
			FP.world.remove(this);
		}
		
		
	}
}