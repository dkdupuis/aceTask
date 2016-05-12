package
{	
	
	
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import flash.utils.setTimeout;
	
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.tweens.misc.VarTween;
	import net.flashpunk.utils.*;
	
	public class GamePhase extends World
	{
		[Embed(source="../assets/graphics/bar_container.png")] public const BAR_CONTAINER:Class;
		[Embed(source="../assets/graphics/bar_fill.png")] public const BAR_FILL:Class;
		
		[Embed(source="../assets/sounds/nextphase.mp3")] public const NEXT_PHASE:Class;
		
		
		public var engineObj:CardGame;
		
		
				
		public var deckSize:int;
		public var startingDeckSize:int;
		public var keepSize:int = 0;
		public var skipSize:int = 0;
		public var deckMax:int;
		public var keepMax:int;
		public var skipMax:int;
		
		public var phaseType:int = 0;
		public var idNum:String;
		
		public var currentCard:Card;
		public var btnContinue:OptionButton;
		public var btnRetry:OptionButton;
		public var tutorialText:Entity;
		public var tutorialTitle:Entity;
		
		public var probability:Number = 0;
		public var time:int = 0;
		public var effortNum:int = 0;
				
		public var btnKeep:Button;
		public var btnSkip:Button;
		
		public var taskTextEntity:Entity;
		public var taskText:Text;
		
		public var taskWindow:TaskWindow;
		
		public var score:int = 0;
		public var isTutorial:Boolean;
		
		public var levelAssets:Assets;
		
		public var locked:Boolean = false;
		
		public var riskInfo:Entity;
		public var taskResult:TaskResult;
		
		public var keyPressToggle:Boolean = true;
		public var keycheckDisable:Boolean = false;
		
		public var background:Rectangle = new Rectangle( -10, -9, -5, -4);
		
		public var pointValuesShown:Vector.<int> = new Vector.<int>;  // FYI, I'm not using this...my making of a matricies below is brutally ugly FYI, the columns are made in the gamephase constructor
		public var pointValuesKept:Vector.<int> = new Vector.<int>;   // FYI, I'm not using this
		public var pointValuesSkipped:Vector.<int> = new Vector.<int>;// FYI, I'm not using this
		
		public var cardResolutionValue = new Array(10); 	//Added, Matrix of resolution status of possible pointXcost combs; 0=unresolved, >1=kept, <1=skipped; Needs Updatated
		public var numWorseCardsUnresolved = new Array(10); //Added, Count of cards at least as bad that are unresolved; Needs Updatated
		public var numBetterCardsUnresolved = new Array(10);//Added, Count of cards at least as good that are unresolved; Needs Updatated
		
		public const firstCardsRisks = new Array(3, 8, 8, 3, 5);	//Added, First 5 cards to be dealt out
		public const firstCardsPoints = new Array(8, 3, 8, 3, 5);	//Added, First 5 cards to be dealt out
		
		public var sequenceTimeStamp: Number = 0;
		
		public function GamePhase( deck:int, kMax:int, sMax:int, type:int, idNum:String, engine:CardGame, _isTutorial:Boolean )
		{
			super();			
			isTutorial = _isTutorial;	//added/updated. Moved this up
			
			if (isTutorial) deck = 5; 	//added/changed/; 5 cards for practice blocks
			else deck = 150;			//added/changed/; task ends when all decisions are resolved for non tutorial
			
			deckSize = deck;
			startingDeckSize = deck;
			deckMax = deck;
			
			engineObj = engine;
			this.idNum = idNum;
			
			// start at max and decrement to 0;
			keepMax = 150;// kMax; added/changed/; task ends when all decisions are resolved
			skipMax = 150;// sMax; added/changed/; task ends when all decisions are resolved
			
			phaseType = type;
			//isTutorial = _isTutorial; added/updated duplicate line... needed at at the top of the constructor (after super call)
			
			//Added, initialize decision matricies; Needs Updatated until line ~119
			for (var r:int = 0; r < 10; r++)
			{
				cardResolutionValue[r] = new Array(10);			//embarrassing looking code for declaring matricies
				numWorseCardsUnresolved[r] = new Array(10);
				numBetterCardsUnresolved[r] = new Array(10);
				for (var c:int = 0; c < 10; c++)
				{
					cardResolutionValue[r][c] = 0;
					numWorseCardsUnresolved[r][c] = (10 - r) * (c + 1); 	//(9,0)=1;   (0,9)=100;	(9,9)=10; (0,0)=10					
					numBetterCardsUnresolved[r][c] = (r + 1) * (10 - c);	//(9,0)=100; (0,9)=1	(9,9)=10; (0,0)=10					
				}
			} //Added end point

			if (isTutorial)
			{
				var text:Text = new Text("Practice Round");
				text.size = 45;
				text.color = 0x669966;
				tutorialTitle = new Entity(0, 0, text);
				tutorialTitle.layer = -99999;
				add(tutorialTitle);
			}
		}
		
		override public function begin():void
		{
			super.begin();
						
			Text.size = 16;
			
			levelAssets = new Assets(this, deckMax, keepMax, skipMax, phaseType);
			add(levelAssets);
			
			btnKeep = new Button(750, 220, "keep", this);
			add(btnKeep);
			btnSkip = new Button(750, 300, "skip", this);
			add(btnSkip);	
			
			//add in message window for tutorial
			
			

			//keep at bottom	
			dealCard();
		}
		
		override public function update():void
		{
			super.update();
			/*
			if (Input.check(Key.S) && Input.check(Key.K) && Input.check(Key.I) && Input.check(Key.P)&&!keyPressToggle&&!keycheckDisable)
			{
				remove(btnSkip);
				remove(btnKeep);
				remove(levelAssets);
				remove(currentCard);
				if (CardGame.soundEnabled) new Sfx(NEXT_PHASE).play(); 
				keycheckDisable = true;
				setTimeout(engineObj.nextPhase, 1000);
			}
			*/
			if (Input.check(Key.CONTROL) && Input.check(Key.S) && !keyPressToggle && !keycheckDisable)
			{
				remove(btnSkip);
				remove(btnKeep);
				remove(levelAssets);
				remove(currentCard);
				if (CardGame.soundEnabled) new Sfx(NEXT_PHASE).play(); 
				keycheckDisable = true;
				setTimeout(engineObj.nextPhase, 1000);
			}
			// we assume the buttons are held in so we force the keys to be unpressed before checking again
			//if (!Input.check(Key.S) && !Input.check(Key.K) && !Input.check(Key.I) && !Input.check(Key.P)) { keyPressToggle = false;}
			if (!Input.check(Key.CONTROL) && !Input.check(Key.S)) { keyPressToggle = false;}
			
			
			if (locked)
			{
				btnKeep.visible = false;
				btnSkip.visible = false;
			}
			else
			{
				btnKeep.visible = true;
				btnSkip.visible = true;
			}
			//trace(resultVector[0]);
		}
		
		
		public function dealCard():void
		{
//			trace(deckSize.toString);
			if (deckSize > 0 && keepSize < keepMax)
			{	
				var pointRisk = new Object(); 	//added changed line pointRisk.pointValue & pointRisk.riskValue are null if getNewPointRisk line is commented out, and they will be assigned random value in the card constructor and calculateRisk function
				getNewPointRisk(pointRisk);		//added....changed line...thought this made it cleaner to switch to a random algorithm (ie by just commenting out this line) pointRisk = getNewPointRisk();
				if (pointRisk.pointValue == -1) //added. End task when all cards are resolved
				{
					if (isTutorial) { endTutorial();}
					else{nextRound();}
				}
				else
				{
					if (currentCard) { remove(currentCard); }
					//currentCard = new Card(this); // TODO: Add card determination output to the new card
					currentCard = new Card(this, pointRisk); //added, changed Card constructor to take pointRisk object so riskValue can be carried around by the card.
					add(currentCard);
					if(deckSize != startingDeckSize)engineObj.addResult( -1, "\r\n"); //new Line
					deckSize--;
					levelAssets.decreaseDeck(deckSize);
					// current y value of vector (deckMax - deckSize - 1) 
					// add result (0-ID 1-phase 2-time dealt 3-pointvalue
						engineObj.addResult(0, Number(idNum).toString());
						engineObj.addResult(1, phaseType.toString());
						engineObj.addResult(2, null, true);
						engineObj.addResult(3, currentCard.pointValue.toString());
					
						//getNewRiskValue(phaseType); // Maybe use the risk function like this?
						//calculateRisk(); // new random risk and write risk to file 
						calculateRisk(currentCard.riskValue); // new random risk and write risk to file 
						sequenceTimeStamp = engineObj.gameTimer;
						trace ("timestamp =" + sequenceTimeStamp);
				}
					
			}
			else if (deckSize <= 0 || keepSize >= keepMax) {  //End Game Here
				if (isTutorial) { endTutorial();}
				else{nextRound();}
			}
		}
		
		public function getNewPointRisk(pointRisk:Object):void 	//Added, Finds card that will maximize the number of cards that will be resovled, regardless of what participant chooses; Whole function Needs Updatated
		{														//pointRisk.riskValue & pointRisk.pointValue range [1,10] 		   

			var minResolve:int = 0;
			var maxResolve:int = 0;
			var minTempResolve:int = 0;
			var maxTempResolve:int = 0;
			
			if (startingDeckSize-deckSize < 5)
			{
				pointRisk.pointValue = firstCardsPoints[startingDeckSize-deckSize];
				pointRisk.riskValue = firstCardsRisks[startingDeckSize-deckSize];
			}	
			else
			{
				for (var r:int = 0; r < 10; r++)
				{
					for (var c:int = 0; c < 10; c++)
					{
						if (cardResolutionValue[r][c] == 0)
						{
							minTempResolve = Math.min(numBetterCardsUnresolved[r][c], numWorseCardsUnresolved[r][c]);
							maxTempResolve = Math.max(numBetterCardsUnresolved[r][c], numWorseCardsUnresolved[r][c]);			
							
							if (minTempResolve > minResolve || minTempResolve == minResolve && maxTempResolve > maxResolve)
							{
								maxResolve = maxTempResolve;
								minResolve = minTempResolve;
								pointRisk.pointValue = c + 1;
								pointRisk.riskValue = r + 1;
							}
						}
					}
				}
				if (minResolve == 0) pointRisk.pointValue = -1; //If all cards are resolved, minResolve=0, set pointValue to -1 so we can end block
			}
			
		}

		public function endTutorial():void
		{
			remove(btnSkip);
			remove(btnKeep);
			remove(levelAssets);
			remove(currentCard);
			remove(tutorialTitle);
			Text.align = "center";
			var text:Text = new Text("You have completed the practice round for this task \n Score: " + score);
			text.height = 1024;
			text.width = 1024;
			text.size = 45;
			tutorialText = new Entity(0, 200, text);
			add(tutorialText);
			Text.align = "left";
			
			var buttonText:Text = new Text("Continue");buttonText.size = 18;
			btnContinue= new OptionButton(375, 400, buttonText,this);
			btnContinue.setHitbox(225, 20); btnContinue.type = "tutorial_continue";
			add(btnContinue);
			
			buttonText = new Text("Retry Tutorial");buttonText.size = 18;
			 btnRetry= new OptionButton(375, 425, buttonText,this);
			btnRetry.setHitbox(225, 20); btnRetry.type = "tutorial_retry";
			add(btnRetry);
		}
		
		public function optionButtonResponse(response:String):void
		{
			if (isTutorial)
			{
				remove(btnContinue); remove(btnRetry); remove(tutorialText);
				if (CardGame.soundEnabled){new Sfx(NEXT_PHASE).play()};
				if (response == "tutorial_continue") { engineObj.nextPhase(false);}//setTimeout(engineObj.nextPhase, 1500);  }
				if (response == "tutorial_retry") { engineObj.phaseCounter --; engineObj.nextPhase(true);}
		
			}
		}	
		
		public function nextRound():void
		{
			remove(btnSkip);
			remove(btnKeep);
			remove(levelAssets);
			remove(currentCard);
			Text.align="center";
			//var text:Text = new Text("keep pile full");
			var text:Text = new Text("Your Score: "+ score);
			var text2:Text = new Text("moving to next round");
			text.width = 1024;
			text2.width = 1024;
			text.size = 96;
			text2.size = 48;
			add(new Entity(0,200, text));
			add(new Entity(0,300, text2));
			Text.align = "left";
			if (CardGame.soundEnabled){new Sfx(NEXT_PHASE).play()};
			engineObj.addToScore(score);
			engineObj.updateFinishedTasks(phaseType); //update the xml sheet now that we finished this task
			setTimeout(engineObj.nextPhase, 15000);
		}
		
		
		public function openTaskWindow():void
		{
			taskWindow = new TaskWindow(520, 230, this);
			add(taskWindow);
		}
		
		public function closeTaskWindow():void
		{
			FP.world.remove(taskWindow);
		}
		
		public function calculateRisk(risk:Number):void //added: Ok, I ended up changing a lot...prob best to just copy over the whole function...stream of thought comments below if you're interested
		{												//Changed ... don't remember what it was exactley before, but change is prob not really nessecary
														//OK, changed this around again...calculateRisk will never be given a null value. If we're dealing random cards, the card constructor will determine the riskValue
														//This still works, but we could remove all of the checking to see if "risk" is null and the randomized parts (which will never be executed)
														//ie it would be this commented out block
			switch(phaseType)							
			{											
				case 1:
					probability = (11 - risk) / 10;
					engineObj.addResult(4, probability.toString());					
					break;
				case 2:
					time = risk * 6;
					engineObj.addResult(4, time.toString());
					break;
				case 3:
					effortNum = risk + 2;
					engineObj.addResult(4, effortNum.toString());
					
					break;
				default:
					trace("phase type initialized incorrectly");
			}
			/*
			switch(phaseType)							
			{											
				case 1:
					if (risk) { probability = risk; }
					else{probability = (Math.floor(Math.random() * (1+10-1))+1) / 10;}
					// add result ( 4-RISK )
					engineObj.addResult(4, probability.toString());
					
					break;
				case 2:
					if (risk) { time = risk;}
					else{time = (Math.floor(Math.random() * (1+60-1))+1);}
					// add result ( 4-RISK )
					engineObj.addResult(4, time.toString());
					break;
				case 3:
					if (risk) { effortNum = risk;}
					else{effortNum = Math.floor(Math.random() * (1+12-3))+3;}
					// add result ( 4-RISK )
					engineObj.addResult(4, effortNum.toString());
					
					break;
				default:
					trace("phase type initialized incorrectly");
			}*/
		}
		
		public function showRisk():void 
		{
			locked = false;
			switch(phaseType)
			{
				case 1:
					riskInfo = new ProbabilityInfo(probability, this) as ProbabilityInfo;
					add(riskInfo);
					break;
				case 2:
					riskInfo = new DelayInfo(time, this) as DelayInfo;
					add(riskInfo);
					break;
				case 3:
					riskInfo = new EffortInfo(effortNum, this) as EffortInfo;
					add(riskInfo);
					break;
				default:
					trace("error on switch in showRisk");
			}
		}
		
		public function hideRisk():void
		{
			remove(riskInfo);
		}
		
		public function keepCard():void 
		{
			locked = true;
			pointValuesKept.push(currentCard.pointValue);
			//engineObj.callOut("keep");
			
			// add result ( 5-Decision , 6-time)
			engineObj.addResult(5, "1");
			engineObj.addResult(6, null, true);
			
			keepSize++;
			
			//levelAssets.increaseKeepPile(keepSize, keepMax);
			
			// alert text if keep pile is full
			//if (keepSize >= keepMax) { var roundOver:TextAlert = new TextAlert(60, 660, "Moving to Next Phase");  add(roundOver); }

			switch(phaseType)
			{
				case 1:
					var probTest:Number = Math.random();
					hideRisk();
					if (probTest < probability) { keepSuccess(); } 
					else { keepFailure(); }
					break;
				case 2:
					var timer:TimeCountdown = new TimeCountdown(time, this);
					//add(timer);
					(riskInfo as DelayInfo).startCount();
					break;
				case 3:
					var effortTask:SequenceTask = new SequenceTask(effortNum, this);
					add(effortTask);
					break;
				default:
					trace("error on keepCard switch");
			}
				
		}
		

		
		public function keepSuccess():void //added/updated with a call to updateAfterKeep
		{
			// add result ( 7-getpoints(1), resultTime )
			engineObj.addResult(7, "1");
			engineObj.addResult(8, null, true);			
			currentCard.keepCard = true;
			//var alertResult:TextAlert = new TextAlert(60, 600, "You Got " + currentCard.pointValue + " points");
			//add(alertResult);
			//if(!isTutorial) score += currentCard.pointValue; 
			score += currentCard.pointValue; 
			levelAssets.updateScore(score);
			taskResult = new TaskResult(2, this);
			add(taskResult);
			updateAfterKeep(); //added/updated
		}
		
		public function keepFailure():void
		{
			// add result ( 7-getpoints(0), 8-resultTime )
			engineObj.addResult(7, "0");
			engineObj.addResult(8, null, true);
			
			//var alertResult:TextAlert = new TextAlert(60, 600, "You Did Not Get " + currentCard.pointValue + " points");
			//alertResult.text.color = 0xff0000;
			//add(alertResult);
			taskResult = new TaskResult(3, this);
			add(taskResult);
			
			if (phaseType == 1) {updateAfterKeep();}	//keepFailure in probabilty block means probabilistic non-reward...aka they kept the card but randomly didn't get points
			else {updateAfterSkipOrGiveUp();}			//keepFailure in delay/effort block means they gave up
			
		}
		
		public function updateAfterKeep():void //Added/Updated; Updates cardResolutionValue and numBetterCardsUnresolved after a card is kept and not given up (Give up=skip)
		{
			for (var r:int = currentCard.riskValue-1; r >= 0; r--) 
			{
				for (var c:int = currentCard.pointValue-1; c < 10; c++)
				{
					cardResolutionValue[r][c] = cardResolutionValue[r][c] + 1;										
				}
			}
			
			var keptInRow = new Array(10); //# of cards in each row that we know are kept
			for (r = 0; r < 10; r++)			
			{
				keptInRow[r] = 10;
				for (c = 0; c <10; c++)
				{
					if (cardResolutionValue[r][c] > 0) keptInRow[r]--;
					
				}
			}
				
			for (c = 9 ; c >= 0; c--) //Needed because the loop after this would have edge effects
			{
				if (keptInRow[0] - c <= 0)
				{
					numBetterCardsUnresolved[0][c] = 0;
				}
				else
				{
					numBetterCardsUnresolved[0][c] = keptInRow[0] - c;
				}
			}
			
			for (r = 1; r < 10; r++)
			{
				for (c = 9; c >= 0; c--)
				{
					if (keptInRow[r] - c <= 0)
					{
						numBetterCardsUnresolved[r][c] = 0;
					}
					else
					{
						numBetterCardsUnresolved[r][c] = keptInRow[r] - c + numBetterCardsUnresolved[r - 1][c];						
					}					
				}
			}			
			
		}
		
		public function updateAfterSkipOrGiveUp():void //Added/Updated; Updates cardResolutionValue and numWorseCardsUnresolved after a card is skipped or given up (Give up=skip)
		{
			
			for (var r:int = currentCard.riskValue-1; r <10; r++) 
				{
					for (var c:int = 0; c <= currentCard.pointValue-1; c++)
					{
						cardResolutionValue[r][c] = cardResolutionValue[r][c] - 1;						
					}
				}
				
			var skippedInRow = new Array(10); ////# of cards in each row that we know are skipped
			for (r = 0; r < 10; r++)
			{
				skippedInRow[r] = 0;
				for (c = 0; c <10; c++)
				{
					if (cardResolutionValue[r][c] < 0) skippedInRow[r]++;						
				}
			}
			
			for (var c:int = 0 ; c < 10; c++) //Needed because the loop after this would have edge effects
			{
				if (skippedInRow[9] > c)
				{
					numWorseCardsUnresolved[9][c] = 0;
				}
				else
				{
					numWorseCardsUnresolved[9][c] = c - skippedInRow[9] + 1;						
				}
			}
			
			for (r = 8; r >= 0; r--)				
			{
				for (c = 0; c < 10; c++)					
				{
					if (skippedInRow[r] > c)
					{
						numWorseCardsUnresolved[r][c] = 0;
					}
					else
					{
						numWorseCardsUnresolved[r][c] = c - skippedInRow[r] + 1 + numWorseCardsUnresolved[r + 1][c];							
					}
				}
			}
			//trace("debug");			
		}
		
		public function skipCard():void //added a call to updateAfterSkipOrGiveUp 
		{ 
			if (skipSize < skipMax)
			{

				pointValuesSkipped.push(currentCard.pointValue);
				locked = true;
				//add result (5-Decision, 6-time, 7-getpoints(-1))
				engineObj.addResult(5, "0");
				engineObj.addResult(6, null, true);
				engineObj.addResult(7, "-1");
				engineObj.addResult(8, null, true);
				skipSize++;
				taskResult = new TaskResult(1, this);
				add(taskResult);
				//levelAssets.increaseSkipPile(skipSize, skipMax);
				updateAfterSkipOrGiveUp(); //added/updated		
				
			}
			else { add(new TextAlert(620, 380, "Skip Pile Full!")); }
		}
		
		public function moveCard(x:Number, y:Number, type:String):void
		{
			currentCard.moveOut(x, y, type);
		}
		
		
		public function increaseSkip():void
		{
			levelAssets.increaseSkipPile(skipSize, skipMax);
		}
		
		public function increaseKeep():void
		{
			levelAssets.increaseKeepPile(keepSize, keepMax);
		}
		override public function render():void
		{
			super.render();
			FP.buffer.fillRect(background, 0xffffff);
			
		}
	}
	
	
}