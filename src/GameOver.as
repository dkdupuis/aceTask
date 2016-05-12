package
{
	import flash.display.BitmapData;
	
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;

	public class GameOver extends World
	{
		public var gameOverBG:Entity;
		public var gameOverText:Entity;
		
		public function GameOver()
		{
			super();
			
			gameOverBG = new Entity(1,1);
			gameOverBG.graphic = new Image(new BitmapData(1024, 768, false, 0x000000));
			gameOverBG.layer = -5;
			var param:Object = new Object();param["size"] = 50;
			gameOverText = new Entity(300, 384, new Text("Wow!! - You got  " + CardGame.score + " Points!",0,0,param));
			gameOverText.layer = -6;
			
			add(gameOverBG);
			add(gameOverText);

		}
	}
}