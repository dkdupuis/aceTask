package
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Backdrop;
	import net.flashpunk.graphics.Image;
	
	public class BackgroundImage extends Entity
	{
		[Embed(source="../assets/graphics/bg.jpg")] private const BACKGROUND:Class;
		public var image:Image;
		public function backgroundImage()
		{
			image = new Image(BACKGROUND);
			graphic = image;
			layer = 2;
		}
	}
}