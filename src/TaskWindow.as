package
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	
	public class TaskWindow extends Entity
	{
		[Embed(source="../assets/graphics/taskwindow.png")] private const TASKWINDOW:Class;
		[Embed(source="../assets/sounds/taskwindow.mp3")] public const TASK_SOUND:Class;

		public var image:Image;
		public var worldController:GamePhase;
		
		public var taskSound:Sfx = new Sfx(TASK_SOUND);
		public function TaskWindow( x:Number, y:Number, world:GamePhase )
		{
			super(x, y);
	
			worldController = world;
			
			image = new Image(TASKWINDOW);
			image.originX += image.width - 10;
			image.originY += 110;
			graphic = image;
			layer = 0;		
		}
		
		override public function added():void
		{
			super.added();
			image.scaleX = 0;
			image.scaleY = 0;
			
			if (CardGame.soundEnabled)taskSound.play();
			
			var windowScaleX:VarTween = new VarTween(worldController.showRisk);//when a card is dealt show the risk info and  window
			windowScaleX.tween(image, "scaleX", 1, 0.3);
			addTween(windowScaleX, true);
			var windowScaleY:VarTween = new VarTween();
			windowScaleY.tween(image, "scaleY", 1, 0.3);
			addTween(windowScaleY, true);
		}
		
		public function remove():void
		{
			worldController.hideRisk();
			var windowScaleX:VarTween = new VarTween();
			windowScaleX.tween(image, "scaleX", 0, 0.2);
			addTween(windowScaleX, true);
			var windowScaleY:VarTween = new VarTween();
			windowScaleY.tween(image, "scaleY", 0, 0.2);
			addTween(windowScaleY, true);
		}
	}
}