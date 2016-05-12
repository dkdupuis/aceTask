package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.Sfx;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	
	public class DelayInfo extends Entity
	{
		[Embed(source="../assets/graphics/clock.png")] private const CLOCK:Class;
		[Embed(source="../assets/sounds/tick.mp3")] public const TICK_SOUND:Class;
		
		public var clockImage:Image = new Image(CLOCK);
		public var tickSound:Sfx = new Sfx(TICK_SOUND);
		
		
		public var giveupButt : Button;
		
		public var clockEntity:Entity;
		
		public var timeTextEntity:Entity;
		public var secondsTextEntity:Entity;
		
		public var time:int;
		public var degrees:int = 0;
		
		public var circleR:Number = 120;
		public var circleX:Number = 250;
		public var circleY:Number = 280;
		
		public var timer:Number = 0;
		
		public var counting:Boolean = false;
		
		public var worldController:GamePhase;
		
		public function DelayInfo(time:Number, worldController:GamePhase)
		{
			super();
			
			this.time = time;
			this.worldController = worldController;
			degrees = 360 - (time * 360 / 60);
			
			
			clockImage.originX = clockImage.width / 2;
			clockImage.originY = clockImage.height / 2;
			clockEntity = new Entity(circleX, circleY, clockImage); 
			FP.world.add(clockEntity);
			
			var timeText:Text = new Text(time.toString());
			timeText.color = 0xc00e43;
			timeText.size = 84;
			timeTextEntity = new Entity(170, 420, timeText);
			FP.world.add(timeTextEntity);
			
			var secondsText:Text = new Text("seconds");
			secondsText.size = 48;
			secondsText.color = 0x555555;
			secondsTextEntity = new Entity(240, 450, secondsText); 
			FP.world.add(secondsTextEntity);
		}
		
		override public function removed():void
		{
			FP.sprite.graphics.clear();
			FP.world.remove(clockEntity);
			FP.world.remove(timeTextEntity);
			FP.world.remove(secondsTextEntity);
			if (giveupButt)FP.world.remove(giveupButt);
			
			super.removed();
		}
		
		override public function update():void
		{
			super.update();
			//trace(FP.elapsed);
			if (counting == true) { timer += FP.elapsed; }
			
			if (degrees + timer * 6 > 360) { 
				worldController.keepSuccess();
				FP.world.remove(this); 
			}
			
		}
		
		public function startCount():void
		{
			var pop:VarTween = new VarTween(startCount2);
			pop.tween(this.clockImage, "scale", 1.2, 0.08);
			addTween(pop, true);
			
			if (CardGame.soundEnabled) tickSound.play();
			//create Giveup button
			giveupButt = new Button(325, 125, "giveup-time", null, null,null,null,this);
			giveupButt.layer = -6;
			FP.world.add(giveupButt);
		}
		
		public function startCount2():void
		{
			var pop:VarTween = new VarTween(startCount3);
			pop.tween(this.clockImage, "scale", 1, 0.08);
			addTween(pop, true);
		}
		
		public function startCount3():void {
			counting = true;
			
		}
		
		override public function render():void
		{
			super.render(); 
			
			FP.sprite.graphics.clear();
			FP.sprite.graphics.beginFill(0xdfdfec,1);
			//FP.sprite.graphics.lineStyle(1, 0x0000FF, 1);
			
			FP.sprite.graphics.moveTo(circleX, circleY);
			
			//FP.sprite.graphics.lineTo(100, 100);
			//FP.sprite.graphics.lineTo(50, 100);
			for (var i:int = 0; i<=degrees + int(timer*6); i++) {
				FP.sprite.graphics.lineTo(circleX + (circleR *clockImage.scale)*Math.cos((90+degrees+int(timer*6)-i)*Math.PI/180), circleY -(circleR * clockImage.scale)*Math.sin((90+degrees+int(timer*6)-i)*Math.PI/180));
			}
			FP.sprite.graphics.lineTo(circleX,circleY);
			
			FP.sprite.graphics.endFill();
			
			FP.buffer.draw(FP.sprite);
		}
		
		public function giveUp():void
		{
			worldController.keepFailure();
			FP.world.remove(this); 
		}
	}
}