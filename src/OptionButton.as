package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.World;
	import net.flashpunk.FP;
	
	public class OptionButton extends Entity
	{
		private var hover:Boolean = false;
		private var thisWorld:World;
		public function OptionButton(_x:int=0,_y:int=0,_graphic:Graphic=null,thisworld:World=null) 
		{
			x = _x;
			y = _y;
			graphic = _graphic;
			thisWorld = thisworld;
		}
		
		override public function update():void
		{
			super.update();
			if (collidePoint(x, y, world.mouseX, world.mouseY))
			{
				hover = true;
				if (Input.mouseDown)
				{
					click();
				}
			}
			else { hover = false;}
		}
		
		override public function render():void
		{
			//
			super.render();
			if (hover) { Draw.hitbox(this); }
		
		}
		
		private function click():void
		{
			if (thisWorld is TitleScreen){(thisWorld as TitleScreen).optionSelected("" + type);}
			if (thisWorld is GamePhase) { (thisWorld as GamePhase).optionButtonResponse("" + type);}
		}
		
	}

}