package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.Sfx;
	
	public class Card extends Entity
	{
		[Embed(source="../assets/graphics/card1.png")] private const CARD1:Class;
		[Embed(source="../assets/graphics/card2.png")] private const CARD2:Class;
		[Embed(source="../assets/graphics/card3.png")] private const CARD3:Class;
		[Embed(source="../assets/graphics/card4.png")] private const CARD4:Class;
		[Embed(source="../assets/graphics/card5.png")] private const CARD5:Class;
		[Embed(source="../assets/graphics/card6.png")] private const CARD6:Class;
		[Embed(source="../assets/graphics/card7.png")] private const CARD7:Class;
		[Embed(source="../assets/graphics/card8.png")] private const CARD8:Class;
		[Embed(source="../assets/graphics/card9.png")] private const CARD9:Class;
		[Embed(source="../assets/graphics/card10.png")] private const CARD10:Class;
		[Embed(source="../assets/graphics/cardback.png")] public const CARD_BACK:Class;
		
		[Embed(source="../assets/sounds/deal.mp3")] public const DEAL_SOUND:Class;

		public var image:Image;
		
		public var pointValue:int = 0;
		
		public var cardImages:Array = new Array(CARD1, CARD2, CARD3, CARD4, CARD5, CARD6, CARD7, CARD8, CARD9, CARD10, CARD_BACK);
		
		public var worldController:GamePhase;
		
		public var targetX:Number;
		public var targetY:Number;
		public var target:String;
		public var dealSound:Sfx = new Sfx(DEAL_SOUND);
		
		public function Card(world:GamePhase,_pointValue:int = -999)
		{
			super();
			x = 400;
			y = -300;
			
			worldController = world;
			
			//accept pointvalue input otherwise use default random
			if (_pointValue != -999)  pointValue = _pointValue;
			else pointValue = Math.floor(Math.random() * (1+10-1))+1; 
			world.pointValuesShown.push(pointValue); //add to total point values
			
			image = new Image(cardImages[pointValue-1]);
			
			
			
			graphic = image;
			type = "card";
		}
		
		override public function added():void
		{
			if (CardGame.soundEnabled)dealSound.play();
			moveIn();
		}

		public function moveOut(targetX:Number, targetY:Number, target:String,duration:Number=0.1):void
		{
			worldController.taskWindow.remove();
			duration = .05;
			this.targetX = targetX;
			this.targetY = targetY;
			this.target = target;
			
			var flipScale:VarTween = new VarTween(moveOutStep2);
			flipScale.tween(this.image, "scaleX", 0, duration);
			addTween(flipScale, true);
			
			
			var flipMove:VarTween = new VarTween();
			flipMove.tween(this, "x", x+75, duration);
			addTween(flipMove, true);
		}
		
		public function moveOutStep2(duration:Number=0.2):void
		{
			
			duration = .1;
			image = new Image(cardImages[10]);
			graphic = image;
			image.scaleX = 0;
			
			var flipScale2:VarTween = new VarTween();
			flipScale2.tween(this.image, "scaleX", 1, duration);
			addTween(flipScale2, true);
			
			var flipMove2:VarTween = new VarTween(moveOutStep3);
			flipMove2.tween(this, "x", x-75, duration);
			addTween(flipMove2, true);
			
			
		}
		
		public function moveOutStep3(duration:Number = 0.4):void
		{
			duration = .2;
			var moveDownY:VarTween = new VarTween(worldController.dealCard);
			moveDownY.tween(this, "y", targetY, duration);
			addTween(moveDownY, true);
			
			var moveDownX:VarTween = new VarTween(pile);
			moveDownX.tween(this, "x", targetX, duration);
			addTween(moveDownX, true);
		}
		
		public function pile():void
		{
			if (target == "keep") {worldController.increaseKeep();}
			else if (target == "skip") {worldController.increaseSkip();}
		}
		
		public function moveIn(duration:Number = 0.5):void
		{
			duration = .35;
			var moveX:VarTween = new VarTween(worldController.openTaskWindow);
			moveX.tween(this, "x", 550, duration);
			addTween(moveX, true);
			
			var moveY:VarTween = new VarTween();
			moveY.tween(this, "y", 120, duration);
			addTween(moveY, true);
		}
		
		public function remove():void
		{
			FP.world.remove(this);
		}
	}
}