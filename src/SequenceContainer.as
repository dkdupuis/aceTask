package
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.Ease;
	import net.flashpunk.utils.Input;

	
	public class SequenceContainer extends Entity
	{
		[Embed(source="../assets/graphics/bucket.png")] private const SEQUENCE_BUCKET:Class;
		[Embed(source="../assets/graphics/bucket_dragging.png")] private const SEQUENCE_BUCKET_DRAGGING:Class;
		[Embed(source="../assets/graphics/bucket_holder.png")] public const HOLDER:Class;
		[Embed(source = '../assets/headline.ttf', embedAsCFF="false", fontFamily = 'Headline')] private const HEADLINE:Class;
		[Embed(source = '../assets/arialblack.ttf', embedAsCFF="false", fontFamily = 'Arial')] private const ARIAL:Class;

		public var image:Image;
		public var imageDragging:Image;
		public var bucketPos:int;
		
		public var sequence:String;
		public var sequenceText:Entity;
		
		public var originalX: int;
		public var originalY: int;
		
		public var canDrag:Boolean = true;
		public var dragging:Boolean = false;
		public var isColliding:Boolean = false;
		public var xDiff:Number = 0;
		public var yDiff:Number = 0;
		
		public var holder:Entity;
				
		public function SequenceContainer(xPos:int, yPos:int, arrayPos:int, sequenceString:String)
		{
			Text.font = "Arial";
			Text.align = "center";
			image = new Image(SEQUENCE_BUCKET);
			imageDragging = new Image(SEQUENCE_BUCKET_DRAGGING);
			graphic = image;
			layer = -7;
			type = "sequence container";
			setHitbox(image.width, image.height);
			x = xPos;
			y = yPos;
			
			holder = new Entity(x, y, new Image(HOLDER));
			holder.layer = -6;
			FP.world.add(holder);
			
			
			// starting position (snaps back if not in a drop target)
			originalX = xPos;
			originalY = yPos;
			bucketPos = arrayPos;
			
			// set sequence variable and create a new text entity
			sequence = sequenceString;
			var text:Text = new Text(sequence);
			text.width = 160;
			
			text.size = 20;
			sequenceText = new Entity(x, y+5, text);
			sequenceText.layer = this.layer - 1;
			FP.world.add(sequenceText);
			Text.font = "Headline";
			
		}
		override public function update():void
		{
			super.update();
			if(canDrag)
			{
				var e:DropTarget = collide("drop target", x, y) as DropTarget
				
				// if its colliding with a drop target
				if (e) { isColliding = true; }
				else   { isColliding = false; }
				
				// begin dragging
				if(Input.mousePressed && !dragging && collidePoint(x, y, Input.mouseX, Input.mouseY))
				{
					xDiff = Input.mouseX - x;
					yDiff = Input.mouseY - y;
					dragging = true;
					graphic = imageDragging;
					layer = -10;
					sequenceText.layer = this.layer -1;
				}
				
				// continue dragging
				if(dragging && Input.mouseDown)
				{
					x = Input.mouseX - xDiff;
					y = Input.mouseY - yDiff;
				}
				
				// end dragging
				if(Input.mouseReleased && dragging)
				{
					dragging = false;
					graphic = image;
					layer = -6;
					sequenceText.layer = this.layer -1;
					if (isColliding == false) { snapBack(); }
				}
			}
			
			// carries sequence text along;
			sequenceText.x = x;
			sequenceText.y = y + 5;
		}
		
		public function snapBack():void
		{
			var snapBackX:VarTween = new VarTween;
			var snapBackY:VarTween = new VarTween;
			snapBackX.tween(this,"x", originalX, 0.4, Ease.expoOut);
			snapBackY.tween(this,"y", originalY, 0.4, Ease.expoOut);
			addTween(snapBackX,true);
			addTween(snapBackY, true);
			graphic = image;
		}
		
		override public function removed():void
		{
			FP.world.remove(holder);
		}
		
	}
	
	
	
}