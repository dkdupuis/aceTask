package
{
	import flash.utils.setTimeout;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.Sfx;

	
	public class TaskResult extends Entity
	{
		[Embed(source="../assets/graphics/success_result.png")] private const SUCCESS:Class;
		[Embed(source="../assets/graphics/fail_result.png")] private const FAIL:Class;
		[Embed(source="../assets/graphics/skip_result.png")] private const SKIP:Class;
		
		[Embed(source="../assets/sounds/keepsuccess.mp3")] public const SUCCESS_SOUND:Class;
		[Embed(source="../assets/sounds/keepfail.mp3")] public const FAIL_SOUND:Class;
		[Embed(source="../assets/sounds/skip.mp3")] public const SKIP_SOUND:Class;
		
		public var result:int;
		
		public var image:Image;
		public var imageEnt:Entity;
		public var text:Text;
		public var textEnt:Entity;
		
		public var worldController:GamePhase;
		
		public var sound:Sfx;
		
		public function TaskResult(result:int, worldController:GamePhase)
		{
			super();
			Text.align = "center";
			// 1 = skip 2 = success 3 = fail
			this.result = result;
			this.worldController = worldController;
			
			switch (result) {
				case 1:
					image = new Image(SKIP);
					text = new Text("SKIPPED");
					sound = new Sfx(SKIP_SOUND);
					break;
				case 2:
					image = new Image(SUCCESS);
					text = new Text("SUCCESS");
					sound = new Sfx(SUCCESS_SOUND);
					break;
				case 3:
					image = new Image(FAIL);
					text = new Text("No Points Given");
					sound = new Sfx(FAIL_SOUND);
					break;
				default:
					trace("error initializing result graphics");
			}
			image.originX = image.width / 2;
			image.originY = image.height / 2;
			text.size = 72;
			text.width = 480;
			
			text.color = 0x222222;
			
			image.scale = 0;
			
			imageEnt = new Entity(270, 290, image);
			FP.world.add(imageEnt);
			
			textEnt = new Entity(30, 430, text);
			FP.world.add(textEnt);
			
			Text.align="left";
		}
		
		override public function added():void
		{
			super.added();
			var grow:VarTween = new VarTween();
			grow.tween(this.image, "scale", 1, 0.1);
			addTween(grow, true);
			
			if (CardGame.soundEnabled)sound.play();
			
			//setTimeout(remove, 3000); //slow timeout
			setTimeout(remove, 1200);
			worldController.hideRisk();
		}
		
		public function shrink():void
		{
			var shrink:VarTween = new VarTween(remove);
			shrink.tween(this.image, "scale", 0, 0.2);
			addTween(shrink, true);
		}
		
		public function remove():void
		{
			if (result == 2 || result == 3)
				worldController.moveCard(worldController.levelAssets.keepBucket.x+5, worldController.levelAssets.keepBucket.y + 5, "keep");
			else
				worldController.moveCard(worldController.levelAssets.skipBucket.x+5, worldController.levelAssets.skipBucket.y + 5, "skip");
			FP.world.remove(this);		
		}
		
		override public function removed():void
		{
			FP.world.remove(imageEnt);
			FP.world.remove(textEnt);
			super.removed();
		}
	}
}