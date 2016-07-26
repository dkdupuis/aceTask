# aceTask

This is the code base for the Ace Task. Below is the reference for this program. For questions, contact David DuPuis (dkdupuis@gmail.com) or Lisa Gazke-Kopp (lmk18@psu.edu).

Children's sensitivity to cost and reward in decision making across distinct domains of probability, effort, and delay. (In Progress)
  Lisa M. Gatzke-Kopp, Nilam Ram, David Lydon, & David DuPuis


## Deployment Instructions (mac or PC)
 * Install adobe air (http://get.adobe.com/air/)
 * Install ACE.air
 * Executeable will be generated
 * Notes on current version
   * Only contains effort block
   * Needs to be launched from the command line to work (call ACE.exe pathToSaveFile participantID)

## Development Instructions
 * Get a PC
 * Install FlashDevelop (http://www.flashdevelop.org/)
 * Use FlashDevelop to install air and related stuff
 * Develop
 * To create a new air file, in FlashDevelop explore window
   * Edit the path to Flex SDK in 'bat\SetupSDK.bat' 
   * Right click, run bat/createCertificate.bat
   * Right click, run PacakgeApp.bat
 * New deployment file will be generated (air/ACE.air) 

## Notes
 * CardGame() is the entry point
 * There are global booleans in CardGame controlling which blocks are shown
 * To make a version where RA can enter the participant ID, changes will need to be made to CardGame and TitleScreen
