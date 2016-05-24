package
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	
	import flash.net.FileReference;
	import flash.filesystem.*;
	import flash.events.FileListEvent;
	
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	
	public class TitleScreen extends World
	{
		public var userID:String = "";
		private var engineObj:CardGame = null;
		public var dirFiles:File;
		public var conflictFile:File;
		public var conflictOptions: TitleScreen_Conflict;
		public var conflictMode:Boolean = false;
		public var cliFileUsed:Boolean = false;
		public var skipCreateFileCheack:Boolean = true;
		
		private var idInput:TextBox;
		private var btnStart:Button;
		private var btnSound:Button;
		private var newIDPause:Boolean = false;
		private var tempID: String;
		private var overWritePause:Boolean = false;
		public var XMLSaveRequestSent: Boolean =false;
		
		public function TitleScreen( engineObj:CardGame, cliFileUsed:Boolean )//, cliFileResolved:Boolean, inputUserId:String)
		{ //for now passing userId to make sure it's working
			this.engineObj = engineObj;
			this.cliFileUsed = cliFileUsed
			
			idInput= new TextBox( this );
			add(idInput);
			
			btnSound = new Button(950, 15, "sound", null, null, this, null); btnSound.toggle = true; if (CardGame.soundEnabled == false) { btnSound.clicked = true;}
			add(btnSound);
			//temp displaying userId
			var inputTitle:Entity = new Entity(400, 650, new Text("Type ID# and click Start to begin"));// + inputUserId));
			add(inputTitle);
			
			btnStart = new Button(620, 495, "start", null, null, this, idInput);
			add(btnStart);
			
			var titleText:Text = new Text("ACE");
			titleText.size = 100;
			var titleTextEntity:Entity = new Entity(400, 200, titleText);
			add(titleTextEntity);
		}
		
		override public function update():void
		{
			super.update();
			 //Note: User must save the file as the default name or the program will not continue!
			if (newIDPause) //new ID has been entered and we must wait until they click 'save file' in the window
			{
				if (!XMLSaveRequestSent && (skipCreateFileCheack || engineObj.fileExists(userID))) 
				{ 
					engineObj.createInitialXML(); 
					XMLSaveRequestSent = true; 
					
				} // handle UserXML will move isXMLSaved to 3
				if ((skipCreateFileCheack || (engineObj.fileExists(userID)) && engineObj.XMLExists(userID)))
				{ 
					engineObj.readXML();
					engineObj.startGame(userID);  
					
				} //If we see the corresponding save file we may continue
			}
			if (overWritePause)
			{//wait for the file to no longer exist
				if (!engineObj.fileExists(userID) && !engineObj.XMLExists(userID)) 
				{ 
					overWritePause = false;
					engineObj.loadUserFiles(userID); 
					engineObj.createInitialSaveFile(); 
					newIDPause = true ;
					
				}
			}
			
		}
		
		public function start(userID:String):void // wait for file search to verify no file exists for this user
		{
			//engineObj.startGame("las");
			
			/*if (true)
			{
				this.userID = userID;
				engineObj.loadUserFiles(userID);
				engineObj.createInitialSaveFile();
				engineObj.createInitialXML();
				//engineObj.readXML();
				engineObj.startGame(userID);
				return;
			}*/
			if (tempID != userID) { newIDPause = false; overWritePause = false; } // reset selection Pause if another ID is tried
			XMLSaveRequestSent = false;
			this.userID = userID;
			tempID = userID;
			if (engineObj.fileExists(userID)) showConflict();
			else { 
				engineObj.loadUserFiles(userID); 
				engineObj.createInitialSaveFile(); 
				newIDPause = true ;	
			}
		}
	
		public function showConflict():void // present options for the user
		{
			conflictMode = true;
			conflictOptions = new TitleScreen_Conflict(this);
			add(conflictOptions);
		}
		public function optionSelected(option:String):void // option has been selected by user
		{
			// TODO: CHECK TO MAKE SURE BOTH DATA AND XML FILES EXIST IF NOT THROW AN ERROR
			if (option == "continue") 
			{ 
				conflictMode = false;
				engineObj.loadUserFiles(userID); //setup files
				engineObj.readXML(); //readXML file
				engineObj.continueGame(); //write to data file that we have a new session
				engineObj.startGame(userID); // start game
			}
			if (option == "overwrite")// TODO: OVERWRITE MOSTLY WORKS I THINK, THIS SHOULD BE DOUBLE CHECKED
			{
				conflictMode = false;
				engineObj.loadUserFiles(userID); 
				engineObj.deleteUserFiles(userID);
				overWritePause = true;
				
			}
			if (option == "cancel")
			{
				conflictMode = false;
				remove(idInput); remove(btnStart); // reset
				idInput= new TextBox(this);
				btnStart = new Button(620, 495, "start", null, null, this, idInput);
				add(idInput);
				add(btnStart);
				remove(conflictOptions);
			}
		}
		public function soundSetting():void // toggle sound
		{
			if (CardGame.soundEnabled) { CardGame.soundEnabled = false; }
			else { CardGame.soundEnabled = true; }
			engineObj.saveSettings("sound");
			trace ("sent request to save");
		}
		
		
	}
}
