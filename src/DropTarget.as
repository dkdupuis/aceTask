package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;

	
	public class DropTarget extends Entity
	{
		[Embed(source="../assets/graphics/target_empty.png")] private const TARGET_EMPTY:Class;
		protected var image:Image = new Image(TARGET_EMPTY);
		public var arrayPosition:int;
		
		public var heldValue:String = "-1";
		public function DropTarget( xPos:Number, yPos:Number, arrayPos:int)
		{
			graphic = image;
			x = xPos;
			y = yPos;
			layer = -6;
			arrayPosition = arrayPos;
			setHitbox(image.width, image.height/5, 0, image.height* 2/5 * -1);
			type = "drop target";
		}
		
		override public function update():void
		{
			super.update();
			
			var e:SequenceContainer = collide("sequence container", x, y) as SequenceContainer

			if (e && e.dragging == true && collidable)
			{
				this.image.scaleX = 1.1;
				this.image.scaleY = 1.1;
			}
			else
			{
				this.image.scaleX = 1;
				this.image.scaleY = 1;
			}
				
			// if sequence is dropped here	
			if (e && e.dragging == false && collidable)
			{
				heldValue = e.sequence;
				collidable = false;
				e.x = this.x;
				e.y = this.y;	
			}
			
			if(!e)
			{
				heldValue = "-1";
				collidable = true;
			}
		}
	}
}