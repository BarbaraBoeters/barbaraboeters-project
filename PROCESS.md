## Week 1

# 10 January
- Written my proposal
- Decided not to use an API unless I have time left. 

# 11 January
- Started the Design document. 

# 12 January
- Written the DESIGN document. 
- Created a sketch of the app
- Created a Class diagram
- Started the Xcode project
- Added the homescreen with the buttons
- Added the tableview for the second screen. 

# 13 January
- Finished the prototype and interface. 
- Added all the buttons, text fields and image views. 
- Found out how to create a circle rounded image view. 

## Week 2

# 16 January
- Started Firebase: sign up, log in and log out. 
- Started saving plants in Firebase but wanted to save them by user. Didn't work yet. Couldnt get the UID from the user to add to the plant'
- Made the table view transparant with this tutorial: https://grokswift.com/transparent-table-view/

# 17 January 
- Checked the Guide on Firebase and figured out how to fix the last problem. 
- Still have the problem of hierarchy in Firebase. 
- Used this tutorial for the UIStepper: https://www.ioscreator.com/tutorials/uistepper-tutorial-ios8-swift
- Used this tutorial to convert http://stackoverflow.com/questions/31694635/convert-optional-string-to-int-in-swift
- Was able to add the value of the Stepper in Firebase
- Next step is to get the datestamp and something like a reminder using the value of the Stepper. 
- Found a tutorial about Event Kit which could be usefull: http://www.techotopia.com/index.php/Using_iOS_8_Event_Kit_and_Swift_to_Create_Date_and_Location_Based_Reminders
- Had an error which occured before and was easy to fix: http://www.swifttocodes.com/cannot-assign-value-type-uiimage-type-uiimageview/

# 18 January
- Added a standard photo in the tableview. 
- Made he tableview working, in a simple way. 
- Next step is to only show the items of the currentuser
- Then I need to start with Eventkit: tutorial: https://www.andrewcbancroft.com/2015/05/14/beginners-guide-to-eventkit-in-swift-requesting-permission/

# 19 January
- Changed Firebase tree structure to childByAutoId() for the plants instead of the name to prevent overwriting. 
- Also added some error handling in the addPlant function
- Enabled Firebase to be able to work offline

# 20 January
- Add photo by camera or photolibrary with this tutorial: http://www.codingexplorer.com/choosing-images-with-uiimagepickercontroller-in-swift/
- Added some keyboard actions but failed to install the IQKeyboardManagerSwift framework: https://github.com/hackiftekhar/IQKeyboardManager. Update: it worked
- Getting an error with the loading of the photo 2017-01-21 02:20:09.321013 barbaraboeters-project[398:46782] [Generic] Creating an image format with an unknown type is an error

# 21 January
- Fixed the IQKeyboardManagerSwift and its working now on all viewcontrollers
- Now there is an error with the interval

## Week 3

# 23 January
- Found solution to error interval -> need to delete app from simulator
- Started writing functions for checking how what difference between interval and time is
- Started Geotifications tutorial 

# 24 January
- Changed to another tutorial to try out geofencing. https://www.appcoda.com/geo-targeting-ios/
- Hardcoded the current location to test out the notifications: it works but only within the app. 
- http://stackoverflow.com/questions/25296691/get-users-current-location-coordinates

# 25 January 
- Started working on the code to get the current location and put it in variables. 
- Searchbar http://sweettutos.com/2015/04/24/swift-mapkit-tutorial-series-how-to-search-a-place-address-or-poi-in-the-map/

# 26 January
- All plants are showing on the geofencing map
    - Update: only plants of the current user
- Also in the tableview there are only the plants of the current user. 

# 27 January
- Problem: only 20 geolocations can be tracked at the same time. 
- Put my code through Better Code Hub: at first 5 of 10 points, after configuration 7 of 10 points
- Still working on figuring out how to keep geofence checking through the whole app and when the app is on the background


