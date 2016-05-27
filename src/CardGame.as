package
{	
	import flash.external.ExternalInterface;
	import flash.net.FileReference;
	import flash.filesystem.*;
	import flash.events.FileListEvent;
	import flash.events.*;
    import flash.net.*;
	import flash.display.*;
	import flash.external.ExternalInterface
	import flash.display.StageDisplayState;
	
	
	import net.flashpunk.Engine;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Draw;
	import net.flashpunk.Sfx;
	[SWF(width="1024", height="768")]
	
	
	public class CardGame extends Engine
	{
		[Embed(source="../assets/sounds/beep.mp3")] public const BEEPY:Class;
		[Embed(source = '../assets/headline.ttf', embedAsCFF = "false", fontFamily = 'My Font')]private const MY_FONT:Class;
		
		public static var soundEnabled:Boolean = false;
		public static var filePrefix: String = "output_behav_";
		public static var userID:String = "";
		
		public var dirFiles:File;
		private var shared:SharedObject;
		public var saveFile:File;
		public var xmlSaveFile:File;
		public var userXML:XML;
		public var fStream: FileStream;
		public var xStream: FileStream;
		public var finishedTasks:Array ;
	
		public var phases:Array;
		public var phaseCounter:int = 0;
		
		
		public var gameTimer:Number = 0;
		public var resultVector:Vector.<String> = new Vector.<String>();
		public var fileOutput:FileReference = new FileReference();
		public var beepSound:Sfx = new Sfx(BEEPY);
		
		public static var score:int = 0;
		
		public var playDelay:Boolean = true;
		public const playEffort:Boolean = false;
		public const playProb:Boolean = false;
		public var numBlocks:int;
		
		public var cliFileResolved:Boolean = false;//change to default to false
		public var cliUserId:String = "10";
		public var filePath:String = "C:\\Users\\Sarah\\Documents\\ACE Data";
		
		//import flash.desktop.NativeApplication; 

		import flash.desktop.InvokeEventReason; 
		import flash.desktop.NativeApplication; 
		import flash.display.Sprite; 
		import flash.events.InvokeEvent;
 
		
		
		public function CardGame()
		{
			NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, onInvoke );
			
			numBlocks = 0;
			if (playDelay) {numBlocks ++;}
			if (playEffort) {numBlocks ++;}
			if (playProb) {numBlocks ++;}
			
			super(1024, 768);	
			//FP.console.enable();
			Text.font = "My Font";		
			Text.size = 24;
			loadSettings();
			FP.world = new TitleScreen(this, cliFileResolved, cliUserId);
			//flash.external.ExternalInterface.addCallback("calling app", beep);
			//startGame();
			stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			var dir:File = File.documentsDirectory.resolvePath("ACE Data");
			dir.createDirectory();
			//var dir2:File = File.documentsDirectory.resolvePath("ACE Data/user_xml");
			//dir2.createDirectory();
			
		}
		private function onInvoke( event:InvokeEvent ):void 
        {
			//Error(event.toString())
			
			//event.
			//var arguments:Array = event.arguments;
			if ( event.arguments.length >= 2)
			{
				cliFileResolved = true;
				playDelay = true
				filePath = event.arguments[0]
				cliUserId = event.arguments[1]

			}
			
			/*
			//userID = user;
			//saveFile = File.documentsDirectory;
			//saveFile = saveFile.resolvePath("ACE Data/" + filePrefix + userID + ".txt");
			
			var cliUserId:String = rand(0,500000).toString();
			var cliFilePath:String = "C:\\Users\Sarah\Documents\ACE Data";
			//var file:File = new File(); 
			saveFile.nativePath = cliFilePath + cliUserId;
			
			//saveFile = File.documentsDirectory.resolvePath("ACE Data/" + filePrefix + userID + ".txt");
			xmlSaveFile = File.documentsDirectory;
			xmlSaveFile = xmlSaveFile.resolvePath("Ace Data/" + "xml_" + userID + ".xml");
			fStream = new FileStream;
			xStream = new FileStream;
			*/
			
			//var filePath:String = "C:\\Users\Sarah\Documents\ACE Data";
			
			//var thisDate:Date = new Date();
			
			//public var cliUserId:String = 10;
			//public var filePath:String = "C:\\Users\\Sarah\\Documents\\ACE Data";
			
			//set filePath
			
			//loadUserFiles(cliUserId);
			
			/*
			//thisDate.timezoneOffset(-6)//???
			userID = "21a46a";
			
			saveFile = new File()
			saveFile.nativePath = filePath + "\\" + filePrefix + userID + "_" + thisDate.month + "_" + thisDate.day + "_" + thisDate.fullYear + "_" +".txt";
			//saveFile.save("asasa");
			
			//xmlSaveFile = new File()
			//xmlSaveFile.nativePath = filePath + "\\" + "xml_" + userID + ".xml";
			
			fStream = new FileStream;
			xStream = new FileStream;
			
			fStream.open(saveFile, FileMode.APPEND);
			fStream.writeUTFBytes("NEW SESSION-----"+"User: " + userID +" Date: " + thisDate +"\r\n"  );
			fStream.close();
			*/
			//createInitialSaveFile()
			
		}
		
		public function addToScore(currentScore:int = 0):void
		{
			score += currentScore;
			trace(score);
		}
		
		
		public function createInitialSaveFile():void //loadUserFiles must be run first
		{
			var thisDate:Date = new Date();
			//saveFile.save("User: " + userID +" Date: " + thisDate +"\r\n", filePrefix + userID + ".txt");
			//			saveFile.save("User: " + userID +" Date: " + thisDate +"\r\n");// , filePrefix + userID + ".txt");
			
			fStream.open(saveFile, FileMode.WRITE);
			fStream.writeUTFBytes("User: " + userID +" Date: " + thisDate +"\r\n");
			fStream.close();

		}
		public function createInitialXML():void //read xml create a new one if one does not exsist
		{
			//xmlSaveFile.save("<data finishedTasks=\"\"></data>", "xml_" + userID + ".xml");
			xStream.open(xmlSaveFile, FileMode.WRITE); 
			xStream.writeUTFBytes("<data finishedTasks=\"\"></data>");//, "xml_" + userID + ".xml");
			xStream.close(); 
		}
		public function XMLExists(userID:String):Boolean
		{
			var thisFile:File = File.documentsDirectory;
			thisFile = thisFile.resolvePath("ACE data/" +"xml_"+ userID + ".xml");
			if (thisFile.exists) { return true }
			else {return false}
		}
		public function deleteUserFiles(user:String):void
		{
			saveFile.deleteFile();
			xmlSaveFile.deleteFile();
		}
		public function loadUserFiles(user:String):void
		{			
			//hack;
			userID = cliUserId;
			var thisDate:Date = new Date();
			var timeStr:String = thisDate.getFullYear() + "" + thisDate.getMonth() + "" + thisDate.getDate() + "_" + thisDate.getHours() + thisDate.getMinutes() + thisDate.getSeconds();
			//saveFile = File.documentsDirectory;
			//saveFile = saveFile.resolvePath("ACE Data/" + filePrefix + userID + ".txt");
			//saveFile = File.documentsDirectory.resolvePath("ACE Data/" + filePrefix + userID + ".txt");
			saveFile = new File()
			saveFile.nativePath = filePath + "\\" + filePrefix + userID + "_" + timeStr + ".txt";
		
			xmlSaveFile = new File()
			xmlSaveFile.nativePath = filePath + "\\" + "xml_" + userID + "_" + timeStr + ".xml";
			fStream = new FileStream;
			xStream = new FileStream;
			
		}
		public function readXML():void //loadUserFiles must be run first
		{
			xStream.open(xmlSaveFile, FileMode.READ); 
			userXML = XML(xStream.readUTFBytes(xStream.bytesAvailable)); 
			xStream.close(); 
			trace ("finished Tasks says: " + userXML.@finishedTasks);
			if (userXML.@finishedTasks != undefined) {finishedTasks = userXML.@finishedTasks.split(",");} // turn xml into array
			else finishedTasks = new Array;
			
		}
		
		public function updateFinishedTasks(_type:int):void
		{
			finishedTasks.push("" + _type); //add finished task
			xStream.open(xmlSaveFile, FileMode.WRITE); 
			var finishedString:String = "";
			for (var i = 0; i < finishedTasks.length; i++)
			{
				finishedString += finishedTasks[i];
				if (finishedTasks[finishedTasks.length - 1] != finishedTasks[i])  finishedString +=","; // add comma unless its the last 
				
			}
			xStream.writeUTFBytes("<data finishedTasks=\"" + finishedString + "\"></data>");
			xStream.close(); 
		}
		
		public function beep():void
		{
			if (soundEnabled){beepSound.play()};
		}
		
		public function callOut(data:String = "empty"):void
		{
			//flash.external.ExternalInterface.call("ext1", data);
			//beepSound.play();
		}
		
		public function startGame(idNum:String = "notset"):void
		{
			//create random order for the rounds
			var phaseOrder:Array = generatePhaseOrder();
			phases = new Array();
			// GamePhase( size of deck, keep size, skip size, phase type)  // phase type -> 1 = probability, 2 = time, 3 = effort
			for (var i:int= 0; i < phaseOrder.length; i++)
			{
				if (i == 0) // first iteration is seperate values
				{
				phases[i] = new GamePhase(5, 5, 5, phaseOrder[i], userID, this,true ); //tutorial
				phases[i+1] = new GamePhase(5, 5, 5, phaseOrder[i], userID, this,false );
				}
				else
				{
				phases[i+1+(i-1)] = new GamePhase(5, 5, 5, phaseOrder[i], userID, this,true ); //tutorial
				phases[i+2+(i-1)] = new GamePhase(5, 5, 5, phaseOrder[i], userID, this, false );
				}
			}
			nextPhase();	
		}

		public function fileExists(userID:String):Boolean
		{var thisFile:File = File.documentsDirectory;
			thisFile = thisFile.resolvePath("ACE data/" +filePrefix + userID + ".txt");
			if (thisFile.exists) { return true }
			else {return false}
		}
		
		public function nextPhase(restartTutorial:Boolean = false):void
		{
			if (resultVector.length > 0) pushResult(); // write to file 
			if (phaseCounter >= phases.length) //finish the game and output the result
			{
				FP.world = new GameOver;
			}
			else // continue with list of phases(games)
			{
				if (restartTutorial) restartTutorialPhase(); // check for  a tutorial and restart
				trace("phase count is: " + phaseCounter);
				trace("tutorial: " + phases[phaseCounter].isTutorial);
				FP.world = phases[phaseCounter];
				phaseCounter++;
			}	
		}
		public function continueGame():void
		{
			var thisDate:Date = new Date();
			fStream.open(saveFile, FileMode.APPEND);
			fStream.writeUTFBytes("NEW SESSION-----"+"User: " + userID +" Date: " + thisDate +"\r\n"  );
			fStream.close();
		}
		
		public function restartTutorialPhase():void
		{
			var oldWorld:GamePhase = phases[phaseCounter];
			phases[phaseCounter] = new GamePhase(5, 5, 5, oldWorld.phaseType, userID, this, true);
		}
		
		
		override public function update():void
		{
			super.update();
			gameTimer += FP.elapsed;
		}
		
		public function addResult(x:int, data:String, useTime:Boolean = false):void
		{
			if (!(FP.world as GamePhase).isTutorial && data !="\r\n")
			{
				if (useTime) resultVector.push((Math.round((gameTimer*1000))/1000).toString());
				else resultVector.push(data.toString());
				resultVector.push("\t");
			}
			else if (!(FP.world as GamePhase).isTutorial && data == "\r\n")
			{
				resultVector.push("\r\n");
			}
		}
		
		public function pushResult():void
		{
			var resultString:String = "";
			for (var i:int = 0; i < resultVector.length; i++) //add in tabs
			{
				//if (i % 18 == 0 && i > 0) { resultString += "\r\n"; }
				resultString += resultVector[i] ;
			}
			resultString += "\r\n";
			fStream.open(saveFile, FileMode.APPEND);
			fStream.writeUTFBytes(resultString);
			fStream.close();
			resultVector = new Vector.<String>;
		}
		
		public function saveSettings(_type:String):void
		{
			if (_type == "sound")
			{
				shared.data.soundEnabled = soundEnabled;
				shared.flush();
				shared.close();	
				trace ("saved sound to: " + shared.data.soundEnabled);
			}
		}
		public function loadSettings():void
		{
			shared = SharedObject.getLocal("ACE_Settings");//Load setting Preferences
			//Load Sound
			if (shared.data.soundEnabled ==  undefined) 
			{ 
				shared.data.soundEnabled = true;
				shared.flush(); 
				shared.close(); 
				soundEnabled = true; 
				trace ("was undefined");
			}
			else  { soundEnabled = shared.data.soundEnabled; trace("set sound"); }
		}
		
		private function generatePhaseOrder():Array
		{
			// var availableTasks:Vector.<int> = new <int>[1,2,3];
			var numTasks:int = 0;
			var availableTasks:Array = new Array();
			// phase type -> 1 = probability, 2 = time, 3 = effort
			if (playProb)
			{
				availableTasks[numTasks] = 1;
				numTasks++;
			}
			if (playDelay)
			{
				availableTasks[numTasks] = 2;
				numTasks++;
			}
			if (playEffort)
			{
				availableTasks[numTasks] = 3;
				numTasks++;
			}
			
			
			trace ("finished number: "+finishedTasks.length );
				for (var a:int = 0; a < finishedTasks.length; a++) // remove tasks that have already been completed
				{
					for (var b:int = 0; b < availableTasks.length; b++){if (finishedTasks[a] == availableTasks[b]) availableTasks.splice(b, 1);}
				}
			
			var totalTaskLength:int = availableTasks.length;
			var generatedOrder:Array = new Array();
			for (var i:int = 0; i < totalTaskLength; i ++) // make sure each number is only selected once
			{
				var iteration: int;
				iteration = rand(0, availableTasks.length-1);
				generatedOrder[i] = availableTasks[iteration];
				availableTasks.splice(iteration, 1);
			}
			trace ("generated Tasks: "+generatedOrder);
			return generatedOrder;
		}
		public function getNewPointRisk():Object
		{
			var currentPhase: GamePhase =  (FP.world as GamePhase);
			//: Vectors relating to point values://
			//currentPhase.pointValuseShown; // 
			//currentPhase.pointValuesKept;
			//currentPhase.pointValuesSkipped
			return null;
		}
		public function rand(min:int,max:int):int
		{
			return Math.round(Math.random() * (max-min)) + min;
		}
	}
}