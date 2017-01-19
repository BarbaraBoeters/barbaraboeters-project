## Week 1

# 10 January
Written my proposal
Decided not to use an API unless I have time left. 


# 11 January
Started the Design document. 

# 12 January
Written the DESIGN document. 
Created a sketch of the app
Created a Class diagram
Started the Xcode project
Added the homescreen with the buttons
Added the tableview for the second screen. 

# 13 January
Finished the prototype and interface. 
Added all the buttons, text fields and image views. 
Found out how to create a circle rounded image view. 

## Week 2

# 16 January
Started Firebase: sign up, log in and log out. 
Started saving plants in Firebase but wanted to save them by user. Didn't work yet. Couldnt get the UID from the user to add to the plant'

# 17 January 
Checked the Guide on Firebase and figured out how to fix the last problem. 
Still have the problem of hierarchy in Firebase. 
Used this tutorial for the UIStepper: https://www.ioscreator.com/tutorials/uistepper-tutorial-ios8-swift
Used this tutorial to convert http://stackoverflow.com/questions/31694635/convert-optional-string-to-int-in-swift
Was able to add the value of the Stepper in Firebase
Next step is to get the datestamp and something like a reminder using the value of the Stepper. 
Found a tutorial about Event Kit which could be usefull: http://www.techotopia.com/index.php/Using_iOS_8_Event_Kit_and_Swift_to_Create_Date_and_Location_Based_Reminders
Had an error which occured before and was easy to fix: http://www.swifttocodes.com/cannot-assign-value-type-uiimage-type-uiimageview/

# 18 January
Added a standard photo in the tableview. 
Made he tableview working, in a simple way. 
Next step is to only show the items of the currentuser
Then I need to start with Eventkit: tutorial: https://www.andrewcbancroft.com/2015/05/14/beginners-guide-to-eventkit-in-swift-requesting-permission/

# 19 January
Changed Firebase tree structure to childByAutoId() for the plants instead of the name to prevent overwriting. 
Also added some error handling in the addPlant function
Enabled Firebase to be able to work offline

