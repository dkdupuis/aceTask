package
{
	import flash.geom.Rectangle;
	import flash.utils.setTimeout;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	
	public class MessageBar extends Entity
	{
		public var background:Rectangle = new Rectangle (0,-70, 1024, 70);
		public var messageText:Text;
		public var messageTextEntity:Entity;
		
		public function MessageBar(text:String)
		{
			super();
			messageText = new Text(text);
		}
		
		override public function added():void
		{
			messageText.size = 36;
			messageText.color = 0x000000;
			messageTextEntity = new Entity(512, -50, messageText);
			FP.world.add(messageTextEntity);
			
			var slideDown:VarTween = new VarTween();
			slideDown.tween(background, "y", 0, 0.2);
			addTween(slideDown, true);
			
			var slideDown2:VarTween = new VarTween();
			slideDown2.tween(messageTextEntity, "y", 20, 0.2);
			addTween(slideDown2, true);
			
			setTimeout(remove, 3000);
		}
		
		public function remove():void
		{
			var slideDown:VarTween = new VarTween();
			slideDown.tween(background, "y", -70, 0.2);
			addTween(slideDown, true);
			
			var slideDown2:VarTween = new VarTween();
			slideDown2.tween(messageTextEntity, "y", -50, 0.2);
			addTween(slideDown2, true);
		}
		
		override public function render():void
		{
			FP.buffer.fillRect(background, 0xffffff);
		}
		
		
	}
}