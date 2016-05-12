package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	
	import flash.utils.setTimeout;
	
	public class ProbabilitySpinner extends Entity
	{
		[Embed(source="../assets/graphics/thumbsup.png")] public const THUMBS_UP:Class;
		
		public var thumbsupImage:Image = new Image(THUMBS_UP);
		public var success:Boolean;
		public var counter:int = 0;
		public var target:int;
		
		public var worldController:GamePhase;
		
		public function ProbabilitySpinner(success:Boolean, worldController:GamePhase)
		{
			super();
			this.success = success;
			this.worldController = worldController;
			
			trace(success);
			
			if (success) { target = 6; } else { target = 5; }
			
			x = 270;
			y = 320;
			
			thumbsupImage.originX = thumbsupImage.width / 2;
			thumbsupImage.originY = thumbsupImage.height / 2;
			thumbsupImage.scale = 0;
			graphic = thumbsupImage;
		}
		
		override public function added():void
		{
			var flyin:VarTween = new VarTween(flipController);
			flyin.tween(thumbsupImage, "scale", 1, 0.1);
			addTween(flyin, true);
		}
		
		public function flipController():void
		{
			if (counter < target) {
				if (thumbsupImage.scaleY == 1) { down(); }
				else { up(); }
			}
			else { setTimeout(remove, 1000); }
			
			counter++;
		}
		
		public function down():void
		{
			var spinDown:VarTween = new VarTween(flipController);
			spinDown.tween(thumbsupImage, "scaleY", -1, 0.2);
			addTween(spinDown, true);
		}
		
		public function up():void
		{
			var spinUp:VarTween = new VarTween(flipController);
			spinUp.tween(thumbsupImage, "scaleY", 1, 0.2);
			addTween(spinUp, true);
		}
		
		public function remove():void
		{
			FP.world.remove(this);
		}
		
		override public function removed():void
		{
			if (success) { worldController.keepSuccess(); }
			else { worldController.keepFailure(); }
			super.removed();
		}
	}
}