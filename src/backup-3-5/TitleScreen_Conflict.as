package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Stamp;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	
	public class TitleScreen_Conflict extends Entity
	{
		[Embed(source = '../assets/graphics/attention.png')] private const ATTENTION:Class;
		public var btnCancel:OptionButton;
		public var btnContinue:OptionButton;
		public var btnOverwrite:OptionButton;
		public var titleTextEntity:Entity;
		public function TitleScreen_Conflict(thisworld:World) 
		{
			/*
			var btnContinue:Button = new Button(620, 495, "continue", null, null, thisworld, null);
			add(btnContinue);
			var btnOverWrite:Button = new Button(620, 495, "overwrite", null, null, thisworld, null);
			add(btnOverWrite);
			var btnCancel:Button = new Button(620, 495, "cancel", null, null, thisworld, null);
			add(btnOverWrite);
			*/
				//continue button
			var buttonText:Text = new Text("Continue where this user left off");buttonText.size = 18;
			 btnContinue= new OptionButton(375, 400, buttonText,thisworld);
			btnContinue.setHitbox(225, 20); btnContinue.type = "continue";
			thisworld.add(btnContinue);
			
				//overwrite button
			//buttonText = new Text("Overwrite this file");buttonText.size = 18;
			//btnOverwrite = new OptionButton(375, 425, buttonText,thisworld);
			//btnOverwrite.setHitbox(125, 20); btnOverwrite.type = "overwrite";
			//thisworld.add(btnOverwrite);
				//cancel button
			buttonText = new Text("Cancel");buttonText.size = 18;
			btnCancel = new OptionButton(375, 425, buttonText,thisworld);
			btnCancel.setHitbox(125, 20); btnCancel.type = "cancel";
			thisworld.add(btnCancel);
			
			var titleText:Text = new Text("Attention: This user already has a file. Please choose an option...");
			titleText.size = 20;
			titleTextEntity = new Entity(300, 375, titleText);
			thisworld.add(titleTextEntity);
			
			graphic = new Stamp(ATTENTION);
			x = 250;
			y = 360;
		}
		
		override public function update():void
		{
			
		}
		override public function removed():void
		{
			world.remove(btnContinue);
			world.remove(btnOverwrite);
			world.remove(btnCancel);
			world.remove(titleTextEntity);
		}
		override public function render():void
		{
			super.render();
			//Draw.hitbox(btnContinue);
			//Draw.hitbox(btnOverwrite);
			//Draw.hitbox(btnCancel);
			
		}
	}

}